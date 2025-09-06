extends Node

var _galaxyName
var _reptRandom


var _galaxyStars = [];
var _systemData = {} ;

var reptRandom = preload('ReptRandom.gd')
var systemClass = preload('System.gd')

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
		
				
			if ( result < 0.01):
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


func isStar(x, y):
	
	x = remapCord(x,'X')
	y = remapCord(y,'Y')
		
	if ( self._galaxyStars[x].count(y) > 0  ):
		return true;
		
	return false;


func systemDetails( x, y):
	
	x = remapCord(x,'X')
	y = remapCord(y,'Y')
	
	var systemKey = ''
	
	if( isStar(x,y)):
		systemKey = str(x) + ":" + str(y) 
				
	if (not systemKey in _systemData):		
		
		if (systemKey == ''):
			_systemData[systemKey] = systemClass.new ( '', 0,0)
		else:
			_systemData[systemKey] = systemClass.new ( _galaxyName, x,y)
	
	return( _systemData[systemKey] )
