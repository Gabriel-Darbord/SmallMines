Class {
	#name : #SMCell,
	#superclass : #Object,
	#instVars : [
		'position'
	],
	#category : #SmallMines
}

{ #category : #testing }
SMCell >> isEmptyTally [

	^ false
]

{ #category : #testing }
SMCell >> isMine [

	^ false
]

{ #category : #accessing }
SMCell >> position [

	^ position
]

{ #category : #'as yet unclassified' }
SMCell >> position: aPoint [

	position := aPoint
]

{ #category : #drawing }
SMCell >> shape [

	^ RSBox new
		  color: Color white;
		  size: 20;
		  withBorder;
		  yourself
]
