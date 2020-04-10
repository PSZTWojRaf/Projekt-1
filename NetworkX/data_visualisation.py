import math
import copy
import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
import xlrd
import pandas as pd

# heuristics computation
def h(start, end):
    start_idx = name.index(start)
    end_idx = name.index(end)
    return math.sqrt((X[start_idx][1]-X[end_idx][1])**2+(Y[start_idx][1]-Y[end_idx][1])**2)

# A* algorithm
def Astar(start, end):

    class State:
        def __init__(self, name, path, cost):
            # city name
            self.name = name
            # case for init node
            if(len(path))==0:
                self.predecessor = name
            else:
                self.predecessor = path[-1]
            # heuristic function
            self.h = h(self.name, end)
            # cost of path until this city
            self.cost = cost+h(self.name, self.predecessor)
            # cost + h - used to sort
            self.h_and_cost = self.h + self.cost
            # it needs to be copied
            self.path = copy.copy(path)
            self.path.append(name)

        # all below needed to make comparisions between objects
        def __lt__(self, other):
            return  self.h_and_cost < other.h_and_cost

        def __le__(self, other):
            return  self.h_and_cost <= other.h_and_cost

        def __eq__(self, other):
            return  self.h_and_cost == other.h_and_cost

        def __ge__(self, other):
            return  self.h_and_cost >= other.h_and_cost

        def __gt__(self, other):
            return  self.h_and_cost > other.h_and_cost

        def __ne__(self, other):
            return  self.h_and_cost != other.h_and_cost

        def __str__(self):
            return "name: " +self.name + ", path: " + str(self.path)+", cost: "+str(self.cost)+", h(s):"+str(self.h)

    # initial state
    S1 = [State(start, [], 0)]
    #print(str(current))
    current = S1[0]
    while current.name != end:
        # searching for the best next-state
        current = min(S1)
        # adding new states
        for s in list(G.neighbors(current.name)):
            # checking if not going back
            if current.predecessor != s:
                new = State(s, current.path, current.cost)
                S1.append(new)
        # removing the old state
        S1.remove(current)
    # debug
    print(str(current))
    return current.path

# loading data from excel using pandas
# r - to produce raw string otherwise problems with "\"
loc = (r"C:\Users\Rafal\Documents\PW\6 semestr\PSZT\Projekt-1\NetworkX\DaneMiastaXY.xlsx")
dataMiasta = pd.read_excel(loc)
loc_1 = (r"C:\Users\Rafal\Documents\PW\6 semestr\PSZT\Projekt-1\NetworkX\DaneMiastaDrogi.xlsx")
dataDrogi = pd.read_excel(loc_1)
print(dataDrogi.head())
print(dataMiasta.head())

# data to numpy array
M = dataMiasta.values
D = dataDrogi.values

# creating graph
G=nx.Graph()
G.add_nodes_from(M[:,0])
nx.set_node_attributes(G,dict(zip(M[:,0],M[:,1])),'X')
nx.set_node_attributes(G,dict(zip(M[:,0],M[:,2])),'Y')

# preparing graph edges weights
Z = np.zeros((len(D[:,1]),1))
D = np.append(D,Z,axis=1)
name = list(G.nodes)
X = list(G.nodes('X'))
Y = list(G.nodes('Y'))
for data in D:
    start_idx = name.index(data[0])
    end_idx = name.index(data[1])
    data[2] = math.sqrt((X[start_idx][1]-X[end_idx][1])**2+(Y[start_idx][1]-Y[end_idx][1])**2)

# adding edges to graph
G.add_weighted_edges_from(D)

# creating specific dictionary for visualisation
pos = {}
for i in range(len(G.nodes)):
    pos[name[i]]=[X[i][1], Y[i][1]]
nx.draw_networkx(G,pos=pos,node_size=100)

# calculating shortest path built-in alg.
path = nx.shortest_path(G,source='Gdansk',target='Warszawa')
path_edges = set(zip(path,path[1:]))

# highlighting shortest path on graph
nx.draw_networkx_nodes(G,pos=pos,nodelist=path,node_color='r',node_size=100)
nx.draw_networkx_edges(G,pos,edgelist=path_edges,edge_color='r',width=2)

# calculating shortest path custom alg.
my_path = Astar('Szczecin','Wroclaw')
my_path_edges = set(zip(my_path,my_path[1:]))

# highlighting shortest path on graph
nx.draw_networkx_nodes(G,pos=pos,nodelist=my_path,node_color='g',node_size=100)
nx.draw_networkx_edges(G,pos,edgelist=my_path_edges,edge_color='g',width=2)


plt.show()
