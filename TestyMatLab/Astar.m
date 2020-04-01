function [PATH, D] = Astar(G,start,goal, heuristic)

start_idx = findnode(G,start);
goal_idx = findnode(G,goal);

% funkcja heurystyczna
    function h = h(idxA)
        if heuristic == false
            h = 0;
        else
            h = sqrt((G.Nodes.X(goal_idx)*ones(length(idxA),1) - G.Nodes.X(idxA)).^2 + (G.Nodes.Y(goal_idx)*ones(length(idxA),1) - G.Nodes.Y(idxA)).^2);
        end
    end




% zbiór otwarty
OpenSet = zeros(length(neighbors(G,start_idx)),3);
OpenSet(:,1) = neighbors(G,start_idx);

% przygotowanie wektorów do znalezienia krawêdzi
S = ones(length(OpenSet),1)*start_idx;
T = OpenSet(:,1);

% za³adowanie pierwszego kroku algorytmu
% rozwiniêcie stanu
OpenSet(:,2) = G.Edges.Weight(findedge(G,S,T));
OpenSet(:,3) = OpenSet(:,2) + h(OpenSet(:,1));

% posortowanie zbioru stanów otwartych
min_idx
OpenSet = sortrows(OpenSet,3);
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
            
            % dodanie wêz³ów do zbioru stanów otwartych wraz z d³ugoœciami
            % œcie¿ek
            OpenSet(end+1,1) = temp(i);
            OpenSet(end,2) = OpenSet(1,2) + G.Edges.Weight(findedge(G,OpenSet(1,1),temp(i)));
            OpenSet(end,3) = OpenSet(end,2)+h(temp(i));
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
    %[val min_idx] = min(OpenSet(:,3));
    % sprawdzenie czy wêze³ na szczycie jest wêz³em koñcowym
    if OpenSet(1,1) == goal_idx
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
