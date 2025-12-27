extends Node

var _inputValues = {}
var _outputValues = {}

const NUM_OF_BUCKETS = 256
const NUM_OF_STEPS = 255

var _dirtyImage = { };

var _image = {}

var _DrawTextClass = preload("res://FuzzyClass/DrawTextOnImage.gd")
var _DrawText = _DrawTextClass.new()


func loadFile(path):
	var fileName = "res://FuzzyClass/" + path
	pass
	
func saveFile(path):
	
	var fileName = "res://FuzzyClass/" + path
	
	var fileSave = {
		'input': _inputValues,
		'output': _outputValues
	}
	
	
	var _file = FileAccess.open(fileName, FileAccess.WRITE)
	_file.store_string( JSON.stringify(fileSave) )
	
	
	
	pass
	
func listVariable():
	pass

func _OutputCalcAvg(outputs):
	
	var total = 0;
	
	for  i in outputs:
		
		total = total + i * outputs[i]
		
	return total
		
		

func _calcOutput(outputName):
	
	var outputs = {}
	
	var totalPercentages = 0
		
	for rule in _outputValues[outputName].rules:
		
		var calcuatedPecentage = 1
		
		
		for inputName in rule.inputs:
			
			var inputGroup = rule.inputs[inputName]
			
			
			var inputValue = _inputValues[inputName].calculated[inputGroup]
						
			calcuatedPecentage  = calcuatedPecentage  * inputValue
			
			if calcuatedPecentage > 0:
				
				var outputToUse = rule.output
				
				if !(outputToUse in outputs):
					outputs[outputToUse] = 0
					
				outputs[outputToUse] = outputs[outputToUse]  + calcuatedPecentage
				
				
			totalPercentages = totalPercentages + calcuatedPecentage
				
	if  outputs.size() == 0:
		return null
	
	for  i in outputs :
		#Normalize to 1
		
		outputs[i] = outputs[i] / totalPercentages
		
	return _OutputCalcAvg(outputs);
	
	
	return 2.0

func getOutput(outputName) :
	
	var variablesThatAreDirty  = [];
	
	for i in _inputValues:
		
		if _inputValues[i].dirtyOutput :
			variablesThatAreDirty.append( i ) 
			
		_inputValues[i].dirtyOutput = false
		
	for _outputIndex in _outputValues:
		
		var _match = false;
		
		for  x in  variablesThatAreDirty :
			for  y in  _outputValues[_outputIndex].inputs :
				
				if( x == y ):
					_match = true
					break;
			
			if( _match ):
				break
		
		if( _match ):
			_outputValues[_outputIndex].dirty = true

	if( _outputValues[outputName].dirty  ):
		_outputValues[outputName].output = _calcOutput(outputName)
		
	return _outputValues[outputName].output
	


var _font = {};

var _blackImage;



func getPicture(varName: String):
	
	
			
	if (!( varName in _inputValues)):
		
		if(! _blackImage):
			_blackImage = Image.create(NUM_OF_BUCKETS,NUM_OF_STEPS, false, Image.FORMAT_RGB8) 
			_blackImage.fill(Color.BLACK)
					
		return _blackImage
	
	
	if( _dirtyImage[varName]):
	
		
		_image[varName] = Image.create(NUM_OF_BUCKETS + 100,NUM_OF_STEPS + 100, false, Image.FORMAT_RGB8)
		
		_image[varName].fill(Color.BLACK)
		
		for x in range ( NUM_OF_BUCKETS ):
			
			_image[varName].set_pixel(x,0, Color.WHITE_SMOKE)
			_image[varName].set_pixel(x,NUM_OF_STEPS, Color.WHITE_SMOKE)
		
		for y in range ( NUM_OF_STEPS ):
			
			_image[varName].set_pixel(0,y, Color.WHITE_SMOKE)
			_image[varName].set_pixel(NUM_OF_BUCKETS,y, Color.WHITE_SMOKE)
			
			if y%2:
				_image[varName].set_pixel(_inputValues[varName].value,y, Color.ANTIQUE_WHITE)
		
		
		
		var outputs = _inputValues[varName].outputs.keys()		
		
		for i in  range(outputs.size() ) :
			var color2Use = Color.from_hsv(i/float(outputs.size()) , 0.5, 1.0, 1.0)
			
			var _displayString = outputs[i]
			
			var percentageMatch = _inputValues[varName].calculated[outputs[i]]
			
			percentageMatch = str(percentageMatch * 100.0).pad_decimals(1).lpad(5)
			
			_displayString = _displayString.rpad(30).substr(0,30)  + ' ' + percentageMatch + '%';
			
			
			_DrawText.draw(_image[varName], 0 , NUM_OF_STEPS + 20 + 10 * i ,  _displayString , color2Use)
			
			
			var output2Use = _inputValues[varName].outputs[ outputs[i] ];
			
			
			for j in range(NUM_OF_STEPS) :
				if(output2Use[j] > 0):
					_image[varName].set_pixel(j,NUM_OF_STEPS - output2Use[j], color2Use)
		
		_dirtyImage[varName] = false
	
		pass
		
	
	
	return _image[varName];
	
	
	pass
	
	
