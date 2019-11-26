;;------------------------------------
;; Model 2
;;------------------------------------
;;

;; This model relies only on storage and retrieval of memory of past experience with stimuli and associated response. It relies on three parameters: memory decay, activation noise and retrieval threshold at which a memory will be...activated/retrieved. 

(clear-all)

(define-model rlwm_memory_model2

(sgp :bll 0.5
     :ans 0.5
     :rt  0.5
     :er t
     )
    
    ;; Chunk types 
(chunk-type goal 
            fproc) ;; fproc= feedback processed
    
(chunk-type stimulus
            picture)
    
(chunk-type feedback
            feedback)

;; chunks
   (add-dm (make-response
       isa goal
       fproc yes)
       )
;; productions
   ;; Check memory: picture p is a variable?

(p check-memory
    =visual>
      picture p 
    ?visual>
      state free
    =goal>
       fproc yes
    
    ==>
   ?retrieval>
      state free
   
   +retrieval> 
      picture = p
      outcome yes
   
   +imaginal>
      picture = p
)
    
;; Depending on outcome: yes or no

   ;;outcome is no: make random response (3 possible)
(p response-monkey-j
     =retrieval>
      state error

    ?manual>
     preparation free
     processor free
     execution free
     ==>
    +manual>
       cmd punch
       hand right
       finger index
   )
    
(p response-monkey-k
     =retrieval>
      state error
    ?manual>
     preparation free
     processor free
     execution free
    ==>
   +manual>
       cmd punch
       hand right
       finger middle
   )

(p response-monkey-l
   =retrieval>
      state error
      
    ?manual>
     preparation free
     processor free
     execution free
   ==>
    +manual>
      cmd punch
      hand right
      finger ring 
   )
    
    
   ;;outcome is yes: make response based on memory
(p feedback-yes
    =retrieval> 
       outcome yes 
      key = k
    +imaginal>
      picture =cup
   ?manual>
   ==>
   +manual>

)

    
;;Encode response after feedback
    
(p encode-feedback
    =visual>
    feedback yes OR no
    ?Imaginal
    outcome nil
    ==> 
    +imaginal>
   
    outcome = F
)

(goal-focus
 make-response)
 


    
    
    )

