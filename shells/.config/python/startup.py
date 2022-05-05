import atexit
import os
import readline

history = os.path.join(os.path.expanduser('~'), '.cache/python_history')
try:
    readline.read_history_file(history)
except OSError:
    pass

def write_history():
    try:
        readline.write_history_file(history)
    except OSError:
        pass

atexit.register(write_history)
