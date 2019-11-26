#!/usr/bin/env python
# coding: utf-8

# ### Python interface for Model 2

# In[1]:


import random as rnd
import numpy as np
import os
import sys
import string
import actr
import pandas as pd



#Stimuli to be used and exp parameters
stims_3 = ['cup','bowl','plate']
stims_6 = ['hat','gloves','shoes', 'shirt', 'jacket', 'jeans']
nPresentations = 12
nTrials = nPresentations * 3 #for sets size three experiment/block

#associated responses (these are arbitrary)
stims_3_resps = ['j', 'k', 'l'];
stims_6_resps = ['k','k', 'j', 'j', 'l', 'l'];

#generate stimult to present to model **Edit as needed **

#this shuffles both lists, stimuli and associated correct responses, in the same order
stims_temp = list( zip(np.repeat(stims_3, 12).tolist(),
         np.repeat(stims_3_resps,12).tolist()
        ))

rnd.shuffle(stims_temp)

#stims, cor_resps = zip(*stims_temp)
##########debug########
stims=['cup']

# In[3]:


#Load model
model = actr.load_act_r_model('/home/master-tedward/RLWM_ACTR/memory_model2.lisp')


#variables needed
chunks = None
current_response  = np.repeat('x', nTrials).tolist()
accuracy = np.repeat(0, nTrials).tolist()

i = 0
win = None


#Daisy chained python functions to present stimuli, get response and  present feedback

def present_stim():
    global chunks
    global stims
    global i
   
    chunks = actr.define_chunks(['isa', 'stimulus', 'picture', stims[i]])
    actr.set_buffer_chunk('visual', chunks[0])
    
    print('Presented: ', stims[i])
    print('correct response: ', cor_resps[i])   
def get_response(model, key):
    global current_response
    global i
    
    actr.schedule_event_relative(0, 'present_feedback')
    
    current_response[i] = key
   
    return current_response

def present_feedback():
    global i
    global current_response
    global accuracy
    
    feedback = 'no'
     
    # check if response matches the appropriate key for the current stimulus in cue
    #need list of correct responses
    if current_response[i] == cor_resps[i]:
        feedback = 'yes'
        accuracy[i] = 1
    
    chunks = actr.define_chunks(['isa', 'feedback', 'feedback',feedback])
    actr.set_buffer_chunk('visual', chunks[0])
    print("Feedback given: ", feedback )
  
    #increase index for next stimulus
    i = i + 1
    actr.schedule_event_relative(1, 'present_stim')
    

# This function builds ACT-R representations of the python functions

def model_loop():
    
    global win
    actr.add_command('present_stim', present_stim, 'presents stimulus') 
    actr.add_command('present_feedback', present_feedback, 'presents feedback')
    actr.add_command('get_response', get_response, 'gets response')
    
    #open window for interaction
    win = actr.open_exp_window("test", visible = False)
    actr.install_device(win)
    actr.schedule_event_relative(0, 'present_stim' )
    
    #waits for a key press?
    actr.monitor_command("output-key", 'get_response')
    actr.run(45)
   

model_loop()
      
print('mean accuracy: ', np.mean(accuracy))






