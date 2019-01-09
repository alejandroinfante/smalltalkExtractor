Class {
	#name : #C2VNameSplitter,
	#superclass : #Object,
	#instVars : [
		'methodName',
		'parts',
		'accumulator'
	],
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #run }
C2VNameSplitter class >> split: aName [
	^ self new 
		methodName: aName;
		run
]

{ #category : #running }
C2VNameSplitter >> addCharacterToAccumulator: char [
	accumulator add: char
]

{ #category : #running }
C2VNameSplitter >> initialize [
	super initialize.
	parts := OrderedCollection new.
	accumulator := OrderedCollection new
]

{ #category : #accessing }
C2VNameSplitter >> methodName: anObject [
	methodName := anObject
]

{ #category : #running }
C2VNameSplitter >> postProcessParts [
	parts := parts asArray collect: #asLowercase.
	^ parts collect: [ :part | part reject: [ :c | c = $: or: [ c = $_ ] ] ]
]

{ #category : #running }
C2VNameSplitter >> promotePartFromAccumulator [
	parts add: (String withAll: accumulator).
	accumulator := OrderedCollection new
]

{ #category : #running }
C2VNameSplitter >> run [
	methodName do: [ :char |
		(self shouldSplitWith: char)
			ifTrue: [ 
				self promotePartFromAccumulator.
				self addCharacterToAccumulator: char ]
			ifFalse: [
				self addCharacterToAccumulator: char ] ].
	self promotePartFromAccumulator.
	^ self postProcessParts
]

{ #category : #running }
C2VNameSplitter >> shouldSplitWith: char [
	| last |
	accumulator ifEmpty: [ ^ false ].
	last := accumulator last.
	(char isLetter and: [ last isLetter not ]) ifTrue: [ ^ true ].
	(char isDigit and: [ last isDigit not ]) ifTrue: [ ^ true ].
	^ (char isUppercase) or: [ last = $: or: [ last = $_ ] ]
]
