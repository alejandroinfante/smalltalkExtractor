Class {
	#name : #ALONPathContext,
	#superclass : #Object,
	#instVars : [
		'leftPartialPath',
		'rightPartialPath',
		'centerNode'
	],
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #'as yet unclassified' }
ALONPathContext class >> left: leftNode center: centerNode right: rightNode [
	^ self new
		leftPartialPath: leftNode;
		centerNode: centerNode;
		rightPartialPath: rightNode;
		yourself
]

{ #category : #comparing }
ALONPathContext >> = aPath [
	aPath class == ALONPathContext ifFalse: [ ^ false ].
	^ leftPartialPath = aPath leftPartialPath 
		and: [ rightPartialPath = aPath rightPartialPath
			and: [ centerNode = aPath centerNode ] ]
]

{ #category : #accessing }
ALONPathContext >> centerNode [
	^ centerNode
]

{ #category : #accessing }
ALONPathContext >> centerNode: anObject [
	centerNode := anObject
]

{ #category : #comparing }
ALONPathContext >> hash [
	^ ((3 * self class hash) + 
		(7 * leftPartialPath hash) + 
		(11 * rightPartialPath hash) + 
		(13 * centerNode hash)) hashMultiply 
]

{ #category : #accessing }
ALONPathContext >> leftPartialPath [
	^ leftPartialPath
]

{ #category : #accessing }
ALONPathContext >> leftPartialPath: anObject [
	leftPartialPath := anObject
]

{ #category : #accessing }
ALONPathContext >> leftValue [
	^ leftPartialPath first value
]

{ #category : #accessing }
ALONPathContext >> path [
	^ leftPartialPath , (Array with: centerNode) , rightPartialPath
]

{ #category : #printing }
ALONPathContext >> printOn: aStream [
	leftPartialPath ifNotNil: [ 
		leftPartialPath first value printOn: aStream.
		aStream << ';'.
		leftPartialPath do: [ :node |
			aStream << node nodeName.
			aStream << '(' ] ].
	
	aStream << centerNode nodeName.
	
	rightPartialPath ifNotNil: [ 
		rightPartialPath reverse do: [ :node |
			aStream << ')'.
			aStream << node nodeName ].
		aStream << ';'.
		rightPartialPath first value printOn: aStream ].
]

{ #category : #accessing }
ALONPathContext >> rightPartialPath [
	^ rightPartialPath
]

{ #category : #accessing }
ALONPathContext >> rightPartialPath: anObject [
	rightPartialPath := anObject
]

{ #category : #accessing }
ALONPathContext >> rightValue [
	^ rightPartialPath first value
]
