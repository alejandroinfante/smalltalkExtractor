Class {
	#name : #ALONFuelCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #accessing }
ALONFuelCommandLineHandler class >> commandName [
	^ 'extractFuel'
]

{ #category : #accessing }
ALONFuelCommandLineHandler class >> description [
	^ 'Extract in Uri-Alon code2vec format the serialized methods from file in argument.'
]

{ #category : #activation }
ALONFuelCommandLineHandler >> activate [
	self activateHelpWithoutArguments
		ifTrue: [ ^ self ].
	(ALONExtractor extractFromFile: (self argumentAt: 1)).
	self quit
]
