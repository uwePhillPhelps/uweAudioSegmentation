<?php
/*

    Phill phelps 2009 - philip3.phelps@uwe.ac.uk
    
    this file defines some functions for interacting with TRS XML files
    
        the need for parsing TRS XML files arises from legacy software
          * "transcriber" (http://trans.sourceforge.net)
          * "projectpad" for sakai (http://dewey.at.northwestern.edu/ppad2/)
          * "sakai" (http://sakaiproject.org/)
          
        these softwares share timecode and transcript information in a TRS format
          * (see trans-13.dtd) http://trans.sourceforge.net/en/archi.php
          
   
        Over the course of the project - the importance of the TRS XML file format
        has moved from being the primary data storage format to being a transient format
        
        at time of writing (November 2009) - it is used as the input "skeleton"
        we extract times from it, and store them in other formats during processing
          
    the most important function is extractTagData()
        we parse the xml tags and store the times and associated information
        in a series of indexed arrays
*/
  
class TRSXMLTools {

        // flags
        //
        public $character_data_on; // flag used when extracting text between two closed XML tags
        public $tag_complete;      // flag 
        
        // transient values - updated as we progress
        //
        public $last_tag_read;       // name of last XML tag processed
        public $last_startTime_read; // (float) value of last startTime attribute
        public $last_synctime_read;  // (float) value of last time attribute from last sync tag
        public $begin;               // current timecode start value
        public $speaker_name;        // current speaker
        public $matchingfname;       // splitFilename for Turn tag with startTime==$begin
        
        
        // accumalating values - arrays filled or counters incremented as we progress
        //
        // arrays
        //
    	public $ary_fnames;   // segment mp3 filenames indexed by (int) tag count
        public $ary_times;    // start times indexed by (int) tag count
        public $ary_types;    // tag types indexed by (int) tag count
    	public $ary_spklist;  // !!php associative array!! speakers indexed by speaker ids
    	public $ary_spktimes; // speaker ids indexed by (float) startTime
        public $ary_fnametimes; // segment mp3 filenames indexed by (float) startTime
    	//
        // counters
        //
    	public $spkcount;     // (int) count of individual speakers
        public $tagcount;     // (int) count of all tags
        public $sectioncount; // (int) count of section tags
        public $turncount;    // (int) count of section tags
        public $synccount;    // (int) count of turn tags
        
        
    function __construct() {
        $this->character_data_on = false;  // flag used when extracting text between two closed XML tags
        $this->tag_complete = true;      // flag 

        $this->last_tag_read = '';        // name of last XML tag processed
        $this->last_startTime_read = 0.0; // (float) value of last startTime attribute
        $this->last_synctime_read = 0.0;  // (float) value of last time attribute from last sync tag
        $this->begin = 0;                 // current timecode start value
        $this->speaker_name = '';         // current speaker
        $this->matchingfname = '';        // splitFilename for Turn tag with startTime==$begin

    	$this->ary_fnames = array();  // segment mp3 filenames indexed by (int) tag count
        $this->ary_times= array();    // start times indexed by (int) tag count
        $this->ary_types= array();    // tag types indexed by (int) tag count
    	$this->ary_spklist= array();  // !!php associative array!! speakers indexed by speaker ids
    	$this->ary_spktimes= array(); // speaker ids indexed by (float) startTime
        $this->ary_fnametimes = array();  // segment mp3 filenames indexed by (float) startTime
   
    	$this->spkcount = 0;     // (int) count of individual speakers
        $this->tagcount = 0;     // (int) count of all tags
        $this->sectioncount = 0; // (int) count of section tags
        $this->turncount = 0;    // (int) count of section tags
        $this->synccount = 0;    // (int) count of turn tags
        
    
    }
    
    function parseXMLFilename($fullpath){
    	/*
    		loads and parses an XML file from a full path specified
    		
    	    parses xml tags with extractTagData()
    	    ignores character data
    	    ignores closing tags
    	*/
    
        $xml_parser = xml_parser_create();
        xml_parser_set_option($xml_parser, XML_OPTION_CASE_FOLDING, false);
        xml_set_element_handler($xml_parser, array($this, 'extractTagData'), NULL); //empty endElement
        xml_set_character_data_handler($xml_parser, NULL); //empty textParts function

        // open the file to parse  
        $filehandle = fopen($fullpath,'r') or trigger_error(
            "Can't open the skeleton TRS data file for this transcript"
            , E_USER_ERROR);

        // parse
        while ($file_content = fread($filehandle, 4096)) {
            if (!xml_parse($xml_parser, $file_content, feof($filehandle))) {
                die(sprintf("XML error: %s at line %d",
                            xml_error_string(xml_get_error_code($xml_parser)),
                            xml_get_current_line_number($xml_parser)));
            }
        }
        xml_parser_free($xml_parser);
        fclose($filehandle);
        unset($filehandle);
        
        // counters offset by one
        $this->tagcount--;
        $this->sectioncount--;
        $this->turncount--;
        $this->synccount--;
    }
    
    function calculateLengths(){
    	/*
    		returns an array of lengths of TRS XML turn tags
    		
    			aborts if no xml file is loaded
     	*/
    
    	// abort if no xml tags counted
    	if ( $this->tagcount == 0) {
    		die("No xml tags counted - load an xml file first with loadXMLFilename()");
    	}

		// lengths are calculated by subtracting the difference in timecode
		// of each segment encountered
        $ary_lengths = array();
        for ($beginindex = 1; $beginindex <= $this->tagcount; $beginindex++)
        {
        	// find the time for [T]urn tags
        	if ($this->ary_types[$beginindex] == 'T'){
    			
    			$begin = $this->ary_times[$beginindex];
    					
    			// find matching $end [T]urn tag
    			$endindex = 0;
    			do{	
    				$endindex++;
    				// find the time for [T]urn tags
    				if ($this->ary_types[$endindex] == 'T'){
    					$end = $this->ary_times[$endindex];	
    				}
    			}while ($endindex < $this->tagcount && $end <= $begin);
    			
    			$ary_lengths[$beginindex] = $end - $begin;
    			
    		}
    	}
    	return $ary_lengths;
    }
    
