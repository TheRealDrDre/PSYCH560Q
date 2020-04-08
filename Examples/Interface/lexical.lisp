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
    
(p find-word
   ?visual>
     state free
     buffer empty
==>
   +visual-location>
     kind text
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