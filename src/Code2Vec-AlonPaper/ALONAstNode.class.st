Class {
	#name : #ALONAstNode,
	#superclass : #C2VAstNode,
	#instVars : [
		'children'
	],
	#category : #'Code2Vec-AlonPaper-AST-Nodes'
}

{ #category : #accessing }
ALONAstNode >> children [
	^ children
]

{ #category : #accessing }
ALONAstNode >> children: anObject [
	children := anObject
]

{ #category : #'as yet unclassified' }
ALONAstNode >> nodeName [
	^ self class name
]
