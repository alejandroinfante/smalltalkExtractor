Class {
	#name : #C2VVocabulary,
	#superclass : #Object,
	#instVars : [
		'dict'
	],
	#category : #'Code2Vec-Base'
}

{ #category : #adding }
C2VVocabulary >> add: anObject [
	^ dict at: anObject ifAbsentPut: [ dict size + 1 ]
]

{ #category : #adding }
C2VVocabulary >> addAll: collectionOfObjects [
	collectionOfObjects do: [ :obj | self add: obj ]
]

{ #category : #accessing }
C2VVocabulary >> at: anObject [
	^ dict at: anObject
]

{ #category : #accessing }
C2VVocabulary >> at: anObject ifAbsent: aBlock [
	^ dict at: anObject ifAbsent: aBlock
]

{ #category : #initialization }
C2VVocabulary >> initialize [
	super initialize.
	dict := Dictionary new
]
