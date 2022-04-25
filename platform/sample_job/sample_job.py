import os
import time

def main():
    nap_time_in_seconds = 60
    start_time = time.time()
    end_time = start_time + nap_time_in_seconds
    current_time = start_time
    while current_time < end_time:
        current_time = time.time()
        print("Time to zzzz for {} more seconds".format(end_time - current_time))
        time.sleep(1)

if '__main__' == __name__:
    main()