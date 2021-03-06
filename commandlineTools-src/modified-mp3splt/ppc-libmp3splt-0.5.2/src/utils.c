/**********************************************************
 *
 * libmp3splt -- library based on mp3splt,
 *               for mp3/ogg splitting without decoding
 *
 * Copyright (c) 2002-2005 M. Trotta - <mtrotta@users.sourceforge.net>
 * Copyright (c) 2005-2008 Alexandru Munteanu - io_fx@yahoo.fr
 *
 * http://mp3splt.sourceforge.net
 *
 *********************************************************/

/**********************************************************
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307,
 * USA.
 *
 *********************************************************/

#include <sys/stat.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <dirent.h>

#include "splt.h"

extern short global_debug;

/****************************/
/* some prototypes */

static void splt_u_cut_extension(char *str);

/****************************/
/* utils for conversion */

//converts string s in hundredth
//and returns seconds
//returns -1 if it cannot convert (usually we hope it can :)
long splt_u_convert_hundreths (const char *s)
{
  long minutes=0, seconds=0, hundredths=0, i;
  long hun;

  for(i=0; i<strlen(s); i++) // Some checking
    if ((s[i]<0x30 || s[i] > 0x39) && (s[i]!='.'))
      return -1;

  if (sscanf(s, "%ld.%ld.%ld", &minutes, &seconds, &hundredths)<2)
    return -1;

  if ((minutes < 0) || (seconds < 0) || (hundredths < 0))
    return -1;

  if ((seconds > 59) || (hundredths > 99))
    return -1;

  if (s[strlen(s)-2]=='.')
    hundredths *= 10;

  hun = hundredths;
  hun += (minutes*60 + seconds) * 100;

  return hun;
}

//convert to decibels
float splt_u_convert2dB(double input)
{
  float level;
  if (input<=0.0)
  {
    level = -96.0;
  }
  else 
  {
    level = 20 * log10(input);
  }

  return level;
}

//convert from decibels
double splt_u_convertfromdB(float input)
{
  double amp;
  if (input<-96.0)
  {
    amp = 0.0;
  }
  else 
  {
    amp = pow(10.0, input/20.0);
  }

  return amp;
}

/****************************/
/* utils for file infos */

//returns -1 is the file is damaged
//0 otherwise
int splt_u_getword (FILE *in, off_t offset, int mode, 
    unsigned long *headw)
{
  int i;
  *headw = 0;

  if (fseeko(in, offset, mode)==-1)
  {
    return -1;
  }

  for (i=0; i<4; i++)
  {
    if (feof(in)) 
    {
      return -1;
    }
    *headw = *headw << 8;
    *headw |= fgetc(in);
  }

  return 0;
}

//returns the file length
off_t splt_u_flength(splt_state *state, FILE *in, const char *filename, int *error)
{
  struct stat info;
  if (fstat(fileno(in), &info)==-1)
  {
    splt_t_set_strerror_msg(state);
    splt_t_set_error_data(state, filename);
    *error = SPLT_ERROR_CANNOT_OPEN_FILE;
    return -1;
  }
  return info.st_size;
}

/*****************************************************/
/* utils manipulating strings (including filenames) */

//cleans the string of weird characters like ? " | : > < * \ \r
void splt_u_cleanstring(splt_state *state, char *s, int *error)
{
  int i = 0, j=0;
  char *copy = NULL;
  if (s)
  {
    copy = strdup(s);
    if (copy)
    {
      for (i=0; i<=strlen(copy); i++)
      {
        if ((copy[i]!='\\')&&(copy[i]!='/')&&(copy[i]!='?')
            &&(copy[i]!='*')&&(copy[i]!=':')&&(copy[i]!='"')
            &&(copy[i]!='>')&&(copy[i]!='<')&&(copy[i]!='|')
            &&(copy[i]!='\r'))
        {
          s[j++] = copy[i];
        }
      }
      free(copy);
      copy = NULL;

      // Trim string. I will never stop to be surprised about cddb strings dirtiness! ;-)
      for (i=strlen(s)-1; i >= 0; i--) 
      {
        if (s[i]==' ')
        {
          s[i] = '\0';
        }
        else 
        {
          break;
        }
      }
    }
    else
    {
      *error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
    }
  }
}

//cuts spaces from the begin
char *splt_u_cut_spaces_from_begin(char *c)
{
  //cut spaces from the begin
  if (*c == ' ')
  {
    while (*c == ' ')
    {
      c++;
    }
  }

  return c;
}

//cuts spaces at the end
char *splt_u_cut_spaces_at_the_end(char *c)
{
  //we cut spaces at the end
  while (*c == ' ')
  {
    *c = '\0';
    c--;
  }

  return c;
}

//finding the real name of the file, without the path
const char *splt_u_get_real_name(const char *filename)
{
  char *c = NULL;
  while ((c = strchr(filename, SPLT_DIRCHAR)) !=NULL)
  {
    filename = c + 1;
  }

  return filename;
}

//returns the filename of the new file to be created, the two integer
//parameters are for the 2 splitpoints
//Warning !! the first splitpoint begins at 0 !!!
//i is the current split, to find the current name in 
//state->fn[i]
//error is the possible error
//result must be freed
static char *splt_u_get_mins_secs_filename(char *filename, splt_state *state,
    long split_begin, long split_end, int i, int *error)
{
  int number_of_splits = 0;
  splt_point *points = 
    splt_t_get_splitpoints(state, &number_of_splits);

  char *fname = NULL, *fname2 = NULL;
  int fname2_malloc_number = 0,fname_malloc_number = 0;

  fname2_malloc_number = fname_malloc_number = strlen(filename) + 256;

  long old_split_end = split_end;

  if((fname = malloc(fname_malloc_number*sizeof(char))) != NULL)
  {
    memset(fname,'\0',fname_malloc_number*sizeof(char));
    if((fname2 = malloc(fname2_malloc_number*sizeof(char))) != NULL)
    {
      memset(fname2,'\0',fname2_malloc_number*sizeof(char));
      long hundr = 0, secs = 0, mins = 0;
      long hundr2 = 0, secs2 = 0, mins2 = 0;
      splt_t_get_mins_secs_hundr_from_splitpoint(split_begin, &mins, &secs, &hundr);
      splt_t_get_mins_secs_hundr_from_splitpoint(split_end, &mins2, &secs2, &hundr2);

      //if we have this splitpoint
      if (splt_t_splitpoint_exists(state, i))
      {
        if (points[i].name != NULL)
        {
          char temp[3] = { '\0' };
          //transform " " to "\ "
          int j;
          for (j = 0; j < strlen(points[i].name); j++)
          {
            if ((state->split.points[i].name[j] == ' '))
            {
              strcat(fname, " ");
            }
            else
            {
              if ((state->split.points[i].name[j] == '\\') ||
                  (state->split.points[i].name[j] == '/'))
              {
                strcat(fname, "-");
              }
              else
              {
                snprintf(temp,2,"%c", state->split.points[i].name[j]);
                strcat(fname,temp);
              }
            }
          }
        }

        //if fn[i] is "", we put the same name as the
        //original file
        if ((points[i].name == NULL) || (strcmp(points[i].name,"") == 0))
        {
          snprintf(fname,strlen(filename),"%s", filename);
          //we cut the extension of the original file
          splt_u_cut_extension(fname);
        }
      }
      else
      {
        splt_u_error(SPLT_IERROR_INT,__func__, i, NULL);
      }

      //we put EOF if LONG_MAX
      if (old_split_end == LONG_MAX)
      {
        snprintf(fname2,fname2_malloc_number,
            "%s_%ldm_%lds_%ldh__EOF", 
            fname, mins, secs, hundr);
      }
      else
      {
        snprintf(fname2,fname2_malloc_number,
            "%s_%ldm_%lds_%ldh__%ldm_%lds_%ldh", 
            fname, mins, secs, hundr, mins2, secs2, hundr2);
      }

      //put the extension according to the file type
      const char *extension = splt_p_get_extension(state, error);
      if (*error >= 0)
      {
        strcat(fname2, extension);
      }
    }
    else
    {
      *error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
    }
    //freeing memory
    if (fname)
    {
      free(fname);
      fname = NULL;
    }
  }
  else
  {
    *error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
  }

  return fname2;
}

