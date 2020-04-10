import math
import networkx as nx

def astar(G, start, end):

    if start == end:
        print("Miasto początkowe musi być inne od końcowego")
        return False

    if not(G.__contains__(start)):
        print("Początkowe miasto nie zostało rozpoznane. \
        Proszę przejrzeć listę dostępnych miast w pliku DaneMiastaXY.xlsx.")
        return False

    if not(G.__contains__(end)):
        print("Końcowe miasto nie zostało rozpoznane. \
        Proszę przejrzeć listę dostępnych miast w pliku DaneMiastaXY.xlsx.")
        return False

    # Creating edges structure [[{str_start, str_end}, float_cost],...]
    edges = list()
    for x in list(G.edges()):
        c = math.sqrt(math.pow((G.nodes[x[1]]['X'] - G.nodes[x[0]]['X']), 2) + math.pow((G.nodes[x[1]]['Y'] - G.nodes[x[0]]['Y']), 2))
        edges.append([{x[0], x[1]}, c])

    # Initial list of states
    Gs = [[[start], 0]]

    while(True):

        # Finding best state
        lowest_cost = Gs[0][1]
        first_iteration = True
        for x in Gs:
            current_city = x[0][len(x[0])-1]

            h = math.sqrt(math.pow((G.nodes[end]['X'] - G.nodes[current_city]['X']), 2) + math.pow((G.nodes[end]['Y'] - G.nodes[current_city]['Y']), 2))
            
            if first_iteration:
                first_iteration = False
                lowest_cost = h + x[1]
                lowest_cost_idx = Gs.index(x)
                continue
            
            if h + x[1] < lowest_cost:
                lowest_cost = x[1]
                lowest_cost_idx = Gs.index(x)
            
        best_state = Gs[lowest_cost_idx]
        last_city = best_state[0][len(best_state[0])-1]
        prev_last_city = best_state[0][len(best_state[0])-2]

        if last_city == end:
            print("Koniec działania algorytmu A*. Najoptymalniejsza ścieżka: ")
            print(best_state[0])
            break

        # Creating list of neighbours
        Ps = list(G.neighbors(last_city))

        try:
            Ps.remove(prev_last_city)
        except ValueError:
            pass

        newPs = list()
        # Creating new states
        for x in Ps:
            c = math.sqrt(math.pow((G.nodes[x]['X'] - G.nodes[last_city]['X']), 2) + math.pow((G.nodes[x]['Y'] - G.nodes[last_city]['Y']), 2))
            newPs.append([best_state[0] + [x], best_state[1] + c])

        ## TODO: Eliminate repeating states
        # Adding new states to list of states
        Gs += newPs
        Gs.remove(best_state)