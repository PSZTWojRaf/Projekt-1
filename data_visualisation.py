import networkx as nx
import matplotlib.pyplot as plt

def visualise(figure_name, graph, path = 'no_path'):

    nodes = list(graph.nodes)
    nodes_x = list(graph.nodes('X'))
    nodes_y = list(graph.nodes('Y'))

    # adding figure title
    plt.figure(figure_name)
    
    # creating specific dictionary for visualisation
    pos = {}
    for i in range(len(graph.nodes)):
        pos[nodes[i]]=[nodes_x[i][1], nodes_y[i][1]]
    nx.draw_networkx(graph,pos=pos,node_size=100)

    # highlighting shortest path on graph
    if path != 'no_path':
        path_edges = set(zip(path,path[1:]))
        nx.draw_networkx_nodes(graph, pos=pos, nodelist=path, node_color='r', node_size=100)
        nx.draw_networkx_edges(graph, pos, edgelist=path_edges, edge_color='r', width=2)

    # show ploted graph
    plt.show()