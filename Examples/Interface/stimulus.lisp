(clear-all)
(define-model stimulus

(sgp :auto-attend t)

(chunk-type concept name class natural manmade living)
(chunk-type (image-object (:include visual-object)) content style)
(chunk-type (image-location (:include visual-location)) style)
    
(add-dm (yes) (no)
        (black-and-white) (color)
        (photo) (linedrawing)
        (animal) (image) (zebra)
        (zebra-concept ISA concept 
                       name zebra
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
     kind image
)
    
(p decide
   =visual>
     ISA image-object
     content =OBJ
   
   ?visual>
     state free
   
   ?retrieval>
     state free
     buffer empty

==>
   =visual>
   +retrieval>
     ISA   concept
     name =OBJ
)
        
(p respond-natural
   ?retrieval>
      state free
      buffer full
   
   ?manual>
      preparation free
      processor free
      execution free
   
   =retrieval>
      natural yes
==>
   
   +manual>
      isa punch
      hand left
      finger index)
    
(p respond-manmade
   ?retrieval>
      state free
      buffer full
   
   ?manual>
      preparation free
      processor free
      execution free
   
   =retrieval>
      ISA concept
      manmade yes
==>
   
   +manual>
      isa punch
      hand right
      finger index)

); End of model