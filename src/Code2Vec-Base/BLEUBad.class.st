Class {
	#name : #BLEUBad,
	#superclass : #Object,
	#instVars : [
		'candidate',
		'reference',
		'maxNgramSize',
		'refNGrams',
		'candidateNGrams',
		'candidateBag',
		'referenceBag'
	],
	#category : #'Code2Vec-Base'
}

{ #category : #'as yet unclassified' }
BLEUBad class >> precisionForCandidate: candidate reference: reference ngramSize: n [
	^ self new
			candidate: candidate;
			reference: reference;
			n: n;
			compute
]

{ #category : #private }
BLEUBad >> averageModifiedPrecisions [
	^ self candidateNGrams inject: 0 into: [ :subTotal :ngram | 
		subTotal + ((self weight: ngram) * (self modifiedPrecision: ngram) ln) ]
]

{ #category : #private }
BLEUBad >> bp [
	^ candidate size > reference size
		ifTrue: [ 1 ]
		ifFalse: [ (1 - (reference size / candidate size)) exp ]
]

{ #category : #accessing }
BLEUBad >> candidate [
	^ candidate
]

{ #category : #accessing }
BLEUBad >> candidate: anObject [
	candidate := anObject
]

{ #category : #private }
BLEUBad >> candidateBag [
	^ candidateBag ifNil: [ candidateBag := Bag new ]
]

{ #category : #accessing }
BLEUBad >> candidateNGrams [
	^ candidateNGrams ifNil: [ candidateNGrams := self computeNGramsFor: candidate ]
]

{ #category : #private }
BLEUBad >> compute [
	^ self bp * self averageModifiedPrecisions exp
]

{ #category : #accessing }
BLEUBad >> computeNGramsFor: sentence [
	| accumulate |
	accumulate := OrderedCollection new.
	1 to: sentence size - n + 1 do: [ :i |
		accumulate add: (sentence copyFrom: i to: i + n - 1) ].
	^ accumulate
]

{ #category : #accessing }
BLEUBad >> maxNgramSize [
	^ maxNgramSize
]

{ #category : #accessing }
BLEUBad >> maxNgramSize: anObject [
	maxNgramSize := anObject
]

{ #category : #private }
BLEUBad >> modifiedPrecision: ngram [
	self candidateBag add: ngram.
	^ (self candidateBag occurrencesOf: ngram) > (self referenceBag occurrencesOf: ngram)
			ifTrue: [ 0 ]
			ifFalse: [ 1 ]
]

{ #category : #accessing }
BLEUBad >> refNGrams [
	^ refNGrams ifNil: [ refNGrams := self computeNGramsFor: reference ]
]

{ #category : #accessing }
BLEUBad >> reference [
	^ reference
]

{ #category : #accessing }
BLEUBad >> reference: anObject [
	reference := anObject
]

{ #category : #private }
BLEUBad >> referenceBag [
	^ referenceBag ifNil: [ 
			referenceBag := Bag new.
			referenceBag addAll: self refNGrams.
			referenceBag ]
]

{ #category : #accessing }
BLEUBad >> weight: ngram [
	^ 1 / (candidateNGrams size)
]
