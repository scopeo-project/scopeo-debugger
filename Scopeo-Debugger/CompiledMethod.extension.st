Extension { #name : 'CompiledMethod' }

{ #category : '*Scopeo-Debugger' }
CompiledMethod >> hasScopeoNodes [
	^self ast hasScopeoNodes
]

{ #category : '*Scopeo-Debugger' }
CompiledMethod >> originalSourceCode [
	^self ast originalSourceCode
]
