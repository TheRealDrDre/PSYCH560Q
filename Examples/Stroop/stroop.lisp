;;; ======================================================================== ;;;
;;; Response monkey
;;; ======================================================================== ;;;
;;; Does nothing, except randomly responding to the stimuli.
;;; ======================================================================== ;;;

(clear-all)

(define-model stroop-model

(sgp :esc nil
	 :er nil
	 :auto-attend t
     )



(chunk-type color-name
		    concept
			name)

;;; ===  CHUNKS ============================================================ ;;;

(add-dm (blue-color-name isa color-name
						 concept blue
						 name "blue")
		(red-color-name isa color-name
						 concept red
						 name "red")
		(green-color-name isa color-name
						  concept green
						  name "green"))


;;; === Productions ======================================================== ;;;

(p check-the-screen
   "Checks whatever is on the screen"
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
   "If a encoding went wrong, recover from it"
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
   "If we are looking at the fixation cross, discard"
   =visual>
     text t
     value "+"
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

;;; --- Random Responses --------------------------------------------------- ;;;

(p retrieve-color-name
   =visual>
     text t
   - color black
     color =COLOR	 

   ?retrieval>
     state free
     buffer empty
==>
   +retrieval>
     isa color-name
     concept =COLOR)

(p retrieve-color-name
   =visual>
     text t
   - color black
     color =COLOR	 

   ?retrieval>
     state free
     buffer empty
==>
   +retrieval>
     isa color-name
     concept =COLOR)

(p respond-green
   "Responds to green"
   =visual>
     text t
   - color black

   =retrieval>
     isa color-name
     name green

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

;;; --- DONE! -------------------------------------------------------------- ;;;

(p done
   "Detects when the experiment is done"
   =visual>
     text t
     value "done"
     color black

   ?visual>
     state free
	 
   ?manual>
     preparation free
     processor free
     execution free	 
==>
   !stop!
)


) ;; End of model
