Class {
	#name : #ALONDirCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #accessing }
ALONDirCommandLineHandler class >> commandName [
	^ 'extractDir'
]

{ #category : #accessing }
ALONDirCommandLineHandler class >> description [
	^ 'Extract in Uri-Alon code2vec format the serialized methods from directory in argument.'
]

{ #category : #activation }
ALONDirCommandLineHandler >> activate [
	self activateHelpWithoutArguments
		ifTrue: [ ^ self ].
	(ALONExtractor extractFromDir: (self argumentAt: 1) asFileReference).
	self quit
]
