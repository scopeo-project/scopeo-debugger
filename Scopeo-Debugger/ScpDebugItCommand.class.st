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

	| doItReceiver doItContext recorder |

	(self context respondsTo: #doItReceiver)
		ifTrue: [
			doItReceiver := self context doItReceiver.
			doItContext := self context doItContext ]
		ifFalse: [ doItReceiver := doItContext := nil ].

	recorder := ScpExecutionRecorder
		forCode: self selectedTextOrLine 
		inContext: doItContext 
		onReceiver: doItReceiver.
		
	recorder execution inspect.
	
	(OupsDebugRequest newForContext: recorder process suspendedContext)
		process: recorder process;
		label: 'Debug it with Scopeo';
		submit
]
