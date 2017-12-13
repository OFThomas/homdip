import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

#datafile=raw_input('file name:') # read in data file
#coincidencewindow=float(raw_input('Enter coincidence window (ns): ')) #read coinc window

#hardcoded for testing
datafile='tT1L2_1s.out'
#time window
nstime=10
#no. of bins
bins=500

#max range of histogram to plot
window=nstime*10**(-9)
delay=[]
count=0
countchnl0=0
countchnl1=0
#split data into two columns
channel, time = np.genfromtxt(datafile, unpack=True)

for i in range(1, len(channel)-1):
	if channel[i] == 0:
		countchnl0 += 1
	elif channel[i] == 1:
		countchnl1 += 1

	#look for 0 then 1
	if (channel[i] == 0 and  channel[i+1]==1) or (channel[i]==1 and channel[i+1]==0):
		#covert from picos to seconds
 		 delay.append((time[i+1] - time[i])/10**12)

chnlratio=float(countchnl0)/float(countchnl1)
#if chnlratio < 1.0:
#	chnlratio = 1/float(chnlratio)

#if (chnlratio >= 1):
print 'ERROR: Ratio of channels =', chnlratio
print 'Channel 0:', countchnl0, 'Channel 1:', countchnl1, 'Tot counts:', len(channel)

#write out delay if order of nano seconds
for i in range(1,len(delay)):
	if delay[i] <= window:
#		print delay[i]
		count+=1

print 'time window', nstime,'ns', 'Coincidences',count

# Test for normality
delay = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] 
print('normaltest teststat = %6.3f pvalue = %6.4f' % stats.normaltest(delay))

#plot
plt.hist(delay,bins=bins, range=(0,window))
plt.ylabel('Counts')
plt.xlabel('Time window (s)')
plt.title('Time between counts ')

#save graph 
d_name = datafile +'.png'
plt.savefig(d_name, format='png')
plt.clf()
