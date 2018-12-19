import time

def handle(req):
    msg_size = 2 ** 21 # it makes the resulting list size near 16MB

    before = time.time()
    byte_array = list()
    for i in range(msg_size):
      byte_array.append(i)
    after = time.time()

    return after - before