//puts the complete filename with the correct path
//error is the possible error
void splt_u_set_complete_mins_secs_filename(splt_state *state, int *error)
{
  int get_error = SPLT_OK;
  int current_split = splt_t_get_current_split(state);
  long split_begin = splt_t_get_splitpoint_value(state, current_split, &get_error);
  if (get_error < 0) { *error = get_error; return; }
  long split_end = splt_t_get_splitpoint_value(state, current_split+1, &get_error);
  if (get_error < 0) { *error = get_error; return; }
  char *filename = splt_t_get_filename_to_split(state);

  char *filename2 = strdup(filename);
  if (!filename2)
  {
    *error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
    return;
  }
  else
  {
    //filename of the new created file
    char *fname = NULL;

    //get the filename without the path
    char *filename3 = strdup(splt_u_get_real_name(filename2));
    if (!filename3)
    {
      if (filename2)
      {
        free(filename2);
        filename2 = NULL;
      }
      *error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
    }
    else
    {
      fname = splt_u_get_mins_secs_filename(filename3, state,
          split_begin, split_end, current_split, error);

      if (*error >= 0)
      {
        //we cut the extension
        char *fname2 = strdup(fname);
        if (fname2)
        {
          fname2[strlen(fname2)-4]='\0';
          //we put the filename in the state
          splt_t_set_splitpoint_name(state, current_split, fname2);
          if (fname2)
          {
            free(fname2);
            fname2 = NULL;
          }
        }
        else
        {
          *error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
        }
      }

      if (fname)
      {
        free(fname);
        fname = NULL;
      }

      //free some memory
      if (filename3)
      {
        free(filename3);
        filename3 = NULL;
      }
    }

    //free some memory
    if (filename2)
    {
      free(filename2);
      filename2 = NULL;
    }
  }
}

//the result must be freed
//returns the new_filename_path + filename + extension or NULL if error
char *splt_u_get_fname_with_path_and_extension(splt_state *state, int *error)
{
  char *output_fname_with_path = NULL;
  char *new_filename_path = splt_t_get_new_filename_path(state);
  int current_split = splt_t_get_current_split(state);
  char *output_fname = splt_t_get_splitpoint_name(state, current_split, error);
  int malloc_number = strlen(new_filename_path) + 10;
  if (output_fname)
  {
    malloc_number += strlen(output_fname);
  }

  //if we don't output to stdout
  if (output_fname && (strcmp(output_fname,"-") != 0))
  {
    if ((output_fname_with_path = malloc(malloc_number)) != NULL)
    {
      //we put the full output filename (with the path)
      //construct full filename with path
      const char *extension = splt_p_get_extension(state, error);
      if (*error >= 0)
      {
        if (new_filename_path[0] == '\0')
        {
          snprintf(output_fname_with_path, malloc_number,
              "%s%s", output_fname, extension);
        }
        else
        {
          snprintf(output_fname_with_path, malloc_number,
              "%s%c%s%s",new_filename_path, SPLT_DIRCHAR,
              output_fname, extension);
        }
      }
      else
      {
        if (output_fname_with_path)
        {
          free(output_fname_with_path);
          output_fname_with_path = NULL;
        }
        return NULL;
      }
    }
    else
    {
      *error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
      return NULL;
    }

    char *filename = splt_t_get_filename_to_split(state);

    //if the output file exists
    int is_file = splt_check_is_file(state, output_fname_with_path);
    if (is_file)
    {
      //if input and output are the same file
      if (splt_check_is_the_same_file(state,filename, output_fname_with_path, error))
      {
        splt_t_set_error_data(state,filename);
        *error = SPLT_ERROR_INPUT_OUTPUT_SAME_FILE;
      }
      else
      {
        //if no error from the check_is_the_same..
        if (*error >= 0)
        {
          //TODO
          //warning if a file already exists
        }
      }
    }

    return output_fname_with_path;
  }
  else
  {
    char *returned_result = NULL;
    if (output_fname)
    {
      returned_result = strdup(output_fname);
    }
    else
    {
      returned_result = strdup("-");
    }
    if (returned_result)
    {
      return returned_result;
    }
    else
    {
      *error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
      return NULL;
    }
  }
}

/****************************/
/* utils for splitpoints */

//cut extension from 'str'
static void splt_u_cut_extension(char *str)
{
  char *point = strrchr(str , '.');
  if (point)
  {
    *point = '\0';
  }
}

//cuts the extension of a splitpoint
int splt_u_cut_splitpoint_extension(splt_state *state, int index)
{
  int change_error = SPLT_OK;

  if (splt_t_splitpoint_exists(state,index))
  {
    int get_error = SPLT_OK;
    char *temp_name = splt_t_get_splitpoint_name(state, index, &get_error);

    if (get_error != SPLT_OK)
    {
      return get_error;
    }
    else
    {
      if (temp_name)
      {
        char *new_name = strdup(temp_name);
        if (new_name == NULL)
        {
          return SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
        }
        else
        {
          splt_u_cut_extension(new_name);
          change_error = splt_t_set_splitpoint_name(state,index, new_name);
          free(new_name);
          new_name = NULL;
        }
      }
    }
  }

  return change_error;
}

//order the splitpoints (used in the silence split)
//only works for the values, the names are not ordered!
void splt_u_order_splitpoints(splt_state *state, int len)
{
  long temp = 0;

  int err = SPLT_OK;

  int i, j;
  float key;
  for (j=1; j < len; j++)
  {
    key = splt_t_get_splitpoint_value(state,j,&err);
    i = j -1;
    while ((i >= 0) && 
        (splt_t_get_splitpoint_value(state,i,&err) > key))
    {
      temp = splt_t_get_splitpoint_value(state,i,&err);
      splt_t_set_splitpoint_value(state,i+1,temp);
      i--;
    }
    splt_t_set_splitpoint_value(state,i+1,key);
  }
}

/****************************/
/* utils for the tags       */

