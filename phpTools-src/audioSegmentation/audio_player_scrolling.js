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


function scrollToSegment(scrolltime)
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
    
    var ary_elements = document.getElementsByClassName("viewerTableRow");
    for (var i = 0; i < (ary_elements.length-1); i++) {
        
        var need_time = parseInt(scrolltime);
        var this_time = parseInt(ary_elements[i].getAttribute('id'));
        var next_time = parseInt(ary_elements[i+1].getAttribute('id'));
        
        if ( (this_time <= need_time) && (next_time > need_time)){
            // the requested time falls between the cracks, pick the first one of the two
            ary_elements[i].scrollIntoView(true);
            break;
        }
    }

}
