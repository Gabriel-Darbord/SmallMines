Class {
	#name : #SMMine,
	#superclass : #SMCell,
	#category : #SmallMines
}

{ #category : #testing }
SMMine >> isMine [

	^ true
]

{ #category : #drawing }
SMMine >> shape [

	^ RSComposite new
		  add: super shape;
		  add: (RSLabel text: $M);
		  yourself
]