//parse the word, returns a allocated string with the recognised word
//-return must be freed
static char *splt_u_parse_tag_word(const char *cur_pos,
    const char *end_paranthesis, int *ambigous, int *error)
{
  char *word = NULL;
  char *word_end = NULL;
  char *word_end2 = NULL;
  const char *equal_sign = NULL;

  if ((word_end = strchr(cur_pos,',')))
  {
    if ((word_end2 = strchr(cur_pos,']')) < word_end)
    {
      word_end = word_end2;
      if ((strchr(word_end+1,']') && !strchr(word_end+1,'['))
          || (strchr(word_end+1,']') < strchr(word_end+1,'[')))
      {
        *ambigous = SPLT_TRUE;
      }
    }

    if (*word_end == ',')
    {
      if (*(word_end+1) != '@')
      {
        *ambigous = SPLT_TRUE;
      }
    }
  }
  else
  {
    word_end = strchr(cur_pos,']');
  }

  if (word_end <= end_paranthesis)
  {
    if (*(cur_pos+1) == '=')
    {
      equal_sign = cur_pos+1;
      int string_length = word_end-(equal_sign+1);
      if (string_length > 0)
      {
        word = malloc((string_length+1)*sizeof(char));
        memset(word,'\0',(string_length+1)*sizeof(char));
        if (word)
        {
          memcpy(word,equal_sign+1,string_length);
          word[string_length] = '\0';
        }
        else
        {
          *error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
          return NULL;
        }
      }
      else
      {
        *ambigous = SPLT_TRUE;
      }
    }
    else
    {
      *ambigous = SPLT_TRUE;
    }
  }

  cur_pos = word_end;

  return word;
}

