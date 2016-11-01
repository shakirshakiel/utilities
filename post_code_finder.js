// Postcodes to find from http://www.zweitwohnagentur.de/

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
