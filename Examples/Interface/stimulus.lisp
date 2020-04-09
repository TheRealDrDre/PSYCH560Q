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
   "Finds a picture in the visual field"
   ?visual>
     state free
     buffer empty
==>
   +visual-location>
     kind image
)
    
(p decide
   "Retrieves the concept associated with the picture"
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
   "if the concept is a natural object, respond with left index finger"
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
   "If the concept is an artificial object, respond with right index finger"
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