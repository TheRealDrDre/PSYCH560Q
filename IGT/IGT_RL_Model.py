"""This is an ACT-R model of the Iowa Gambling Task using reinforcement learning"""
"""Written by Jim Treyens"""
"""Updated 1/6/2020"""

"""The model selects 100 cards from 4 decks as described in Bechara et al. (1994)  """

""" Bechara, A., Damasio, A. R., Damasio, H., & Anderson, S. W. (1994). Insensitivity to future consequences   """ 
""" following damage to human prefrontal cortex. Cognition, 50(1-3), 7-15."""

""" The model produces a trace showing information for each card selected: """
"""  Overall pick #, deck from card was picked, penalty associated with pick, reward (where reward = yield - penalty) """

"""Decide whether to put import statements in Jupyter notebook or in python file"""

import actr
import random as rnd
import numpy as np
import os
import sys
import string

actr.load_act_r_model("ACT-R:IGT;igt11.lisp")

decka_penalties = [0,0,150,0,300,0,200,0,250,350,0,350,0,250,200,0,300,150,0,0,0,300,0,350,0,200,250,150,0,0,350,200,250,0,0,0,150,300,0,0]
decka_counter = 0

deckb_penalties = [0,0,0,0,0,0,0,0,1250,0,0,0,0,1250,0,0,0,0,0,0,1250,0,0,0,0,0,0,0,0,0,0,1250,0,0,0,0,0,0,0,0]
deckb_counter = 0

deckc_penalties = [0,0,50,0,50,0,50,0,50,50,0,25,75,0,0,0,25,75,0,50,0,0,0,50,25,50,0,0,75,50,0,0,0,25,25,0,75,0,50,75]
deckc_counter = 0

deckd_penalties = [0,0,0,0,0,0,0,0,0,250,0,0,0,0,0,0,0,0,0,250,0,0,0,0,0,0,0,0,250,0,0,0,0,0,250,0,0,0,0,0]
deckd_counter = 0

current_pick = None
total_picks = 0
reward = 0
trace = []
tracedeckA = []
tracedeckB = []
tracedeckC = []
tracedeckD = []
tracepicksA = []
tracepicksB = []
tracepicksC = []
tracepicksD = []

"""Loads decks to visual buffer""" 
def load_decks():
    global decka_counter
    global deckb_counter
    global deckc_counter
    global deckd_counter
    if decka_counter < 40:
        decka = "yes"
    else:
        decka = "no"    
    if deckb_counter < 40:
        deckb = "yes"
    else:
        deckb = "no"                     
    if deckc_counter < 40:
        deckc = "yes"
    else:
        deckc = "no"        
    if deckd_counter < 40:
        deckd = "yes"
    else:
        deckd = "no"                
    
    deck_chunk = actr.define_chunks(['isa', 'decks', 'deckA', decka, 'deckB', deckb, 'deckC', deckc, 'deckD', deckd])

    actr.set_buffer_chunk("visual", deck_chunk[0])

