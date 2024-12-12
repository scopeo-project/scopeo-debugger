Extension { #name : 'RBMethodNode' }

{ #category : '*Scopeo-Debugger' }
RBMethodNode >> hasScopeoNodes [
	^self allChildren anySatisfy: [ :node| node isScopeoNode ]
]

{ #category : '*Scopeo-Debugger' }
RBMethodNode >> originalSourceCode [
	^self statements first sourceNode sourceCode
]
