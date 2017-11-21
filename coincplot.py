import numpy as np
import matplotlib.pyplot as plt

#datafile=raw_input('enter data file name: ') # read in data file
#coincidencewindow=float(raw_input('Enter coincidence window (ns): ')) #read coinc window

#hardcoded for testing
datafile='inverter60s_000.out'
bins=50
delay=[]

#split data into two columns
channel, time = np.genfromtxt(datafile, unpack=True)

for i in range(1, len(channel)-1):
	if channel[i] == 0 and  channel[i+1]==1:
 		 delay.append((time[i+1] - time[i])/10**12)

maxrange=0.01*max(delay)

plt.hist(delay,bins=bins, range=(0,maxrange))

plt.ylabel('Counts')
plt.xlabel('Time window (s)')
plt.title('Time between counts ')

#save graph 
d_name = datafile + '.png'
plt.savefig(d_name, format='png')
plt.clf()


