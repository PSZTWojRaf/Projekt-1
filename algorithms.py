import networkx as nx
import math
import time

def compute_cost(start, end, nodes, x, y):
    start_idx = nodes.index(start)
    end_idx = nodes.index(end)
    return math.sqrt((x[start_idx][1]-x[end_idx][1])**2+(y[start_idx][1]-y[end_idx][1])**2)

def astar_search(start, end, graph, heuristic):

    nodes = list(graph.nodes)
    nodes_x = list(graph.nodes('X'))
    nodes_y = list(graph.nodes('Y'))

    # parameter for efficiency check - how many times the state was 'unfold'
    it_number = 0

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
            if heuristic == True:
                self.h = compute_cost(self.name, end, nodes, nodes_x, nodes_y)
            else:
                self.h = 0
            # cost of path until this city
            self.cost = cost + compute_cost(self.name, self.predecessor, nodes, nodes_x, nodes_y)
            # cost + h - used to sort
            self.h_and_cost = self.h + self.cost
            # it needs to be copied
            self.path = path.copy()
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
            return "path: " + str(self.path) + "\ncost: " + \
                str(round(self.cost*111.19662,2))+"km." + "\nh(s):" + str(round(self.h*111.19662,2))+"km."

    # list of states with initial state
    g_states = [State(start, [], 0)]
    current_state = g_states[0]

    # begin time measurement
    time_start = time.clock()

    # main loop of the algorithm
    while current_state.name != end:
        # adding new states
        p_states = list(graph.neighbors(current_state.name))
        for s in p_states:
            # checking if not going back to previous state
            if not(s in current_state.path):
                new = State(s, current_state.path, current_state.cost)
                g_states.append(new)
        # removing the old state
        g_states.remove(current_state)
        # searching for the best next state
        current_state = min(g_states)

        it_number += 1

    time_end = time.clock()
    total = time_end - time_start
    return {'path':current_state.path, 'time': total*1000, 'iterations': it_number, 'info':str(current_state), 'cost': round(current_state.cost*111.19662,2)}


def breadth_search(start, end, graph):

    nodes = list(graph.nodes)
    nodes_x = list(graph.nodes('X'))
    nodes_y = list(graph.nodes('Y'))

    # parameter for efficiency check - how many times the state was 'unfold'
    it_number = 0

    class State:
        def __init__(self, name, path, cost):
            # city name
            self.name = name
            # case for init node
            if(len(path))==0:
                self.predecessor = name
            else:
                self.predecessor = path[-1]
            # cost of path until this city
            self.cost = cost + compute_cost(self.name, self.predecessor, nodes, nodes_x, nodes_y)
            # it needs to be copied
            self.path = path.copy()
            self.path.append(name)

        def __str__(self):
            return "path: " + str(self.path) + "\ncost: " + str(round(self.cost*111.19662,2))+"km."

    # list of states with initial state
    a_states = [State(start, [], 0)]
    # list of already searched states
    z_states = []

    # changes to True if final state is present in a_states
    fin = False

    # begin time measurement
    time_start = time.clock()

    # main loop of the algorithm
    while not fin:
        # adding new states
        current_state = a_states[0]
        p_states = list(graph.neighbors(current_state.name))
        for s in p_states:
            # checking if not going back to previous state or repeating in already searched states
            if (s != current_state.predecessor) and not (s in z_states):
                    new = State(s, current_state.path, current_state.cost)
                    a_states.append(new)
                    # checking if current state is final state
                    if s == end:
                        final_state = new
                        fin = True
        # moving unfolded state to already searched states
        z_states.append(current_state)
        a_states.remove(current_state)

        it_number += 1

    time_end = time.clock()
    total = time_end - time_start
    return {'path':final_state.path, 'time': total*1000, 'iterations': it_number, 'info':str(final_state), 'cost': round(final_state.cost*111.19662,2)}
