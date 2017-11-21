import numpy as np

datafile=raw_input('enter data file name: ') # read in data file
coincidencewindow=raw_input('Enter coincidence window: ') #read coinc window

#hardcoded for testing
#datafile='inverter60s_000.out'
#coincidencewindow=10000000

channel, time = np.genfromtxt(datafile, unpack=True) #split data into two columns

numphotons= len(channel)

count=0

for i in range(1, numphotons-1):
	if channel[i] != channel[i+1]:
 		if time[i+1] - time[i] <= coincidencewindow:
			count +=1

print count
			


