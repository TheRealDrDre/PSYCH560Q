;;=======================================================
;; Response monkey
;;=================

(clear-all)

(define-model response-monkey

(sgp :esc nil
	 :er t
	 :auto-attend t
     )


(chunk-type stroop-answer
			kind
			representation
			string)

;; Chunks 
(add-dm (answer isa chunk)
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
                      string "blue"))


;; Productions 
(p view-stim
   "Views stimulus"
   ?visual>
     state          free
     buffer         empty

   ?visual-location>
     state          free

   ?manual>
     preparation free
     processor free
     execution free	 
==>
   +visual-location>
     kind           text
     screen-y       lowest
)

(p recover-from-error
   "Views stimulus"
   ?visual>
     state          error

   ?manual>
     preparation free
     processor free
     execution free	 
==>
   +visual-location>
     kind           text
     screen-y       lowest
)

(p ignore-fixation
   "Views stimulus"
   =visual>
     text t
     color black

   ?visual>
     state free
	 
   ?manual>
     preparation free
     processor free
     execution free	 
==>
   -visual>
)

(p respond-index
   "Responds randomly"
   =visual>
     text t
   - color black

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
)

(p respond-middle
   "Responds randomly"
   =visual>
     text t
   - color black

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
)



(p respond-ring
   "Responds randomly"
   =visual>
     text t
   - color black
	 
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
)


)
