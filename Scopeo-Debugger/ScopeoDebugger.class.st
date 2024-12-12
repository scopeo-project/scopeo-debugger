Class {
	#name : 'ScopeoDebugger',
	#superclass : 'StDebugger',
	#category : 'Scopeo-Debugger-presenters',
	#package : 'Scopeo-Debugger',
	#tag : 'presenters'
}

{ #category : 'code pane' }
ScopeoDebugger >> updateSourceCodeFor: aContext [

	| codeText |
	codeText := self unsavedCodeChanges at: aContext ifAbsent: [
		            aContext method hasScopeoNodes
			            ifTrue: [ aContext method originalSourceCode ]
			            ifFalse: [ aContext sourceCode ] ].


	self code text: codeText
]
