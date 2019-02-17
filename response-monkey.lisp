 ;;=======================================================
;; Stroop Model MK 1
;;=================
;; Processes both word and color and selects representation that has highest activation,
;; Checks if activation matches color and then responds
;;=================
;; Created by Micah Ketola Fall 2018
;;=======================================================

(clear-all)

(define-model response-monkey

(sgp :esc nil
	 :er t
	 :egs 0.2
	 :auto-attend t
     )

;; Stroop Device 
(chunk-type (stroop-stimulus (:include visual-object)) kind color word)

(chunk-type (stroop-screen (:include visual-object)) kind value)

(chunk-type (stroop-stimulus-location (:include visual-location)) kind color word)

(chunk-type phase step)

(chunk-type stroop-answer kind representation string)

(chunk-type imaginal slot1 slot2)

;; Chunks 
(add-dm (color           isa chunk)
        (word            isa chunk)
        (done            isa chunk)
        (encode          isa chunk)
        (check           isa chunk)
        (stimulus        isa chunk)
        (pause           isa chunk)
        (screen          isa chunk)
        (stroop-stimulus isa chunk)
		(answer          isa chunk)
		;; Neutral stimuli
		(chair           isa chunk)
		(table           isa chunk)
		(coffee          isa chunk)
		(dog             isa chunk)
		(phone           isa chunk)
		(backpack        isa chunk)
		;; Complex chunks
        (answer-red   isa stroop-answer
                      kind answer
                      representation red
                      string "red")
        (answer-green isa stroop-answer
                      kind answer
                      representation green
                      string "green")
        (answer-blue  isa stroop-answer
                      kind answer
                      representation blue
                      string "blue")
        (answer-yellow isa stroop-answer
                      kind answer
                      representation yellow
                      string "yellow"))


;; Productions 
(p view-stim
   "Views stimulus"
   ?visual>
     state          free

   ?imaginal>
     state          free
     buffer         empty

   ?visual-location>
     state          free

   ?goal>
     state          free
     buffer         empty

   ?manual>
     preparation free
     processor free
     execution free	 
==>
   +visual-location>
     kind           stroop-stimulus
     :attended      nil
   ;;+goal>
   ;;  isa            phase
   ;;  step           encode
)

(p respond-index
   "Responds randomly"
   =visual>
     kind stroop-stimulus

   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
     cmd punch
	 hand right
     finger index
   -visual>
   -goal>	 
)

(p respond-middle
   "Responds randomly"
   =visual>
     kind stroop-stimulus

   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
     cmd punch
	 hand right
     finger middle
   -visual>
   -goal>	 
)



(p respond-ring
   "Responds randomly"
   =visual>
     kind stroop-stimulus

   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
     cmd punch
	 hand right
     finger ring
   -visual>
   -goal>	 
)


;; Stroop-Device-Codes
;(install-device (make-instance 'stroop-task))

;(init (current-device))

;(proc-display)
)