    function extractTagData($parser, $name, $attrs)
    {
    //based on tips from hendra_g
    // --- http://uk2.php.net/manual/en/function.xml-set-element-handler.php#58893
               
        // store the name of the tag in a global variable
        $this->last_tag_read = $name;

        //if the tag we've just read has some attributes (i.e it doesn't look like <tag> or </tag>)
        if (sizeof($attrs)) {

    		if ($name == "Speaker"){
                // if we've read a speaker tag
        		// we need to associate the name of the speaker with the ID
        		// storing it in a global array $ary_spklist
    		    $this->ary_spklist[$attrs["id"]] = $attrs["name"];
    		}
    			
            while (list($k, $v) = each($attrs))
            {
            
              // check for Section tags
              if ($name == "Section"){
                if($k == "startTime"){
                    // if we've just read a Section tag
                    // and it's got a startTime argument
                   $this->last_startTime_read = $v; // store the value in a global variable
                   $this->ary_times[$this->tagcount] = $v; // store the time in a global array 
                   $this->ary_types[$this->tagcount] = "S"; // store the type in a global array (S for Section)
                   
              
                   if ($this->begin == -1){
                    // if we've just read a Section tag
                    // and it's got a time argument
                    // and the $begin value is -1 (not a legitimate time value)
                    // this is a value used to flag that we need to update the empty begin with the FIRST FOUND sync point
                    $this->begin = $this->last_startTime_read; // store the value in the global $begin variable
                    //echo "just updated begin to $begin";
                   }
                   
                }
                else if($k == "endTime"){
                    // if we've just read a Section tag
                    // and it's got a endTime argument
                    
                    // don't store the value
                }
                else {
                    // if we've got here, this is an unexpected argument for the section tag
                }
                $this->sectioncount++; // that's the end of the section tag then
              }
              
              // check for Turn tags
              else if ($name == "Turn"){
                if ($k == "startTime"){
                    // if we've just read a Turn tag
                    // and it's got a startTime argument
                    $this->last_startTime_read = $v; // store the value in a global variable                
                    $this->ary_times[$this->tagcount] = $v; // store the time in a global array 
                    $this->ary_types[$this->tagcount] = "T"; // store the type in a global array (T for Turn)
                    
                    // if we've just read a Turn tag
                   // and it's got a startTime argument
                   // get at the value for the speaker argument directly
        		   // store the id in an array at the point indicated by startTime
                   $this->ary_spktimes[$v] = $attrs["speaker"];
                   
                   
                   if ($this->begin == -1){
                    // if we've just read a Turn tag
                    // and it's got a time argument
                    // and the $begin value is -1 (not a legitimate time value)
                    // this is a value used to flag that we need to update the empty begin with the FIRST FOUND point
                    $this->begin = $this->last_startTime_read; // store the value in the global $begin variable
                    //echo "just updated begin to $begin";
                   }
                }
                else if($k == "endTime"){
                    // if we've just read a Turn tag
                    // and it's got a endTime argument
                    
                    // don't store the value
                }
                else if ($k == "splitFilename"){
                    // if we've just read a Turn tag
                    // and it's got a splitFilename argument
                      $this->ary_fnames[$this->tagcount] = $v; // store the mp3 filename in an array
                      $this->ary_fnametimes[$this->last_startTime_read] = $v; // indexed by (float) startTime
                      
                    if ($this->last_startTime_read == $this->begin){
                        // if we've just read a Turn tag
                        // and it's got a splitFilename argument
                        // and we've read the startTime previously
                        // and the last_startTime_read is the same as the requested $begin time
                        // (the $begin seekpoint time comes from from WIP or from the URL)
                        

                        //echo "found an mp3 file name".$v." for". $this->begin. "seconds";
                        $this->matchingfname = $v; // store the matching filename in a global variable
                    }
                }
                else if ($k == "speaker"){
                    // if we've just read a Turn tag
                    // and it's got a speaker argument
                    
                    // don't store the value
                }
                else {
                    // if we've got here, this is an unexpected argument for the turn tag
                }
               $this->turncount++; // that's the end of the turn tag then
               }
    		   
    		  // check for Sync tags
              else if($name == "Sync"){
                if ($k == "time"){
                    // if we've just read a Sync tag
                    // and it's got a time argument
                    $this->last_synctime_read = $v; // store the value in a global variable
                    $this->ary_times[$this->tagcount] = $v; // store the time in a global array 
                    $this->ary_types[$this->tagcount] = "Y"; // store the type in a global array (Y for sYnc)
                    
                    
                    if ($this->begin == -1){
                    // if we've just read a Sync tag
                    // and it's got a time argument
                    // and the $begin value is -1 (not a legitimate time value)
                    // this is a value used to flag that we need to update the empty begin with the FIRST FOUND point
                    $this->begin = $this->last_startTime_read; // store the value in the global $begin variable
                    //echo "just updated begin to $begin";
                   }
                }
                else {
                    // if we've got here, this is an unexpected argument for the turn tag
                }
                $this->synccount++; // that's the end of the sync tag then
               }
               
               else{
                    // if we've got here, this is an unexpected tag
               }
            }//while
            
            $this->tagcount++; // that's the end of the tag
        }//sizeof
        
           
        //## Tag is still still incomplete,
        //## will be completed at either endElement or characterData ##//
        $this->tag_complete = false;
        $this->character_data_on = false;
    }
}

?>