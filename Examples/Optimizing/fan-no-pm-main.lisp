(clear-all)

(define-model fan-andrea

  (sgp :v nil 
       :act nil 
       :esc t 
      ; :lf .63 
      ; :mas 1.6 
      ; :ga 1.0 
      ; :imaginal-activation 1.0
       )
  (sgp :style-warnings nil)
  
  (chunk-type comprehend-sentence relation arg1 arg2)
  (chunk-type meaning word)
  
  (chunk-type sentence-goal arg1 arg2 state)
  
  (P start
     =goal>
        ISA         sentence-goal
        arg1        =person
        state       test   
     ==>
     =goal>
        state       harvest-person
     +retrieval>
        ISA         meaning
        word        =person)

  (P harvest-person
     =goal>
        ISA         sentence-goal
        arg2        =location
        state       harvest-person
     =retrieval>
     ==>
     =goal>
        arg1        =retrieval
        state       harvest-location
     +retrieval>
        ISA         meaning
        word        =location)

  (p harvest-location
     =goal>
        ISA         sentence-goal
        state       harvest-location
     =retrieval>
        ISA         meaning
     ==>
     =goal>
        arg2        =retrieval
        state       get-retrieval)

  (P retrieve-from-person
     =goal>
        ISA         sentence-goal
        arg1        =person
        state       get-retrieval
     ==>
     =goal>
        state       nil
     +retrieval>
        ISA         comprehend-sentence
        arg1        =person)

  (P retrieve-from-location
     =goal>
        ISA         sentence-goal
        arg2        =location
        state       get-retrieval
     ==>
     =goal>
        state       nil
     +retrieval>
        ISA         comprehend-sentence
        arg2        =location)

  (P respond-yes
     =goal>
        ISA         sentence-goal
        arg1        =person
        arg2        =location
        state       nil
     =retrieval>
        ISA         comprehend-sentence
        arg1        =person
        arg2        =location
     ==>
     =goal>
        state       "k")

  (P mismatch-person-no
     =goal>
        ISA         sentence-goal
        arg1        =person
        arg2        =location
        state       nil
     =retrieval>
        ISA         comprehend-sentence
      - arg1        =person
     ==>
     =goal>
        state       "d")

  (P mismatch-location-no
     =goal>
        ISA         sentence-goal
        arg1        =person
        arg2        =location
        state       nil
     =retrieval>
        ISA         comprehend-sentence
      - arg2        =location
     ==>
     =goal>
        state       "d")

  (spp mismatch-location-no :at .21)
  (spp mismatch-person-no :at .21)
  (spp respond-yes :at .21)
  (spp start :at .250)
  (spp harvest-person :at .285))

