;;; ======================================================================== ;;;
;;; Stroop, well done
;;; ======================================================================== ;;;
;;; Does nothing, except randomly responding to the stimuli.
;;; ======================================================================== ;;;

(clear-all)

(define-model stroop-model-jim

(sgp :esc nil
	 :er t
	 :auto-attend t
	 :v nil
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


;;; --- Retrieve color name -------------------------------

(p retrieve-color-name
   "Retrieves the name of a color"
   =visual>
     text t
   - color black
     value =NAME	 
     color =COLOR	 

   ?manual>
     preparation free
     processor free
     execution free

   ?retrieval>
     state free
     buffer empty

   ?visual>
     state free	  
==>
   =visual>   

   +retrieval>
     isa color-name
     name =NAME
     concept =COLOR
)

;;; --- Respond based on color name ------------------------------ ;;;

(p check-retrieval-error
   =visual>
     text t
     color =COLOR
   - color black

   ?retrieval>
      state error

   ?manual>
     preparation free
     processor free
     execution free
 ==>
   =visual>	 
   +retrieval>
     isa color-name
     concept =COLOR
	 )

(p respond-red
   "Responds to red"
   =visual>
     text t
   - color black

   =retrieval>
     isa color-name
     name "red"

   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
     cmd punch
	 hand right
     finger index
   -retrieval>
   -visual>	 
)

(p respond-blue
   "Responds 'BLUE'"
   =visual>
     text t
   - color black

   =retrieval>
     isa color-name
     name "blue"
   
   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
     cmd punch
	 hand right
     finger middle
   -retrieval>
   -visual>	 
)



(p respond-green
   "Responds randomly"
   =visual>
     text t
   - color black

   =retrieval>
     isa color-name
     name "green"
   
   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
     cmd punch
	 hand right
     finger ring
   -retrieval>
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
