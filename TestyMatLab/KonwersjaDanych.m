DaneMiasta = LoadDaneMiasta('Dane50Miast.xlsx',1,2,50);
% struktura do konwersji wsp. geograficznych na p�aszczyzn� XY
utmstruct = defaultm('utm');
utmstruct.zone = '33N';
utmstruct.geoid = wgs84Ellipsoid;
utmstruct = defaultm(utmstruct);
% konwersja na p�aszczyzn� XY
[latitude, longitude] = mfwdtran(utmstruct,DaneMiasta.Latitude,DaneMiasta.Longitude);
% stworzenie tablicy
X =  latitude*10e-06;
Y = longitude*10e-06;
Name = DaneMiasta.Miasta;
DanePoKonwersji = table(Name,X,Y);
% zapis tablicy do pliku excela
writetable(DanePoKonwersji,'DaneMiastaXY.xlsx','Sheet',1,'WriteVariableNames',true);