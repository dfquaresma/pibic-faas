import time
import gc

def handle(req):
    gc.disable()

    msg_size = 2 ** 21 # it makes the resulting list size near 16MB

    before = time.time()
    byte_array = list()
    for i in range(msg_size):
      byte_array.append(i)
    after = time.time()

    gc.enable()
    return after - before
