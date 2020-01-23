;;tornado model
(clear-all)

(define-model tornado-model

;; SET PARAMETERS

;;---------------------------------------
;; chunk types
;;---------------------------------------

;; Chunk to keep track task in goal module.
(chunk-type goal
	state ;;look-screen, encoding, translating
	decision ;;yes/no. whether a decision to shelter or not shelter was made or not. "Yes" will be a requirement to begin next trial.
	)

;; stimulus chunk is information about the forecast taken from the visual buffer.
(chunk-type stimulus
	forecast
	number
	color
	word
	)

;; This chunk represents a magnitude (preloaded - think of as real-world knowledge) associated with colors, numbers, and words.
(chunk-type magnitude
	mag
	number 
	color 
	word
	)

;;---------------------------------------
;; preload chunks
;;---------------------------------------
;;set stimulus chunk to green to start
(add-dm (first-forcast ISA stimulus color green)
;;create the starting goal state as look-screen
		(first-decision ISA make-decision
			   state look-screen)
		;;(mag-green-hi ISA magnitude color green mag 3)) ;;considering making 2 or three chunks per color (hi, med, weak strength)? 

;;place stimulus in visual buffer
(set-buffer-chunk visual first-forcast)

;; set the initial goal
(goal-focus first-decision)

;;---------------------------------------
;; productions
;;---------------------------------------

;; Imaginal buffer holds current problem state information
;; production encode-stimulus takes information from visual buffer and adds to imaginal
(P encode-stimulus
	=visual>
	isa stimulus
	forecast =cur_forecast
	color =color1
	number =num1 ;;how to address num2? (e.g. the "40%"" in the "25-40%") 
	word =word1

	?visual>
	state free

   	?imaginal>
   	state free
   	buffer empty

    ?goal>
    ISA make-decision
    state look-screen

==> 
	=goal>
	ISA 	make-decision
	state	encoding		

   +imaginal>
   	isa	stimulus
   	forecast =cur_forecast
 	color =color1
	number =num1
	word =word1
   	) 

;; production translate takes info from imaginal buffer and retrieves a magnitude based on associative strength.
(p translate
	=imaginal>
	isa	stimulus
   	forecast =cur_forecast
 	color =color1
	number =num1
	word =word1

	?imaginal>
   	state free

	?goal>
	ISA make-decision
	state encoding

	?retrieval>
    state free
    buffer empty

 ==>  
 	=goal>
 	ISA make-decision
 	state translating

   +retrieval> 
   	ISA magntiude
   	color =color1
   	number =num1
   	word =word1
   	;;let imaginal clear?
	)

;; production takes magnitude and makes decision based on shelter/not shelter threshold
)