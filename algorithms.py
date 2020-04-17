import networkx as nx
import math

def compute_cost(start, end, nodes, x, y):
    start_idx = nodes.index(start)
    end_idx = nodes.index(end)
    return math.sqrt((x[start_idx][1]-x[end_idx][1])**2+(y[start_idx][1]-y[end_idx][1])**2)

def astar_search(start, end, graph):

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
            self.h = compute_cost(self.name, end, nodes, nodes_x, nodes_y)
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
            return "name: " + self.name + ", path: " + str(self.path) + ", cost: " + \
                str(self.cost) + ", h(s):" + str(self.h)

    # list of states with initial state
    g_states = [State(start, [], 0)]
    current_state = g_states[0]

    while current_state.name != end:
        # adding new states
        p_states = list(graph.neighbors(current_state.name))
        for s in p_states:
            # checking if not going back to previous state
            if s != current_state.predecessor:
                new = State(s, current_state.path, current_state.cost)
                g_states.append(new)
        # removing the old state
        g_states.remove(current_state)
        # searching for the best next state
        current_state = min(g_states)

        it_number += 1

    # debug
    print(str(current_state))
    print("Number of iterations (how many times the state was 'unfold'): ", it_number)
    return current_state.path

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
            return "name: " + self.name + ", path: " + str(self.path) + ", cost: " + str(self.cost)

    # list of states with initial state
    a_states = [State(start, [], 0)]
    # list of already searched states
    z_states = []

    # changes to True if final state is present in a_states
    fin = False
    
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

    print(str(final_state))
    print("Number of iterations (how many times the state was 'unfold'): ", it_number)
    return final_state.path