//we put the custom tags
//returns if ambigous or not
int splt_u_put_tags_from_string(splt_state *state, const char *tags, int *error)
{
  if (tags != NULL)
  {
    const char *cur_pos = NULL;
    int all_tags = SPLT_FALSE;
    int we_had_all_tags = SPLT_FALSE;

    cur_pos = tags;

    int ambigous = SPLT_FALSE;
    const char *end_paranthesis = NULL;
    //we search for tags
    if (!strchr(cur_pos,'['))
    {
      ambigous = SPLT_TRUE;
    }

    //tags that we put to all the others : %[@t=tag1,@b=album1]
    char *all_artist = NULL;
    char *all_album = NULL;
    char *all_title = NULL;
    char *all_performer = NULL;
    char *all_year = NULL;
    char *all_comment = NULL;
    int all_tracknumber = -1;
    unsigned char all_genre = 12;

    int tags_appended = 0;
    int get_out_from_while = SPLT_FALSE;
    while ((cur_pos = strchr(cur_pos,'[')))
    {
      //if we set the tags for all the files
      if (cur_pos != tags)
      {
        //if we have % before [
        if (*(cur_pos-1) == '%')
        {
          splt_t_set_int_option(state,SPLT_OPT_ALL_REMAINING_TAGS_LIKE_X, tags_appended);
          all_tags = SPLT_TRUE;
          //if we had all tags, remove them
          if (we_had_all_tags)
          {
            if (all_title) { free(all_title); all_title = NULL; }
            if (all_artist) { free(all_artist); all_artist = NULL; }
            if (all_album) { free(all_album); all_album = NULL; }
            if (all_performer) { free(all_performer); all_performer = NULL; }
            if (all_year) { free(all_year); all_year = NULL; }
            if (all_comment) { free(all_comment); all_comment = NULL; }
          }
        }
      }

      char *title = NULL;
      char *artist = NULL;
      char *album = NULL;
      char *performer = NULL;
      char *year = NULL;
      char *comment = NULL;
      char *tracknumber = NULL;
      //means "other"
      unsigned char genre = 12;

      //how many we have found in one [..]  
      short s_title = 0;
      short s_artist = 0;
      short s_album = 0;
      short s_performer = 0;
      short s_year = 0;
      short s_comment = 0;
      short s_tracknumber = 0;

      cur_pos++;

      end_paranthesis = strchr(cur_pos,']');
      if (!end_paranthesis)
      {
        ambigous = SPLT_TRUE;
      }
      else
      {
        if ((*(end_paranthesis+1) != '[') &&
            (*(end_paranthesis+1) != '%') &&
            (*(end_paranthesis+1) != '\0'))
        {
          ambigous = SPLT_TRUE;
        }
      }

      char *tag = NULL;
      int original_tags = SPLT_FALSE;
      while ((tag = strchr(cur_pos-1,'@')))
      {
        //if the current position is superior or equal
        if (tag >= end_paranthesis)
        {
          break;
        }
        else
        {
          cur_pos = tag+1;
        }

        const char *old_pos = cur_pos;
        //we take the artist, performer,...
        if (*(cur_pos-1) == '@')
        {
          switch (*cur_pos)
          {
            case 'o':
              //if we have twice @o
              if (original_tags)
              {
                ambigous = SPLT_TRUE;
              }
              //if we have other thing than @o, or @o]
              //then ambigous
              if ((*(cur_pos+1) != ',') &&
                  (*(cur_pos+1) != ']'))
              {
                ambigous = SPLT_TRUE;
              }

              char *filename = splt_t_get_filename_to_split(state);
              //if we don't have STDIN
              if (! splt_t_is_stdin(state))
              {
                int err = SPLT_OK;
                splt_t_lock_messages(state);
                splt_check_file_type(state, &err);
                if (err < 0)
                {
                  *error = err;
                  splt_t_unlock_messages(state);
                  get_out_from_while = SPLT_TRUE;
                  goto end_while;
                }
                splt_t_unlock_messages(state);

                splt_t_lock_messages(state);
                splt_p_init(state, &err);
                if (err >= 0)
                {
                  splt_t_get_original_tags(state, &err);
                  if (err < 0) 
                  {
                    *error = err;
                    splt_t_unlock_messages(state);
                    get_out_from_while = SPLT_TRUE;
                    goto end_while;
                  }
                  splt_p_end(state);
                  err = splt_t_append_original_tags(state);
                  if (err < 0)
                  {
                    *error = err;
                    splt_t_unlock_messages(state);
                    get_out_from_while = SPLT_TRUE;
                    goto end_while;
                  }
                  //if we have all_tags, get out the last tags
                  if (all_tags)
                  {
                    //and copy them
                    splt_tags last_tags = splt_t_get_last_tags(state);
                    //free previous all tags
                    if (all_title) { free(all_title); all_title = NULL; }
                    if (all_artist) { free(all_artist); all_artist = NULL; }
                    if (all_album) { free(all_album); all_album = NULL; }
                    if (all_performer) { free(all_performer); all_performer = NULL; }
                    if (all_year) { free(all_year); all_year = NULL; }
                    if (all_comment) { free(all_comment); all_comment = NULL; }
                    //set new all tags
                    if (last_tags.title != NULL)
                    {
                      all_title = strdup(last_tags.title);
                    }
                    if (last_tags.artist != NULL)
                    {
                      all_artist = strdup(last_tags.artist);
                    }
                    if (last_tags.album != NULL)
                    {
                      all_album = strdup(last_tags.album);
                    }
                    if (last_tags.performer != NULL)
                    {
                      all_performer = strdup(last_tags.performer);
                    }
                    if (last_tags.year != NULL)
                    {
                      all_year = strdup(last_tags.year);
                    }
                    if (last_tags.comment != NULL)
                    {
                      all_comment = strdup(last_tags.comment);
                    }
                    all_genre = last_tags.genre;
                    all_tracknumber = last_tags.track;
                  }
                  original_tags = SPLT_TRUE;
                  splt_t_unlock_messages(state);
                }
                else
                {
                  *error = err;
                  splt_t_unlock_messages(state);
                  get_out_from_while = SPLT_TRUE;
                  goto end_while;
                }
              }
              else
              {
                ambigous = SPLT_TRUE;
              }

              //if we have a @a,@p,.. before @n
              //then ambigous
              if ((artist != NULL) || (performer != NULL) ||
                  (album != NULL) || (title != NULL) ||
                  (comment != NULL) || (year != NULL) ||
                  (tracknumber != NULL))
              {
                ambigous = SPLT_TRUE;
              }
              break;
            case 'a':
              artist = splt_u_parse_tag_word(cur_pos,end_paranthesis,&ambigous, error);
              if (*error < 0) { get_out_from_while = SPLT_TRUE; goto end_while; }
              if (artist != NULL)
              {
                //copy the artist for all tags
                if (all_tags)
                {
                  if (all_artist) { free(all_artist); all_artist = NULL; }
                  all_artist = strdup(artist);
                }
                cur_pos += strlen(artist)+2;
                s_artist++;
              }
              else
              {
                cur_pos++;
              }
              break;
            case 'p':
              performer = splt_u_parse_tag_word(cur_pos,end_paranthesis,&ambigous, error);
              if (*error < 0) { get_out_from_while = SPLT_TRUE; goto end_while; }
              if (performer != NULL)
              {
                //copy the performer for all tags
                if (all_tags)
                {
                  if (all_performer) { free(all_performer); all_performer = NULL; }
                  all_performer = strdup(performer);
                }
                cur_pos += strlen(performer)+2;
                s_performer++;
              }
              else
              {
                cur_pos++;
              }
              break;
            case 'b':
              album = splt_u_parse_tag_word(cur_pos,end_paranthesis,&ambigous,error);
              if (*error < 0) { get_out_from_while = SPLT_TRUE; goto end_while; }
              if (album != NULL)
              {
                //copy the album for all tags
                if (all_tags)
                {
                  if (all_album) { free(all_album); all_album = NULL; }
                  all_album = strdup(album);
                }
                cur_pos += strlen(album)+2;
                s_album++;
              }
              else
              {
                cur_pos++;
              }
              break;
            case 't':
              title = splt_u_parse_tag_word(cur_pos,end_paranthesis,&ambigous,error);
              if (*error < 0) { get_out_from_while = SPLT_TRUE; goto end_while; }
              if (title != NULL)
              {
                //copy the title for all tags
                if (all_tags)
                {
                  if (all_title) { free(all_title); all_title = NULL; }
                  all_title = strdup(title);
                }

                cur_pos += strlen(title)+2;
                s_title++;
              }
              else
              {
                cur_pos++;
              }
              break;
            case 'c':
              comment = splt_u_parse_tag_word(cur_pos,end_paranthesis,&ambigous,error);
              if (*error < 0) { get_out_from_while = SPLT_TRUE; goto end_while; }
              if (comment != NULL)
              {
                //copy the comment for all tags
                if (all_tags)
                {
                  if (all_comment) { free(all_comment); all_comment = NULL; }
                  all_comment = strdup(comment);
                }

                cur_pos += strlen(comment)+2;
                s_comment++;
              }
              else
              {
                cur_pos++;
              }
              break;
            case 'y':
              year = splt_u_parse_tag_word(cur_pos,end_paranthesis,&ambigous,error);
              if (*error < 0) { get_out_from_while = SPLT_TRUE; goto end_while; }
              if (year != NULL)
              {
                //copy the year for all tags
                if (all_tags)
                {
                  if (all_year) { free(all_year); all_year = NULL; }
                  all_year = strdup(year);
                }

                cur_pos += strlen(year)+2;
                s_year++;
              }
              else
              {
                cur_pos++;
              }
              break;
            case 'n':
              tracknumber = splt_u_parse_tag_word(cur_pos,end_paranthesis,&ambigous,error);
              if (*error < 0) { get_out_from_while = SPLT_TRUE; goto end_while; }
              if (tracknumber != NULL)
              {

                cur_pos += strlen(tracknumber)+2;
                s_tracknumber++;
              }
              else
              {
                cur_pos++;
              }
              break;
            default:
              ambigous = SPLT_TRUE;
              break;
          }
        }

        if (cur_pos <= old_pos)
        {
          cur_pos++;
        }
      }

      int track = -1;
      //we check that we really have the tracknumber as integer
      if (tracknumber)
      {
        int is_number = SPLT_TRUE;
        int i = 0;
        for (i = 0;i < strlen(tracknumber);i++)
        {
          if (!isdigit(tracknumber[i]))
          {
            is_number = SPLT_FALSE;
            ambigous = SPLT_TRUE;
          }
        }
        if (is_number)
        {
          track = atoi(tracknumber);

          //copy the tracknumber for all tags
          if (all_tags)
          {
            all_tracknumber = track;
          }
        }
      }

      if ((s_title > 1) || (s_artist > 1)
          || (s_album > 1) || (s_performer > 1)
          || (s_year > 1) || (s_comment > 1)
          || (s_tracknumber > 1))
      {
        ambigous = SPLT_TRUE;
      }

      //if we don't have already set the original tags,
      //we set the tags
      if (!original_tags)
      {
        if (track == -1)
        {
          track = 0;
        }
        //we put the tags
        int err = splt_t_append_tags(state, title, artist,
            album, performer, year, comment, track, genre);
        if (err < 0)
        {
          *error = err;
          get_out_from_while = SPLT_TRUE;
        }
      }
      else
      {
        //we put the tags
        int err = splt_t_append_only_non_null_previous_tags(state, title, artist,
            album, performer, year, comment, track, genre);
        if (err < 0)
        {
          *error = err;
          get_out_from_while = SPLT_TRUE;
        }
      }

      //if we have all tags, set them
      if (we_had_all_tags)
      {
        int index = state->split.real_tagsnumber - 1;
        if (!title)
        {
          splt_t_set_tags_char_field(state, index, SPLT_TAGS_TITLE, all_title);
        }
        if (!artist)
        {
          splt_t_set_tags_char_field(state, index, SPLT_TAGS_ARTIST, all_artist);
        }
        if (!album)
        {
          splt_t_set_tags_char_field(state, index, SPLT_TAGS_ALBUM, all_album);
        }
        if (!performer)
        {
          splt_t_set_tags_char_field(state, index, SPLT_TAGS_PERFORMER, all_performer);
        }
        if (!year)
        {
          splt_t_set_tags_char_field(state, index, SPLT_TAGS_YEAR, all_year);
        }
        if (!comment)
        {
          splt_t_set_tags_char_field(state, index, SPLT_TAGS_COMMENT, all_comment);
        }
        if (!tracknumber)
        {
          splt_t_set_tags_int_field(state, index, SPLT_TAGS_TRACK, all_tracknumber);
        }
        if (genre != 12)
        {
          splt_t_set_tags_uchar_field(state, index, SPLT_TAGS_GENRE, all_genre);
        }
      }

end_while:
      //we free the memory
      if (title) { free(title); title = NULL; }
      if (artist) { free(artist); artist = NULL; }
      if (album) { free(album); album = NULL; }
      if (performer) { free(performer); performer = NULL; }
      if (year) { free(year); year = NULL; }
      if (comment) { free(comment); comment = NULL; }
      if (tracknumber) { free(tracknumber); tracknumber = NULL; }

      //we get out from while when error
      if (get_out_from_while)
      {
        break;
      }

      //set all tags for the next
      if (all_tags)
      {
        we_had_all_tags = SPLT_TRUE;
        all_tags = SPLT_FALSE;
      }

      tags_appended++;
    }

    //free all tags memory
    if (all_title) { free(all_title); all_title = NULL; }
    if (all_artist) { free(all_artist); all_artist = NULL; }
    if (all_album) { free(all_album); all_album = NULL; }
    if (all_performer) { free(all_performer); all_performer = NULL; }
    if (all_year) { free(all_year); all_year = NULL; }
    if (all_comment) { free(all_comment); all_comment = NULL; }

    return ambigous;
  }

  return SPLT_FALSE;
}

