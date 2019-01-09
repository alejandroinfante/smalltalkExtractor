Class {
	#name : #C2VNameSplitterTest,
	#superclass : #TestCase,
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #tests }
C2VNameSplitterTest >> assertSplit: methodName equals: parts [
	self assert: (C2VNameSplitter split: methodName) equals: parts
]

{ #category : #tests }
C2VNameSplitterTest >> testNoSplitName [
	self assertSplit: 'simple' equals: #('simple')
]

{ #category : #tests }
C2VNameSplitterTest >> testSplitComplexNameWithArguments [
	self assertSplit: 'simpleSVG:withTwo:bar:' equals: #('simple' s v g with two bar)
]

{ #category : #tests }
C2VNameSplitterTest >> testSplitNameWitNumbers [
	self assertSplit: 'simpleName33foo' equals: #('simple' 'name' '33' 'foo')
]

{ #category : #tests }
C2VNameSplitterTest >> testSplitNameWitUnderscore [
	self assertSplit: 'simpleName_foo' equals: #('simple' 'name' 'foo')
]

{ #category : #tests }
C2VNameSplitterTest >> testSplitNameWitUnderscore2 [
	self assertSplit: 'simpleName_Foo' equals: #('simple' 'name' 'foo')
]

{ #category : #tests }
C2VNameSplitterTest >> testSplitNameWithMultipleNumbers [
	self assertSplit: 'simple1Name33foo' equals: #('simple' '1' 'name' '33' 'foo')
]

{ #category : #tests }
C2VNameSplitterTest >> testSplitNameWithNumberWord [
	self assertSplit: 'simpleR3TName' equals: #('simple' 'r' '3' 't' 'name')
]

{ #category : #tests }
C2VNameSplitterTest >> testSplitNameWithUpperWord [
	self assertSplit: 'simpleRTName' equals: #('simple' 'r' 't' 'name')
]

{ #category : #tests }
C2VNameSplitterTest >> testSplitSimpleNameInThree [
	self assertSplit: 'simpleMyName' equals: #('simple' 'my' 'name')
]

{ #category : #tests }
C2VNameSplitterTest >> testSplitSimpleNameInTwo [
	self assertSplit: 'simpleName' equals: #('simple' 'name')
]

{ #category : #tests }
C2VNameSplitterTest >> testSplitSimpleNameWithArguments [
	self assertSplit: 'simpleName:with:' equals: #('simple' 'name' with)
]
