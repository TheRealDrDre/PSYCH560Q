;;;tornado model
(clear-all)

(define-model tornado-model

;;; SET PARAMETERS

;;;---------------------------------------
;;; chunk types
;;;---------------------------------------

;;; Chunk to keep track of task in goal module.
(chunk-type make-decision
	state ;; encoding; look-screen, translating, deciding, collecting (i.e. collecting info from interface)
	decision-made ;;yes/no. whether a decision to shelter or not shelter was made or not. "Yes" will be a requirement to begin next trial.
	outcome-collected ;;yes/no. model collected info from interface
	)

;;; stimulus chunk is information about the forecast taken from the visual buffer.
(chunk-type stimulus
	forecast
	number
	color
	word
	)

;;; This chunk represents a magnitude (preloaded - think of as real-world knowledge) associated with colors, numbers, and words.
(chunk-type magnitude ;;represents a position on the gradient from 1 to 10 magnitude
	mag
	number 
	color 
	word
	)
	
;;; After a decision is made (and all forecasts have been seen) the interface gives a tornado outcome. Consider including point balance in this outcome for future. 
(chunk-type outcome
	outcome ;;did interface give outcome y/no
	tornado-hit ;;y for tornado hit, n for no hit
	point-bal
	   )
	
;;; encode outcome and relevant situation and decision info into an instance
(chunk-type instance
	shelter ;;y/n
	tornado-hit ;;tornado-hit yes/no
	mag ;;should this be mag and/or the stimulus visual characteristics? Want to allow program to eventually find shortcut of color to decision rule.
	point-deduct ;;Reflects points spent and lost (penalty) during this trial. Calcualted via point balance of last trial minus point-bal of this trial.
	    )
	
	    
;;;---------------------------------------
;;; preload chunks
;;;--------------------------------------
;;;set stimulus chunk to green to start
(add-dm (first-forcast ISA stimulus color green)
;;;create the starting goal state as look-screen
		(first-decision ISA make-decision
                        state look-screen)
        (look-screen);;must create the chunk that will be in slot of first decision (or will get a warning)
        (encoding)
	(translating))
		;;(mag-green-hi ISA magnitude color green mag 3)) ;;considering making 2 or three chunks per color (hi, med, weak strength)? 

;;;place stimulus in visual buffer
(set-buffer-chunk 'visual 'first-forcast)

;;; set the initial goal
(goal-focus first-decision)

;;;---------------------------------------
;;;productions
;;;---------------------------------------

;;; production translate takes info from visual buffer and retrieves a magnitude based on associative strength. 
;;; Copies magnitude information to imaginal buffer.
(p translate
	=visual>
	  ISA stimulus
   	  forecast =cur_forecast
 	  color =color1
	  number =num1
	  word =word1

	?imaginal>
   	  state free
   	  buffer empty

	=goal>
	  ISA make-decision
	  state encoding
   	  decision-made no
   	  outcome-learned no

	?retrieval>
      	  state free
     	  buffer empty

 ==>  
 	*goal>
 	  ISA make-decision
 	  state translating
   	  decision-made no
   	  outcome-learned no
	
   	+retrieval> 
      	  ISA magnitude
   	  mag =mag1
   	  color =color1
   	  number =num1
   	  word =word1
	
   	+imaginal>
   	  ISA magnitude
   	  mag =mag1
   	  color =color1
   	  number =num1
   	  word =word1
   )
	
;;; productions take magnitude and make decision based on shelter/not shelter threshold. s is Shelter. n is not shelter.
(p decide-s
	=goal>
	  ISA make-decision
	  state translating
	  decision-made no
   	  outcome-processed no
   	
   	=imaginal>
   	  state free
   
   	=imaginal>
     	  ISA magnitude
   	  mag1 >= 2.5 ;;can i directly compute here? set ranges of possible magnitudes at beginning.
   	
   	?manual>
     	  preparation free
          processor   free
    	  execution   free
   
   ==>  
   	*goal>
 	  ISA make-decision
 	  state collecting
   	  decision-made yes
   	  outcome-learned no
   
   	*imaginal>
 	  ISA instance
    	  shelter yes

    	+manual>
     	  cmd press-key
   	  key =s
)

	
;;; add not shelter production

;;;collect info from interface and copy to imaginal buffer into slots of instance
(p encode-outcome
   	=visual>
   	  ISA outcome  
     	  outcome yes ;;outcome was provided
     	  tornado hit=t
     	  point-bal =p
 
   	?visual>
     	  state free

   	=goal>
     	  ISA make-decision
 	  state collecting
     	  outcome-collected no
   
   	?imaginal>
     	  state free
     ;;buffer should have "shelter=y/n" in it from decide-s decide-ns productions

   ==>
   	*imaginal>
   	  ISA instance
 	  shelter =s
	  tornado-hit =t
	  mag ;;should this be mag and/or the stimulus visual characteristics? Want to allow program to eventually find shortcut of color to decision rule.
	  point-deduct ;;Reflects points spent and lost (penalty) during this trial. Calcualted via point balance of last trial minus point-bal of this trial.

 	*goal>
   	  ISA make-decision
   	  state encoding ;;set to encoding so as to allow for next trial
   	  outcome-collected no ;;reset for new trial
)


