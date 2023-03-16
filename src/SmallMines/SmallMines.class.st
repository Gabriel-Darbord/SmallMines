"
I represent a game of Minesweeper.

Start a game:
```
SmallMines play
```

Configure a game:
```
SmallMines new
	width: 9;
	height: 9;
	mineCount: 10;
	play
```
"
Class {
	#name : #SmallMines,
	#superclass : #Object,
	#instVars : [
		'bounds',
		'mineCount',
		'mines',
		'ui',
		'swept',
		'flagged',
		'isGenerated'
	],
	#category : #SmallMines
}

{ #category : #playing }
SmallMines class >> play [

	<script>
	^ self new
		  mineCount: 10;
		  play
]

{ #category : #accessing }
SmallMines >> flagAt: aPoint [

	flagged add: aPoint
]

{ #category : #accessing }
SmallMines >> flagged [

	^ flagged
]

{ #category : #'private - accessing' }
SmallMines >> generateBoardFrom: aPoint [

	"The board is only generated when the first cell is swept to ensure the board is playable"

	| forbidden |
	isGenerated := true.
	forbidden := (aPoint eightNeighbors select: [ :point | 
		              bounds containsPoint: point ]) asSet.
	mines := OrderedCollection new: bounds area - forbidden size.
	1 to: self height do: [ :x | 
		1 to: self width do: [ :y | 
			| point |
			point := x @ y.
			(forbidden includes: point) ifFalse: [ mines add: point ] ] ].
	^ mines := (mines shuffle first: mineCount) asSet
]

{ #category : #accessing }
SmallMines >> height [

	^ bounds height
]

{ #category : #accessing }
SmallMines >> height: anInteger [

	bounds bottom: anInteger + 1
]

{ #category : #initialization }
SmallMines >> initialize [

	bounds := 1 @ 1 corner: 10 @ 10.
	swept := Set new.
	flagged := Set new.
	isGenerated := false
]

{ #category : #accessing }
SmallMines >> mineCount [

	^ mineCount
]

{ #category : #accessing }
SmallMines >> mineCount: anInteger [

	mineCount := anInteger
]

{ #category : #accessing }
SmallMines >> mines [

	^ mines
]

{ #category : #initialization }
SmallMines >> play [

	self verifyConfig.
	self ui drawBoard
]

{ #category : #'private - accessing' }
SmallMines >> privateSweepAt: aPoint [

	"Sweep a single cell"

	| cell |
	cell := (mines includes: aPoint)
		        ifTrue: [ "Sweeped a mine" SMMine new ]
		        ifFalse: [ "Tally surrounding mines"
			        SMTally new
				        tally:
					        (aPoint eightNeighbors count: [ :point | 
							         mines includes: point ]);
				        yourself ].
	cell position: aPoint.
	swept add: aPoint.
	ui drawCell: cell.

	^ cell
]

{ #category : #'private - accessing' }
SmallMines >> privateSweepSpreadFrom: aPoint [

	"Sweep recursively in a flood-fill pattern until no more empty cells remain"

	| toSweep sweeping |
	toSweep := (aPoint eightNeighbors select: [ :next | 
		            bounds containsPoint: next ]) asSet.
	sweeping := OrderedCollection new.

	[ toSweep isEmpty ] whileFalse: [ 
		| cell |
		cell := self privateSweepAt: (toSweep remove: toSweep anyOne).
		sweeping add: cell.
		cell isEmptyTally ifTrue: [ 
			toSweep addAll: (cell position eightNeighbors reject: [ :next | 
					 (bounds containsPoint: next) not or: [ 
						 (swept includes: next) or: [ flagged includes: next ] ] ]) ] ].

	^ sweeping
]

{ #category : #accessing }
SmallMines >> sweepAt: aPoint [

	"Return one or multiple SMCells that have been swept"

	| cells |
	(bounds containsPoint: aPoint) ifFalse: [ 
		SmallMinesError signal: 'Index out of bounds' ].

	"If first sweep, generate the board"
	isGenerated ifFalse: [ self generateBoardFrom: aPoint ].

	"Sweep the cell"
	cells := self privateSweepAt: aPoint.

	"Check for mine, resulting in defeat"
	cells isMine ifTrue: [ 
		self ui drawDefeat.
		^ cells ].

	"If no mines at or around, keep sweeping recursively"
	cells isEmptyTally ifTrue: [ 
		cells := (self privateSweepSpreadFrom: aPoint)
			         add: cells;
			         yourself ].

	"Check for victory"
	swept size == (bounds area - mines size) ifTrue: [ 
		self ui drawVictory ].

	^ cells
]

{ #category : #accessing }
SmallMines >> swept [

	^ swept
]

{ #category : #accessing }
SmallMines >> ui [

	^ ui ifNil: [ 
		  ui := SmallMinesGUI new
			        engine: self;
			        yourself ]
]

{ #category : #accessing }
SmallMines >> ui: aUserInterface [

	ui := aUserInterface
]

{ #category : #verifying }
SmallMines >> verifyConfig [

	"Verify that configuration is correct"

	self height <= 3 ifTrue: [ 
		SmallMinesError signal: 'Height must be more than 3' ].
	self width <= 3 ifTrue: [ 
		SmallMinesError signal: 'Width must be more than 3' ].

	mineCount <= 0 ifTrue: [ 
		SmallMinesError signal: 'Number of mines must be more than 0' ].
	mineCount >= bounds area ifTrue: [ 
		SmallMinesError signal: (' ' join: { 
					 'Number of mines must be less than'.
					 bounds area.
					 'with current height and width settings' }) ]
]

{ #category : #accessing }
SmallMines >> width [

	^ bounds width
]

{ #category : #accessing }
SmallMines >> width: anInteger [

	bounds right: anInteger + 1
]
