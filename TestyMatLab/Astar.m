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




% zbi�r otwarty
OpenSet = zeros(length(neighbors(G,start_idx)),3);
OpenSet(:,1) = neighbors(G,start_idx);

% przygotowanie wektor�w do znalezienia kraw�dzi
S = ones(length(OpenSet),1)*start_idx;
T = OpenSet(:,1);

% za�adowanie pierwszego kroku algorytmu
% rozwini�cie stanu
OpenSet(:,2) = G.Edges.Weight(findedge(G,S,T));
OpenSet(:,3) = OpenSet(:,2) + h(OpenSet(:,1));

% posortowanie zbioru stan�w otwartych
min_idx
OpenSet = sortrows(OpenSet,3);
% dodanie kolumny na stany poprzedzaj�ce
OpenSet(:,4) = zeros(length(OpenSet(:,1)),1);

% zbi�r stan�w zamkni�tych ???
ClosedSet(1,1) = [0];



%for k =1:5
k = 0;
while size(OpenSet) ~= size([])
    k = k+1;
    % rozwini�cie w�z�a o najta�szej �cie�ce dotychczasowej
    temp = neighbors(G,OpenSet(1,1));
    % sprawdzenie czy s� w zbiorze w�z��w zamkni�tych
    for i = 1:length(temp)
        % sprawdzenie czy jest w stanach zamkni�tych ???
        if sum(ClosedSet(:,1) == temp(i)) == 0
            
            % dodanie kolumny na poprzednie w�z�y, je�li jest konieczna
            if OpenSet(1,end)~=0
                OpenSet(:,end+1) = zeros(length(OpenSet(:,1)),1);
            end
            
            % dodanie w�z��w do zbioru stan�w otwartych wraz z d�ugo�ciami
            % �cie�ek
            OpenSet(end+1,1) = temp(i);
            OpenSet(end,2) = OpenSet(1,2) + G.Edges.Weight(findedge(G,OpenSet(1,1),temp(i)));
            OpenSet(end,3) = OpenSet(end,2)+h(temp(i));
            % dodanie w�z�a poprzedzaj�cego
            OpenSet(end,4) = OpenSet(1,1);
            % przepisanie w�z��w poprzedzaj�cych w�ze� poprzedzaj�cy
            OpenSet(end,5:end) = OpenSet(1,4:end-1);
       end
    end
    
    % usuni�cie w�z�a, kt�ry by� rozwijany
    % G.Nodes.Name(OpenSet(1,[true false false OpenSet(1,4:end)~=0]))
    OpenSet(1,:) = [];
    ClosedSet(end+1,1) = OpenSet(1,1);
    
    % posortowanie zbioru stan�w otwartych
    OpenSet = sortrows(OpenSet,3);
    %[val min_idx] = min(OpenSet(:,3));
    % sprawdzenie czy w�ze� na szczycie jest w�z�em ko�cowym
    if OpenSet(1,1) == goal_idx
        % je�li to prawda, zwr�cenie �cie�ki i d�ugo�ci �cie�ki
        TEST = OpenSet(1,OpenSet(1,:)~=0);
        START = cellstr(start);
        GOAL = cellstr(goal);
        PATH = [GOAL, G.Nodes.Name(TEST(1,4:end))', START];
        D = OpenSet(1,2);
        k
        break
    end
    
    % je�li nie jest to w�ze� ko�cowy wracamy na pocz�tek p�tli
    
    
    
end







end
