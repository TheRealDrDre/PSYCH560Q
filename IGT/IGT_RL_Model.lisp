;;------------------------------------
;; IGT-RF
;;------------------------------------
;;
;; This is a 'pure' reinforcement learning model of the IGT (Bechara et al., 1994). This model has only two parameter, :alpha(learning 
;;rate) and :egs (expected gain s: amount of noise added to *utility*/selection).

;; No feedback from interface --> select deck/card --> feedback from interface --> process feedback --> feedback is processed

(clear-all)

(define-model igt_rf

;; parameters - learning rate and noise (expected gain s: amount of noise added to *utility*/selection)
(sgp :alpha 0.2
     :egs 23
     :er t
     :esc t
     :ul t) 
;;--------------------------------------------------------  
;;----------------Possible rewards------------------------
;;(spp process-reward+100 :reward +100)
;;--------------------------------------------------------  
;;----------------Chunk types----------------------------- 
(chunk-type selection-yes-or-no selection pick)
(chunk-type reward-amount amount)
(chunk-type decks deckA deckB deckC deckD)

(p select-A
   "Select deck A"
   =visual>
     ISA decks 
     deckA yes
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
      cmd         press-key
      key         "a"   
-visual>
)
 
(p select-B
   "Select deck B"
   =visual>
     ISA decks 
     deckB yes
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
      cmd         press-key
      key         "b"
   -visual>
)
    
(p select-C
   "Select deck C"
   =visual>
     ISA decks 
     deckC yes
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
      cmd         press-key
      key         "c"
   -visual>
)
    
(p select-D
   "Select deck D"
   =visual>
     ISA decks 
     deckD yes
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   +manual>
      cmd         press-key
      key         "d"
   -visual>
)
    
(p process_reward+100
   =visual>
     ISA reward-amount
     amount 100
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)
   
(p process_reward+50
   =visual>
     ISA reward-amount
     amount 50
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)
   
(p process_reward+25
   =visual>
     ISA reward-amount
     amount 25
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)
   
(p process_reward+0
   =visual>
     ISA reward-amount
     amount 0
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)   

(p process_reward-25
   =visual>
     ISA reward-amount
     amount -25
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)
   
(p process_reward-50
   =visual>
     ISA reward-amount
     amount -50
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)
    
(p process_reward-100
   =visual>
     ISA reward-amount
     amount -100
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)
    
(p process_reward-150
   =visual>
     ISA reward-amount
     amount -150
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)
    
(p process_reward-200
   =visual>
     ISA reward-amount
     amount -200
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)
    
(p process_reward-250
   =visual>
     ISA reward-amount
     amount -250
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)
    
(p process_reward-1150
   =visual>
     ISA reward-amount
     amount -1150
   ?visual>
     state free
   ?manual>
     preparation free
     processor free
     execution free
==>
   -visual>
   +manual>
     cmd         press-key
     key         space)
    
(spp process_reward+100 :reward +100)
(spp process_reward+50 :reward +50)
(spp process_reward+25 :reward +25)
(spp process_reward+0 :reward 0)
(spp process_reward-25 :reward -25)
(spp process_reward-50 :reward -50)
(spp process_reward-100 :reward -100)
(spp process_reward-150 :reward -150)
(spp process_reward-200 :reward -200)
(spp process_reward-250 :reward -250)
(spp process_reward-1150 :reward -1150)      
    )