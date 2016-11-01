// Postcodes to find from http://www.zweitwohnagentur.de/

function geocode() {
	result = [];
	anchors = document.getElementsByTagName("a");
	for(index in anchors){
		href = anchors[index].href;
		if(href && href.match(/javascript*/)) {
			code = href.match(/.*PLZ=(.*)&STRASSE.*/);
			loc = code[1] + " Dusseldorf";
			result.push(loc);
		}
	}
	console.log(result.join("|"));	
}

function reverse_geocode(postcodes) {
	result = [];
	anchors = document.getElementsByTagName("a");
	for(anchorIndex in anchors){
		for(postcodeIndex in postcodes) {
			href = anchors[anchorIndex].href;
			re = new RegExp(".*PLZ=" + postcodes[postcodeIndex] + "&STRASSE.*")
			if(href && href.match(/javascript*/) && href.match(re)) {			
				objectHref = anchors[anchorIndex].parentElement.children[0].href
				objectId = objectHref.match(/.*OBJEKT_NUM=(.*)/)[1]
				result.push(objectId);
			}	
		}
	}
	console.log(result);		
}
