Class {
	#name : 'ScopeoDebugger',
	#superclass : 'StDebugger',
	#category : 'Scopeo-Debugger-presenters',
	#package : 'Scopeo-Debugger',
	#tag : 'presenters'
}

{ #category : 'actions' }
ScopeoDebugger >> currentContextIsScopeo [

	^ self currentContext method hasScopeoNodes
]

{ #category : 'actions' }
ScopeoDebugger >> restartCurrentContext [

	self debuggerActionModel restartContext: self currentContext.
	self clearUnsavedCodeChanges.
	self stepOverScopeoCode.
	self updateSourceCodeFor: self currentContext.
	self updateCodeFromContext
]

{ #category : 'actions' }
ScopeoDebugger >> stepInto [

	self currentContextIsScopeo ifFalse: [ ^ super stepInto ].
	self sindarinDebugger stepIntoScopeoInstrumentation
]

{ #category : 'actions' }
ScopeoDebugger >> stepOver [

	| oldContext |
	oldContext := self currentContext.
	self debuggerActionModel stepOver: oldContext.
	oldContext method == self currentContext method ifTrue: [
		self stepOverScopeoCode ]
]

{ #category : 'actions' }
ScopeoDebugger >> stepOverScopeoCode [

	self currentContextIsScopeo ifTrue: [
		self sindarinDebugger stepUntilScopeoInstrumentedNode ]
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
		self updateSourceCodeFor: aContext ].
	selectionInterval := self currentContextIsScopeo
		                     ifTrue: [
			                     | currentNode originalNode |
			                     currentNode := method sourceNodeForPC:
				                                    aContext pc.
			                     originalNode := currentNode sourceNode.
			                     originalNode start to: originalNode stop ]
		                     ifFalse: [
		                     self selectedCodeRangeForContext: aContext ].

	formerCodeInteractionModel := self code interactionModel.
	self code beForContext: aContext.
	"add bindings of the old interaction model in the new one"
	formerCodeInteractionModel ifNotNil: [
		formerCodeInteractionModel bindings associations do: [ :assoc |
			self code interactionModel addBinding: assoc ] ].
	self code selectionInterval:
		(selectionInterval last to: selectionInterval last - 1).
	self
		updateCodeTextSegmentDecoratorsIn: aContext
		forInterval: selectionInterval
]

{ #category : 'code pane' }
ScopeoDebugger >> updateSourceCodeFor: aContext [

	| codeText |
	codeText := self unsavedCodeChanges at: aContext ifAbsent: [
		            self currentContextIsScopeo
			            ifTrue: [ aContext method originalSourceCode ]
			            ifFalse: [ aContext sourceCode ] ].
	self code text: codeText
]
