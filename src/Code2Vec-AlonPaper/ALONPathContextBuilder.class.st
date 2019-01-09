Class {
	#name : #ALONPathContextBuilder,
	#superclass : #Object,
	#instVars : [
		'ast',
		'pathsDictionary',
		'partialPathsDictionary'
	],
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #'instance creation' }
ALONPathContextBuilder class >> from: ast [
	^ self new 
		ast: ast;
		build
]

{ #category : #accessing }
ALONPathContextBuilder >> ast: astNode [
	ast := astNode
]

{ #category : #building }
ALONPathContextBuilder >> build [
	pathsDictionary := IdentityDictionary new.
	partialPathsDictionary := IdentityDictionary new.
	^ self getPathsFor: ast
]

{ #category : #building }
ALONPathContextBuilder >> computePartialPathsFor: astNode [
	^ astNode isLeaf
		ifTrue: [ 
			Array with: (Array with: astNode) ]
		ifFalse: [ 
			astNode children flatCollect: [ :partialPaths | 
				(self getPartialPathsFor: partialPaths) collect: [ :partialPath | 
					partialPath , (Array with: astNode) ] ] ]
]

{ #category : #building }
ALONPathContextBuilder >> computePartialPathsPairsFrom: pathListL and: pathListR [
	| pairs |
	pairs := OrderedCollection new.
	pathListL do: [ :lPath |
		pathListR do: [ :rPath |
			pairs add: (Array with: lPath with: rPath) ] ].
	^ pairs
]

{ #category : #building }
ALONPathContextBuilder >> computePathsFor: astNode [
	^ astNode isLeaf
		ifTrue: [ #() ]
		ifFalse: [ | children childrenPaths newPaths |
			children := astNode children.
			childrenPaths := astNode children flatCollect: [ :child | self getPathsFor: child ].
			newPaths := OrderedCollection new.
			children doWithIndex: [ :childL :indexL | | pathsL |
				pathsL := self getPartialPathsFor: childL.
				indexL + 1 to: children size do: [ :indexR | | childR pathsR pairs |
					childR := children at: indexR.
					pathsR := self getPartialPathsFor: childR.
					pairs := self computePartialPathsPairsFrom: pathsL and: pathsR.
					pairs do: [ :pair |
						newPaths add: (ALONPathContext 
												left: pair first 
												center: astNode 
												right: pair second) ] ] ].
			childrenPaths , newPaths
		]
]

{ #category : #building }
ALONPathContextBuilder >> getPartialPathsFor: astNode [
	^ partialPathsDictionary at: astNode ifAbsentPut: [ self computePartialPathsFor: astNode ]
]

{ #category : #building }
ALONPathContextBuilder >> getPathsFor: astNode [
	^ pathsDictionary at: astNode ifAbsentPut: [ self computePathsFor: astNode ]
]
