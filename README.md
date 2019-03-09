# Demo ACT-R: Building a device and a model for the Stroop task

This is some demo code for the ACT-R class; it shows how to build a
simple, interactive device for an ACT-R model, how to implement a
simple model of a cognitively relevant paradigm (the Stroop task), and
how to conduct simulations and model fitting through standard
optimization algorithms.

## Requirements

To run this code, it is essential to have the following software
installed:

1. ACT-R, version 7.6 or higher. This is the new version of the
architectures that neatly separates the model from the code that
manages the experiment and collects the data.

2. Python, preferably in version 3.x, although this code seems to work
with Python 2.7.x as well. In addition to the main code, you need to
have the following packages installed:

3. Python's `numpy` and `scipy` packages, which are used for
simulation and optimization of the model code, respectively.


## Device

The device is written in Python using the new, JSON-RPC based
on the new interface for ACT-R (currently in beta, coded as 7.6 or
7.x).

The device implements the version of the Stroop task used by Tim
Verstynen in his 2014 paper. In this version of the Stroop, words
appear in one of three colors (red, blue, and green), and the
responses are given by pressing one of three corresponding keys with
the right hand (index = red, middle = blue, ring = green). The task is
made of 120 trials: 42 congruent, 42 neutral, and 36 incongruent.

### Device implementation

The device is implemented as a Python object (`StroopTask`) that
controls an ACT-R experimental window. The experimental window is
ACT-R's predefined proxy for a screen, and comes with native support
to translate GUI elements (text, images, buttons, and lines) into a
predefined set of ACT-R chunks.

If ACT-R's Environment has been started, the window can be set to
"visible", with the stimuli appearing in order. If ACT-R is running
without the Environment, the window will be hidden from the user (but
still visible for the model).

## Models

This repository contains four different models. The first model is a
simple test model designed to test and debug the interaction with the
experimenta window. The model is called `response-monkey.lisp`, and it
simply clicks at random when it sees a stimulus. The model
continuously performs the following actions:

1. If the model is not looking at anything, it looks for a object 
   on the screen.
   
2. If the model is looking at a fixation cross, it does nothing and
   keeps looking.
   
3. If the model is looking at a stimulus (a word in red, green, or
   blue color), then it randomly responds with the index ("j"), the
   middle ("k") or the ring finger ("l").
   
4. If the model is looking at a black word that reads "done", it 
   stops ACT-R using the `!stop!` command.

The second model, `stroop-well.lisp`, actually performs the task
correctly, albeit unnaturally. It possesses knowledge of the color names, 
correctly retrievs the color name associated with each word on the
screen, and presses the approprieta response button.

The third model, 'stroop-jim.lisp', also incorporates a simple form of
Stroop interference.

The fourth model, 'stroop-better.lisp', incorporates a more
sophisticated form of interference in the form of alternative color
names competing for retrieval.

## Running the code

All the code to run and optimize the models can be found in the
`stroop.py` task. Simply type the following:

```
> import stroop
ACT-R connection has been started.
> stroop.run_experiment(model = "stroop.lisp", time = 200)
     0.000   PROCEDURAL             CONFLICT-RESOLUTION
     0.050   PROCEDURAL             PRODUCTION-FIRED CHECK-THE-SCREEN
     0.050   PROCEDURAL             CLEAR-BUFFER VISUAL-LOCATION
     0.050   VISION                 Find-location
     0.050   VISION                 FIND-LOC-FAILURE
   ...	 
   163.905   VISION                 Encoding-complete VISUAL-LOCATION599-1 NIL
   163.905   VISION                 SET-BUFFER-CHUNK VISUAL TEXT784
   163.905   PROCEDURAL             PRODUCTION-FIRED DONE
   163.905   PROCEDURAL             CLEAR-BUFFER VISUAL
   163.905   ------                 BREAK-EVENT Stopped by !stop!
--------------------------------------------------------------------------------
congruent (N=42): Accuracy = 0.33, Response Times = 329.88 ms
neutral (N=42): Accuracy = 0.34, Response Times = 417.32 ms
incongruent (N=36): Accuracy = 0.31, Response Times = 329.31 ms
```
