Class {
	#name : #ALONPathContextBuilderVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'ast'
	],
	#category : #'Code2Vec-AlonPaper'
}

{ #category : #'instance creation' }
ALONPathContextBuilderVisitor class >> from: ast [
	^ self new 
		ast: ast;
		build
]

{ #category : #accessing }
ALONPathContextBuilderVisitor >> ast: astNode [
	ast := astNode
]

{ #category : #building }
ALONPathContextBuilderVisitor >> build [
]