/*******************************/
/* utils for the output format */

//parse the output format to see if correct
//use strdup on 's' when calling this function
int splt_u_parse_outformat(char *s, splt_state *state)
{
  char *ptrs = NULL, *ptre = NULL;
  int i=0, amb = SPLT_OUTPUT_FORMAT_AMBIGUOUS, len=0;

  for (i=0; i<strlen(s); i++)
  {
    if (s[i]=='+') 
    {
      s[i]=' ';
    }
    else 
    {
      if (s[i] == SPLT_VARCHAR) 
      {
        s[i]='%';
      }
    }
  }

  splt_u_cleanstring(state, s, &amb);
  if (amb < 0) { return amb; }

  ptrs = s;
  i = 0;
  ptre = strchr(ptrs+1, '%');
  if (s[0] != '%')
  {
    if (ptre==NULL)
    {
      len = strlen(ptrs);
    }
    else
    {
      len = ptre-ptrs;
    }
    if (len > SPLT_MAXOLEN)
    {
      len = SPLT_MAXOLEN;
    }
    strncpy(state->oformat.format[i++], ptrs, len);
  }
  else
  {
    ptre = s;
  }

  //if stdout, NOT ambigous
  if (splt_t_is_stdout(state))
  {
    return SPLT_OUTPUT_FORMAT_OK;
  }

  if (ptre == NULL)
  {
    return SPLT_OUTPUT_FORMAT_AMBIGUOUS;
  }
  ptrs = ptre;

  while (((ptre = strchr(ptrs+1, '%')) != NULL) && (i < SPLT_OUTNUM))
  {
    char cf = *(ptrs+1);

    len = ptre-ptrs;
    if (len > SPLT_MAXOLEN)
    {
      len = SPLT_MAXOLEN;
    }

    switch (cf)
    {
      case 'a':
        break;
      case 'b':
        break;
      case 't':
        break;
      case 'n':
        amb = SPLT_OUTPUT_FORMAT_OK;
        break;
      case 'f':
        break;
      case 'p':
        break;
      default:
        return SPLT_OUTPUT_FORMAT_ERROR;
    }

    strncpy(state->oformat.format[i++], ptrs, len);
    ptrs = ptre;
  }

  strncpy(state->oformat.format[i], ptrs, strlen(ptrs));

  if (ptrs[1]=='t')
  {
    amb = SPLT_OUTPUT_FORMAT_OK;
  }

  if (ptrs[1]=='n')
  {
    amb = SPLT_OUTPUT_FORMAT_OK;
  }

  return amb;
}

//writes the current filename according to the output_filename
int splt_u_put_output_format_filename(splt_state *state)
{
  int error = SPLT_OK;

  char *temp = NULL;
  char *fm = NULL;
  int i = 0;
  char *output_filename = NULL;
  int output_filename_size = 0;

  char *title = NULL;
  char *artist = NULL;
  char *album = NULL;
  char *performer = NULL;
  char *original_filename = NULL;

  int old_current_split = splt_t_get_current_split(state);

  int current_split = old_current_split;

  int fm_length = 0;

  //if we get the tags from the first file
  int remaining_tags_like_x = 
    splt_t_get_int_option(state,SPLT_OPT_ALL_REMAINING_TAGS_LIKE_X);
  if ((current_split >= state->split.real_tagsnumber) &&
      (remaining_tags_like_x != -1))
  {
    current_split = remaining_tags_like_x;
  }

  splt_u_print_debug("The output format is ",0,state->oformat.format_string);

  for (i = 0; i < SPLT_OUTNUM; i++)
  {
    if (strlen(state->oformat.format[i]) == 0)
    {
      break;
    }
    //if we have some % in the format (@ has been converted to %)
    if (state->oformat.format[i][0] == '%')
    {
      //we allocate memory for the temp variable
      if (temp)
      {
        free(temp);
        temp = NULL;
      }

      int temp_len = strlen(state->oformat.format[i])+10;
      if ((temp = malloc(temp_len * sizeof(char))) == NULL)
      {
        error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
        goto end;
      }
      memset(temp, 0x0, temp_len);

      temp[0] = '%';
      temp[1] = 's';
      switch (state->oformat.format[i][1])
      {
        case 'a':
          if (splt_t_tags_exists(state,current_split))
          {
            //we get the artist
            artist =
              splt_t_get_tags_char_field(state,current_split, SPLT_TAGS_ARTIST);
          }
          else
          {
            artist = NULL;
          }

          //
          if (artist != NULL)
          {
            snprintf(temp+2,temp_len, state->oformat.format[i]+2);

            int artist_length = 0;
            artist_length = strlen(artist);
            fm_length = strlen(temp) + artist_length + 1;
          }
          else
          {
            snprintf(temp,temp_len, state->oformat.format[i]+2);
            fm_length = strlen(temp) + 1;
          }

          if ((fm = malloc(fm_length * sizeof(char))) == NULL)
          {
            error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
            goto end;
          }

          //
          if (artist != NULL)
          {
            snprintf(fm, fm_length, temp, artist);
          }
          else
          {
            snprintf(fm, fm_length, temp);
          }
          break;
        case 'b':
          if (splt_t_tags_exists(state,current_split))
          {
            //we get the album
            album =
              splt_t_get_tags_char_field(state,current_split, SPLT_TAGS_ALBUM);
          }
          else
          {
            album = NULL;
          }

          //
          if (album != NULL)
          {
            int album_length = 0;
            album_length = strlen(album);
            snprintf(temp+2, temp_len, state->oformat.format[i]+2);

            fm_length = strlen(temp) + album_length + 1;
          }
          else
          {
            snprintf(temp,temp_len, state->oformat.format[i]+2);
            fm_length = strlen(temp) + 1;
          }

          if ((fm = malloc(fm_length * sizeof(char))) == NULL)
          {
            error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
            goto end;
          }

          //
          if (album != NULL)
          {
            snprintf(fm, fm_length, temp, album);
          }
          else
          {
            snprintf(fm, fm_length, "%s", temp);
          }
          break;
        case 't':
          if (splt_t_tags_exists(state,current_split))
          {
            //we get the title
            title =
              splt_t_get_tags_char_field(state,current_split, SPLT_TAGS_TITLE);
          }
          else
          {
            title = NULL;
          }

          //
          if (title != NULL)
          {
            int title_length = 0;
            title_length = strlen(title);
            snprintf(temp+2, temp_len, state->oformat.format[i]+2);

            fm_length = strlen(temp) + title_length + 1;
          }
          else
          {
            snprintf(temp,temp_len, state->oformat.format[i]+2);
            fm_length = strlen(temp) + 1;
          }

          if ((fm = malloc(fm_length * sizeof(char))) == NULL)
          {
            error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
            goto end;
          }

          //
          if (title != NULL)
          {
            snprintf(fm, fm_length, temp, title);
          }
          else
          {
            snprintf(fm, fm_length, temp);
          }
          break;
        case 'p':
          if (splt_t_tags_exists(state,current_split))
          {
            //we get the performer
            performer =
              splt_t_get_tags_char_field(state,current_split, SPLT_TAGS_PERFORMER);
          }
          else
          {
            performer = NULL;
          }

          //
          if (performer != NULL)
          {
            int performer_length = 0;
            performer_length = strlen(performer);
            snprintf(temp+2, temp_len, state->oformat.format[i]+2);

            fm_length = strlen(temp) + performer_length + 1;
          }
          else
          {
            snprintf(temp,temp_len, state->oformat.format[i]+2);
            fm_length = strlen(temp) + 1;
          }

          if ((fm = malloc(fm_length * sizeof(char))) == NULL)
          {
            error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
            goto end;
          }

          if (performer != NULL)
          {
            snprintf(fm, fm_length, temp, performer);
          }
          else
          {
            snprintf(fm, fm_length, temp);
          }
          break;
        case 'n':
          temp[1] = '0';
          temp[2] = state->oformat.output_format_digits;
          temp[3] = 'd';

          //we set the track number
          int tracknumber = old_current_split+1;

          //if not time split, or normal split, or silence split or error,
          //we put the track number from the tags
          int split_mode = splt_t_get_int_option(state,SPLT_OPT_SPLIT_MODE);
          if ((split_mode != SPLT_OPTION_TIME_MODE) &&
              (split_mode != SPLT_OPTION_NORMAL_MODE) &&
              (split_mode != SPLT_OPTION_SILENCE_MODE) &&
              (split_mode != SPLT_OPTION_ERROR_MODE))
          {
            if (splt_t_tags_exists(state,current_split))
            {
              int tags_track = splt_t_get_tags_int_field(state,
                  current_split,SPLT_TAGS_TRACK);
              if (tags_track > 0)
              {
                tracknumber = tags_track;
              }
            }
          }
          snprintf(temp+4, temp_len, state->oformat.format[i]+2);

          fm_length = strlen(temp) + 1;
          char tt[2] = { state->oformat.output_format_digits, '\0' };
          int number_of_digits = atoi(tt);
          if ((fm = malloc(fm_length * sizeof(char))) == NULL)
          {
            error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
            goto end;
          }

          snprintf(fm, fm_length, temp, tracknumber);
          break;
        case 'f':
          if (splt_t_get_filename_to_split(state) != NULL)
          {
            //we get the filename
            original_filename = strdup(splt_u_get_real_name(splt_t_get_filename_to_split(state)));
            if (original_filename)
            {
              snprintf(temp+2,temp_len, state->oformat.format[i]+2);

              //we cut extension
              splt_u_cut_extension(original_filename);

              int filename_length = strlen(original_filename);

              fm_length = strlen(temp) + filename_length;
              if ((fm = malloc(fm_length * sizeof(char))) == NULL)
              {
                error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
                goto end;
              }

              snprintf(fm, fm_length, temp, original_filename);
              free(original_filename);
              original_filename = NULL;
            }
            else
            {
              error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
              goto end;
            }
          }
          break;
      }
    }
    else
    {
      fm_length = SPLT_MAXOLEN;
      if ((fm = malloc(fm_length * sizeof(char))) == NULL)
      {
        error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
        goto end;
      }

      strncpy(fm, state->oformat.format[i], SPLT_MAXOLEN);
    }

    int fm_size = 7;
    if (fm != NULL)
    {
      fm_size = strlen(fm);
    }

    //allocate memory for the output filename
    if (!output_filename)
    {
      if ((output_filename = malloc((1+fm_size)*sizeof(char))) == NULL)
      {
        error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
        goto end;
      }
      output_filename_size = fm_size;
      output_filename[0] = '\0';
    }
    else
    {
      output_filename_size += fm_size+1;
      if ((output_filename = realloc(output_filename, output_filename_size
              * sizeof(char))) == NULL)
      {
        error = SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
        goto end;
      }
    }

    if (fm != NULL)
    {
      strcat(output_filename, fm);
    }

    //we free fm
    if (fm)
    {
      free(fm);
      fm = NULL;
    }
  }

  //we change the splitpoint name
  int name_error = SPLT_OK;
  int cur_splt = splt_t_get_current_split(state);

  splt_u_print_debug("The new output filename is ",0,output_filename);

  name_error = splt_t_set_splitpoint_name(state, cur_splt, output_filename);

  if (name_error != SPLT_OK)
  {
    error = name_error;
  }

end:
  //free memory
  if (output_filename)
  {
    free(output_filename);
    output_filename = NULL;
  }
  if (fm)
  {
    free(fm);
    fm = NULL;
  }
  if (temp)
  {
    free(temp);
    temp = NULL;
  }

  return error;
}

