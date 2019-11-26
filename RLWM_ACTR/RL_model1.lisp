;;------------------------------------
;; Model 1
;;------------------------------------
;;
;; This is a 'pure' reinforcement learning model of the RLWM task (COllins, 2018). This model has only two parameters: alpha(learning 
;;rate) and temperature(softmax function)

;; Stimulus is displayed --> processed --> disapears --> a response is selected --> feedback is given --> feedback is processed

(clear-all)

(define-model rlwm_model1

;; parameters - learning rate and temperature (expected gain s: amount of noise added to *utility*/selection), enable randomness (er)
    ;; ul: utility learning, *bll for the memory model*
    
(sgp :alpha 0.2
     :egs 0.1
     :er t
     :ul t
     :esc t
     ) 
;;--------------------------------------------------------  
;;----------------Chunk types----------------------------- 
(chunk-type goal 
            fproc) ;; fproc= feedback processed
    
(chunk-type stimulus
            picture)
    
(chunk-type feedback
            feedback)
    
;;---------------------------------------
;; Chunks
;;---------------------------------------
  
    ;; Stimulus chunks
    
;; **add chunks for all images? These are added in the python interface**
;;(add-dm (cup-stimulus
     ;;   isa stimulus
      ;; picture cup)
       ;; )
    
;;(add-dm (bowl-stimulus
  ;;      isa stimulus
    ;;    picture bowl)
      ;;  ) 
    
 
    ;; Goal chunk    
(add-dm (make-response
        isa goal
        fproc yes)
        )


    
;;-------------------------------------------------      
;; Productions: 1 for each image : 2 conditions (ns 6 & ns 3) * 3 response keys
;;-------------------------------------------------      
    
    
;;- visual, encode stimulus, check visual to see if its free,  make response (j, k or l)based on Q value, updates goal?. 
;;  If never encountered, select arbitrarily

;;-------------object 1: cup-----------------------
(p cup-j
   =visual>
       picture cup 
   ?visual>
       state free
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
       finger index 
   *goal>
       fproc no    
   )

(p cup-k
   =visual>
       picture cup 
   ?visual>
       state free
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
       finger middle 
   *goal>
       fproc no    
   )

(p cup-l
   =visual>
       picture cup 
   ?visual>
       state free
  =goal>
   fproc =x
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
    
 ;;--------object 2: bowl--------------------------- 
(p bowl-j
   =visual>
       picture bowl 
   ?visual>
       state free
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
       finger index 
   *goal>
       fproc no    
   )

(p bowl-k
   =visual>
       picture bowl 
   ?visual>
       state free
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
       finger middle 
   *goal>
       fproc no    
   )

(p bowl-l
   =visual>
       picture bowl 
   ?visual>
       state free
  =goal>
   fproc =x
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
    
    
    
;;---------object 3: plate-------------------------- 
(p plate-j
   =visual>
       picture plate 
   ?visual>
       state free
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
       finger index 
   *goal>
       fproc no    
   )

(p plate-k
   =visual>
       picture plate 
   ?visual>
       state free
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
       finger middle 
   *goal>
       fproc no    
   )

(p plate-l
   =visual>
       picture plate 
   ?visual>
       state free
  =goal>
   fproc =x
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
;;--------------- object 4: hat------------------
(p hat-j
   =visual>
       picture hat 
   ?visual>
       state free
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
       finger index 
   *goal>
       fproc no    
   )

(p hat-k
   =visual>
       picture hat 
   ?visual>
       state free
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
       finger middle 
   *goal>
       fproc no    
   )

(p hat-l
   =visual>
       picture hat 
   ?visual>
       state free
  =goal>
   fproc =x
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
;;--------------object 5: gloves------------------

(p gloves-j
   =visual>
       picture gloves 
   ?visual>
       state free
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
       finger index 
   *goal>
       fproc no    
   )

(p gloves-k
   =visual>
       picture gloves 
   ?visual>
       state free
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
       finger middle 
   *goal>
       fproc no    
   )

(p gloves-l
   =visual>
       picture gloves 
   ?visual>
       state free
  =goal>
   fproc =x
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
 ;;--------------- object 6: shoes-----------------------
(p shoes-j
   =visual>
       picture shoes 
   ?visual>
       state free
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
       finger index 
   *goal>
       fproc no    
   )

(p shoes-k
   =visual>
       picture shoes 
   ?visual>
       state free
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
       finger middle 
   *goal>
       fproc no    
   )

(p shoes-l
   =visual>
       picture shoes 
   ?visual>
       state free
  =goal>
   fproc =x
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
    
;;--------------- object 7: shirt ------------------------
(p shirt-j
   =visual>
       picture shirt 
   ?visual>
       state free
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
       finger index 
   *goal>
       fproc no    
   )

(p shirt-k
   =visual>
       picture shirt 
   ?visual>
       state free
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
       finger middle 
   *goal>
       fproc no    
   )

(p shirt-l
   =visual>
       picture shirt 
   ?visual>
       state free
  =goal>
   fproc =x
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
    
;;--------------- object 8: jacket ------------------------    
    
(p jacket-j
   =visual>
       picture jacket 
   ?visual>
       state free
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
       finger index 
   *goal>
       fproc no    
   )

(p jacket-k
   =visual>
       picture jacket 
   ?visual>
       state free
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
       finger middle 
   *goal>
       fproc no    
   )

(p jacket-l
   =visual>
       picture jacket 
   ?visual>
       state free
  =goal>
   fproc =x
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
    
;;--------------- object 9: jeans ------------------------ 

(p jeans-j
   =visual>
       picture jeans 
   ?visual>
       state free
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
       finger index 
   *goal>
       fproc no    
   )

(p jeans-k
   =visual>
       picture jeans 
   ?visual>
       state free
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
       finger middle 
   *goal>
       fproc no    
   )

(p jeans-l
   =visual>
       picture jeans 
   ?visual>
       state free
  =goal>
   fproc =x
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
    
    
;;--------------------------------------------------------    
;; Productions: processing feedback
;;--------------------------------------------------------    
    
(p parse-feedback-yes
   =visual>
       feedback yes
   ?visual>
       state free
   =goal>
       fproc no
   ==>
   *goal>
       fproc yes
   )
    
 (p parse-feedback-no
   =visual>
       feedback no
   ?visual>
       state free
   =goal>
       fproc no
   ==>
   *goal>
       fproc yes
   )
      
(goal-focus
 make-response)
 
 (spp parse-feedback-yes :reward +1)
 (spp parse-feedback-no :reward -1)
;;(set-buffer-chunk 'visual 'cup-stimulus)    
    
    
    )