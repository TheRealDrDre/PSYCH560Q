(clear-all)
(define-model lexical

(sgp :auto-attend t)
(chunk-type word form meaning class plural)
(add-dm (regular isa chunk)
        (zebra-animal isa chunk)
        (noun isa chunk)
        (zebra isa word
               form "zebra"
               meaning zebra-animal
               class noun
               plural regular)
        )
    
(p look-at-string
   ?visual>
     state free
     buffer empty
==>
   +visual-location>
     kind text
)
    
(p decide
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
   
   =visual>
)
 
(p respond-word
   ?retrieval>
      state free
      buffer full
   
   ?manual>
      preparation free
      processor free
      execution free
   
==>
   
   +manual>
      isa punch
      hand left
      finger index)
    
(p respond-nonword
   ?retrieval>
      state error
   
   ?manual>
      preparation free
      processor free
      execution free
   
==>
   
   +manual>
      isa punch
      hand right
      finger index)
    
); End of model