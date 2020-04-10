import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
import xlrd
import pandas as pd
import math
import algorithms

# Loading data from excel using pandas
# r - to produce raw string otherwise problems with "\"
#loc = (r"C:\Users\Rafal\Documents\PW\6 semestr\PSZT\Projekt-1\NetworkX\DaneMiastaXY.xlsx")
loc = (r"C:\Users\Nitrox\Google Drive\studia\semestr_6\pszt\projekt\przeszukiwanie\DaneMiastaXY.xlsx")

dataMiasta = pd.read_excel(loc)
#loc_1 = (r"C:\Users\Rafal\Documents\PW\6 semestr\PSZT\Projekt-1\NetworkX\DaneMiastaDrogi.xlsx")
loc_1 = (r"C:\Users\Nitrox\Google Drive\studia\semestr_6\pszt\projekt\przeszukiwanie\DaneMiastaDrogi.xlsx")

dataDrogi = pd.read_excel(loc_1)
#print(dataDrogi.head())
#print(dataMiasta.head())

# Data to numpy array
M = dataMiasta.to_numpy()
D = dataDrogi.to_numpy()

# Creating graph
G=nx.Graph()
G.add_nodes_from(M[:,0])
nx.set_node_attributes(G,dict(zip(M[:,0],M[:,1])),'X')
nx.set_node_attributes(G,dict(zip(M[:,0],M[:,2])),'Y')
G.add_edges_from(D)

print("Podaj miasto startowe: ")
start = input()
print("Podaj miasto końcowe: ")
end = input()

algorithms.astar(G, start, end)