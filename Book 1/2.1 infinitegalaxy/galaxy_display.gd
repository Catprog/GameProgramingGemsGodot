extends TextureRect

var _galImage;
var _texture

var _zoomedTexture

var _GalaxyMaker = preload('res://Galaxy/GalaxyMaker.gd')
var _Galaxy = null

var playerX = 0;
var playerY = 0;

var imageWidthToShow = 256;
var imageHeightToShow = 256;

@export var xLabel: Label
@export var yLabel: Label


@export var nameLabel: Label
@export var planetCntLabel: Label

@export var zoomedNode: TextureRect

func _ready():
	_galImage = Image.new()
	
	
	_Galaxy = _GalaxyMaker.new(240);
		
	var height = _Galaxy.height() + imageHeightToShow;
	var width = _Galaxy.width() + imageWidthToShow;
	
	_galImage = Image.create_empty(
		width, height,false,Image.FORMAT_RGBA8 
	)
		
	
	
	
	var black = Color(0.0,0.0,0.0,1)
	var white = Color(1.0,1.0,1.0,1)
	var grey = Color(0.5,0.5,0.5,1)
	var red = Color(1,0,0,1)
	
	
	_galImage.fill(black)
	
	print('image made')
	
	for x in width :
		for y in height:
			
			var xStar = x - imageWidthToShow/2
			var yStar = y - imageHeightToShow/2
				#Use an offset to move the target system into the middle of the screen
			
			if( _Galaxy.isStar(xStar,yStar) ):
				
				var system = _Galaxy.systemDetails(xStar,yStar)
								
				_galImage.set_pixel(x,y, system.Color())
				
	
	var _textureImg = ImageTexture.create_from_image(_galImage);
	
	_texture = AtlasTexture.new()	
	_texture.atlas = _textureImg
	_texture.resource_name = "Galaxy Texture"
	
	
	_zoomedTexture = AtlasTexture.new()	
	_zoomedTexture.atlas = _textureImg
	_zoomedTexture.resource_name = "Galaxy Texture 2"
	
	
	
	set_process_input(true) 
	
	
	drawGalaxy()
	drawCord()

func drawCord():
	
	if(xLabel):
		#xLabel.text = str(playerX)
		pass
		
	if(yLabel):
		#yLabel.text = str(playerY)
		pass

func _input(_ev):
	
	var redraw = false;
	
	if Input.is_key_pressed(KEY_LEFT):
		playerX = playerX - 1
		redraw = true	
		
	if Input.is_key_pressed(KEY_RIGHT):
		playerX = playerX + 1
		redraw = true
		
		
	if Input.is_key_pressed(KEY_UP):
		playerY = playerY - 1
		redraw = true
		
	if Input.is_key_pressed(KEY_DOWN):
		playerY = playerY + 1
		redraw = true
			
	
		
	if redraw:
		
		playerX = _Galaxy.remapCord(playerX, 'X' )
		playerY = _Galaxy.remapCord(playerY, 'Y' )
	
		drawCord();	
		await drawGalaxy()
		


func drawGalaxy():
	
	var _Rect2Draw = Rect2(playerX , playerY, imageWidthToShow , imageHeightToShow) 
	
	
	var xOffset = (imageWidthToShow - 10)/2
	var yOffset = (imageHeightToShow - 10)/2
	
	var _Rect2DrawZoomed = Rect2(playerX + xOffset, playerY + yOffset, 11 , 11) 
	
		
	#print(_Rect2Draw);
	
	#var _dynImage = _galImage.get_rect ( _Rect2Draw )
	
	#var _imageTexture = ImageTexture.new()
	#_imageTexture = ImageTexture.create_from_image(_dynImage)
	#_imageTexture.resource_name = "The created texture!"*/
		
	_texture.region = _Rect2Draw
	self.texture = _texture
	
	
	_zoomedTexture.region = _Rect2DrawZoomed
	zoomedNode.texture = _zoomedTexture
	
	var systemDetails = _Galaxy.systemDetails( playerX, playerY )
	
	
	if( systemDetails.Name() == ''):
		planetCntLabel.text = ''
		nameLabel.text = ''
	else:
		nameLabel.text = 'System ' + systemDetails.Name()
		planetCntLabel.text = 'Planet Count ' + str(systemDetails.PlanetCount())

	
	
