import multiprocessing as mp
import random
import time

def F(i):
  # if random.random() > 0.9:
  #   print '    proxy waiting...............'
  #   time.sleep(5)
  # else:
  #time.sleep(random.random())
  #print '  Function, i:', i
  
  k = 1.22222
  for i in range(1000):
     for j in range(5000):
       k /= 1.1111
  return i

def back(i):
  print 'back, i:', i

def main():
  
  print 'round:',
  n = input()
  for i in range(n):
    t1 = time.time()

    print 'round', i, 
    pool = mp.Pool(8)
    for j in range(50):
      # print 'for, i:', i
      pool.apply_async(func=F, args=(i, ), callback=None)
    pool.close()
    pool.join()
    
    t2 = time.time()
    print 'time', t2 - t1

  print 'join done'
  


if __name__ == '__main__':
  main()
