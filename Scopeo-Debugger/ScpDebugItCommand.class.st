Class {
	#name : 'ScpDebugItCommand',
	#superclass : 'SpCodeSelectionCommand',
	#category : 'Scopeo-Debugger',
	#package : 'Scopeo-Debugger'
}

{ #category : 'default' }
ScpDebugItCommand class >> defaultIconName [

	^ #exception
]

{ #category : 'default' }
ScpDebugItCommand class >> defaultName [

	^ 'Debug it with Scopeo'
]

{ #category : 'default' }
ScpDebugItCommand class >> defaultShortcutKey [

	^ $x shift meta mac | $x alt control win | $x alt control unix
]

{ #category : 'executing' }
ScpDebugItCommand >> execute [

	| tmp1 tmp2 tmp3 |
	(self context respondsTo: #doItReceiver)
		ifTrue: [
			tmp1 := self context doItReceiver.
			tmp2 := self context doItContext ]
		ifFalse: [ tmp1 := tmp2 := nil ].
	tmp3 := ScpExecutionRecorder
		        forCode: self selectedTextOrLine
		        inContext: tmp2
		        onReceiver: tmp1.
	tmp3 runAsynchronously.
	tmp3 execution inspect
]
