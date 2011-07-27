/*
    based on: http://www.onlinetools.org/articles/javascript_fallback.htm

    javascript to show or hide element
*/

// items with the div.hidden class applied get hidden if javascript is on
document.write('<style type="text/css">div.hidden{display:none;}</style>')

function collapse(id){
    if (document.getElementById && document.createTextNode){canDOM=true}
    if (canDOM && document.getElementById(id)){
    elm=document.getElementById(id);
        
    if (elm.style.display=='none') { // if explicitly collapsed, uncollapse
    	elm.style.display='block';
    }
    else if (elm.style.display=='block') { // else if explicitly uncollapsed - collapse
    	elm.style.display='none';
    }
    else if (elm.className.indexOf('hidden')>-1){ // else if pre-hidden - uncollapse
    	elm.style.display='block';
    }
    else {  // else explicitly collapse no matter what
    	elm.style.display='none';
    }
    
    //elm.style.display=(elm.style.display=='none'||elm.style.display=='')?'block':'none';
    }
}