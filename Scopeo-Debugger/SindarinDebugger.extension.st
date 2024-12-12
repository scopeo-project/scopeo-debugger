Extension { #name : 'SindarinDebugger' }

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
