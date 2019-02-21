## ================================================================ ##
## STROOP.PY                                                        ##
## ================================================================ ##
## A simple ACT-R device for the Stroop task                        ##
## -----------------------------------------                        ##
## This is a device that showcases the unique capacities of the new ##
## JSON-RPC-based ACT-R interface. The device is written in Python, ##
## and interacts with ACT-R entirely through Python code.           ##
## The Stroop task is modeled after Tim Verstynen's (2014)          ##
## neuroimaging paper on the Stroop task.                           ##
## ================================================================ ##

import os
import actr
import random

COLORS = ("red", "blue", "green")

NAMES = ("chair", "table")

COLOR_MAPPINGS = {"red" : "j",
                  "blue" : "k",
                  "green" : "l"}


class StroopStimulus:
    """An abstract Stroop task stimulus"""
    def __init__(self, word, color):
        if color in COLORS:
            self.word = word
            self.color = color

    @property
    def word(self):
        return self._word

    @word.setter
    def word(self, val):
        self._word = val

    @property
    def color(self):
        return self._color

    @color.setter
    def color(self, val):
        self._color = val

    @property
    def congruent(self):
        if self.color in COLORS and self.word == self.color:
            return True
        else:
            return False

    @property
    def incongruent(self):
        if self.color in COLORS and self.word in COLORS and \
           self.color is not self.word:
            return True
        else:
            return False

    @property
    def neutral(self):
        if self.color in COLORS and self.word not in COLORS:
            return True
        else:
            return False

    def __str__(self):
        return "<'%s' in %s>" % (self.word, self.color)

    def __repr__(self):
        return self.__str__()


class StroopTrial:
    """A class for recording a Stroop trial"""
    def __init__(self, stimulus):
        """Inits a stroop trial"""
        self.stimulus = stimulus
        self.setup()

    def setup(self):
        "Sets up properly"
        self.color = self.stimulus.color
        self.word = self.stimulus.word
        self.onset = 0.0
        self.offset = 0.0
        self.response = None

    @property
    def correct_response(self):
        return COLOR_MAPPINGS[self.color]
        
    @property
    def accuracy(self):
        if self.response is not None and \
           self.response == self.correct_response:
            return 1.0
        else:
            return 0.0

    @property
    def response_time(self):
        return self.offset - self.onset


def generate_stimuli(shuffle = True):
    "Generates stimuli according to the Verstynen (2014) paradigm" 
    congr = [(x, x) for x in COLORS]
    incongr = [(x, y) for x in COLORS for y in COLORS if x is not y]
    neutr = [(x, y) for x in NAMES for y in COLORS]

    lst = congr * 14 + neutr * 7 + incongr * 6

    if shuffle:  # Randomized if needed
        random.shuffle(lst)
    
    return [StroopStimulus(word = x[0], color = x[1]) for x in lst]


class StroopTask:
    """A simple version of the Stroop task"""
    def __init__(self, stimuli=generate_stimuli()):
        """Initializes a Stroop task (if there are stimuli)""" 
        if len(stimuli) > 0:
            self.stimuli = stimuli
            self.setup()

        
    def setup(self, win=None):
        """Sets up and prepares for first trial"""
        self.window = win
        self.index = 0
        self.log = []
        self.phase = "fixation"
        self.current_trial = StroopTrial(self.stimuli[self.index])
        self.update_window()
        actr.schedule_event_relative(1, "stroop-next")

        
    def run_stats(self):
        """Runs some basic analysis"""
        if len(self.log) > 0:
            cong = [x for x in self.log if x.stimulus.congruent]
            incn = [x for x in self.log if x.stimulus.incongruent]
            neut = [x for x in self.log if x.stimulus.neutral]

            R = {}
            for cond, data in zip(["congruent", "neutral", "incongruent"],
                                  [cong, neut, incn]):
                if len(data) > 0:
                    acc = sum([x.accuracy for x in data]) / len(data)
                    rt = sum([x.response_time for x in data]) / len(data)
                    
                    R[cond] = (len(data), acc, rt)
            
            return R


    def print_stats(self, stats={}):
        """Pretty prints stats about the experiment"""
        for cond in stats.keys():
            n, acc, rt = stats[cond]
            print("%s (N=%d): Accuracy = %.2f, Response Times = %.2f ms" % \
                  (cond, n, acc, rt * 1000))

            
    def update_window(self):
        """Updates the experiment window"""
        if self.window is not None:
            # First, clean-up
            actr.clear_exp_window()

            # Then, add new elements
            if self.phase == "fixation":
                item = actr.add_text_to_exp_window(self.window, "+",
                                                   x = 400, y = 300,
                                                   color = "black")
            
            elif self.phase == "stimulus":
                color = self.current_trial.color
                word = self.current_trial.word
                item = actr.add_text_to_exp_window(self.window, word,
                                                   x=400, y= 300,
                                                   color = color)

                for i, col in enumerate(COLOR_MAPPINGS):
                    item = actr.add_text_to_exp_window(self.window,
                                                       COLOR_MAPPINGS[col],
                                                       x = 600 + i * 50,
                                                       y = 500,
                                                       color = col)

            elif self.phase == "done":
                color = self.current_trial.color
                word = self.current_trial.word
                item = actr.add_text_to_exp_window(self.window, "done",
                                                   x=400, y= 300,
                                                   color = "black")

                
    def accept_response(self, model, response):
        """A valid response is a key pressed during the 'stimulus' phase"""
        if self.phase == "stimulus":
            self.current_trial.response = response
            actr.schedule_event_now("stroop-next")

            
    def next(self):
        """Moves on in th task progression"""
        if self.phase == "fixation":
            self.phase = "stimulus"
            self.current_trial.onset = actr.mp_time()

        elif self.phase == "stimulus":
            self.current_trial.offset = actr.mp_time()
            self.index += 1
            self.log.append(self.current_trial)
            if self.index >= len(self.stimuli):
                self.phase = "done"

            else:
                self.current_trial = StroopTrial(self.stimuli[self.index])
                self.phase = "fixation"
                actr.schedule_event_relative(1, "stroop-next")

        actr.schedule_event_now("stroop-update-window")


def run_experiment(model_name="response-monkey.lisp", time=200):
    """Runs an experiment"""
    actr.reset()
    # current directory
    curr_dir = os.path.dirname(os.path.realpath(__file__))
    actr.load_act_r_model(os.path.join(curr_dir, model_name))

    win = actr.open_exp_window("* STROOP TASK *", width = 800,
                               height = 600)

    actr.install_device(win)

    task = StroopTask()
    #task.window = win

    actr.add_command("stroop-next", task.next,
                     "Updates the internal task")
    actr.add_command("stroop-update-window", task.update_window,
                     "Updates the window")
    actr.add_command("stroop-accept-response", task.accept_response,
                     "Accepts a response for the Stroop task")

    actr.monitor_command("output-key",
                         "stroop-accept-response")

    task.setup(win)
    actr.run(time)
    print("-" * 80)
    task.print_stats(task.run_stats())

    # Clean-up the interface
    # (Removes all the links between ACT-R and this object).

    actr.remove_command_monitor("output-key",
                                "stroop-accept-response")
    actr.remove_command("stroop-next")
    actr.remove_command("stroop-update-window")
    
    # Returns the task as a Python object for further analysis of data
    return task
     
