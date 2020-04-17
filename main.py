import networkx as nx
import matplotlib.pyplot as plt

import pandas as pd
import xlrd

import numpy as np
import math

import os

import algorithms
import data_visualisation

# loading data from excel using pandas
# r - to produce raw string otherwise problems with "\"
workspace_path = os.getcwd()
cities_data = pd.read_excel(workspace_path + r"\cities_data.xlsx")
connections_data = pd.read_excel(workspace_path + r"\connections_data.xlsx")
print("Cities data: ")
print(cities_data.head())
print("Connections data: ")
print(connections_data.head())


# data to numpy array
M = cities_data.values # deprecated, use instead to_numpy()
D = connections_data.values

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

# visualising graph
data_visualisation.visualise('Graph visualisation', G)

# asking for A and B city
print('Enter starting city: ')
start = input()

print('Endter final city: ')
end = input()

# checking if inputs are correct
if start == end:
    print("Starting city has to differ from final city.")
    exit()

if not(G.__contains__(start)):
    print("Starting city wasn't recognized. \
    Please look for available cities up in cities_data.xlsx file.")
    exit()

if not(G.__contains__(end)):
    print("Final city wasn't recognized. \
    Please look for available cities up in cities_data.xlsx file.")
    exit()

# calculating shortest path custom alg.
print("Custom A* algorithm output: ")
my_path = algorithms.astar_search(start, end, G)
# visualising shortest path custom alg.
data_visualisation.visualise('Custom A* algorithm', G, my_path)

# calculating breadth search custom alg.
print("Custom Breadth algorithm output: ")
my_path = algorithms.breadth_search(start, end, G)
# visualising shortest path custom alg.
data_visualisation.visualise('Custom Breadth algorithm', G, my_path)