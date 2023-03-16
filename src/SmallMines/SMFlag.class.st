Class {
	#name : #SMFlag,
	#superclass : #SMCell,
	#category : #SmallMines
}

{ #category : #drawing }
SMFlag >> shape [

	^ RSComposite new
		  add: (super shape
				   color: Color blue;
				   yourself);
		  add: (RSLabel text: $F);
		  yourself
]
