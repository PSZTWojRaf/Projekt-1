% za�adowanie danych z excel
LoadData;
% stworzenie Grafu
G = graph(DaneTest.A, DaneTest.B, DaneTest.Weight);
% stworzenie losowych wektor�w wsp�rz�dnych w�z��w w grafie
Y = [5; (randperm(4).*2)'; 5];
X = [0; (randperm(4).*2)'; 10];
% przypisanie wsp�rz�dnych do grafu
G.Nodes.X = X;
G.Nodes.Y = Y;


% funkcja h
% p�tla po wszystkich w�z�ach
t = strings(G.numnodes-1, 1); 
s = strings(G.numnodes-1, 1); 
Weight = zeros(G.numnodes-1, 1);
for i = 1:G.numnodes-1
    t(i,1) = G.Nodes.Name(G.numnodes);
    s(i,1) = G.Nodes.Name(i);
    Weight(i,1) = sqrt((G.Nodes.X(G.numnodes)-G.Nodes.X(i))^2+(G.Nodes.Y(G.numnodes)-G.Nodes.Y(i))^2);
end
% stworzenie grafu
H = graph(s,t,Weight);
% przepisanie wspolrzednych
for i = 1:H.numnodes
   temp = findnode(H, G.Nodes.Name(i));
   H.Nodes.X(temp) = G.Nodes.X(i);  
   H.Nodes.Y(temp) = G.Nodes.Y(i); 
end

%przygotowanie siatki wykresu
figure
ax = axes;
ax.XLim = [-1 11];
xticks([-1:11])
ax.YLim = [-1 11];
yticks([-1:11])
grid on;
box on;
hold(ax, 'on')
% stworzenie wykresu
g = plot(G,'EdgeLabel',G.Edges.Weight, 'LineWidth',2, 'NodeColor', 'b');
% umiejscowienie w�z��w wg wsp�rz�dnych
g.XData = G.Nodes.X;
g.YData = G.Nodes.Y;

% stworzenie wykresu
hold on;
h = plot(H, 'EdgeColor', 'g', 'NodeColor','k');
h.LineStyle = '--';
% umiejscowienie w�z��w wg wsp�rz�dnych
h.XData = H.Nodes.X;
h.YData = H.Nodes.Y;

% znalezienie najkr�tszej �cie�ki
[PATH D] = shortestpath(G,'A','F');
% zaznaczenie najkr�tszej �cie�ki
g.highlight(PATH,'EdgeColor','r','NodeColor','r');


