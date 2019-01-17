Class {
	#name : #C2VDatasetDownloader,
	#superclass : #Object,
	#classVars : [
		'MCZDirectory',
		'RepositoryNames'
	],
	#category : #'Code2Vec-DatasetBuilder'
}

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> defaultMCZDirectory [
	^ 'mczDataset' asFileReference ensureCreateDirectory
	
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> defaultNames [
	^ '15Puzzle/OlesDobosevych
2048Game/PierreChanson
3DaysVM/ClementBera' lines
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> directoryForRepository: aRepository [
	| dir |
	dir := (self mczDirectory / aRepository owner / aRepository project).
	dir ensureCreateDirectory.
	^ dir
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> downloadAllMCZForRepository: repository [
	[	MCCacheRepository uniqueInstance disableCacheDuring: [ 
			repository loadAllFileNames do: [ :filename |
				self downloadMCZ: filename forRepository: repository ]
		 ] ] 
	ensure: [ 
		MCCacheRepository flushCache.
		MCCacheRepository cacheDirectory deleteAllChildren ]
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> downloadLastMCZForAllRepositories [
	self getAllRepositories do: [ :repository |
		self downloadLastMCZForRepository: repository.
		Transcript 
			show: repository owner;
			show: '/';
			show: repository project;
			cr ]
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> downloadLastMCZForRepository: repository [
	[[	MCCacheRepository uniqueInstance disableCacheDuring: [ 
			(self selectLastVersions: repository loadAllFileNames) do: [ :filename |
				self downloadMCZ: filename forRepository: repository ]
		 ] ] 
	ensure: [ 
		MCCacheRepository flushCache.
		MCCacheRepository cacheDirectory deleteAllChildren ]] on: Error do: [ :ex | Transcript show: 'Error on:' , repository asString ]
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> downloadMCZ: filename forRepository: repository [
	| file |
	file := (self directoryForRepository: repository) / filename.
	file exists ifTrue: [ ^ self ].
	[file binaryWriteStreamDo: [ :ws |
		repository readStreamForFileNamed: filename do: [ :rs |
			ws nextPutAll: rs contents ] ]] on: Error do: [ :ex | 
				Transcript 
					show: 'Error on:';
					show: filename;
					cr ]
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> downloadMCZForAllRepositories [
	self getAllRepositories do: [ :repository |
		self downloadAllMCZForRepository: repository.
		Transcript 
			show: repository owner;
			show: '/';
			show: repository project;
			cr ]
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> getAllRepositories [
	^ self smalltalkhubNames collect: [ :smalltalkhubName | self repositoryForSmalltalkhub: smalltalkhubName ] 
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> getOwner: smalltalkhubName [
	| names |
	names := (smalltalkhubName splitOn: '/').
	names size = 2 
		ifTrue: [ ^ names second ]
		ifFalse: [ ^ names first ]
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> getRepositoryName: smalltalkhubName [
	^ (smalltalkhubName splitOn: '/') first
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> mczDirectory [
	^ MCZDirectory ifNil: [ MCZDirectory := self defaultMCZDirectory ]
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> mczDirectory: aFileReference [
	MCZDirectory := aFileReference
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> packageNameFromFilename: filename [
	| nameStream |
	nameStream := String new writeStream.
	(filename splitOn: '-') allButLast 
		do: [ :namePart | nameStream << namePart ]
		separatedBy: [ nameStream << '-' ].
	^ nameStream contents
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> repositoryForSmalltalkhub: smalltalkhubName [
	^ MCSmalltalkhubRepository
			owner: (self getOwner: smalltalkhubName)
			project: (self getRepositoryName: smalltalkhubName)
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> selectLastVersions: filenames [
	| groups |
	groups := (filenames groupedBy: [ :n | self packageNameFromFilename: n ]) values.
	^ groups collect: [ :g | | assocs |
		assocs := g collect: [ :n | n -> (self versionFromFilename: n) ].
		(assocs inject: assocs first into: [ :max :each | 
			max value > each value
				ifTrue: [ max ]
				ifFalse: [ each ]]) key ]
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> smalltalkhubNames [
	^ RepositoryNames ifNil: [ ^ RepositoryNames := self defaultNames ] 
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> smalltalkhubNames: names [
	RepositoryNames := names
]

{ #category : #'as yet unclassified' }
C2VDatasetDownloader class >> versionFromFilename: filename [
	^ [(filename splitOn: '.') allButLast last asNumber] on: Error do: [ :ex | 0 ]
]
