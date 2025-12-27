extends Node

var _pixelData = {}
var _charToIndex = {}

func _extractData():
	
	var _font = Image.load_from_file("res://FuzzyClass/font.png")
	
	var size = _font.get_size()
	
	var _data  = [];
		
	for y in range (size[1]) :
		for x in range (size[0]) :
			
			
			var _clr = _font.get_pixel(x,y) == Color.BLACK
			
			if _clr :
				
				_data.append ( {'x':x, 'y': y} );
			
			
			var _xIndex = x / 15
			var _yIndex = y / 20
			
			
			var _xPos = x % 15
			var _yPos = y % 20
			
			
			var _key = _xIndex + _yIndex * 16
						
			
			if(_clr):
				
				if ! (_key in _pixelData):
					_pixelData[_key] = []
				
				_pixelData[_key].append ( {'x':_xPos, 'y': _yPos} );
			
					
	
	var _file = FileAccess.open("res://FuzzyClass/Font.txt", FileAccess.READ)
	var _content = _file.get_as_text()
	
	var _index = 0;
	for _char in _content:
		
		_charToIndex[_char] = _index;
		
		_index = _index + 1
		
			
	
	
func _init():
	
	
	_extractData()
	
	

func draw_h(x, y, color2Use):
	
	pass
	

func draw(image: Image,x: int, y:int, text: String, color2Use):
	
	
	for _char in text:
		
		x = x + 8
		
		if( _char in _charToIndex):
			
		
			for _pix in _pixelData[ _charToIndex[_char] ]:
				
				image.set_pixel(x+_pix['x'],y+_pix['y'],color2Use)
			
		
		
		
