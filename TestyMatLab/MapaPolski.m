DaneMiasta = LoadDaneMiasta('Dane50Miast.xlsx',1,2,50);
% struktura do konwersji wsp. geograficznych na p³aszczyznê XY
utmstruct = defaultm('utm');
utmstruct.zone = '33N';
utmstruct.geoid = wgs84Ellipsoid;
utmstruct = defaultm(utmstruct);
% konwersja na p³aszczyznê XY
[latitude, longitude] = mfwdtran(utmstruct,DaneMiasta.Latitude,DaneMiasta.Longitude);
latitude =  latitude*10e-06;
longitude = longitude*10e-06;

% wyznaczenie krawêdzi grafu
A = zeros(height(DaneMiasta));
%longitude = DaneMiasta.Longitude;
%latitude = DaneMiasta.Latitude;
nazwa = DaneMiasta.Miasta;
max_dist = 0.5;
temp = zeros(height(DaneMiasta),3);
for i = 1:height(DaneMiasta)
    temp = zeros(height(DaneMiasta),3);
    for j = 1: height(DaneMiasta)
        dist = sqrt((latitude(i)-latitude(j))^2+(longitude(i)-longitude(j))^2);
        temp(j,:) = [i j dist];
    end
    temp = sortrows(temp, 3, 'ascend');
    length(temp);
    for l = 1:5
        % adjacency matrix
        if temp(l,3) > 0
            A(temp(l,1),temp(l,2)) = temp(l,3);
            A(temp(l,2),temp(l,1)) = temp(l,3);
        end
    end
end

% stworzenie grafu
G = graph(A,nazwa);
G.Nodes.X = latitude;
G.Nodes.Y = longitude;

% wizualizacja - osie
figure
ax = axes;
grid on;
box on;
hold(ax, 'on')
% wizualizacja - graf
g = plot(G, 'NodeLabel',G.Nodes.Name, 'LineWidth',2, 'NodeColor', 'b');
% umiejscowienie wêz³ów wg wspó³rzêdnych
g.XData = G.Nodes.X;
g.YData = G.Nodes.Y;

tic
% znalezienie najkrótszej œcie¿ki
[PATH, D] = shortestpath(G,'Gdansk','Wroclaw');
toc
PATH
D
% zaznaczenie najkrótszej œcie¿ki
g.highlight(PATH,'EdgeColor','g','NodeColor','g');

tic
% znalezienie najkrótszej œcie¿ki
[PATH, D] = Astar(G,'Gdansk','Wroclaw');
toc
PATH
D
% zaznaczenie najkrótszej œcie¿ki
g.highlight(PATH,'EdgeColor','r','NodeColor','r');





