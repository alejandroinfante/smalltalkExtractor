Class {
	#name : #CNMethod,
	#superclass : #Object,
	#instVars : [
		'id',
		'sourceCode',
		'methodName',
		'clsName',
		'pkgName',
		'datasetFlag'
	],
	#classVars : [
		'CurrentDataset'
	],
	#category : #'Code2Vec-Base'
}

{ #category : #'as yet unclassified' }
CNMethod class >> currentDataset [
	^ CurrentDataset ifNil: [ CurrentDataset := self materializeDataset: self defaultDatasetFile ]
]

{ #category : #'as yet unclassified' }
CNMethod class >> defaultDatasetFile [
	^ 'experiment_dataset.fl' asFileReference
]

{ #category : #'initialize-release' }
CNMethod class >> forMethod: compiledMethod [
	^ self new 
		methodName: compiledMethod selector;
		clsName: compiledMethod methodClass;
		pkgName: compiledMethod package name;
		sourceCode: compiledMethod sourceCode;
		yourself.
]

{ #category : #'as yet unclassified' }
CNMethod class >> materializeDataset: aDataset [
	^ (FLMaterializer newDefault materializeFrom: aDataset binaryReadStream) root
]

{ #category : #'as yet unclassified' }
CNMethod class >> serializeDataset: collectionOfCnMethods fromFile: fileRef [ 
	fileRef binaryWriteStreamDo: [ :str |
		FLSerializer serialize: collectionOfCnMethods on: str ]
]

{ #category : #'as yet unclassified' }
CNMethod class >> testingFlag [
	^ 3
]

{ #category : #'as yet unclassified' }
CNMethod class >> trainingFlag [
	^ 1
]

{ #category : #'as yet unclassified' }
CNMethod class >> validationFlag [
	^ 2
]

{ #category : #comparing }
CNMethod >> = aCNMethod [
	aCNMethod class == CNMethod ifFalse: [ ^ false ].
	^ self id = aCNMethod id
]

{ #category : #accessing }
CNMethod >> ast [
	^ RBParser parseMethod: self sourceCode
]

{ #category : #accessing }
CNMethod >> clsName [
	^ clsName
]

{ #category : #accessing }
CNMethod >> clsName: anObject [
	clsName := anObject
]

{ #category : #accessing }
CNMethod >> datasetFlag [
	^ datasetFlag
]

{ #category : #accessing }
CNMethod >> datasetFlag: anObject [
	datasetFlag := anObject
]

{ #category : #formatting }
CNMethod >> formatCode: aCode [
	| tree formatted |
	tree := RBParser parseMethod: aCode onError: [ :msg :pos | ^ aCode ].
	formatted := tree formattedCodeWithMaxLineLength: 120.
	^ formatted
]

{ #category : #'as yet unclassified' }
CNMethod >> formattedMethodCode [
	^ self formatCode: sourceCode
]

{ #category : #comparing }
CNMethod >> hash [
	^ self id * 7 + 11
]

{ #category : #accessing }
CNMethod >> id [
	^ id
]

{ #category : #accessing }
CNMethod >> id: anObject [
	id := anObject
]

{ #category : #testing }
CNMethod >> isTesting [
	^ datasetFlag == self testingFlag
]

{ #category : #testing }
CNMethod >> isTraining [
	^ datasetFlag == self trainingFlag
]

{ #category : #testing }
CNMethod >> isValidation [
	^ datasetFlag == self validationFlag
]

{ #category : #accessing }
CNMethod >> methodName [
	^ methodName
]

{ #category : #accessing }
CNMethod >> methodName: anObject [
	methodName := anObject
]

{ #category : #'as yet unclassified' }
CNMethod >> noNameCode: aCode [
	| ast |
	ast := (RBParser parseMethod: aCode) body.
	^ aCode copyFrom: ast sourceInterval first to: ast sourceInterval last
]

{ #category : #'as yet unclassified' }
CNMethod >> noNameFormatted [
	^ self noNameCode: self formattedMethodCode
]

{ #category : #'as yet unclassified' }
CNMethod >> noNameSourceCode [
	^ self noNameCode: sourceCode
]

{ #category : #accessing }
CNMethod >> pkgName [
	^ pkgName
]

{ #category : #accessing }
CNMethod >> pkgName: anObject [
	pkgName := anObject
]

{ #category : #printing }
CNMethod >> printOn: str [
	clsName printOn: str.
	str << '>>'.
	methodName printOn: str
]

{ #category : #accessing }
CNMethod >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
CNMethod >> sourceCode: anObject [
	sourceCode := anObject
]

{ #category : #testing }
CNMethod >> testingFlag [
	^ self class testingFlag
]

{ #category : #testing }
CNMethod >> trainingFlag [
	^ self class trainingFlag
]

{ #category : #testing }
CNMethod >> validationFlag [
	^ self class validationFlag
]
