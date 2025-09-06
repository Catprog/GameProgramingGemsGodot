extends Node

var _seed

func _init(  seed2Use):
	
	var seed2UseStr = seed2Use.sha256_text();
	var intResult = seed2UseStr.substr(0,10).hex_to_int();
	
	
	self._seed = intResult
	
	

func generateNumber(  ):
	
	var newseed = self._seed;
	
	newseed = newseed * 16807;
	newseed = newseed % 2147483647;
	
	
	var floatResult = newseed /  2147483647.0
	self._seed  = newseed;
			
	return floatResult
		
