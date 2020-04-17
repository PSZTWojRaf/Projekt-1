% original data - geographical coordiantes
CitiesData = LoadDaneMiasta('original_cities_data.xlsx',1,2,50);

% structure to convert gegraphical coordinates into XY plane
utmstruct = defaultm('utm');
utmstruct.zone = '33N';
utmstruct.geoid = wgs84Ellipsoid;
utmstruct = defaultm(utmstruct);

% conversion to XY plane
[latitude, longitude] = mfwdtran(utmstruct,CitiesData.Latitude,CitiesData.Longitude);

% new table
X =  latitude*10e-06;
Y = longitude*10e-06;
Name = CitiesData.Miasta;
ConvertedData = table(Name,X,Y);

% saving into excel file
writetable(ConvertedData,'cities_data.xlsx','Sheet',1,'WriteVariableNames',true);