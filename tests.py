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

# main loop in which tests are performed
user_input = ' '
while user_input != 'e':
    print('Start city:')
    start = input()
    print('End city:')
    end = input()

    time_astar = 0
    time_firstbest = 0
    time_breadth = 0

# time measurement reapeted 10 times
    for i in range(10):
        time_astar += algorithms.astar_search(start, end, G, True).get('time')
        time_firstbest += algorithms.astar_search(start, end, G, False).get('time')
        time_breadth += algorithms.breadth_search(start, end, G).get('time')
        print(time_astar)

    print("\nCustom A* algorithm output: ")
    result_astar = algorithms.astar_search(start, end, G, True)
    my_path_astar = result_astar.get('path')
    print(result_astar.get('info'))
    print("Number of iterations: ", result_astar.get('iterations'))
    print("Mean time elapsed {:03.4f}ms".format(time_astar/10))


    print("\nCustom First Best algorithm output: ")
    result_firstbest = algorithms.astar_search(start, end, G, False)
    my_path_firstbest = result_firstbest.get('path')
    print(result_firstbest.get('info'))
    print("Number of iterations: ", result_firstbest.get('iterations'))
    print("Mean time elapsed {:03.4f}ms".format(time_firstbest/10))

    # calculating breadth search custom alg.
    print("\nCustom Breadth algorithm output: ")
    result_breadth = algorithms.breadth_search(start, end, G)
    my_path_breadth = result_breadth.get('path')
    print(result_breadth.get('info'))
    print("Number of iterations: ", result_breadth.get('iterations'))
    print("Mean time elapsed {:03.4f}ms".format(time_breadth/10))

# formatted into latex table
    print(start +' - '+ end   +'&'+str(result_astar.get('cost'))    +'&' +str(result_astar.get('iterations'))+'&' + "{:03.3f}".format(time_astar/10)  + '&'+str(result_firstbest.get('cost'))    +'&' +str(result_firstbest.get('iterations'))+'&' +"{:03.3f}".format(time_firstbest/10) + '&'+str(result_breadth.get('cost'))    +'&' +str(result_breadth.get('iterations'))+'&' +"{:03.3f}".format(time_breadth/10)+'\\\\')

    print('Type \"e\" to finish tests.')
    user_input = input()