/****************************/
/* debug errors */

//prints an error message
//if such error messages appear, there are coding errors
void splt_u_error(int error_type, const char *function,
    int arg_int, char *arg_char)
{
  switch (error_type)
  {
    case SPLT_IERROR_INT:
      fprintf(stderr,
          "libmp3splt: error in %s with value %d\n",
          function, arg_int);
      fflush(stderr);
      break;
    case SPLT_IERROR_SET_ORIGINAL_TAGS:
      fprintf(stderr,
          "libmp3splt: cannot set original file tags, "
          "libmp3splt not compiled with libid3tag\n");
      fflush(stderr);
      break;
    case SPLT_IERROR_CHAR:
      fprintf(stderr,
          "libmp3splt: error in %s with message '%s'\n",function,arg_char);
      fflush(stderr);
      break;
    default:
      fprintf(stderr,
          "libmp3splt: unknown error in %s\n", function);
      fflush(stderr);
      break;
  }
}

/****************************/
/* utils miscellaneous */

//get silence position depending of the offset
float splt_u_silence_position(struct splt_ssplit *temp, float off)
{
  float position = (temp->end_position - temp->begin_position);
  position = temp->begin_position + (position*off);

  return position;
}

//returns a string error message from the 'error_code'
//-return result must be freed
char *splt_u_strerror(splt_state *state, int error_code)
{
  int max_error_size = 4096;
  char *error_msg = malloc(sizeof(char) * max_error_size);
  if (error_msg)
  {
    memset(error_msg,'\0',4096);

    switch (error_code)
    {
      //
      case SPLT_MIGHT_BE_VBR:
        snprintf(error_msg,max_error_size,
            " warning: might be VBR, use frame mode");
        break;
      case SPLT_SYNC_OK:
        snprintf(error_msg,max_error_size, " error mode ok");
        break;
      case SPLT_ERR_SYNC:
        snprintf(error_msg,max_error_size, " error: unknown sync error");
        break;
      case SPLT_ERR_NO_SYNC_FOUND:
        snprintf(error_msg,max_error_size, " no sync errors found");
        break;
      case SPLT_ERR_TOO_MANY_SYNC_ERR:
        snprintf(error_msg,max_error_size, " sync error: too many sync errors");
        break;
        //
      case SPLT_FREEDB_MAX_CD_REACHED :
        snprintf(error_msg,max_error_size, " maximum number of found CD reached");
        break;
      case SPLT_CUE_OK :
        snprintf(error_msg,max_error_size, " cue file processed");
        break;
      case SPLT_CDDB_OK :
        snprintf(error_msg,max_error_size, " cddb file processed");
        break;
      case SPLT_FREEDB_FILE_OK :
        snprintf(error_msg,max_error_size, " freedb file downloaded");
        break;
      case SPLT_FREEDB_OK :
        snprintf(error_msg,max_error_size, " freedb search processed");
        break;
        //
      case SPLT_FREEDB_ERROR_INITIALISE_SOCKET :
        snprintf(error_msg,max_error_size, 
            " freedb error: cannot initialise socket (%s)",
            state->err.strerror_msg);
        break;
      case SPLT_FREEDB_ERROR_CANNOT_GET_HOST :
        snprintf(error_msg,max_error_size, 
            " freedb error: cannot get host '%s' by name (%s)",
            state->err.error_data, state->err.strerror_msg);
        break;
      case SPLT_FREEDB_ERROR_CANNOT_OPEN_SOCKET :
        snprintf(error_msg,max_error_size, " freedb error: cannot open socket");
        break;
      case SPLT_FREEDB_ERROR_CANNOT_CONNECT :
        snprintf(error_msg,max_error_size, 
            " freedb error: cannot connect to host '%s' (%s)",
            state->err.error_data, state->err.strerror_msg);
        break;
      case SPLT_FREEDB_ERROR_CANNOT_SEND_MESSAGE :
        snprintf(error_msg,max_error_size, 
            " freedb error: cannot send message to host '%s' (%s)",
            state->err.error_data, state->err.strerror_msg);
        break;
      case SPLT_FREEDB_ERROR_INVALID_SERVER_ANSWER :
        snprintf(error_msg,max_error_size, " freedb error: invalid server answer");
        break;
      case SPLT_FREEDB_ERROR_SITE_201 :
        snprintf(error_msg,max_error_size, " freedb error: site returned code 201");
        break;
      case SPLT_FREEDB_ERROR_SITE_200 :
        snprintf(error_msg,max_error_size, " freedb error: site returned code 200");
        break;
      case SPLT_FREEDB_ERROR_BAD_COMMUNICATION :
        snprintf(error_msg,max_error_size, " freedb error: bad communication with site");
        break;
      case SPLT_FREEDB_ERROR_GETTING_INFOS :
        snprintf(error_msg,max_error_size, " freedb error: could not get infos from site '%s'",
            state->err.error_data);
        break;
      case SPLT_FREEDB_NO_CD_FOUND :
        snprintf(error_msg,max_error_size, " no CD found for this search");
        break;
      case SPLT_FREEDB_ERROR_CANNOT_RECV_MESSAGE:
        snprintf(error_msg,max_error_size,
            " freedb error: cannot receive message from server '%s' (%s)",
            state->err.error_data, state->err.strerror_msg);
        break;
      case SPLT_INVALID_CUE_FILE:
        snprintf(error_msg,max_error_size, " cue error: invalid cue file '%s'",
            state->err.error_data);
        break;
      case SPLT_INVALID_CDDB_FILE:
        snprintf(error_msg,max_error_size, " cddb error: invalid cddb file '%s'",
            state->err.error_data);
        break;
      case SPLT_FREEDB_NO_SUCH_CD_IN_DATABASE :
        snprintf(error_msg,max_error_size, " freedb error: No such CD entry in database");
        break;
      case SPLT_FREEDB_ERROR_SITE :
        snprintf(error_msg,max_error_size, " freedb error: site returned an unknown error");
        break;
        //
      case SPLT_DEWRAP_OK:
        snprintf(error_msg,max_error_size, " wrap split ok");
        break;
        //
      case SPLT_DEWRAP_ERR_FILE_LENGTH:
        snprintf(error_msg,max_error_size, " wrap error : incorrect file length");
        break;
      case SPLT_DEWRAP_ERR_VERSION_OLD:
        snprintf(error_msg,max_error_size,
            " wrap error: libmp3splt version too old for this wrap file");
        break;
      case SPLT_DEWRAP_ERR_NO_FILE_OR_BAD_INDEX:
        snprintf(error_msg,max_error_size,
            " wrap error: no file found or bad index");
        break;
      case SPLT_DEWRAP_ERR_FILE_DAMAGED_INCOMPLETE:
        snprintf(error_msg,max_error_size,
            " wrap error: file '%s' damaged or incomplete",
            state->err.error_data);
        break;
      case SPLT_DEWRAP_ERR_FILE_NOT_WRAPED_DAMAGED:
        snprintf(error_msg,max_error_size,
            " wrap error: maybe not a wrapped file or wrap file damaged");
        break;
        //
      case SPLT_OK_SPLIT_EOF :
        snprintf(error_msg,max_error_size," file split (EOF)");
        break;
      case SPLT_NO_SILENCE_SPLITPOINTS_FOUND:
        snprintf(error_msg,max_error_size, " no silence splitpoints found");
        break;
      case SPLT_TIME_SPLIT_OK:
        snprintf(error_msg,max_error_size, " time split ok");
        break;
      case SPLT_SILENCE_OK:
		// UWE transcription - supress message
		//snprintf(error_msg,max_error_size, " silence split ok");
		error_msg[0] = '\0'; 
        break;
      case SPLT_SPLITPOINT_BIGGER_THAN_LENGTH :
        snprintf(error_msg,max_error_size,
            " file split, splitpoints bigger than length");
        break;
      case SPLT_OK_SPLIT:
        snprintf(error_msg,max_error_size," file split");
        break;
      case SPLT_OK :
        //fprintf(console_err," bug in the program, please report it");
        break;
      case SPLT_ERROR_SPLITPOINTS :
        snprintf(error_msg,max_error_size, " error: not enough splitpoints (<2)");
        break;
      case SPLT_ERROR_CANNOT_OPEN_FILE :
        snprintf(error_msg,max_error_size,
            " error: cannot open file '%s' : %s",
            state->err.error_data, state->err.strerror_msg);
        break;
      case SPLT_ERROR_CANNOT_CLOSE_FILE :
        snprintf(error_msg,max_error_size,
            " error: cannot close file '%s' : %s",
            state->err.error_data, state->err.strerror_msg);
        break;
      case SPLT_ERROR_INVALID :
        ;
        int err = SPLT_OK;
        const char *plugin_name = splt_p_get_name(state,&err);
        snprintf(error_msg,max_error_size,
            " error: invalid input file '%s' for '%s' plugin",
            state->err.error_data, plugin_name);
        break;
      case SPLT_ERROR_EQUAL_SPLITPOINTS :
        snprintf(error_msg,max_error_size,
            " error: splitpoints are equal (%s)",
            state->err.error_data);
        break;
      case SPLT_ERROR_SPLITPOINTS_NOT_IN_ORDER :
        snprintf(error_msg,max_error_size,
            " error: the splitpoints are not in order (%s)",
            state->err.error_data);
        break;
      case SPLT_ERROR_NEGATIVE_SPLITPOINT :
        snprintf(error_msg,max_error_size, " error: negative splitpoint (%s)",
            state->err.error_data);
        break;
      case SPLT_ERROR_INCORRECT_PATH :
        snprintf(error_msg,max_error_size,
            " error: bad destination folder '%s' (%s)",
            state->err.error_data, state->err.strerror_msg);
        break;
      case SPLT_ERROR_INCOMPATIBLE_OPTIONS:
        snprintf(error_msg,max_error_size, " error: incompatible options");
        break;
      case SPLT_ERROR_INPUT_OUTPUT_SAME_FILE:
        snprintf(error_msg,max_error_size,
            " input and output are the same file ('%s')",
            state->err.error_data);
        break;
      case SPLT_ERROR_CANNOT_ALLOCATE_MEMORY:
        snprintf(error_msg,max_error_size, " error: cannot allocate memory");
        break;
      case SPLT_ERROR_CANNOT_OPEN_DEST_FILE:
        snprintf(error_msg,max_error_size,
            " error: cannot open destination file '%s' : %s",
            state->err.error_data,state->err.strerror_msg);
        break;
      case SPLT_ERROR_CANT_WRITE_TO_OUTPUT_FILE:
        snprintf(error_msg,max_error_size,
            " error: cannot write to output file '%s' : %s",
            state->err.error_data,state->err.strerror_msg);
        break;
      case SPLT_ERROR_WHILE_READING_FILE:
        snprintf(error_msg,max_error_size, " error: error while reading file '%s'",
            state->err.error_data,state->err.strerror_msg);
        break;
      case SPLT_ERROR_SEEKING_FILE:
        snprintf(error_msg,max_error_size, " error: cannot seek file '%s'",
            state->err.error_data);
        break;
      case SPLT_ERROR_BEGIN_OUT_OF_FILE:
        snprintf(error_msg,max_error_size, " error: begin point out of file");
        break;
      case SPLT_ERROR_INEXISTENT_FILE:
        snprintf(error_msg,max_error_size, " error: inexistent file '%s' : %s",
            state->err.error_data,state->err.strerror_msg);
        break;
      case SPLT_SPLIT_CANCELLED:
        snprintf(error_msg,max_error_size, " split process cancelled");
        break;
      case SPLT_ERROR_LIBRARY_LOCKED: 
        snprintf(error_msg,max_error_size, " error: library locked");
        break;
      case SPLT_ERROR_STATE_NULL:
        snprintf(error_msg,max_error_size,
            " error: the state has not been initialized with 'mp3splt_new_state'");
        break;
      case SPLT_ERROR_NEGATIVE_TIME_SPLIT:
        snprintf(error_msg,max_error_size, " error: negative time split");
        break;
      case SPLT_ERROR_CANNOT_CREATE_DIRECTORY:
        snprintf(error_msg,max_error_size, " error: cannot create directory '%s'",
            state->err.error_data);
        break;
      case SPLT_ERROR_NO_PLUGIN_FOUND:
        snprintf(error_msg,max_error_size, " error: no plugin found");
        break;
      case SPLT_ERROR_CANNOT_INIT_LIBLTDL:
        snprintf(error_msg,max_error_size, " error: cannot initiate libltdl");
        break;
      case SPLT_ERROR_CRC_FAILED:
        snprintf(error_msg,max_error_size, " error: CRC failed");
        break;
      case SPLT_ERROR_NO_PLUGIN_FOUND_FOR_FILE:
        snprintf(error_msg,max_error_size,
            " error: no plugin matches the file '%s'", state->err.error_data);
        break;
        //
      case SPLT_OUTPUT_FORMAT_OK:
        break;
      case SPLT_OUTPUT_FORMAT_AMBIGUOUS:
        snprintf(error_msg,max_error_size, " warning: output format ambigous (@t or @n missing)");
        break;
        //
      case SPLT_OUTPUT_FORMAT_ERROR:
        snprintf(error_msg,max_error_size, " warning: output format error");
        break;
        //
      case SPLT_ERROR_INEXISTENT_SPLITPOINT:
        snprintf(error_msg,max_error_size, " error: inexistent splitpoint");
        break;
        //
      case SPLT_ERROR_PLUGIN_ERROR:
        snprintf(error_msg,max_error_size, " plugin error: '%s'",
            state->err.error_data);
        break;
        //
      case SPLT_PLUGIN_ERROR_UNSUPPORTED_FEATURE:
        ;
        splt_plugins *pl = state->plug;
        int current_plugin = splt_t_get_current_plugin(state);
        snprintf(error_msg,max_error_size, " error: unsupported feature for the plugin '%s'",
            pl->data[current_plugin].info.name);
        break;
    }

    if (error_msg[0] == '\0')
    {
      free(error_msg);
      error_msg = NULL;
    }
  }
  else
  {
    //if not enough memory
    splt_u_error(SPLT_IERROR_CHAR,__func__, 0, "not enough memory");
  }

  return error_msg;
}

