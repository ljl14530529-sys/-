addpath('/Applications/MATLAB_R2025b.app/toolbox/m_map');
ncdisp('2.nc');
ncdisp('3.nc');

lon=ncread('2.nc','LONN11_133');
lat=ncread('2.nc','LAT5_69');
UWND=ncread('2.nc','UWND',[1,1,1],[145,65,12]);
VWND=ncread('3.nc','VWND',[1,1,1],[145,65,12]);

[Lat,Lon]=meshgrid(lat,lon);

figure('color','white')
m_proj('robinson','lon',[-30 329],'lat',[-80 80]);
m_coast
m_grid
hold on
u1=UWND(:,:,1);
v1=VWND(:,:,1);
title('一月风场');

m_quiver(Lon(1:4:end,1:4:end),Lat(1:4:end,1:4:end),u1(1:4:end,1:4:end),v1(1:4:end,1:4:end),2);
 
hold on
figure('color','white')
m_proj('robinson','lon',[-30 329],'lat',[-80 80]);
m_coast
m_grid
hold on
u7=UWND(:,:,7);
v7=VWND(:,:,7);
title('七月风场');

m_quiver(Lon(1:4:end,1:4:end),Lat(1:4:end,1:4:end),u7(1:4:end,1:4:end),v7(1:4:end,1:4:end),2);


m_quiver(lon_sub,lat_sub,u7_sub,v7_sub,0.3);






