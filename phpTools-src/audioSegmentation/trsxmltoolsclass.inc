<?php
/*  
    As you can tell from the sheer.... quality of the code - this is just a
    prototype with potentially lots and lots of bugs. 
	
	Should you have any questions or comments (not necessarily jibes at my
	hilariously inefficient php code) please email me at zenpho@zenpho.co.uk
	or philip3.phelps@uwe.ac.uk

	Thanks,
	
	========================================================================
	Intended use:
		class definitions for interacting with TRS XML files
		
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
		
	see also:
		troywolfxmlclass.inc
	
	summary:
		loading and parsing XML files
		determining the timespan between a tag with startTime/endTime attributes
		determining the path of the original audio file
		determining the first timecode point
		determining the last timecode point 
		determining the path of a tag with a splitFilename attribute
		determining the next adjacent timecode for a given a startTime
		creating an array of all TRS XML turn tags as troywolf xml() objects
   
*/


require_once('troywolfxmlclass.inc'); // Troy Wolf's class
// originally called class_xml.php this dumps xml data into 
// easily-iteratable arrays for each tagname and attribute
  
class TRSXMLTools {
    /*
        most of this is a wrapper for the troy wolf class
    */   

    //
    // 
    public $x;
    //
    //
      
    function __construct() {
        $this->x = new xml();
    }
    
    function fetch($fullpath){
    	/*
    		loads and parses an XML file from a full path specified
    	*/
    
        $source = file_get_contents($fullpath);
       
        if (!$this->x->fetch($source)) {
          // echo ;
          trigger_error("Problem parsing xml $fullpath<br>"
            . $this->x->log 
          , E_USER_ERROR);
          
        }
        unset($source);
    }
    
    function length($turn){
    	/*
    		returns the length of a passed TRS XML turn tag
            
                actually, any tag with a starttime and endtime attribute
     	*/
        
        if ($turn->_attr->STARTTIME && $turn->_attr->ENDTIME){
            return $turn->_attr->ENDTIME - $turn->_attr->STARTTIME;
        }
        else {
            return false;
        }
    }
    
    function originalAudioFilename(){
        /*
    		returns audioFilename attribute in the first TRANS tag
     	*/
        if ($this->x->data->TRANS[0]->_attr->AUDIO_FILENAME){
            return $this->x->data->TRANS[0]->_attr->AUDIO_FILENAME;
        } else {
            return false;
        }
    }
    
    function firstTurnStartTime(){
        /*
    		returns startTime attribute in the first TURN tag
     	*/
        foreach ($this->eachTurn() as $turn){
            return $turn->_attr->STARTTIME;
        }
    }
    
    function lastTurnEndTime(){
        /*
    		returns endTime attribute in the last TURN tag
     	*/
        $array_of_turns = $this->eachTurn();
        return $array_of_turns[count($array_of_turns)-1]->_attr->ENDTIME;
    }
    
    function findTurnSplitFilename($startTime, $mode = 'start'){
        
        foreach ($this->eachTurn() as $turn){
            
            if ($startTime == $turn->_attr->STARTTIME){
                return $turn->_attr->SPLITFILENAME;
            }
            
            /*
            if (
            $mode == 'start'
            and $startTime == $turn->_attr->STARTTIME){
                
                return $turn->_attr->SPLITFILENAME;
            }
            else if (
            $mode == 'between'
            and $startTime >= $turn->_attr->STARTTIME
            and $turn->_attr->ENDTIME < $startTime ) {
                
                return $turn->_attr->SPLITFILENAME;
            }
            else {
                return false;
            }
            */
        }
        /* if we've reached the end of the turns
         and there's still no matching time, then return false */
        return false;
    }
    
    function findTurnEndTime($startTime, $mode = 'start'){
        foreach ($this->eachTurn() as $turn){
            
            if ($startTime == $turn->_attr->STARTTIME){
                return $turn->_attr->ENDTIME;
            }
            
            /*
            if (
            $mode == 'start'
            and $startTime == $turn->_attr->STARTTIME){
                
                return $turn->_attr->ENDTIME;
            }
            else if (
            $mode == 'between'
            and $startTime >= $turn->_attr->STARTTIME
            and $turn->_attr->ENDTIME < $startTime ) {
                
                return $turn->_attr->ENDTIME;
            }
            else {
                return false;
            }
            */
        }
    }
    
    /*
        this would be useful
    function findTurnAttribute($attribute, $searchvalue, $using = 'start'){
        foreach ($this->eachTurn() as $turn){
            
            switch($using){
                case 'start':
                    if ($turn->$attribute){
                        echo "it exists\n"
                        if ($turn->$attribute == $searchvalue) return $turn->$attribute;
                break;
            }
        }
    }
    */
    
    function eachTurn(){
        /*
    		returns an array of turn tags to iterate over
            
                keeps the nested foreach structure out of the way
     	*/
    
        $array_of_turns = array();
        
        foreach ($this->x->data->TRANS as $trans){            
        
            // sometimes episodes are containers for sections for turns
            if ($trans->EPISODE) {
                foreach ($trans->EPISODE as $episode){
                    foreach ($episode->SECTION as $section){
                        foreach ($section->TURN as $turn){
                            $array_of_turns[] = $turn;
                        }
                    }
                }
            }
            else if ($trans->SECTION){
                // other times a section is a container for turns
                foreach ($trans->SECTION as $section){
                    foreach ($section->TURN as $turn){
                        $array_of_turns[] = $turn;
                    }
                }
            }
            else {
                // turns are there on their own
                foreach ($trans->TURN as $turn){
                    $array_of_turns[] = $turn;
                }
            }
        }
        
        return $array_of_turns;
    }
    
}

?>