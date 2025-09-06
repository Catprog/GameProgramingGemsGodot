extends Node

var _reptRandom = preload('ReptRandom.gd')
	
var _galaxyName;
var _x;
var _y;

var _rColor = 0;
var _gColor = 0;
var _bColor = 0;

var _systemName = ''
var _planetCont = 0

func _init(galaxyName,x:int,y:int): 
		
	if(str(galaxyName) == ''):
		return
		
	_galaxyName = galaxyName
	_x = x
	_y = y
	
	var _randClass = _reptRandom.new( str(_galaxyName) + " " + str(x) + ":" + str(y) )
	
	_rColor = _randClass.generateNumber();
	_gColor = _randClass.generateNumber();
	_bColor = _randClass.generateNumber();
	
	_planetCont = floor(_randClass.generateNumber()*3) + floor(_randClass.generateNumber()*3) + floor(_randClass.generateNumber()*3)
	
	_systemName = ceil( _randClass.generateNumber()*9000+999 ) ;
	
func Color():
	return Color(_rColor,_gColor,_bColor,1)
	
func Name():
	return str(_systemName);

func PlanetCount():
	return _planetCont;
