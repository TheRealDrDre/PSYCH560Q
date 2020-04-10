;;; ================================================================
;;; PARSING A SENTENCE IN ACT-R
;;; ================================================================
;;; (c) 2016, Andrea Stocco, University of Washington
;;;           stocco@uw.edu
;;; ================================================================
;;; This is an ACT-R model that simply parses a sentence presented
;;; on the screen, creating a syntactic tree as it goes. The
;;; syntactic parsing tree has this general form:
;;;
;;;             (S)
;;;            /    \
;;;          /      (VP)
;;;        /        /  \ 
;;;    (NP)       /    (NP)
;;;    /  \     /      /  \
;;;  the  boy  kicks  the  ball
;;;
;;; To properly parse the sentence, the model must resolve
;;; attachment (the NP might be attached the S or the VP), which
;;; in turns requires to handle two distinct buffers.
;;; ================================================================
(clear-all)

(define-model parser

(sgp :auto-attend t 
     :show-focus t 
     :esc t 
     :blc 10)

  
(chunk-type lexical-entry word meaning category number tense determinate)
(chunk-type noun word meaning number)
(chunk-type verb word meaning tense number)
(chunk-type article word meaning determinate)
(chunk-type np level article noun processing)
(chunk-type vp level verb np processing)
(chunk-type sentence level np vp processing)

(add-dm (yes) (no) 
        (article) (noun)  (verb)
        (one-specific) (one-generic) 
        (singular) (plural) (present)
        (vp) (np) (sentence)
        (complete) (incomplete)
        (young-man) (round-toy) (expert-person) 
        (to-kick) (to-evaluate)
        
        (the isa lexical-entry
             word "the"
             category article
             meaning one-specific
             determinate yes)
        
        (a isa lexical-entry
           word "a"
           category article
           meaning one-generic
           determinate yes)
        
        (boy isa lexical-entry
             word "boy"
             category noun
             meaning young-man
             number singular
             determinate no)
        
        (boys isa lexical-entry
              word "boys"
              category noun
              meaning young-man
              number plural
              determinate no)
        
        (ball isa lexical-entry
              word "ball"
              category noun
              meaning round-toy
              number singular
              determinate no)
        
        (pundit isa lexical-entry
                word "pundit"
                category noun
                meaning expert-person
                number singular
                determinate no)
        
        (expert isa lexical-entry
                word "expert"
                category noun
                meaning expert-person
                number singular
                determinate no)
        
        (kicks isa lexical-entry
               word "kicks"
               category verb
               meaning to-kick
               tense present
               number singular)
        
        (ponders isa lexical-entry
                 word "ponders"
                 category verb
                 meaning to-evaluate
                 tense present
                 number nil)
        
        (examines isa lexical-entry
                  word "examines"
                  category verb
                  meaning to-evaluate
                  tense present
                  number nil)
        
        (circumstance isa lexical-entry
                      word "circumstance"
                      category noun
                      meaning situation
                      tense nil
                      number singular)
        
        (situation isa lexical-entry
                   word "situation"
                   category noun
                   meaning situation
                   tense nil
                   number singular)
)

;;; -------------------------------------------------------------------
;;; PRODUCTION RULES
;;; -------------------------------------------------------------------

(p start
   "Starts by looking at the leftmost word"
   ?goal>
     buffer empty
     state free
   
   ?imaginal>
     state free
     buffer empty
==>
   +goal>            ;; New goal to process sentences
     level sentence
     processing incomplete
     
   +visual-location>
     kind text
     screen-x lowest
)

(p next-word
   "When done processing, looks for next word"
   ?visual>
     state free
   
   =goal>
     processing complete 
==>
   +visual-location>
     kind text
   > screen-x current   ;; Next word to to the right
     screen-x lowest

   *goal>
     processing incomplete  
)


(p find-meaning
   "Retrieves the meaning a of word"
   ?visual>
     state free
   
   =visual>
     text t
     value =WORD
     
   =goal>
     processing incomplete
==>
   +retrieval>
     word =WORD
)

(p start-np
   "If the word is an article, creates a new NP"
   =retrieval>
     category article
     
   =goal>
     processing incomplete

   ?imaginal>
     state free  
==>
   +imaginal>
     level np
     article =retrieval
     noun nil
     
   *goal>
     processing complete  ;; Finished processing word
)

(p add-noun-to-np
   "Adds a noun to an NP with an article"
   =retrieval>
     category noun
     
   =imaginal>
     level np  
   - article nil
     noun nil
==>
   *imaginal>
     isa np
     noun =retrieval
)

(p attach-np
   "Attach NP to its parent node (S or VP)" 
   =goal>
     np nil
     
   =imaginal>
   - article nil
   - noun nil
==>
   *goal>
     np =imaginal
     processing complete  ;; Finished processing NP
)

(p start-vp
   "If the meaning is a verb, create a new VP"
   =retrieval>
     word =WORD
     category verb
     
   ?imaginal>
     state free  
==>
   +imaginal>
     level vp
     verb =retrieval
     np nil
)

(p save-sentence
   "Save a sentence in LTM while completing the VP"
   =goal>
     level sentence
     vp nil
     
   ?imaginal>
     state free
   
   =imaginal>
     level vp
==>
   =imaginal>     
   -goal>
)  

(p switch-context-1
   "Switch the parent node to VP instead of S"
   ?goal>
     buffer empty
     
   ?imaginal>
     state free
   
   =imaginal>
     level vp
   - processing complete
==>
   *imaginal>
     processing complete
)
    
(p switch-context-2
   "Switch the parent node to VP instead of S"
   ?goal>
     buffer empty
     
   =imaginal>
     level vp
     processing complete
==>     
   @goal>  =imaginal
)


(p retrieve-sentence
   "If there are no more words, we need to complete the sentence" 
   ?visual-location>
     state error

   =goal>
     level vp  
 
   ?retrieval>
     state free
     buffer empty
==>
   +retrieval>
     level sentence
   - np nil
     vp nil
     processing incomplete

   @imaginal> =goal
     
)

(p back-on-sentence
   "Switches back the focus on the sentence"
   =retrieval>
     level sentence
     vp nil
     processing incomplete
     
   =goal>
     level vp
   
   ?imaginal>
     state free
   
   =imaginal>
     level vp  
==>
   *imaginal>
     processing nil
   
   @goal> =retrieval     
)

(p close-sentence
   "Attaches the VP to S"
   =goal>
     level sentence
     vp nil
     processing incomplete
        
   ?imaginal>
     state free
   
   =imaginal>
     level vp
   - np nil
==>
  *goal>
    vp =imaginal
    processing nil
    
  -goal> ;; Put back into LTM   
    
  !stop! ;; Done :-)
)


)  ;; End of define-model