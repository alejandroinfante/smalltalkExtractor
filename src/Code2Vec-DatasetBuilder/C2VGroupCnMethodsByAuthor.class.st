Class {
	#name : #C2VGroupCnMethodsByAuthor,
	#superclass : #Object,
	#classVars : [
		'ExclusionDict'
	],
	#category : #'Code2Vec-DatasetBuilder'
}

{ #category : #'as yet unclassified' }
C2VGroupCnMethodsByAuthor class >> groupPackages [
	| methods |
	C2VMczToCnMethods directories do: [ :dir |
		dir children do: [ :authorDir |
			methods := OrderedCollection new.
			authorDir children 
				select: [ :f | f extension = 'fl' ] 
				thenDo: [ :fl | 
					Transcript show: fl basename; cr.
					[ methods addAll: (CNMethod materializeDataset: fl) ] 
						on: Error 
						do: [ :ex | Transcript show: 'ERROR!! ' , fl basename ].
					fl ensureDelete ].
			CNMethod 
				serializeDataset: methods 
				fromFile: authorDir / (authorDir basename , '.fl') ] ].
]
