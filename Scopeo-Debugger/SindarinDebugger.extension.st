Extension { #name : 'SindarinDebugger' }

{ #category : '*Scopeo-Debugger' }
SindarinDebugger >> firstInstrumentedParentNode [

	| parent |
	
	parent := self node.
	[ parent isIndirectionNode and: [ parent sourceNode isIndirectionNode not ] ] whileFalse: [ 
		parent := parent parent 
	].
	
	^ parent
]

{ #category : '*Scopeo-Debugger' }
SindarinDebugger >> isInstrumentedAssignment [

	^ self firstInstrumentedParentNode sourceNode isAssignment
]

{ #category : '*Scopeo-Debugger' }
SindarinDebugger >> isInstrumentedMessage [

	^ self firstInstrumentedParentNode sourceNode isMessage
]

{ #category : '*Scopeo-Debugger' }
SindarinDebugger >> stepIntoInstrumentation [

	| scopeoNode messageReceiver messageSelector method methodNode dp|
	self isInstrumentedMessage ifFalse: [ ^ self basicStepOver ].
	scopeoNode := self firstInstrumentedParentNode.
	
	messageReceiver := self context at: self context size - 1.
	messageSelector := self context at: self context size - 3.
	
	method := (messageReceiver class lookupSelector: messageSelector).
	method isPrimitive ifTrue: [ ^self basicStepOver ].
	methodNode := method ast.
	dp := methodNode debugPoint.
	dp enable.
	
	[ self basicStepThrough ] ensure: [ dp disable ]
]

{ #category : '*Scopeo-Debugger' }
SindarinDebugger >> stepUntilInstrumentedNode [

	| current topParent levels |
	self method isInstrumented ifFalse: [ ^ self ].
	current := self node.
	topParent := self node parent.
	levels := 1.
	[ topParent == self method ast body ] whileFalse: [
		levels := levels + 1.
		current := topParent.
		topParent := current parent ].
	current == self method ast statements first ifTrue: [
		levels timesRepeat: [ self basicStepOver ] ]
]