//debug messages
void splt_u_print_debug(const char *message,double optional, const char *optional2)
{
  if (global_debug)
  {
    if (optional != 0)
    {
      if (optional2 != NULL)
      {
        fprintf(stderr,"%s %f _%s_\n",message,optional,
            optional2);
      }
      else
      {
        fprintf(stderr,"%s %f\n",message,optional);
      }
    }
    else
    {
      if (optional2 != NULL)
      {
        fprintf(stderr,"%s _%s_\n",message, optional2);
      }
      else
      {
        fprintf(stderr,"%s\n",message);
      }
    }
    fflush(stderr);
  }
}

//convert to float for hundredth
// 3460 -> 34.6  | 34 seconds and 6 hundredth
double splt_u_get_double_pos(long split)
{
  double pos = 0;
  pos = split / 100;
  pos += ((split % 100) / 100.);

  return pos;
}

int splt_u_parse_ssplit_file(splt_state *state, FILE *log_file, int *error)
{
  char line[512] = { '\0' };
  int found = 0;

  while(fgets(line, 512, log_file)!=NULL)
  {
    int len = 0;
    float begin_position = 0, end_position = 0;
    if (sscanf(line, "%f\t%f\t%d", &begin_position, &end_position, &len) == 3)
    {
      splt_t_ssplit_new(&state->silence_list, begin_position, end_position, len, error);
      if (*error < 0)
      {
        break;
      }
      found++;
    }
  }

  return found;
}

