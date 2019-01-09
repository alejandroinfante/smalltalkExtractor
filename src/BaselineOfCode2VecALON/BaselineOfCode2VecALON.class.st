Class {
	#name : #BaselineOfCode2VecALON,
	#superclass : #BaselineOf,
	#category : #BaselineOfCode2VecALON
}

{ #category : #baselines }
BaselineOfCode2VecALON >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [			
			spec package: 'Code2Vec-Base'.
			spec package: 'Code2Vec-AlonPaper' with: [ spec requires: 'Code2Vec-Base' ]
			 ]
]
