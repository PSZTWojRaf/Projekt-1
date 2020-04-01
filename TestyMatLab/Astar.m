function [PATH, D] = Astar(G,start,goal, heuristic)

% funkcja heurystyczna
    function h = h(idxA)
        if heuristic == false
            h = 0;
        else
            h = sqrt((G.Nodes.X(findnode(G,goal))*ones(length(idxA),1) - G.Nodes.X(idxA)).^2 + (G.Nodes.Y(findnode(G,goal))*ones(length(idxA),1) - G.Nodes.Y(idxA)).^2);
        end
    end


% zbiór otwarty
OpenSet = zeros(length(neighbors(G,findnode(G,start))),3);
OpenSet(:,1) = neighbors(G,findnode(G,start));

% przygotowanie wektorów do znalezienia krawêdzi
S = cell(length(OpenSet), 1);
S(:,1) = {start};
T = cell(length(OpenSet), 1);
T(:,1) = G.Nodes.Name(OpenSet(:,1));

% za³adowanie pierwszego kroku algorytmu
% rozwiniêcie stanu
OpenSet(:,3) = G.Edges.Weight(findedge(G,S,T)) + h(findnode(G,T));
OpenSet(:,2) = G.Edges.Weight(findedge(G,S,T));
% posortowanie zbioru stanów otwartych
OpenSet = sortrows(OpenSet,2);
% dodanie kolumny na stany poprzedzaj¹ce
OpenSet(:,4) = zeros(length(OpenSet(:,1)),1);

% zbiór stanów zamkniêtych ???
ClosedSet(1,1) = [0];



%for k =1:5
k = 0;
while size(OpenSet) ~= size([])
    k = k+1;
    % rozwiniêcie wêz³a o najtañszej œcie¿ce dotychczasowej
    temp = neighbors(G,OpenSet(1,1));
    % sprawdzenie czy s¹ w zbiorze wêz³ów zamkniêtych
    for i = 1:length(temp)
        % sprawdzenie czy jest w stanach zamkniêtych ???
        if sum(ClosedSet(:,1) == temp(i)) == 0
            
            % dodanie kolumny na poprzednie wêz³y, jeœli jest konieczna
            if OpenSet(1,end)~=0
                OpenSet(:,end+1) = zeros(length(OpenSet(:,1)),1);
            end
            
            % dodanie wêz³ów do zbioru stanów otwartych
            OpenSet(end+1,1:3) = [temp(i), OpenSet(1,2) + G.Edges.Weight(findedge(G,OpenSet(1,1),temp(i))) , OpenSet(1,2) + G.Edges.Weight(findedge(G,OpenSet(1,1),temp(i)))+h(temp(i))];
            % dodanie wêz³a poprzedzaj¹cego
            OpenSet(end,4) = OpenSet(1,1);
            % przepisanie wêz³ów poprzedzaj¹cych wêze³ poprzedzaj¹cy
            OpenSet(end,5:end) = OpenSet(1,4:end-1);
        end
    end
    
    % usuniêcie wêz³a, który by³ rozwijany
    % G.Nodes.Name(OpenSet(1,[true false false OpenSet(1,4:end)~=0]))
    OpenSet(1,:) = [];
    ClosedSet(end+1,1) = OpenSet(1,1);
    
    % posortowanie zbioru stanów otwartych
    OpenSet = sortrows(OpenSet,3);
    
    % sprawdzenie czy wêze³ na szczycie jest wêz³em koñcowym
    if strcmp(G.Nodes.Name(OpenSet(1,1)), goal)
        % jeœli to prawda, zwrócenie œcie¿ki i d³ugoœci œcie¿ki
        TEST = OpenSet(1,OpenSet(1,:)~=0);
        START = cellstr(start);
        GOAL = cellstr(goal);
        PATH = [GOAL, G.Nodes.Name(TEST(1,4:end))', START];
        D = OpenSet(1,2);
        k
        break
    end
    
    % jeœli nie jest to wêze³ koñcowy wracamy na pocz¹tek pêtli
    
    
    
end







end
