extends Node2D

var fuzzyLogicClass = preload("res://FuzzyClass/fuzzyClass.gd")
var fuzzyLogic =  fuzzyLogicClass.new()

@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect2: TextureRect = $TextureRect2


@onready var speedMultipler: Label = $Label



var _distance = 30
var _distanceDelta = 0

func _updateVariables():
	
	_distance = _distance + 1
	_distanceDelta = _distanceDelta + 2
	
	if(_distanceDelta > 60):
		_distanceDelta = -60;		
	
	if(_distance > 55):
		_distance = -1
	
	fuzzyLogic.setVariable('DistanceDelta', _distanceDelta);
	fuzzyLogic.setVariable('DistanceCarTenthLength', _distance);
	
	showImages()
	
	await get_tree().create_timer(0.1).timeout 
	_updateVariables()
	

func _init():
	
	fuzzyLogic.createInputVariable('DistanceCarTenthLength',-1,50)
	
	
	fuzzyLogic.createSawToothValue('DistanceCarTenthLength','Very Small',-1,2,10)
	fuzzyLogic.createSawToothValue('DistanceCarTenthLength','Small',10,10,20)
	fuzzyLogic.createSawToothValue('DistanceCarTenthLength','Perfect',20,20,10)
	fuzzyLogic.createSawToothValue('DistanceCarTenthLength','Big',30,30,40)
	fuzzyLogic.createSawToothValue('DistanceCarTenthLength','Very Big',40,50,30)
	
	fuzzyLogic.setVariable('DistanceCarTenthLength', 10);
	
	
	fuzzyLogic.createInputVariable('DistanceDelta',-60,60)
	
	
	fuzzyLogic.createSawToothValue('DistanceDelta','Shrinking Fast',-60,-50,-25)
	fuzzyLogic.createSawToothValue('DistanceDelta','Shrinking',-25,-25,0)
	fuzzyLogic.createSawToothValue('DistanceDelta','Stable',0,0,-25)
	fuzzyLogic.createSawToothValue('DistanceDelta','Growing',25,25,0)
	fuzzyLogic.createSawToothValue('DistanceDelta','Growing Fast',50,60,25)
	
	
	fuzzyLogic.setVariable('DistanceDelta',0)
	
	
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Very Small', 'DistanceDelta','Shrinking Fast'], 10);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Very Small', 'DistanceDelta','Shrinking'], 10);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Very Small', 'DistanceDelta','Stable'], 15);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Very Small', 'DistanceDelta','Growing'], 15);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Very Small', 'DistanceDelta','Growing Fast'],20);
	
	
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Small', 'DistanceDelta','Shrinking Fast'], 10);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Small', 'DistanceDelta','Shrinking'], 15);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Small', 'DistanceDelta','Stable'],15);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Small', 'DistanceDelta','Growing'], 20);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Small', 'DistanceDelta','Growing Fast'], 30);
	
	
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Perfect', 'DistanceDelta','Shrinking Fast'], 15);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Perfect', 'DistanceDelta','Shrinking'], 15);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Perfect', 'DistanceDelta','Stable'],20);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Perfect', 'DistanceDelta','Growing'], 30);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Perfect', 'DistanceDelta','Growing Fast'], 30);
		
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Big', 'DistanceDelta','Shrinking Fast'], 15);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Big', 'DistanceDelta','Shrinking'], 20);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Big', 'DistanceDelta','Stable'],30);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Big', 'DistanceDelta','Growing'], 30);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Big', 'DistanceDelta','Growing Fast'], 40);
		
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Very Big', 'DistanceDelta','Shrinking Fast'], 20);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Very Big', 'DistanceDelta','Shrinking'], 30);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Very Big', 'DistanceDelta','Stable'],30);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Very Big', 'DistanceDelta','Growing'], 40);
	fuzzyLogic.setOutputValue('Speed * 20', ['DistanceCarTenthLength', 'Very Big', 'DistanceDelta','Growing Fast'], 40);
	
	fuzzyLogic.saveFile ('CAR.fuzzy')
	

func _ready():
	_updateVariables()
	
func showImages():
	
	var _image_texture = ImageTexture.create_from_image(fuzzyLogic.getPicture('DistanceCarTenthLength'))
	var _image_texture2 = ImageTexture.create_from_image(fuzzyLogic.getPicture('DistanceDelta'))
	
	
	texture_rect.texture  = _image_texture
	texture_rect2.texture  = _image_texture2
	
	var output = fuzzyLogic.getOutput('Speed * 20');
		
	if output != null :
		output = output / 20.0
	
	speedMultipler.text =  'Speed Multipler: ' + str(output) ;