func createInputVariable( varName :String,  min: int, max: int):
	
	_inputValues [varName] = {}
	
	_inputValues[varName]['min'] = min
	_inputValues[varName]['max'] = max
	_inputValues[varName]['range'] = float(max - min)
	_inputValues[varName]['outputs'] = {}
	_inputValues[varName]['dirtyOutput'] = false
	
	
	
	
	setVariable(varName, min)
	
	_dirtyImage[varName] = true

func _convertValueToBucket( varName: String,  value: int ):
	
	if (!( varName in _inputValues)):
		return
	
	var _newValue = (value -  _inputValues [varName]['min']) 	
	_newValue =  _newValue/_inputValues [varName]['range']	
	_newValue = clampf(_newValue,0,1)
	
	return round(_newValue * NUM_OF_BUCKETS)
	
	
func _calcInput( varName):
	
	var _bucketNum = _inputValues[varName]['value']
	
	var _outputs = _inputValues[varName]['outputs']
	
	_inputValues[varName]['calculated'] = {}
	
	for outputNum in _outputs:
		
		if( _bucketNum >= _outputs[outputNum].size() ):
			_bucketNum = _outputs[outputNum].size()-1
		
		var bucketNum = _outputs[outputNum][_bucketNum]
		
		var _result = bucketNum / float(NUM_OF_STEPS)
		
		
		_inputValues[varName]['calculated'][outputNum]  = _result
	
		
func setVariable( varName: String,  value: int ):
	
	if (!( varName in _inputValues)):
		return
	
	_inputValues[varName]['value'] =  _convertValueToBucket(varName,  value )
	_inputValues[varName]['dirtyOutput'] =  true
	
	_calcInput( varName)
	
	_dirtyImage[varName] = true
	
	
func createSawToothValue( varName: String,  valueName: String,  leftPeak: int, rightPeak : int, zeroValue:int):
	
	
	if (!( varName in _inputValues)):
		return
		
		
	var _mainLbucket = _convertValueToBucket(varName, leftPeak)
	var _mainRbucket = _convertValueToBucket(varName, rightPeak)
	
	var _zeroBucket   = _convertValueToBucket(varName, zeroValue)
	
	var _range = 0
	
	if( _zeroBucket >  _mainRbucket ):
		_range = _zeroBucket - _mainRbucket
	else:
		_range = _mainLbucket - _zeroBucket 
		
	var _lRange = float(_range) # Future use. Left and right do not need the same range
	var _rRange = float(_range) # Future use. Left and right do not need the same range
		
	var _zeroLbucket = max( 0, _mainLbucket - _lRange)
	var _zeroRbucket = min( NUM_OF_BUCKETS, _mainRbucket + _rRange)
	
	var _bucketValues =  PackedByteArray()
	
	
	for i in range(0, NUM_OF_BUCKETS):
		
		var _value = 0
		
		if( i > _mainLbucket && i < _mainRbucket ):
			_value = 255
		elif( i > _zeroLbucket && i <= _mainLbucket):
			_value =  ((i - _zeroLbucket) / _lRange ) * NUM_OF_STEPS
		elif( i < _zeroRbucket && i >= _mainRbucket):
			_value = (( _zeroRbucket - i ) / _rRange )  * NUM_OF_STEPS
		
		_bucketValues.append(_value)
	
	
	
	_inputValues[varName].outputs[valueName] =  _bucketValues
	
	
	_dirtyImage[varName] = true

func _array_unique(array: Array) -> Array:
	var unique_array: Array = []
	for item in array:
		if not unique_array.has(item):
			unique_array.append(item)
	return unique_array
	
	
func setOutputValue(outputName, values, output):
	
	if(! (outputName in _outputValues)  ):
		_outputValues[outputName] = {
			'inputs': [],
			'rules': [],
			'output': 0,
			'dirty': true
		}
		
	var inputVars = {}
		
	for  value in values:		
		
		for  i in values.size()/2 :
			
			var varName =  values[i*2]
			var varValue =  values[i*2+1]
			
			inputVars[varName] = varValue
			
			_outputValues[outputName].inputs.append(varName)
			
	_outputValues[outputName].rules.append( {
		'inputs': inputVars,
		'output': output
	})
		
	_outputValues[outputName].inputs = _array_unique(_outputValues[outputName].inputs)
