Class {
	#name : #ALONNodeEquality,
	#superclass : #TestCase,
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #tests }
ALONNodeEquality >> testDiferentClass [
	self deny: ALONArrayNode new = ALONMessageNode new.
]

{ #category : #tests }
ALONNodeEquality >> testDiferentClassHash [
	self deny: ALONArrayNode new hash = ALONMessageNode new hash.
]

{ #category : #tests }
ALONNodeEquality >> testSameClassNodeDiferentChildren [
	self assert: ALONArrayNode new equals: ALONArrayNode new.
	self 
		assert: (ALONArrayNode new
					children: #(foo bar);
					yourself)
		equals: (ALONArrayNode new
					children: 33;
					yourself)
]

{ #category : #tests }
ALONNodeEquality >> testSameClassNodeDiferentChildrenHash [
	self assert: ALONArrayNode new equals: ALONArrayNode new.
	self 
		assert: (ALONArrayNode new
					children: #(foo bar);
					yourself) hash
		equals: (ALONArrayNode new
					children: 33;
					yourself) hash
]
