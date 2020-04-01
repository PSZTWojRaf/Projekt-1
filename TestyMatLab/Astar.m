function [PATH, D] = Astar(G,start,goal, heuristic)

% funkcja heurystyczna
    function h = h(idxA)
        if heuristic == false
            h = 0;
        else
            h = sqrt((G.Nodes.X(findnode(G,goal))*ones(length(idxA),1) - G.Nodes.X(idxA)).^2 + (G.Nodes.Y(findnode(G,goal))*ones(length(idxA),1) - G.Nodes.Y(idxA)).^2);
        end
    end


% zbi�r otwarty
OpenSet = zeros(length(neighbors(G,findnode(G,start))),3);
OpenSet(:,1) = neighbors(G,findnode(G,start));

% przygotowanie wektor�w do znalezienia kraw�dzi
S = cell(length(OpenSet), 1);
S(:,1) = {start};
T = cell(length(OpenSet), 1);
T(:,1) = G.Nodes.Name(OpenSet(:,1));

% za�adowanie pierwszego kroku algorytmu
% rozwini�cie stanu
OpenSet(:,3) = G.Edges.Weight(findedge(G,S,T)) + h(findnode(G,T));
OpenSet(:,2) = G.Edges.Weight(findedge(G,S,T));
% posortowanie zbioru stan�w otwartych
OpenSet = sortrows(OpenSet,2);
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
            
            % dodanie w�z��w do zbioru stan�w otwartych
            OpenSet(end+1,1:3) = [temp(i), OpenSet(1,2) + G.Edges.Weight(findedge(G,OpenSet(1,1),temp(i))) , OpenSet(1,2) + G.Edges.Weight(findedge(G,OpenSet(1,1),temp(i)))+h(temp(i))];
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
    
    % sprawdzenie czy w�ze� na szczycie jest w�z�em ko�cowym
    if strcmp(G.Nodes.Name(OpenSet(1,1)), goal)
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
