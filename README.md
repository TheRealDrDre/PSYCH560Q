# Demo ACT-R: Building a Stroop Device and a Stroop model

This is some demo code for the ACT-R class; it shows how to build a
simple, interactive device for an ACT-R model, and it provides
a skeleton for a model.

## Device

The device is written in Python using the new, JSON-RPC based
interface for ACT-R 9 (currently in beta, coded as 7.6 or 7.x).

The device implements the version of the Stroop task used by
Tim Verstynen in his 2014 paper.

## Model

The model is a "response monkey", a basic model that simply clicks
at random when it sees a stimulus.

## How to run the code

Simply type the following:

```python
> import stroop
> stroop.run_experiment(time = 200)
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
congruent : Accuracy = 0.27, Response Times = 353.41
neutral : Accuracy = 0.26, Response Times = 403.10
incongruent : Accuracy = 0.33, Response Times = 330.97
```