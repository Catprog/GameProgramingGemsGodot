extends Node

var _reptRandom = preload('ReptRandom.gd')
static var _starSpectrum = preload("starSpectrum.png")
	
var _galaxyName;
var _x;
var _y;

var _starColor = Color(0,0,0,1);

var _systemName = ''
var _planetCont = 0

func _init(galaxyName,x:int,y:int): 
	
		
	if(str(galaxyName) == ''):
		return
		
	_galaxyName = galaxyName
	_x = x
	_y = y
	
	var _randClass = _reptRandom.new( str(_galaxyName) + " " + str(x) + ":" + str(y) )
	
	#Version0 Code
	#_rColor = _randClass.generateNumber();
	#_gColor = _randClass.generateNumber();
	#_bColor = _randClass.generateNumber();
	
	
	var colorPercentage = _randClass.generateNumber();
	var colorPixel = floor(_starSpectrum.get_width() * colorPercentage);
		
	_starColor = _starSpectrum.get_image().get_pixel(colorPixel, 0);
		
	
	_randClass.generateNumber(); #leftover from version0
	_randClass.generateNumber(); #leftover from version0
	
	_planetCont = floor(_randClass.generateNumber()*3) + floor(_randClass.generateNumber()*3) + floor(_randClass.generateNumber()*3)
	
	_systemName = ceil( _randClass.generateNumber()*9000+999 ) ;
	
func Color():
	return _starColor;
	
func Name():
	return str(_systemName);

func PlanetCount():
	return _planetCont;
