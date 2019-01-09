Class {
	#name : #ALONPathContextTest,
	#superclass : #TestCase,
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #tests }
ALONPathContextTest >> astForMethod: method [
	^ ALONPharoASTNodeBuilderVisitor from: method ast
]

{ #category : #tests }
ALONPathContextTest >> computePartialPathsFor: astNode [
	^ ALONPathContextBuilder new
			ast: astNode;
			build;
			getPartialPathsFor: astNode
]

{ #category : #tests }
ALONPathContextTest >> pathsForAst: ast [
	^ ALONPathContextBuilder new
			ast: ast;
			build
]

{ #category : #tests }
ALONPathContextTest >> pathsForMethod: method [
	^ self pathsForAst: (ALONPharoASTNodeBuilderVisitor from: method ast)
]

{ #category : #tests }
ALONPathContextTest >> testBaseCasePartialPath [
	| node partialPaths |
	node := ALONLiteralNode new
					value: 'foo';
					yourself.
	partialPaths := self computePartialPathsFor: node.
	self assert: partialPaths size equals: 1.
	self assert: partialPaths first equals: (Array with: node)
]

{ #category : #tests }
ALONPathContextTest >> testBaseCasePath [
	| node partialPaths |
	node := ALONLiteralNode new
					value: 'foo';
					yourself.
	partialPaths := self pathsForAst: node.
	self assert: partialPaths size equals: 0
]

{ #category : #tests }
ALONPathContextTest >> testInductiveStepPartialPath [
	| partialPaths nodeL nodeR ast |
	nodeL := ALONLiteralNode new
					value: 'foo';
					yourself.
	nodeR := ALONNameNode new
					value: 'msg';
					yourself.
	ast := ALONMessageNode new children: (OrderedCollection with: nodeL with: nodeR); yourself.
	partialPaths := self computePartialPathsFor: ast.
	self assert: partialPaths size equals: 2.
	self assert: partialPaths first equals: (Array with: nodeL with: ast).
	self assert: partialPaths second equals: (Array with: nodeR with: ast)
]

{ #category : #tests }
ALONPathContextTest >> testInductiveStepPath [
	| nodeL nodeR ast paths |
	nodeL := ALONLiteralNode new
					value: 'foo';
					yourself.
	nodeR := ALONNameNode new
					value: 'msg';
					yourself.
	ast := ALONMessageNode new children: (OrderedCollection with: nodeL with: nodeR); yourself.
	paths := self pathsForAst: ast.
	self assert: paths size equals: 1.
	self assert: paths first leftPartialPath first value equals: 'foo'.
	self assert: paths first rightPartialPath first value equals: 'msg'.
	self assert: paths first centerNode class equals: ALONMessageNode
]

{ #category : #tests }
ALONPathContextTest >> testM1AssignPath [
	| paths |
	paths := self pathsForMethod: C2VStubClass2>>#m1.
	self assert: paths size equals: 1.
	self assert: paths first leftPartialPath first value equals: 'ivar1'.
	self assert: paths first rightPartialPath first value equals: 5.
	self assert: paths first centerNode class equals: ALONAssignmentNode
]

{ #category : #tests }
ALONPathContextTest >> testM2AssignPath [
	| paths |
	paths := self pathsForMethod: C2VStubClass2>>#m2.
	self assert: paths size equals: 3.
	self assert: paths first leftPartialPath first value equals: 1.
	self assert: paths first rightPartialPath first value equals: #+.
	self assert: paths first centerNode class equals: ALONMessageNode.
	self assert: paths second leftPartialPath first value equals: 1.
	self assert: paths second rightPartialPath first value equals: 33.
	self assert: paths second centerNode class equals: ALONMessageNode.
	self assert: paths third leftPartialPath first value equals: #+.
	self assert: paths third rightPartialPath first value equals: 33.
	self assert: paths third centerNode class equals: ALONMessageNode.
]
