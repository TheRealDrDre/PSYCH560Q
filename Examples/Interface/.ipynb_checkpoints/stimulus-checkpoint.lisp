(clear-all)
(define-model lexical

(sgp :auto-attend t)

(chunk-type concept name class natural manmade living)
(chunk-type picture kind object style screen-x screen-y width height color)
(chunk-type picture-location screen-x screen-y width height kind)
    
(add-dm (yes) (no)
        (black-and-white) (color)
        (photo) (linedrawing)
        (animal)
        (zebra ISA concept 
               name "zebra"
               class animal
               natural yes
               manmade no
               living yes)
        )
    
(p find-picture
   ?visual>
     state free
     buffer empty
==>
   +visual-location>
     kind picture
)
    
(p decide-word
   =visual>
     text   t
     value =TEXT
   
   ?visual>
     state free
   
   ?retrieval>
     state free
     buffer empty

==>
   +retrieval>
     ISA   word
     form =TEXT
)
        
); End of model