import time

def handle(req):
    msg_size = 16384

    before = time.time()
    byte_array = list()
    for i in range(msg_size):
      byte_array.append(i)
    after = time.time()

    return after - before
