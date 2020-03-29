DaneMiasta = LoadDaneMiasta('Dane60Miast.xlsx',1,2,61);
utmstruct = defaultm('utm');
utmstruct.zone = '33N';
utmstruct.geoid = wgs84Ellipsoid;
utmstruct = defaultm(utmstruct);
[latitude longitude] = mfwdtran(utmstruct,DaneMiasta.Latitude,DaneMiasta.Longitude);
latitude =  latitude*10e-06;
longitude = longitude*10e-06;

%
%A = zeros(height(DaneMiasta));
%longitude = DaneMiasta.Longitude;
%latitude = DaneMiasta.Latitude;
nazwa = DaneMiasta.Miasta;
max_dist = 0.5;
k = 0;
temp = zeros(height(DaneMiasta),3);
s = [];
t = [];
weight = [];
for i = 1:height(DaneMiasta)
    k = 0;
    temp = zeros(height(DaneMiasta),3);
    for j = 1: height(DaneMiasta)
        dist = sqrt((latitude(i)-latitude(j))^2+(longitude(i)-longitude(j))^2);
        temp(j,:) = [i j dist];
    end
    temp = sortrows(temp, 3, 'ascend');
    length(temp);
    for l = 1:5
        if temp(l,3) > 0
            s = [s nazwa(temp(l,1))];
            t = [t nazwa(temp(l,2))];
            weight = [weight temp(l,3)];
        end
    end
end
% stworzenie grafu
G = graph(s,t,weight);

% usuniêcie powtarzaj¹cych siê krawêdzi
G = simplify(G,'max');
for i = 1:G.numnodes
    temp = findnode(G, nazwa(i));
    G.Nodes.X(temp) = latitude(i);
    G.Nodes.Y(temp) = longitude(i);
end
figure
ax = axes;
%ax.YLim = [min(latitude)-1 max(latitude)+1];
%yticks([min(latitude)-1:max(latitude)+1])
%ax.XLim = [min(longitude)-1 max(longitude)+1];
%xticks([min(longitude)-1:max(longitude)+1])
grid on;
box on;
hold(ax, 'on')
g = plot(G, 'NodeLabel',G.Nodes.Name, 'LineWidth',2, 'NodeColor', 'b');
% umiejscowienie wêz³ów wg wspó³rzêdnych
g.XData = G.Nodes.X;
g.YData = G.Nodes.Y;

% znalezienie najkrótszej œcie¿ki
[PATH D] = shortestpath(G,'Gdynia','Rzeszow');
% zaznaczenie najkrótszej œcie¿ki
g.highlight(PATH,'EdgeColor','r','NodeColor','r');





