;;; ======================================================================== ;;;
;;; Response monkey
;;; ======================================================================== ;;;
;;; Does nothing, except randomly responding to the stimuli.
;;; ======================================================================== ;;;

(clear-all)

(define-model response-monkey

(sgp :esc nil
	 :er t
	 :auto-attend t
     )


;;; ===  CHUNKS ============================================================ ;;;



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
