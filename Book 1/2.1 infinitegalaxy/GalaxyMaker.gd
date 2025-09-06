extends Node

var _galaxyName
var _reptRandom


var _galaxyStars = [];

var reptRandom = preload('ReptRandom.gd')

var _width = 1024;
var _height = 1024;

func width():
	return _width;
	
func height():
	return _height;

func _init(galaxyName):
	
	_galaxyName = galaxyName
	_reptRandom = reptRandom.new('galaxy'+str(galaxyName) )
	
	self.makeGalaxy();

func makeGalaxy():
	
	
	for x in _width:
		
		self._galaxyStars.append([]);
		
		for y in _height:
			
			var result = _reptRandom.generateNumber(  )
		
				
			if ( result < 0.001):
				self._galaxyStars[x].append(y)
			
		
	
	
func remapCord(cord, type ):
	
	if(type == 'X'):
		
		if( cord < 0):
			return cord + _width
		elif( cord >= _width):
			return cord - _width
			
			
	
	if(type == 'Y'):
		
		if( cord < 0):
			return cord + _height
		elif( cord >= _height):
			return cord - _height	
			
	return cord
	
func starDetails(x, y):
	
	x = x % _width;
	y = y % _height;
			
	if ( self._galaxyStars[x].count(y) > 0  ):
		return true;
		
	return false;
