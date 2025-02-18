Class {
	#name : 'BaselineOfScopeoDebugger',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfScopeoDebugger',
	#package : 'BaselineOfScopeoDebugger'
}

{ #category : 'baselines' }
BaselineOfScopeoDebugger >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self dependencies: spec.
		self packages: spec 
	]
]

{ #category : 'accessing' }
BaselineOfScopeoDebugger >> dependencies: spec [

	spec baseline: 'ScopeoExecutionRecorder' with: [
		spec repository: 'github://scopeo-project/scopeo-execution-recorder:main' 
	].		
	
]

{ #category : 'accessing' }
BaselineOfScopeoDebugger >> packages: spec [

	spec package: 'Scopeo-Debugger'
]
