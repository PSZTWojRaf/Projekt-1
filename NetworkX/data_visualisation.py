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
G.add_edges_from(D)

# creating specific dictionary for visualisation
pos = {}
name = list(G.nodes)
X = list(G.nodes('X'))
Y = list(G.nodes('Y'))
for i in range(len(G.nodes)):
    pos[name[i]]=[X[i][1], Y[i][1]]
nx.draw_networkx(G,pos=pos,node_size=100)
plt.show()