"""Responds to key press and calculates reward"""
def respond_to_key_press(model,key):
    global current_pick
    current_pick = key
    global total_picks
    global reward
    global decka_counter
    global deckb_counter
    global deckc_counter
    global deckd_counter
    global trace
    global tracedeckA
    global tracedeckB
    global tracedeckC
    global tracedeckD
    global tracepicksA
    global tracepicksB
    global tracepicksC
    global tracepicksD
    
    if current_pick == "a":   
        reward = (100 - decka_penalties[decka_counter])
        decka_counter = decka_counter + 1
        total_picks = total_picks+1
        actr.schedule_event_now("load_reward")
        trace.append(total_picks)
        trace.append(current_pick)
        trace.append(decka_penalties[decka_counter-1])
        trace.append(reward)
        tracedeckA.append(1)
        tracedeckB.append(0)
        tracedeckC.append(0)
        tracedeckD.append(0)
        tracepicksA.append(total_picks)
    
    if current_pick == "b":   
        reward = (100 - deckb_penalties[deckb_counter])
        deckb_counter = deckb_counter + 1
        total_picks = total_picks+1
        actr.schedule_event_now("load_reward")
        trace.append(total_picks)
        trace.append(current_pick)
        trace.append(deckb_penalties[deckb_counter-1])
        trace.append(reward)
        tracedeckA.append(0)
        tracedeckB.append(1)
        tracedeckC.append(0)
        tracedeckD.append(0)
        tracepicksB.append(total_picks)
 
    
    if current_pick == "c":
        reward = (50 - deckc_penalties[deckc_counter])
        deckc_counter = deckc_counter + 1
        total_picks = total_picks+1
        actr.schedule_event_now("load_reward")
        trace.append(total_picks)
        trace.append(current_pick)
        trace.append(deckc_penalties[deckc_counter-1]) 
        trace.append(reward)
        tracedeckA.append(0)
        tracedeckB.append(0)
        tracedeckC.append(1)
        tracedeckD.append(0)
        tracepicksC.append(total_picks)
        
        
    if current_pick == "d":
        reward = (50 - deckd_penalties[deckd_counter])
        deckd_counter = deckd_counter + 1
        total_picks = total_picks+1
        actr.schedule_event_now("load_reward")
        trace.append(total_picks)
        trace.append(current_pick)        
        trace.append(deckd_penalties[deckd_counter-1])
        trace.append(reward)
        tracedeckA.append(0)
        tracedeckB.append(0)
        tracedeckC.append(0)
        tracedeckD.append(1)
        tracepicksD.append(total_picks)
        
"""Loads reward to visual buffer"""
def load_reward():
    global reward
    reward_chunk = actr.define_chunks(['isa', 'reward-amount', 'amount', reward])
    actr.set_buffer_chunk("visual", reward_chunk[0])
    
"""THE NEXT TWO LINES ARE CRITICAL FOR INTERFACING WITH THE ACT-R/LISP CODE; THEY ARE REQUIRED FOR PYTHON TO DETECT KEY PRESSES"""    
win = actr.open_exp_window("Test", visible=False)
actr.install_device(win)

"""THE FOLLOWING LINES SET UP THE INTERFACE TO ACT-R/LISP CODE"""
actr.add_command("get-pick", respond_to_key_press, "IGT key press response monitor")
actr.monitor_command("output-key","get-pick")
actr.add_command("load_reward", load_reward, "Loads reward amount chunk to visual buffer")
actr.add_command("load_decks", load_decks, "Loads decks chunk to visual buffer")

event_time = 1
event_step = 1
total_picks_for_while_loop = 0

while total_picks_for_while_loop < 100:
    actr.schedule_event(event_time, "load_decks")
    event_time += event_step
    total_picks_for_while_loop = total_picks_for_while_loop + 1
    
actr.run(200)


actr.remove_command_monitor("output-key", "get-pick")
actr.remove_command("get-pick")
actr.remove_command("load_reward")
actr.remove_command("load_decks")

# print("Pick %s" % (current_pick))
print("trace picks: ",trace)
print("Deck A trace", tracedeckA)
print("Deck B trace", tracedeckB)
print("Deck C trace", tracedeckC) 
print("Deck D trace", tracedeckD)

tracepicksA = [tracepicksA]
np.savetxt("/Users/jimtr/Documents/PTSD_Python/win-standalone/ACT-R/IGT/picksA.txt", tracepicksA, fmt='%u', delimiter=",")
tracepicksB = [tracepicksB]
np.savetxt("/Users/jimtr/Documents/PTSD_Python/win-standalone/ACT-R/IGT/picksB.txt", tracepicksB, fmt='%u', delimiter=",")
tracepicksC = [tracepicksC]
np.savetxt("/Users/jimtr/Documents/PTSD_Python/win-standalone/ACT-R/IGT/picksC.txt", tracepicksC, fmt='%u', delimiter=",")
tracepicksD = [tracepicksD]
np.savetxt("/Users/jimtr/Documents/PTSD_Python/win-standalone/ACT-R/IGT/picksD.txt", tracepicksD, fmt='%u', delimiter=",")