Class {
	#name : 'ScpStDebugger',
	#superclass : 'StDebugger',
	#category : 'Scopeo-Debugger-presenters',
	#package : 'Scopeo-Debugger',
	#tag : 'presenters'
}

{ #category : 'initialization' }
ScpStDebugger >> initialize [

	super initialize.
	'Test' crTrace
]

{ #category : 'actions' }
ScpStDebugger >> isCurrentMethodInstrumented [

	^ self currentContext method isInstrumented
]

{ #category : 'actions' }
ScpStDebugger >> restartCurrentContext [

	self debuggerActionModel restartContext: self currentContext.
	self
		clearUnsavedCodeChanges;
		stepOverInstrumentedCode;
		updateSourceCodeFor: self currentContext;
		updateCodeFromContext
]

{ #category : 'actions' }
ScpStDebugger >> stepInto [

	self isCurrentMethodInstrumented ifFalse: [ ^ super stepInto ].
	self sindarinDebugger stepIntoInstrumentation
]

{ #category : 'actions' }
ScpStDebugger >> stepOver [

	| tmp1 |
	tmp1 := self currentContext.
	self debuggerActionModel stepOver: tmp1.
	tmp1 method == self currentContext method ifTrue: [
		self stepOverInstrumentedCode ]
]

{ #category : 'actions' }
ScpStDebugger >> stepOverInstrumentedCode [

	self isCurrentMethodInstrumented ifTrue: [
		self sindarinDebugger stepUntilInstrumentedNode ]
]

{ #category : 'code pane' }
ScpStDebugger >> updateCodeFromContext: arg1 [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 |
	arg1 ifNil: [ ^ self clearCode ] ifNotNil: [ arg1 ].
	tmp3 := arg1 method.
	tmp4 := tmp3 ast.
	tmp5 := tmp4 statements first.
	self recordUnsavedCodeChanges.
	arg1 sourceCode = self code text ifFalse: [
		self updateSourceCodeFor: arg1 ].
	tmp1 := self isCurrentMethodInstrumented
		        ifTrue: [
			        tmp6 := tmp3 sourceNodeForPC: arg1 pc.
			        tmp7 := tmp6 indirectionSourceNode.
			        tmp7 start to: tmp7 stop ]
		        ifFalse: [ self selectedCodeRangeForContext: arg1 ].
	tmp2 := self code interactionModel.
	self code beForContext: arg1.
	tmp2 ifNotNil: [
		tmp2 bindings associations do: [ :arg2 |
			self code interactionModel addBinding: arg2 ] ].
	self code selectionInterval: (tmp1 last to: tmp1 last - 1).
	self updateCodeTextSegmentDecoratorsIn: arg1 forInterval: tmp1
]
