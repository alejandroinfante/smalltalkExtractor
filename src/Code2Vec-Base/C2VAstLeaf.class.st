Class {
	#name : #C2VAstLeaf,
	#superclass : #C2VAstAbstractNode,
	#instVars : [
		'value'
	],
	#category : #'Code2Vec-Base'
}

{ #category : #testing }
C2VAstLeaf >> isLeaf [
	^ true
]

{ #category : #accessing }
C2VAstLeaf >> value [
	^ value
]

{ #category : #accessing }
C2VAstLeaf >> value: anObject [
	value := anObject
]
