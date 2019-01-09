Class {
	#name : #ALONDatasetBuilder,
	#superclass : #Object,
	#instVars : [
		'methods',
		'pathVocabulary',
		'namePartVocabulary',
		'valueVocabulary'
	],
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #'as yet unclassified' }
ALONDatasetBuilder >> arrayForMethod: method [
	| pathContexts |
	pathContexts := self pathContextsForMethod: method.
	pathContexts := self reducePathContexts: pathContexts maxSize: self numberPathsPerMethod.
	^ Array 
		with: (self arrayForPathsContexts: pathContexts)
		with: (self arrayForMethodName: method methodName)
]

{ #category : #'as yet unclassified' }
ALONDatasetBuilder >> arrayForMethodName: methodName [
	^ (C2VNameSplitter split: methodName) collect: [ :part | namePartVocabulary at: part ]
]

{ #category : #'as yet unclassified' }
ALONDatasetBuilder >> arrayForPathsContexts: contexts [
	^ contexts collect: [ :ctx |
		Array 
			with: (valueVocabulary at: ctx leftValue)
			with: (pathVocabulary at: ctx)
			with: (valueVocabulary at: ctx rightValue) ]
]

{ #category : #building }
ALONDatasetBuilder >> build [ 
	methods := RPackage organizer packages flatCollect: #methods.
	namePartVocabulary := C2VVocabulary new.
	valueVocabulary := C2VVocabulary new.
	pathVocabulary := C2VVocabulary new.
	methods do: [ :method | | pathContexts |
		namePartVocabulary addAll: (C2VNameSplitter split: method selector).
		pathContexts := self pathContextsForMethod: method.
		pathVocabulary addAll: pathContexts.
		valueVocabulary addAll: (pathContexts collect: #leftValue).
		valueVocabulary addAll: (pathContexts collect: #rightValue) ].
]

{ #category : #building }
ALONDatasetBuilder >> buildFromMethodStream: aStream [
	aStream do: [ :method | | pathContexts |
		namePartVocabulary addAll: (C2VNameSplitter split: method methodName).
		pathContexts := self pathContextsForMethod: method.
		pathVocabulary addAll: pathContexts.
		valueVocabulary addAll: (pathContexts collect: #leftValue).
		valueVocabulary addAll: (pathContexts collect: #rightValue) ].
]

{ #category : #'as yet unclassified' }
ALONDatasetBuilder >> exportMethods: methodStream toFile: fileRef [
	fileRef writeStreamDo: [ :stream |
		methodStream do: [ :method |
			stream nextPutAll: (NeoJSONWriter toString: (self arrayForMethod: method)).
			stream cr. ]
	 ]
]

{ #category : #'as yet unclassified' }
ALONDatasetBuilder >> exportToFile: fileRef [
	fileRef writeStreamDo: [ :stream |
		methods do: [ :method |
			stream nextPutAll: (NeoJSONWriter toString: (self arrayForMethod: method)).
			stream cr. ]
	 ]
]

{ #category : #'as yet unclassified' }
ALONDatasetBuilder >> initialize [
	super initialize.
	namePartVocabulary := C2VVocabulary new.
	valueVocabulary := C2VVocabulary new.
	pathVocabulary := C2VVocabulary new.
]

{ #category : #'as yet unclassified' }
ALONDatasetBuilder >> numberPathsPerMethod [
	^ 100
]

{ #category : #building }
ALONDatasetBuilder >> pathContextsForMethod: m [
	^ ALONPathContextBuilder
		from: (ALONPharoASTNodeBuilderVisitor from: m ast)
]

{ #category : #'as yet unclassified' }
ALONDatasetBuilder >> reducePathContexts: pathContexts maxSize: maxSize [
	| tombola selected random randomIndex |
	pathContexts size <= maxSize ifTrue: [ ^ pathContexts ].
	tombola := (1 to: pathContexts size) asOrderedCollection.
	selected := OrderedCollection new.
	random := Random seed: 42.
	1 to: maxSize do: [ :i | 
		randomIndex := random nextInt: tombola size.
		tombola removeAt: randomIndex.
		selected add: randomIndex.
	].
	^ selected asSortedCollection collect: [ :i | pathContexts at: i ]
	
]
