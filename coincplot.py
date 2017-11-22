import numpy as np
import matplotlib.pyplot as plt

#datafile=raw_input('enter data file name: ') # read in data file
#coincidencewindow=float(raw_input('Enter coincidence window (ns): ')) #read coinc window

#hardcoded for testing
datafile='apd800mv300s.out'
bins=100
rangeratio=1
window=10**(-6)
delay=[]

#split data into two columns
channel, time = np.genfromtxt(datafile, unpack=True)

for i in range(1, len(channel)-1):
	#look for 0 then 1
	if (channel[i] == 0 and  channel[i+1]==1): #or (channel[i]==1 and channel[i+1]==0):
		#covert from picos to seconds
 		 delay.append((time[i+1] - time[i])/10**12)

#max range of histogram to plot
maxrange=rangeratio*max(delay)
maxrange=window

#plot
plt.hist(delay,bins=bins, range=(0,maxrange))

plt.ylabel('Counts')
plt.xlabel('Time window (s)')
plt.title('Time between counts ')

#save graph 
d_name = datafile + str(bins) +'bin'+'.png'
plt.savefig(d_name, format='png')
plt.clf()

#write out delay if order of nano seconds
for i in range(1,len(delay)):
	if delay[i] <= window:
		print i, delay[i]



