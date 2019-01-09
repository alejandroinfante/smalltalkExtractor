Class {
	#name : #C2VAstAbstractNode,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #'Code2Vec-Base'
}

{ #category : #comparing }
C2VAstAbstractNode >> = aNode [
	^ self class == aNode class
]

{ #category : #accessing }
C2VAstAbstractNode >> children [
	^ #()
]

{ #category : #comparing }
C2VAstAbstractNode >> hash [
	^ self class hash * 11 + 7
]

{ #category : #testing }
C2VAstAbstractNode >> isLeaf [
	^ false
]

{ #category : #testing }
C2VAstAbstractNode >> isRoot [
	^ parent == nil
]

{ #category : #accessing }
C2VAstAbstractNode >> parent [
	^ parent
]

{ #category : #accessing }
C2VAstAbstractNode >> parent: anObject [
	parent := anObject
]
