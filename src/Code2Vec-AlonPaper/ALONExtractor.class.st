Class {
	#name : #ALONExtractor,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #'as yet unclassified' }
ALONExtractor class >> extract: cnMethod [
	^ (self new
		extract: cnMethod;
		stream) contents
]

{ #category : #'as yet unclassified' }
ALONExtractor class >> extract: cnMethod usingStream: stream [
	^ self new
		stream: stream;
		extract: cnMethod
]

{ #category : #'as yet unclassified' }
ALONExtractor class >> extractFromDir: directory [
	directory asFileReference files 
		select: [ :f | f extension = 'fl' ]
		thenDo: [ :f | self extractFromFile: f fullName ]
]

{ #category : #'as yet unclassified' }
ALONExtractor class >> extractFromFile: aFileName [
	(FLMaterializer materializeFromFileNamed: aFileName) 
		doWithIndex: [ :cnMethod :index | 
			FileStream stdout << (self extract: cnMethod) ].
]

{ #category : #'as yet unclassified' }
ALONExtractor class >> extractPaths: cnMethod [
	^ (self new
		extractPaths: cnMethod;
		stream) contents
]

{ #category : #'as yet unclassified' }
ALONExtractor >> extract: cnMethod [
	self printNameBag: (self nameBagForMethod: cnMethod).
	stream << ' '.
	(self pathContextsForMethod: cnMethod) 
		do: [ :context | self printContext: context ]
		separatedBy: [ stream << ' ' ].
	stream cr
]

{ #category : #'as yet unclassified' }
ALONExtractor >> extractPaths: cnMethod [
	(self pathContextsForMethod: cnMethod) 
		do: [ :context | self printContext: context ]
		separatedBy: [ stream << ' ' ].
	stream cr
]

{ #category : #initialization }
ALONExtractor >> initialize [
	super initialize.
	stream := (String new: 100) writeStream
]

{ #category : #'as yet unclassified' }
ALONExtractor >> nameBagForMethod: cnMethod [
	^ (C2VNameSplitter split: cnMethod methodName) asSortedCollection: [ :w1 :w2 | w1 < w2 ]
]

{ #category : #building }
ALONExtractor >> pathContextsForMethod: cnMethod [
	^ ALONPathContextBuilder from: (ALONPharoASTNodeBuilderVisitor from: cnMethod ast)
]

{ #category : #printing }
ALONExtractor >> printContext: context [
	stream << (self sanitize: context leftValue).
	stream << ','.
	context leftPartialPath do: [ :node |
		stream << (self sanitize: node nodeName).
		stream << '(' ].
	stream << (self sanitize: context centerNode nodeName).
	context rightPartialPath do: [ :node |
		stream << ')'.
		stream << (self sanitize: node nodeName) ].
	stream << ','.
	stream << (self sanitize: context rightValue)
]

{ #category : #printing }
ALONExtractor >> printNameBag: nameBag [
	nameBag 
		do: [ :namePart | stream << (self sanitize: namePart) ]
		separatedBy: [ stream << '|' ]
]

{ #category : #private }
ALONExtractor >> sanitize: string [
	^ String streamContents: [ :strStream |
		string asString do: [ :c | strStream << (self sanitizeCharacter: c) ] ]
]

{ #category : #'as yet unclassified' }
ALONExtractor >> sanitizeCharacter: char [
	char = $, ifTrue: [ ^ '\c' ].
	char = $| ifTrue: [ ^ '\b' ].
	char = $  ifTrue: [ ^ '\s' ].
	char = $\ ifTrue: [ ^ '\y' ].
	char = Character cr ifTrue: [ ^ '\n' ].
	char = Character enter ifTrue: [ ^ '\e' ].
	char = Character lf ifTrue: [ ^ '\l' ].
	char = Character nbsp ifTrue: [ ^ '\s' ].
	char = Character tab ifTrue: [ ^ '\t' ].
	^ char
]

{ #category : #accessing }
ALONExtractor >> stream [
	^ stream
]

{ #category : #accessing }
ALONExtractor >> stream: anObject [
	stream := anObject
]
