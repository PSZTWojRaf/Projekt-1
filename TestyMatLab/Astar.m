function [PATH, D] = Astar(G,start,goal, heuristic)

% G - przeszukiwany graf
% start - nazwa w�z�a poczatkowego
% goal - nazwa w�z�a ko�cowego
% heuristic (boolean) - czy u�ywa� funkcji h
% PATH - najkr�tsza �cie�ka
% D - d�ugo�� najkr�tszej �cie�ki

start_idx = findnode(G,start);
goal_idx = findnode(G,goal);

% funkcja heurystyczna
    function h = h(idxA)
        if heuristic == false
            h = zeros(length(idxA),1);
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

[~, min_idx] = min(OpenSet(:,3));
% dodanie kolumny na stany poprzedzaj�ce
OpenSet(:,4) = zeros(length(OpenSet(:,1)),1);

% zbi�r stan�w zamkni�tych ???
ClosedSet(1,1) = [0];

%for k =1:5
k = 0;
while size(OpenSet) ~= size([])
    % iterator do debuggu
    k = k+1;
    
    % rozwini�cie w�z�a o najta�szej �cie�ce dotychczasowej
    NewNodes = neighbors(G,OpenSet(min_idx,1));
    

    
    NewNodes_length = length(NewNodes);
    % dodanie kolumny na poprzednie w�z�y, je�li jest konieczna
    if OpenSet(min_idx,end)~=0
        OpenSet(:,end+1) = zeros(length(OpenSet(:,1)),1);
    end
    
    % dodanie indeks�w rozwini�tych w�z��w do przestrzeni przeszukiwa�
    OpenSet(end+1:end+NewNodes_length,1) = NewNodes;
    
    % dodanie informacji o d�ugo�ci �cie�ki
    OpenSet(end-NewNodes_length+1:end,2) = ones(NewNodes_length,1)*OpenSet(min_idx,2) + G.Edges.Weight(findedge(G,ones(NewNodes_length,1)*OpenSet(min_idx,1),NewNodes));
    
    % dodanie informacji o d�ugo�ci �cie�ki powi�kszon� o funkcj�
    % heurystyczn�
    OpenSet(end-NewNodes_length+1:end,3) = OpenSet(end-NewNodes_length+1:end,2)+h(NewNodes);
    
    % przepisanie indeks�w poprzednich w�z��w w �cie�kach
    OpenSet(end-NewNodes_length+1:end,4) = ones(NewNodes_length,1)*OpenSet(min_idx,1);
    OpenSet(end-NewNodes_length+1:end,5:end) = ones(NewNodes_length,length(OpenSet(1,:))-4).*OpenSet(min_idx,4:end-1);
    
    % wersja iteracyjna
    %for i = 1:length(temp)
    %{
        OpenSet(end+1,1) = temp(i);
        OpenSet(end,2) = OpenSet(min_idx,2) + G.Edges.Weight(findedge(G,OpenSet(min_idx,1),temp(i)));
        OpenSet(end,3) = OpenSet(end,2)+h(temp(i));
        % dodanie w�z�a poprzedzaj�cego
        OpenSet(end,4) = OpenSet(min_idx,1);
        % przepisanie w�z��w poprzedzaj�cych w�ze� poprzedzaj�cy
        OpenSet(end,5:end) = OpenSet(min_idx,4:end-1);
    %}
    %end
    
    % usuni�cie w�z�a, kt�ry by� rozwijany
    OpenSet(min_idx,:) = [];
    
    % wybranie w�z�a o minimalnej warto�ci funkcji
    [~, min_idx] = min(OpenSet(:,3));
    
    % sprawdzenie czy w�ze� minimalizuj�cy fonkcj� jest w�z�em ko�cowym
    if OpenSet(min_idx,1) == goal_idx
        % je�li to prawda, zwr�cenie �cie�ki i d�ugo�ci �cie�ki
        TEST = OpenSet(min_idx,OpenSet(min_idx,:)~=0);
        PATH = [cellstr(goal), G.Nodes.Name(TEST(1,4:end))', cellstr(start)];
        D = OpenSet(min_idx,2);
        k
        break
    end
    
    % je�li nie jest to w�ze� ko�cowy wracamy na pocz�tek p�tli
    
end
end
