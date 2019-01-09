Class {
	#name : #ALONAstTest,
	#superclass : #TestCase,
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #tests }
ALONAstTest >> astForMethod: method [
	^ ALONPharoASTNodeBuilderVisitor from: method ast
]

{ #category : #tests }
ALONAstTest >> testM10EmptyBlock [
	| ast block |
	ast := self astForMethod: C2VStubClass1 >> #m10.
	block := ast children first children first.
	self assert: block class equals: ALONBlockNode.
	self assert: block children size equals: 1.
	self assert: block children first class equals: ALONSequenceNode.
	self assert: block children first children size equals: 1
]

{ #category : #tests }
ALONAstTest >> testM11EmptyBlockWithArg [
	| ast block |
	ast := self astForMethod: C2VStubClass1 >> #m11.
	block := ast children first children first.
	self assert: block class equals: ALONBlockNode.
	self assert: block children size equals: 2.
	self assert: block children first class equals: ALONParameterNode.
	self assert: block children first value equals: #arg1.
	self assert: block children second class equals: ALONSequenceNode.
	self assert: block children second children size equals: 1
]

{ #category : #tests }
ALONAstTest >> testM12EmptyBlockWithTemp [
	| ast block seq |
	ast := self astForMethod: C2VStubClass1 >> #m12.
	block := ast children first children first.
	self assert: block class equals: ALONBlockNode.
	self assert: block children size equals: 1.
	seq := block children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 2.
	self assert: seq children first class equals: ALONTemporaryNode.
	self assert: seq children first value equals: #temp1
]

{ #category : #tests }
ALONAstTest >> testM13BlockValue [
	| ast block seq |
	ast := self astForMethod: C2VStubClass1 >> #m13.
	block := ast children first children first.
	self assert: block class equals: ALONBlockNode.
	self assert: block children size equals: 1.
	seq := block children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	self assert: seq children first class equals: ALONLiteralNode.
	self assert: seq children first value equals: 1
]

{ #category : #tests }
ALONAstTest >> testM14EmptyStatement [
	| ast seq literal |
	ast := self astForMethod: C2VStubClass1 >> #m14.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 1.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	literal := seq children first.
	self assert: literal class equals: ALONNullNode.
	self assert: literal value equals: nil
]

{ #category : #tests }
ALONAstTest >> testM15Self [
	| ast seq selfNode |
	ast := self astForMethod: C2VStubClass1 >> #m15.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 1.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	selfNode := seq children first.
	self assert: selfNode class equals: ALONSelfNode.
	self assert: selfNode value equals: #self
]

{ #category : #tests }
ALONAstTest >> testM16Super [
	| ast seq superNode |
	ast := self astForMethod: C2VStubClass1 >> #m16.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 1.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	superNode := seq children first.
	self assert: superNode class equals: ALONSuperNode.
	self assert: superNode value equals: #super
]

{ #category : #tests }
ALONAstTest >> testM17Cascade [
	| ast seq cascade msg1 msg2 |
	ast := self astForMethod: C2VStubClass1 >> #m17.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	cascade := seq children first.
	self assert: cascade class equals: ALONCascadeNode.
	self assert: cascade children size equals: 2.
	msg1 := cascade children first.
	msg2 := cascade children second.
	self assert: msg1 class equals: ALONMessageNode.
	self assert: msg2 class equals: ALONMessageNode.
	self assert: msg1 children first class equals: ALONSelfNode.
	self assert: msg1 children second value equals: #foo1:.
	self assert: msg1 children third value equals: 'arg1'.
	self assert: msg2 children first class equals: ALONSelfNode.
	self assert: msg2 children second value equals: #foo3.
]

{ #category : #tests }
ALONAstTest >> testM18Cascade [
	| ast seq cascade msg1 msg2 |
	ast := self astForMethod: C2VStubClass1 >> #m18.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	cascade := seq children first.
	self assert: cascade class equals: ALONCascadeNode.
	self assert: cascade children size equals: 2.
	msg1 := cascade children first.
	msg2 := cascade children second.
	self assert: msg1 class equals: ALONMessageNode.
	self assert: msg2 class equals: ALONMessageNode.
	self assert: msg1 children first class equals: ALONMessageNode.
	self assert: msg1 children first children first class equals: ALONSelfNode.
	self assert: msg1 children first children second value equals: #foo.
	self assert: msg1 children second value equals: #bar.
	self assert: msg2 children first class equals: ALONMessageNode.
	self assert: msg2 children second value equals: #zork.
]

{ #category : #tests }
ALONAstTest >> testM19ArrayNode [
	| ast seq literal |
	ast := self astForMethod: C2VStubClass1 >> #m19.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 1.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	literal := seq children first.
	self assert: literal class equals: ALONLiteralNode.
	self assert: literal value equals: #(1 2 3 4)
]

{ #category : #tests }
ALONAstTest >> testM1SingleNode [
	| ast seq literal |
	ast := self astForMethod: C2VStubClass1 >> #m1.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 1.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	literal := seq children first.
	self assert: literal class equals: ALONLiteralNode.
	self assert: literal value equals: 16
]

{ #category : #tests }
ALONAstTest >> testM20DynamicArrayNode [
	| ast seq array first second |
	ast := self astForMethod: C2VStubClass1 >> #m20.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 1.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	array := seq children first.
	self assert: array class equals: ALONArrayNode.
	self assert: array children size equals: 2.
	first := array children first.
	second := array children second.
	self assert: first class equals: ALONNameNode.
	self assert: second class equals: ALONLiteralNode.
]

{ #category : #tests }
ALONAstTest >> testM2SimpleMessage [
	| ast seq sum messageSelector |
	ast := self astForMethod: C2VStubClass1 >> #m2.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 1.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	sum := seq children first.
	self assert: sum class equals: ALONMessageNode.
	self assert: sum children size equals: 3.
	messageSelector := sum children second.
	self assert: messageSelector class equals: ALONNameNode.
	self assert: messageSelector value equals: #+.
	self assert: sum children first value equals: 16.
	self assert: sum children third value equals: 33
]

{ #category : #tests }
ALONAstTest >> testM3SimpleReadIvar [
	| ast read |
	ast := self astForMethod: C2VStubClass1 >> #m3.
	read := ast children first children first.
	self assert: read class equals: ALONNameNode.
	self assert: read value equals: #ivar1.
]

{ #category : #tests }
ALONAstTest >> testM4SimpleAssign [
	| ast assign |
	ast := self astForMethod: C2VStubClass1 >> #m4.
	assign := ast children first children first.
	self assert: assign class equals: ALONAssignmentNode.
	self assert: assign children size equals: 2.
	self assert: assign children first class equals: ALONNameNode.
	self assert: assign children first value equals: #ivar1.
	self assert: assign children second class equals: ALONLiteralNode.
	self assert: assign children second value equals: 'foo'.
]

{ #category : #tests }
ALONAstTest >> testM5DeclareTemp [
	| ast seq temp |
	ast := self astForMethod: C2VStubClass1 >> #m5.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 1.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 2.
	temp := seq children first.
	self assert: temp class equals: ALONTemporaryNode.
	self assert: temp value equals: #temp1
]

{ #category : #tests }
ALONAstTest >> testM6DeclareTempAndRead [
	| ast seq temp read |
	ast := self astForMethod: C2VStubClass1 >> #m6.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 1.
	seq := ast children first.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 2.
	temp := seq children first.
	self assert: temp class equals: ALONTemporaryNode.
	self assert: temp value equals: #temp1.
	read := seq children second.
	self assert: read class equals: ALONNameNode.
	self assert: read value equals: #temp1.
]

{ #category : #tests }
ALONAstTest >> testM7MethodArgument [
	| ast arg |
	ast := self astForMethod: C2VStubClass1 >> #m7:.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 2.
	arg := ast children first.
	self assert: arg class equals: ALONParameterNode.
	self assert: arg value equals: #arg1
]

{ #category : #tests }
ALONAstTest >> testM8MethodArgumentAndRead [
	| ast seq read arg |
	ast := self astForMethod: C2VStubClass1 >> #m8:.
	self assert: ast class equals: ALONMethodNode.
	self assert: ast children size equals: 2.
	arg := ast children first.
	self assert: arg class equals: ALONParameterNode.
	self assert: arg value equals: #arg1.
	seq := ast children second.
	self assert: seq class equals: ALONSequenceNode.
	self assert: seq children size equals: 1.
	read := seq children first.
	self assert: read class equals: ALONNameNode.
	self assert: read value equals: #arg1.
]

{ #category : #tests }
ALONAstTest >> testM9Return [
	| ast assign |
	ast := self astForMethod: C2VStubClass1 >> #m9.
	assign := ast children first children first.
	self assert: assign class equals: ALONReturnNode.
	self assert: assign children size equals: 1.
	self assert: assign children first class equals: ALONLiteralNode.
	self assert: assign children first value equals: 45
]
