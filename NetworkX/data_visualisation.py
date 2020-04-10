import math
import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
import xlrd
import pandas as pd

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
    start = name.index(data[0])
    end = name.index(data[1])
    data[2] = math.sqrt((X[start][1]-X[end][1])**2+(Y[start][1]-Y[end][1])**2)

# adding edges to graph
G.add_weighted_edges_from(D)

# creating specific dictionary for visualisation
pos = {}
for i in range(len(G.nodes)):
    pos[name[i]]=[X[i][1], Y[i][1]]
nx.draw_networkx(G,pos=pos,node_size=100)

# calculating shortest path
path = nx.shortest_path(G,source='Gdansk',target='Warszawa')
path_edges = set(zip(path,path[1:]))

# highlighting shortest path on graph
nx.draw_networkx_nodes(G,pos=pos,nodelist=path,node_color='r',node_size=100)
nx.draw_networkx_edges(G,pos,edgelist=path_edges,edge_color='r',width=2)

plt.show()
