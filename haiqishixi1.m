addpath('m_map')
ncdisp('1.nc');

lon=ncread('1.nc','LONN11_133');
lat=ncread('1.nc','LAT5_69');
SLP=ncread('1.nc','SLP',[1,1,1],[145,65,12]);

[Lat,Lon]=meshgrid(lat,lon);

figure('color','white')
m_proj('robinson','lon',[-30 329],'lat',[-80 80]);
m_coast
m_grid
hold on

data_jan=SLP(:,:,1);
[cs,h]=m_contour(Lon,Lat,data_jan,800:4:1400);
clabel(cs,h,'LabelSpacing',400,'fontsize',6);
title('一月海表气压场');


figure('color','white')
m_proj('robinson','lon',[-30 329],'lat',[-80 80]);
m_coast
m_grid
hold on

data_jul=SLP(:,:,7);
[cs,h]=m_contour(Lon,Lat,data_jul,800:4:1400);
clabel(cs,h,'LabelSpacing',400,'fontsize',6);
title('七月海表气压场');
