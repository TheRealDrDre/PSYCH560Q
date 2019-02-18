## A simple ACT-R Device

import actr
import random

COLORS = ("red", "blue", "green")

NAMES = ("chair", "table")

COLOR_MAPPINGS = {"red" : "j",
                  "blue" : "k",
                  "green" : "l"}


class StroopStimulus:
    """An astract Stroop task stimulus"""
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
        if self.color in COLORS and self.word in COLORS and self.color is not self.word:
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
        self.stimulus = stimulus
        self.setup()

    def setup(self):
        "Sets up properly"
        self.color = self.stimulus.color
        self.word = self.stimulus.word
        self.correct_response  = None
        self.onset = 0.0
        self.offset = 0.0
        self.response = None

    @property
    def accuracy(self):
        if self.response is not None and self.response == self.correct_response:
            return 0.0
        else:
            return 1.0

    @property
    def response_time(self):
        return self.offset - self.onset


def generate_stimuli(shuffle = True):
    "Generates stimuli according to the Verstynen (2014) paradigm" 
    congr = [(x, x) for x in COLORS]
    incongr = [(x, y) for x in COLORS for y in COLORS if x is not y]
    neutr = [(x, y) for x in NAMES for y in COLORS]

    lst = congr * 14 + neutr * 7 + incongr * 6

    if shuffle:
        random.shuffle(lst)
    
    return [StroopStimulus(word = x[0], color = x[1]) for x in lst]


class StroopTask:
    """An abstract Stroop task"""
    def __init__(self, stimuli=generate_stimuli()):
        self.stimuli = stimuli
        self.setup()

        
    def setup(self):
        self.index = 0
        self.log = []
        self.phase = "fixation"
        self.current_trial = StroopTrial(self.stimuli[self.index])
        self.update_window()
        actr.schedule_event_relative(1, "stroop-next")

        
    def run_stats(self):
        if len(self.log) > 0:
            print(sum([x.accuracy for x in self.log])/len(self.log))
            print(sum([x.response_time for x in self.log])/len(self.log))

            
    def update_window(self):
        """Updates the experiment window"""

        # First, clean-up
        global WINDOW
        global WINDOW_ITEMS
        
        for item in WINDOW_ITEMS:
            actr.remove_items_from_exp_window(WINDOW, item)
            WINDOW_ITEMS.remove(item)

        if self.phase == "fixation":
            item = actr.add_text_to_exp_window(WINDOW, "+", x = 400, y = 300,
                                               color = "black")
            WINDOW_ITEMS.append(item)

        elif self.phase == "stimulus":
            color = self.current_trial.color
            word = self.current_trial.word
            item = actr.add_text_to_exp_window(WINDOW, word, x=400, y= 300,
                                               color = color)
            WINDOW_ITEMS.append(item)

            for i, col in enumerate(COLOR_MAPPINGS):
                item = actr.add_text_to_exp_window(WINDOW, COLOR_MAPPINGS[col],
                                                   x = 600 + i * 50,
                                                   y = 500,
                                                   color = col)
                WINDOW_ITEMS.append(item)

        elif self.phase == "done":
            color = self.current_trial.color
            word = self.current_trial.word
            item = actr.add_text_to_exp_window(WINDOW, "done", x=400, y= 300,
                                               color = "black")
            WINDOW_ITEMS.append(item)


    def accept_response(self, response):
        """A valid response is a key pressed during the 'stimulus' phase"""
        if self.phase == "stimulus":
            self.current_trial.response = response
            actr.schedule_event_now("stroop-next")

            
    def next(self):
        if self.phase == "fixation":
            self.phase = "stimulus"
            self.current_trial.onset = actr.mp_time()
            #actr.schedule_event_relative(1, "stroop-next")

        elif self.phase == "stimulus":
            self.current_trial.offset = actr.mp_time()
            self.index += 1
            if self.index >= len(self.stimuli):
                self.phase = "done"
            else:
                self.log.append(self.current_trial)
                self.current_trial = StroopTrial(self.stimuli[self.index])
                self.phase = "fixation"
                actr.schedule_event_relative(1, "stroop-next")

        self.update_window()

        
WINDOW = None
WINDOW_ITEMS = []



def run_experiment(model_name="response-monkey.lisp"):
    global WINDOW
    actr.load_act_r_model(model_name)

    WINDOW = actr.open_exp_window("* STROOP TASK *", width = 800,
                                  height = 600)

    actr.install_device(WINDOW)

    task = StroopTask()

    actr.add_command("stroop-next", task.next,
                     "Updates the internal task")
    actr.add_command("stroop-accept-response", task.accept_response,
                     "Accepts a response for the Stroop task")

    actr.monitor_command("output-key","stroop-accept-response")
    actr.run(10)
    print("-" * 80)
    task.run_stats()
     
