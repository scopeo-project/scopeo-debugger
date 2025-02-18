Class {
	#name : 'ScopeoDebugger',
	#superclass : 'StDebugger',
	#category : 'Scopeo-Debugger-presenters',
	#package : 'Scopeo-Debugger',
	#tag : 'presenters'
}

{ #category : 'initialization' }
ScopeoDebugger >> initialize [

	super initialize.
	
	'Test' crTrace
]

{ #category : 'actions' }
ScopeoDebugger >> isCurrentMethodInstrumented [

	^ self currentContext method isInstrumented
]

{ #category : 'actions' }
ScopeoDebugger >> restartCurrentContext [

	self debuggerActionModel restartContext: self currentContext.
	self clearUnsavedCodeChanges.
	self stepOverInstrumentedCode.
	self updateSourceCodeFor: self currentContext.
	self updateCodeFromContext
]

{ #category : 'accessing - model' }
ScopeoDebugger >> session: aSession [

	"aSession interruptedContext inspect."

	(ScpExecutionRecorder new 
		forProcess: aSession interruptedProcess;
		execution) inspect.

	^ super session: aSession 
]

{ #category : 'actions' }
ScopeoDebugger >> stepInto [

	self isCurrentMethodInstrumented ifFalse: [ ^ super stepInto ].
	self sindarinDebugger stepIntoInstrumentation
]

{ #category : 'actions' }
ScopeoDebugger >> stepOver [

	| oldContext |
	oldContext := self currentContext.
	self debuggerActionModel stepOver: oldContext.
	oldContext method == self currentContext method ifTrue: [
		self stepOverInstrumentedCode 
	]
]

{ #category : 'actions' }
ScopeoDebugger >> stepOverInstrumentedCode [

	self isCurrentMethodInstrumented ifTrue: [
		self sindarinDebugger stepUntilInstrumentedNode 
	]
]

{ #category : 'code pane' }
ScopeoDebugger >> updateCodeFromContext: aContext [

	| selectionInterval formerCodeInteractionModel method ast firstNode |

	aContext ifNil: [ ^ self clearCode ].
	method := aContext method.

	ast := method ast.
	firstNode := ast statements first.

	self recordUnsavedCodeChanges.
	aContext sourceCode = self code text ifFalse: [
		self updateSourceCodeFor: aContext 
	].
	
	selectionInterval := self isCurrentMethodInstrumented
		ifTrue: [
			| currentNode originalNode |
			currentNode := method sourceNodeForPC: aContext pc.
			originalNode := currentNode indirectionSourceNode.
			originalNode start to: originalNode stop 
		]
		ifFalse: [ self selectedCodeRangeForContext: aContext ].

	formerCodeInteractionModel := self code interactionModel.
	self code beForContext: aContext.
	
	"Add bindings of the old interaction model in the new one"
	formerCodeInteractionModel ifNotNil: [
		formerCodeInteractionModel bindings associations do: [ :assoc |
			self code interactionModel addBinding: assoc 
		] 
	].
	self code selectionInterval: (selectionInterval last to: selectionInterval last - 1).
	self
		updateCodeTextSegmentDecoratorsIn: aContext
		forInterval: selectionInterval
]
