Extension { #name : 'SindarinDebugger' }

{ #category : '*Scopeo-Debugger' }
SindarinDebugger >> firstScopeoParentNodeWithSourceNode [

	| parent |
	parent := self node.
	[ parent isScopeoNode and: [ parent sourceNode isScopeoNode not ] ]
		whileFalse: [ parent := parent parent ].
	^ parent
]

{ #category : '*Scopeo-Debugger' }
SindarinDebugger >> isScopeoInstrumentedAssignment [

	^ self firstScopeoParentNodeWithSourceNode sourceNode isAssignment
]

{ #category : '*Scopeo-Debugger' }
SindarinDebugger >> isScopeoInstrumentedMessage [

	^ self firstScopeoParentNodeWithSourceNode sourceNode isMessage
]

{ #category : '*Scopeo-Debugger' }
SindarinDebugger >> stepIntoScopeoInstrumentation [

	| scopeoNode messageReceiver messageSelector method methodNode dp|
	self isScopeoInstrumentedMessage ifFalse: [ ^ self basicStepOver ].
	scopeoNode := self firstScopeoParentNodeWithSourceNode.
	
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
SindarinDebugger >> stepUntilScopeoInstrumentedNode [

	| current topParent levels |
	self method hasScopeoNodes ifFalse: [ ^ self ].
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
