function [PATH, D] = Astar(G,start,goal, heuristic)

% G - przeszukiwany graf
% start - nazwa wêz³a poczatkowego
% goal - nazwa wêz³a koñcowego
% heuristic (boolean) - czy u¿ywaæ funkcji h
% PATH - najkrótsza œcie¿ka
% D - d³ugoœæ najkrótszej œcie¿ki

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

[~, min_idx] = min(OpenSet(:,3));
% dodanie kolumny na stany poprzedzaj¹ce
OpenSet(:,4) = zeros(length(OpenSet(:,1)),1);

% zbiór stanów zamkniêtych ???
ClosedSet(1,1) = [0];

%for k =1:5
k = 0;
while size(OpenSet) ~= size([])
    % iterator do debuggu
    k = k+1;
    
    % rozwiniêcie wêz³a o najtañszej œcie¿ce dotychczasowej
    NewNodes = neighbors(G,OpenSet(min_idx,1));
    

    
    NewNodes_length = length(NewNodes);
    % dodanie kolumny na poprzednie wêz³y, jeœli jest konieczna
    if OpenSet(min_idx,end)~=0
        OpenSet(:,end+1) = zeros(length(OpenSet(:,1)),1);
    end
    
    % dodanie indeksów rozwiniêtych wêz³ów do przestrzeni przeszukiwañ
    OpenSet(end+1:end+NewNodes_length,1) = NewNodes;
    
    % dodanie informacji o d³ugoœci œcie¿ki
    OpenSet(end-NewNodes_length+1:end,2) = ones(NewNodes_length,1)*OpenSet(min_idx,2) + G.Edges.Weight(findedge(G,ones(NewNodes_length,1)*OpenSet(min_idx,1),NewNodes));
    
    % dodanie informacji o d³ugoœci œcie¿ki powiêkszon¹ o funkcjê
    % heurystyczn¹
    OpenSet(end-NewNodes_length+1:end,3) = OpenSet(end-NewNodes_length+1:end,2)+h(NewNodes);
    
    % przepisanie indeksów poprzednich wêz³ów w œcie¿kach
    OpenSet(end-NewNodes_length+1:end,4) = ones(NewNodes_length,1)*OpenSet(min_idx,1);
    OpenSet(end-NewNodes_length+1:end,5:end) = ones(NewNodes_length,length(OpenSet(1,:))-4).*OpenSet(min_idx,4:end-1);
    
    % wersja iteracyjna
    %for i = 1:length(temp)
    %{
        OpenSet(end+1,1) = temp(i);
        OpenSet(end,2) = OpenSet(min_idx,2) + G.Edges.Weight(findedge(G,OpenSet(min_idx,1),temp(i)));
        OpenSet(end,3) = OpenSet(end,2)+h(temp(i));
        % dodanie wêz³a poprzedzaj¹cego
        OpenSet(end,4) = OpenSet(min_idx,1);
        % przepisanie wêz³ów poprzedzaj¹cych wêze³ poprzedzaj¹cy
        OpenSet(end,5:end) = OpenSet(min_idx,4:end-1);
    %}
    %end
    
    % usuniêcie wêz³a, który by³ rozwijany
    OpenSet(min_idx,:) = [];
    
    % wybranie wêz³a o minimalnej wartoœci funkcji
    [~, min_idx] = min(OpenSet(:,3));
    
    % sprawdzenie czy wêze³ minimalizuj¹cy fonkcjê jest wêz³em koñcowym
    if OpenSet(min_idx,1) == goal_idx
        % jeœli to prawda, zwrócenie œcie¿ki i d³ugoœci œcie¿ki
        TEST = OpenSet(min_idx,OpenSet(min_idx,:)~=0);
        PATH = [cellstr(goal), G.Nodes.Name(TEST(1,4:end))', cellstr(start)];
        D = OpenSet(min_idx,2);
        k
        break
    end
    
    % jeœli nie jest to wêze³ koñcowy wracamy na pocz¹tek pêtli
    
end
end
