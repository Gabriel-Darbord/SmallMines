Class {
	#name : #SMTally,
	#superclass : #SMCell,
	#instVars : [
		'tally'
	],
	#category : #SmallMines
}

{ #category : #testing }
SMTally >> isEmptyTally [

	^ tally == 0
]

{ #category : #drawing }
SMTally >> shape [

	| cell |
	cell := super shape.
	tally == 0 ifTrue: [ ^ cell ].
	^ RSComposite new
		  add: cell;
		  add: (RSLabel text: tally);
		  yourself
]

{ #category : #accessing }
SMTally >> tally [

	^ tally
]

{ #category : #accessing }
SMTally >> tally: anInteger [

	tally := anInteger
]
