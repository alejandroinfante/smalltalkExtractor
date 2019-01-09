Class {
	#name : #ALONPharoASTNodeBuilderVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'pharoAst'
	],
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #'instance creation' }
ALONPharoASTNodeBuilderVisitor class >> from: astNode [
	^ self new 
		pharoAst: astNode;
		build
]

{ #category : #building }
ALONPharoASTNodeBuilderVisitor >> build [
	^ pharoAst acceptVisitor: self
]

{ #category : #'as yet unclassified' }
ALONPharoASTNodeBuilderVisitor >> newNodeFor: aPharoAstNode [
	^ ALONPharoASTNodeBuilderVisitor from: aPharoAstNode
]

{ #category : #'instance creation' }
ALONPharoASTNodeBuilderVisitor >> newNodeFor: aPharoAstNode parent: astNode [
	^ (ALONPharoASTNodeBuilderVisitor from: aPharoAstNode)
			parent: astNode;
			yourself
]

{ #category : #building }
ALONPharoASTNodeBuilderVisitor >> pharoAst: anObject [
	pharoAst := anObject
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitArrayNode: anArrayNode [
	| children |
	children := OrderedCollection new.
	children addAll: (anArrayNode statements collect: [ :node | self newNodeFor: node ]).
	anArrayNode statements ifEmpty: [ children add: ALONNullNode new ].
	^ ALONArrayNode new
			children: children;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitAssignmentNode: anAssignmentNode [
	| children |
	children := OrderedCollection new.
	children add: (self newNodeFor: anAssignmentNode variable).
	children add: (self newNodeFor: anAssignmentNode value).
	^ ALONAssignmentNode new
			children: children;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitBlockNode: aBlockNode [
	| children |
	children := OrderedCollection new.
	children addAll: (aBlockNode arguments collect: [ :node | ALONParameterNode new
																					value: node name;
																					yourself ]).
	children add: (self newNodeFor: aBlockNode body).
	^ ALONBlockNode new
			children: children;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitCascadeNode: aCascadeNode [
	| children |
	children := OrderedCollection new.
	children addAll: (aCascadeNode messages collect: [ :node | self newNodeFor: node ]).
	^ ALONCascadeNode new
			children: children;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitLiteralArrayNode: aLiteralArrayNode [
	^ ALONLiteralNode new
			value: aLiteralArrayNode value;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitLiteralNode: aLiteralNode [
	^ ALONLiteralNode new
			value: aLiteralNode value;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitMessageNode: aMessageNode [
	| children |
	children := OrderedCollection new.
	children add: (self newNodeFor: aMessageNode receiver).
	children add: (ALONNameNode new
							value: aMessageNode selector;
							yourself).
	children addAll: (aMessageNode arguments collect: [ :node | self newNodeFor: node ]).
	^ ALONMessageNode new
			children: children;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitMethodNode: aMethodNode [
	| children |
	children := OrderedCollection new.
	children addAll: (aMethodNode arguments collect: [ :node | ALONParameterNode new
																					value: node name;
																					yourself ]).
	children add: (self newNodeFor: aMethodNode body).
	^ ALONMethodNode new
			children: children;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitReturnNode: aReturnNode [
	| children |
	children := OrderedCollection new.
	children add: (self newNodeFor: aReturnNode value).
	^ ALONReturnNode new
			children: children;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitSelfNode: aVariableNode [
	^ ALONSelfNode new
			value: #self;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitSequenceNode: aSequenceNode [
	| children |
	children := OrderedCollection new.
	children addAll: (aSequenceNode temporaries collect: [ :temp | 
																				ALONTemporaryNode new
																					value: temp name;
																					yourself ]).
	children addAll: (aSequenceNode statements collect: [ :node | self newNodeFor: node ]).
	aSequenceNode statements ifEmpty: [ children add: ALONNullNode new ].
	^ ALONSequenceNode new
			children: children;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitSuperNode: aVariableNode [
	^ ALONSuperNode new
			value: #super;
			yourself
]

{ #category : #visiting }
ALONPharoASTNodeBuilderVisitor >> visitVariableNode: aVariableNode [
	^ ALONNameNode new
			value: aVariableNode name;
			yourself
]
