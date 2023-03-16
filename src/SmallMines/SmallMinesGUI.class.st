"
I'm a Minesweeper board used by `SmallMines`.
"
Class {
	#name : #SmallMinesGUI,
	#superclass : #Object,
	#instVars : [
		'engine',
		'canvas'
	],
	#category : #SmallMines
}

{ #category : #drawing }
SmallMinesGUI >> drawBoard [

	canvas := RSCanvas new.
	self drawGrid.
	canvas
		@ RSCanvasController;
		zoomToFit;
		openOnceWithTitle: 'SmallMines'
]

{ #category : #drawing }
SmallMinesGUI >> drawCell: aCell [

	| row newShape oldShape |
	newShape := aCell shape.
	row := canvas shapes at: aCell position x.
	oldShape := row shapes at: aCell position y.
	newShape translateTo: oldShape position.
	row addShape: newShape before: oldShape.
	oldShape remove
]

{ #category : #drawing }
SmallMinesGUI >> drawCoveredCellAt: aPoint [

	^ SMCell new shape
		  color: Color blue;
		  when: RSMouseLeftClick
		  do: [ :evt | "Sweep the cell" engine sweepAt: aPoint ];
		  when: RSMouseRightClick do: [ :evt | "Plant a flag"
			  | row oldShape newShape |
			  engine flagAt: aPoint.
			  row := canvas shapes at: aPoint x.
			  oldShape := row shapes at: aPoint y.
			  newShape := SMFlag new shape
				              when: RSMouseRightClick
				              do: [ self drawCoveredCellAt: aPoint ];
				              yourself.
			  newShape translateTo: oldShape position.
			  row addShape: newShape before: oldShape.
			  oldShape remove ];
		  yourself
]

{ #category : #'as yet unclassified' }
SmallMinesGUI >> drawDefeat [

	canvas add: (RSLabel text: 'Kaboom!')
]

{ #category : #drawing }
SmallMinesGUI >> drawFlag: aFlag [

	
]

{ #category : #drawing }
SmallMinesGUI >> drawGrid [

	| rows |
	rows := (1 to: engine height) collect: [ :x | self drawRowAt: x ].
	RSVerticalLineLayout on: rows.
	canvas addAll: rows
]

{ #category : #drawing }
SmallMinesGUI >> drawRowAt: x [

	| row |
	row := (1 to: engine width) collect: [ :y | 
		       self drawCoveredCellAt: x @ y ].
	(RSHorizontalLineLayout withGap: 0) applyOn: row.
	^ RSComposite new
		  addAllShapes: row;
		  yourself
]

{ #category : #'as yet unclassified' }
SmallMinesGUI >> drawVictory [

	canvas add: (RSLabel text: 'Victory!')
]

{ #category : #accessing }
SmallMinesGUI >> engine: aSmallMines [

	engine := aSmallMines
]
