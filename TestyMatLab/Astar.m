function [PATH, D] = Astar(G,start,goal)
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
OpenSet(:,2) = G.Edges.Weight(findedge(G,S,T));
% posortowanie zbioru stanów otwartych
OpenSet = sortrows(OpenSet,2);
% dodanie kolumny na stany poprzedzaj¹ce
OpenSet(:,3) = zeros(length(OpenSet(:,1)),1);

% zbiór stanów zamkniêtych ???
ClosedSet(1,1) = [0];


%for k =1:5
while size(OpenSet) ~= size([])
    
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
            OpenSet(end+1,1:2) = [temp(i) OpenSet(1,2) + G.Edges.Weight(findedge(G,OpenSet(1,1),temp(i)))];
            % dodanie wêz³a poprzedzaj¹cego
            OpenSet(end,3) = OpenSet(1,1);
            % przepisanie wêz³ów poprzedzaj¹cych wêze³ poprzedzaj¹cy
            OpenSet(end,4:end) = OpenSet(1,3:end-1);
        end
    end
    
    % usuniêcie wêz³a, który by³ rozwijany
    OpenSet(1,:) = [];
    ClosedSet(end+1,1) = OpenSet(1,1);
   
    % posortowanie zbioru stanów otwartych
    OpenSet = sortrows(OpenSet,2);
    
    % sprawdzenie czy wêze³ na szczycie jest wêz³em koñcowym
    if strcmp(G.Nodes.Name(OpenSet(1,1)), goal)
        % jeœli to prawda, zwrócenie œcie¿ki i d³ugoœci œcie¿ki
        TEST = OpenSet(1,OpenSet(1,:)~=0);
        START = cellstr(start);
        GOAL = cellstr(goal);
        PATH = [GOAL, G.Nodes.Name(TEST(1,3:end))', START];
        D = OpenSet(1,2);
        break
    end
    
    % jeœli nie jest to wêze³ koñcowy wracamy na pocz¹tek pêtli

    
    
end







end
