import numpy as np
import matplotlib.pyplot as plt

#datafile=raw_input('enter data file name: ') # read in data file
#coincidencewindow=float(raw_input('Enter coincidence window (ns): ')) #read coinc window

#hardcoded for testing
datafile='inverter60s_000.out'
coincidencewindow=10000000
bins=25
count=0
delay=[]

#converts nanoseconds to picoseconds
coincidencewindow=coincidencewindow*1000

channel, time = np.genfromtxt(datafile, unpack=True) #split data into two columns

numphotons= len(channel)

for i in range(1, numphotons-1):
	if channel[i] == 0 and  channel[i+1]==1:
 		 delay.append(time[i+1] - time[i])


#print delay
#y=ch

#xp=np.linspace(min(x),max(x), 100)

plt.hist(delay,bins=bins, range=(0,10000000))

plt.ylabel('Counts')
plt.xlabel('Time window')
plt.title('Time between counts ')

#save graph 
d_name = datafile + '.png'
plt.savefig(d_name, format='png')
plt.clf()

#save graph
#plt.savefig('eform.png',format='png')

