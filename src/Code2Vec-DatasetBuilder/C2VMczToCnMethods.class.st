Class {
	#name : #C2VMczToCnMethods,
	#superclass : #Object,
	#classVars : [
		'ExclusionDict'
	],
	#category : #'Code2Vec-DatasetBuilder'
}

{ #category : #'instance creation' }
C2VMczToCnMethods class >> directories [
	^ Array
			with: self trainDirectory
			with: self validationDirectory 
			with: self testDirectory
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> exclusionDict [
	^ ExclusionDict ifNil: [ ExclusionDict := (CNMethod currentDataset 
										collect: [ :m | (self hash: m sourceCode) -> m ]) asDictionary ]
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> filterMethods: cnMethodCollection [
	^ cnMethodCollection reject: [ :m | self exclusionDict includesKey: (self hash: m sourceCode) ]
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> fromFileReference: aFileReference [
	^ aFileReference binaryReadStreamDo: [ :stream | | version methodDefs |
		MCCacheRepository disableCacheDuring: [
			version := MCMczReader versionFromStream: stream ].
		methodDefs := version snapshot definitions select: #isMethodDefinition.
		methodDefs collect: [ :methodDef | 
			CNMethod new
				methodName: methodDef selector;
				clsName: methodDef className;
				sourceCode: methodDef source;
				yourself ] ]
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> hash: aString [
	^ (MD5 hashMessage: aString) hex
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> mczInAllSubdirectories: aFileReference [
	aFileReference isDirectory 
		ifFalse: [ 
			aFileReference extension = 'mcz' 
				ifTrue: [ ^ Array with: aFileReference ]
				ifFalse: [ ^ #() ] ]
		ifTrue: [ | mczFiles |
			mczFiles := OrderedCollection new.
			aFileReference children do: [ :child |
				mczFiles addAll: (self mczInAllSubdirectories: child) ].
			^ mczFiles ]
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> newFilesForMczFileRef: anMczFile [
	| author newFileName |
	author := anMczFile parent parent basename.
	newFileName := (anMczFile parent basename) , '-' , anMczFile basename , '.fl'.
	^ self directories collect: [ :fr | (fr / author) ensureCreateDirectory / newFileName  ]
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> random [
	| rand |
	rand := SharedRandom globalGenerator next.
	^ rand < 0.7
		ifTrue: [ 1 ]
		ifFalse: [ 
			rand < 0.85
				ifTrue: [ 2 ]
				ifFalse: [ 3 ] ]
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> splitAndTransformMcz: anMcz [
	| cnMethods groups |
	[ cnMethods := self filterMethods: (self fromFileReference: anMcz) ] on: Error do: [ :ex |
		cnMethods := #().
		Transcript show: 'ERROR!! -- ' , anMcz path fullName ].
	groups := cnMethods groupedBy: [ :m | self random ].
	Transcript show: anMcz path fullName; cr.
	(self newFilesForMczFileRef: anMcz) doWithIndex: [ :file :index | | dataset |
		dataset := groups at: index ifAbsent: nil.
		dataset ifNotNil: [ CNMethod serializeDataset: dataset fromFile: file ] ].
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> testDirectory [
	^ 'testFuel' asFileReference ensureCreateDirectory
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> trainDirectory [
	^ 'trainFuel' asFileReference ensureCreateDirectory
]

{ #category : #'instance creation' }
C2VMczToCnMethods class >> validationDirectory [
	^ 'validationFuel' asFileReference ensureCreateDirectory
]
