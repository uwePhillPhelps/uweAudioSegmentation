function getFlashMovieObject(movieName)
{
	/*
		from: http://www.permadi.com/tutorial/flashjscommand/
	*/
	if (window.document[movieName]) 
	{
	  return window.document[movieName];
	}
	if (navigator.appName.indexOf("Microsoft Internet")==-1)
	{
	if (document.embeds && document.embeds[movieName])
	  return document.embeds[movieName]; 
	}
	else // if (navigator.appName.indexOf("Microsoft Internet")!=-1)
	{
	return document.getElementById(movieName);
	}
}

function seekPlayheadToTime(seektime)
{
	/* 
		requires getFlashMovieObject()
	*/
     getFlashMovieObject("audioPlayer").SetVariable(
     	"player.playheadTime", 
     	seektime/1000);
}


function scrollToSegment( scrolltime )
{
    /*
        based on an example at
        http://www.experts-exchange.com/Programming/Languages/Scripting/JavaScript/Q_21525793.html
        
        2009 - phill phelps
        
        Indended usage:
            
            Automatically scroll to the transcript text nearest the requested time (in milliseconds)
            
            Accomplished by searching for every element within the class "viewerTableRow"
            The nearest element with an ID attribute matching the requested time is requested to scrollIntoView()
            
            this goes hand in hand with an swf with an embedded call to scrollToSegment()
        
    */
    
    var ary_elements;
    var i;
    
    function scrollIntoViewAndHighlight( element )
    {
        // scroll the element into view
        element.scrollIntoView(true);
        
        // use CSS to highlight the element
        element.className = "viewerTableRowHighlighted";
    }
    
    // restore CSS status of any previously highlighted elements
    ary_elements = document.getElementsByClassName("viewerTableRowHighlighted");
    for (i = 0; i < (ary_elements.length); i++)
    {
        ary_elements[i].className = "viewerTableRow";
    }
    
    // scroll into view (and use CSS to highlight) the element nearest the requested timecode
    ary_elements = document.getElementsByClassName("viewerTableRow");
    for (i = 0; i < (ary_elements.length); i++) 
    {
        var need_time = parseInt(scrolltime);
        var this_time = parseInt(ary_elements[i].getAttribute('id'));
        var next_time = 'undefined';
        
        // do something unusual when we reach the last element in the transcript
        if ( i == (ary_elements.length -1) )
        {
            next_time = this_time;
        }
        else
        {
            next_time = parseInt(ary_elements[i+1].getAttribute('id'));
        }
        
        // when the requested time falls between the cracks, pick the first one of the two
        if ( next_time != this_time
            && (need_time > this_time) 
            && ( need_time < next_time) )
        {   
            scrollIntoViewAndHighlight( ary_elements[i] );
            break;
        }
        else if ( next_time == this_time ) // must be the last element
        {
            scrollIntoViewAndHighlight( ary_elements[i] );
            break;
        }// if this < need etc
        
    }// for each element

}


