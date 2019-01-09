Class {
	#name : #ALONCodeCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #accessing }
ALONCodeCommandLineHandler class >> commandName [
	^ 'extractPaths'
]

{ #category : #activation }
ALONCodeCommandLineHandler >> activate [
	| methodCode cnmethod |
	self activateHelpWithoutArguments
		ifTrue: [ ^ self ].
	methodCode := (self argumentAt: 1) asFileReference contents.
	methodCode := 'foo' , String cr , methodCode.
	cnmethod := CNMethod new
						sourceCode: methodCode;
						yourself.
	FileStream stdout << (ALONExtractor extractPaths: cnmethod).
	self quit
]
