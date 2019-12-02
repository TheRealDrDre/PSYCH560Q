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
            picture
            associate-key
            )
    
(chunk-type feedback
            feedback)

;; chunks
   (add-dm (make-response
       isa goal
       fproc yes)
       )

;; productions
   ;; Check memory: picture cur_pic, current picture presented is a variable. 
   ;; This is a general purpose production that just takes in whatever presented stimulus
   ;; and checks against declarative memory in the retrieval buffer

(p check-memory
    =visual>
      picture =cur_pic 

    ?visual>
      state free

    =goal>
       fproc yes
    
  ==>
   ?retrieval>
      state free
   
   +retrieval> 
      picture =cur_pic
      outcome no
   
   +imaginal>
      picture =cur_pic
)
    
;; Depending on outcome: yes or no

   ;;outcome is no: make random response (3 possible)
(p response-monkey-j
     =retrieval>
      outcome no

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
(p outcome-yes
    =retrieval> 
       outcome yes 
       associate-key =k

    +imaginal>
      picture =cur_pic
    =goal>
      fproc yes

   ?manual>
     preparation free
     processor free
     execution free

   ==>
   +manual>
      cmd punch
      hand right
      finger ring

  *goal>
       fproc no   
)

    
;;Encode response after feedback
    
(p encode-feedback
    =visual>
    feedback =f
    
    ?imaginal>
    outcome nil
    
    ==> 
    +imaginal>
    outcome =f
)

(goal-focus
 make-response)
 


    (set-buffer-chunk 'visual 'cup-stimulus)    
    
    )

