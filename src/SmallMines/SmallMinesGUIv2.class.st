"
I'm a Minesweeper board used by `SmallMines`.
"
Class {
	#name : #SmallMinesGUIv2,
	#superclass : #Object,
	#instVars : [
		'engine',
		'canvas',
		'cellWidth',
		'cellHeight'
	],
	#category : #SmallMines
}

{ #category : #accessing }
SmallMinesGUIv2 >> cellHeight [

	^ cellHeight ifNil: [ cellHeight := 20 ]
]

{ #category : #accessing }
SmallMinesGUIv2 >> cellHeight: anInteger [

	cellHeight := anInteger
]

{ #category : #drawing }
SmallMinesGUIv2 >> cellWidth [

	^ cellWidth ifNil: [ cellWidth := 20 ]
]

{ #category : #accessing }
SmallMinesGUIv2 >> cellWidth: anInteger [

	cellWidth := anInteger
]

{ #category : #drawing }
SmallMinesGUIv2 >> drawBoard [

	canvas := RSCanvas new.
	self drawGrid.
	canvas
		@ RSCanvasController;
		zoomToFit;
		openOnceWithTitle: 'SmallMines'
]

{ #category : #drawing }
SmallMinesGUIv2 >> drawCell: aCell [

	| row newShape oldShape |
	newShape := aCell shape.
	row := canvas shapes at: aCell position x.
	oldShape := row shapes at: aCell position y.
	newShape translateTo: oldShape position.
	row addShape: newShape before: oldShape.
	oldShape remove
]

{ #category : #'as yet unclassified' }
SmallMinesGUIv2 >> drawDefeat [

	canvas add: (RSLabel text: 'Kaboom!')
]

{ #category : #drawing }
SmallMinesGUIv2 >> drawFlag: aFlag [

	
]

{ #category : #drawing }
SmallMinesGUIv2 >> drawGrid [

	1 to: engine width do: [ :x | 
		1 to: engine height do: [ :y | 
			| cell |
			cell := SMCell new shape
				        color: Color blue;
				        when: RSMouseLeftClick do: [ :evt | "Sweep the cell" 
					        engine sweepAt: (self positionToPoint: evt position) ];
				        when: RSMouseRightClick do: [ :evt | "Plant a flag" 
					        engine flagAt: (self positionToPoint: evt position) ];
				        yourself.
			canvas add: cell ] ]
]

{ #category : #'as yet unclassified' }
SmallMinesGUIv2 >> drawVictory [

	canvas add: (RSLabel text: 'Victory!')
]

{ #category : #accessing }
SmallMinesGUIv2 >> engine: aSmallMines [

	engine := aSmallMines
]

{ #category : #drawing }
SmallMinesGUIv2 >> pointToPosition: aPoint [

	^ (aPoint x * self cellWidth) @ (aPoint y * self cellHeight)
]

{ #category : #drawing }
SmallMinesGUIv2 >> positionToPoint: aPosition [

	^ (aPosition x / self cellWidth) @ (aPosition y / self cellHeight) rounded
]
