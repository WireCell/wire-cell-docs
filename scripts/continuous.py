#!/usr/bin/env python3
'''
Generate a drawing describing continuous vs discontinous mode of the
(Mulit)Ductor.
'''
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from matplotlib.collections import PatchCollection
import numpy
import random
random.seed(42)

def make_times(t0, dt, mean):
    '''Return random stream of times between t0 and t0+dt with given mean'''
    ret = list()
    t = 0
    while True:
        t += random.expovariate(1.0/mean)
        if t >= dt:
            return numpy.asarray(ret);
        ret.append(t0 + t)

    return                      # not reached

class Continuous(object):

    bkglambda = 5.0                 # mean time between "background" depos
    siglambda = 0.1                 # mean time between "signal" depos
    intlambda = 10                  # mean time between "interactions"
    maxtime = 25                    # total extent in time we consider

    extent = 1                      # physical extent in time
    readout = 2*extent              # readout extent in time
    boxheight=0.2

    def __init__(self, **params):
        self.fig = plt.figure()
        self.update(**params)

    def update(self, **params):
        self.__dict__.update(**params)
        self.bkgt = make_times(0, self.maxtime, self.bkglambda)
        self.intt = make_times(0, self.maxtime, self.intlambda)
        self.events = list()
        for t in self.intt:
            dt = random.uniform(0, self.extent)
            times = make_times(t, dt, self.siglambda)
            if not len(times):
                continue
            self.events.append(times)
        self.ecolors = ["red","blue"]*(len(self.events)//2+1)
        #print (self.ecolors)

    def plot(self):
        self.fig.clf()
        ax = self.fig.add_subplot(111)
        ax.set_ylim([-0.5,0.5])
        plt.axis('off')

        # continuous readouts
        cros = list()
        for iro in range(self.maxtime // self.readout):
            left = iro*self.readout
            top = 0.0
            bottom = -self.boxheight
            r = Rectangle((left, bottom), self.readout, self.boxheight)
            cros.append(r)

        # discontinous readouts
        dros = list()
        for ievt, evt in enumerate(self.events):
            ax.plot(evt, [0]*len(evt),
                    linestyle='None',
                    alpha = 0.5,
                    markersize=10, c=self.ecolors[ievt], marker='o')
            dttot = evt[-1] - evt[0]
            nro = 1 + int(dttot/self.readout)
            for iro in range(nro):
                left = evt[0] + iro*self.readout
                bottom = 0
                #print (iro, left, bottom, self.readout, self.boxheight)
                r = Rectangle((left, bottom), self.readout, self.boxheight)
                dros.append(r)

        dpc = PatchCollection(dros, alpha=0.1,
                              edgecolors=('black',), facecolors=('yellow',))
        ax.add_collection(dpc)

        cpc = PatchCollection(cros, alpha=0.1,
                              edgecolors=('black',), facecolors=('green',))
        ax.add_collection(cpc)

        ax.plot(self.bkgt, [0]*len(self.bkgt),
                linestyle='None', alpha=0.5,
                markersize=5, c="black", marker='o')


if '__main__' == __name__:
    c = Continuous()
    c.plot()
    c.fig.savefig("continuous.pdf")

        
    
