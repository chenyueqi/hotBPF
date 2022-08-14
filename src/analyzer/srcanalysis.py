import sys
import argparse
import pickle
import threading
import signal
from threading import Thread, Lock
from utility import runCommand
from tqdm import tqdm

from sklearn.cluster import DBSCAN
import numpy as np

exit_event = threading.Event()

line2bin = {}
hash2srcline = {}
vmlinuxaddr = []

def update_hash2srcline(srcline, h, lock):
  global hash2srcline

  lock.acquire()

  if h not in hash2srcline:
    hash2srcline[h] = srcline

  lock.release()

def update_line2bin(h, addr, lock):
  global line2bin

  lock.acquire()

  if h not in line2bin:
    line2bin[h] = []
  line2bin[h].append(addr)

  lock.release()

def addr2line(start, end, vmlinux, lock):
  for s in tqdm(range(start, end)):
    ret, out, err = runCommand("llvm-symbolizer-10 --obj=" + vmlinux + " " + vmlinuxaddr[s])
  
    srcline = ''
    lines = out.split("\n")[:-2]
    for i in range(0, len(lines), 2):
      srcline += lines[i+1]+","
  
    #h = hash(srcline)
    #update_line2bin(h, vmlinuxaddr[s], lock)
    update_line2bin(srcline, vmlinuxaddr[s], lock)
    #update_hash2srcline(srcline, h, lock)

    if exit_event.is_set():
      break

def action_gen(vmlinux_addr, linuxpath, numW):
  global vmlinuxaddr

  with open(vmlinux_addr, "r") as f:
    vmlinuxaddr = f.readlines()
  for i in range(len(vmlinuxaddr)):
    vmlinuxaddr[i] = vmlinuxaddr[i].strip()

  perW = len(vmlinuxaddr) / numW

  lock = Lock()
  threads = []
  for i in range(numW):
    start = i*perW
    if i == numW-1:
      end = start + perW + (len(vmlinuxaddr) % numW)
    else:
      end = start + perW
    print(start,end)

    threads.append(Thread(target=addr2line, args=(start, end, linuxpath, lock)))

  def signal_handler(signum, frame):
    exit_event.set()

  signal.signal(signal.SIGINT, signal_handler)

  for t in threads:
    t.start()

  for t in threads:
    t.join()

  with open("line2bin.pickle", "wb") as p:
    pickle.dump(line2bin, p)
  #with open("hash2srcline.pickle", "wb") as p:
  #  pickle.dump(hash2srcline, p)

def action_gen_dist(vmlinux_addr, linuxpath, numW):
  from srcanalysis_tasks import addr2line_dist

  vmlinuxaddr = []
  with open(vmlinux_addr, "r") as f:
    vmlinuxaddr = f.readlines()
  perW = len(vmlinuxaddr) / numW

  results = []
  for i in range(numW):
    start = i*perW
    if i == numW-1:
      end = start + perW + (len(vmlinuxaddr) % numW)
    else:
      end = start + perW
    print(start,end)

    results.append(addr2line_dist.delay(start, end, vmlinux_addr, linuxpath))

  line2bin = {}
  for r in results:
    l2b = r.get()
    for l,b in l2b.items():
      if l not in line2bin:
        line2bin[l] = []
      for x in b:
        line2bin[l].append(x)

  print(line2bin)
  with open("line2bin.pickle", "wb") as p:
    pickle.dump(line2bin, p)

def action_stats():
  with open("line2bin.pickle", "rb") as p:
    line2bin = pickle.load(p)

  #buck = {'5':[], '20':[], '40':[], '>40':[]}
  stats = {}
  print(len(line2bin))
  for l,b in tqdm(line2bin.items()):
    #print(l,b)
    #if "rcupdate.h:60" in l:
    #  print(l + " " + str(len(b)))
    #n = len(b)
    #if n < 5:
    #  buck['5'].append((l,b))
    #elif n < 20:
    #  buck['20'].append((l,b))
    #elif n < 40:
    #  buck['40'].append((l,b))
    #else:
    #  buck['>40'].append((l,b))

  #for k,v in buck.items():
    #print(k, len(v))
    #print(k, v)
    #if k == '>40':
    #for v1 in v:
    X = np.array([[int(addr, base=16)] for addr in b])
    clustering = DBSCAN(eps=15, min_samples=2).fit(X)
    #print(clustering.labels_)
    #print(len(np.unique(clustering.labels_)))
    clusters = len(np.unique(clustering.labels_))
    if clusters > 4:
      print(str(clusters) + " " + l + str(b))
    if clusters not in stats:
      stats[clusters] = 0
    stats[clusters] += 1

  print(stats)
    
def action_sim():
  with open("line2bin.pickle", "rb") as p:
    line2bin = pickle.load(p)
  
  count = 0
  for l,b in tqdm(line2bin.items()):
    if (len(l.split(":0")) > 2):
      #print(l, b)
      count += 1
  print(count)


if __name__ == '__main__':
  parser = argparse.ArgumentParser(prog=sys.argv[0], description='Analyze kernel binary')
  parser.add_argument('action', action='store', type=str, choices=["gen", "stats"], help="generate src line mapping, output statistics of mapping")
  parser.add_argument('-a', dest='vmlinux_addr', action='store', type=str, help="path to kernel addresses")
  parser.add_argument('-k', dest='linuxpath', action='store', type=str, help="path to vmlinux")
  parser.add_argument('-n', dest='numW', action='store', type=int, default=1, help="number of threads")
  parser.add_argument('-d', dest='distribute', action='store_true', default=False, help="Use Celery to distribute tasks")
  args = parser.parse_args()

  if args.action == "gen":
    if not args.distribute:
      action_gen(args.vmlinux_addr, args.linuxpath, args.numW)
    else:
      action_gen_dist(args.vmlinux_addr, args.linuxpath, args.numW)
  elif args.action == "stats":
    action_stats()
    #action_sim()