//create recursive directories
int splt_u_create_directory(splt_state *state, const char *dir)
{
  int result = SPLT_OK;
  const char *ptr = NULL;
  if (dir[0] == '\0')
  {
    return result;
  }
  char *junk = malloc(sizeof(char) * (strlen(dir)+100));
  if (!junk)
  {
    return SPLT_ERROR_CANNOT_ALLOCATE_MEMORY;
  }
  DIR *d = NULL;
  
  splt_u_print_debug("Creating directory ...",0,dir);
  
  ptr = dir;
  while ((ptr = strchr(ptr, SPLT_DIRCHAR))!=NULL)
    {
      ptr++;
      strncpy(junk, dir, ptr-dir);
      junk[ptr-dir] = '\0';
      
      splt_u_print_debug("directory ...",0, junk);
      
      if (!(d = opendir(junk)))
        {
#ifdef __WIN32__
          if ((mkdir(junk))==-1)
            {
#else
          if ((mkdir(junk, 0755))==-1)
            {
#endif
              splt_t_set_strerror_msg(state);
              splt_t_set_error_data(state,junk);
              result = SPLT_ERROR_CANNOT_CREATE_DIRECTORY;
              break;
            }
        }
      else
        {
          closedir(d);
        }
    }

  //we have created all the directories except the last one
  if (!(d = opendir(dir)))
    {
      splt_u_print_debug("final directory ...",0, dir);

#ifdef __WIN32__
      if ((mkdir(dir))==-1)
        {
 #else
      if ((mkdir(dir, 0755))==-1)
        {
#endif
          splt_t_set_strerror_msg(state);
          splt_t_set_error_data(state,dir);
          result = SPLT_ERROR_CANNOT_CREATE_DIRECTORY;
        }
    }
  else
    {
      closedir(d);
    }
  
  if (junk)
  {
    free(junk);
    junk = NULL;
  }
  
  return result;
}

void splt_u_print(char *mess)
{
	fprintf(stdout,"mess = _%s_ \n",mess);
	fflush(stdout);
}

//check if its a directory
int splt_u_check_if_directory(char *fname)
{
  struct stat buffer;
  int         status = 0;

  if (fname == NULL)
  {
    return SPLT_FALSE;
  }
  else
  {
    status = stat(fname, &buffer);
    if (status == 0)
    {
      //if it is a directory
      if (S_ISDIR(buffer.st_mode))
      {
        return SPLT_TRUE;
      }
      else
      {
        return SPLT_FALSE;
      }
    }
    else
    {
      return SPLT_FALSE;
    }
  }

  return SPLT_FALSE;
}

