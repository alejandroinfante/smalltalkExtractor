Class {
	#name : #ALONCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #accessing }
ALONCommandLineHandler class >> commandName [
	^ 'extract'
]

{ #category : #accessing }
ALONCommandLineHandler class >> description [
	^ 'Extract in Uri-Alon code2vec format the serialized methods from file in argument.'
]

{ #category : #activation }
ALONCommandLineHandler >> activate [
	self activateHelpWithoutArguments
		ifTrue: [ ^ self ].
	(ALONExtractor extractFromFile: (self argumentAt: 1)).
	self quit
]
