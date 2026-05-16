addpath('m_map')                                 % 添加 m_map 工具箱路径
ncdisp('1.nc');                                  % 查看 1.nc 文件中的变量信息

lon = ncread('1.nc','LONN11_133');               % 读取经度数据
lat = ncread('1.nc','LAT5_69');                  % 读取纬度数据
SLP = ncread('1.nc','SLP',[1,1,1],[145,65,12]); % 读取 12 个月海平面气压数据

R = 6371000;                                     % 地球半径，单位 m
rho = 1.293;                                     % 空气密度，单位 kg/m^3
omega = 7.292e-5;                                % 地球自转角速度，单位 rad/s

[Lat,Lon] = meshgrid(lat,lon);                   % 生成二维经纬度网格

dy = 2*pi*R/360*(lat(2)-lat(1))*ones(size(Lon));            % 计算纬向网格实际距离
dx = 2*pi*R/360*(lon(2)-lon(1))*ones(size(Lon)).*cos(Lat./180*pi); % 计算经向网格实际距离
f = 2*omega*sin(Lat*pi/180);                     % 计算柯氏参数
f(abs(f)<1e-5) = NaN;                            % 赤道附近 f 太小，设为 NaN 避免发散

ug = zeros(size(SLP));                           % 预分配东西向地转风分量
vg = zeros(size(SLP));                           % 预分配南北向地转风分量
ws = zeros(size(SLP));                           % 预分配地转风风速

for k = 1:12                                     % 循环计算 12 个月的地转风
    p = double(SLP(:,:,k));                      % 取出第 k 个月的气压场并转成 double
    [dslpy,dslpx] = gradient(p);                 % 计算气压场在两个方向上的变化率
    dslady = dslpy./dy;                          % 换算为纬向实际气压梯度
    dsladx = dslpx./dx;                          % 换算为经向实际气压梯度

    ug(:,:,k) = -(1./(rho.*f)).*dslady;          % 根据地转风公式计算东西向风分量
    vg(:,:,k) =  (1./(rho.*f)).*dsladx;          % 根据地转风公式计算南北向风分量
    ws(:,:,k) = sqrt(ug(:,:,k).^2 + vg(:,:,k).^2); % 计算地转风风速大小
end

u_mean = mean(ug,3,'omitnan');                   % 计算气候态东西向平均风
v_mean = mean(vg,3,'omitnan');                   % 计算气候态南北向平均风
ws_mean = mean(ws,3,'omitnan');                  % 计算气候态平均风速

u_winter = mean(ug(:,:,[12 1 2]),3,'omitnan');  % 计算冬季东西向平均风
v_winter = mean(vg(:,:,[12 1 2]),3,'omitnan');  % 计算冬季南北向平均风
ws_winter = mean(ws(:,:,[12 1 2]),3,'omitnan'); % 计算冬季平均风速

u_summer = mean(ug(:,:,[6 7 8]),3,'omitnan');   % 计算夏季东西向平均风
v_summer = mean(vg(:,:,[6 7 8]),3,'omitnan');   % 计算夏季南北向平均风
ws_summer = mean(ws(:,:,[6 7 8]),3,'omitnan');  % 计算夏季平均风速

figure('color','white')                          % 新建白色背景图窗
m_proj('robinson','lon',[-30 329],'lat',[-80 80]); % 设置 Robinson 投影和显示范围
set(gca,'color','white');                        % 设置坐标区背景为白色
hold on                                          % 保持当前图层，继续叠加绘图
m_coast('patch',[0.8 0.8 0.8]);                  % 绘制灰色陆地
m_grid                                           % 绘制经纬网格
m_quiver(Lon(1:4:end,1:4:end),Lat(1:4:end,1:4:end), ... % 绘制气候态风矢量
    u_mean(1:4:end,1:4:end),v_mean(1:4:end,1:4:end),2,'k'); % 箭头缩放倍数为 2，颜色为黑色
title('气候态海面地转风场');                      % 设置图题

figure('color','white')                          % 新建白色背景图窗
m_proj('robinson','lon',[-30 329],'lat',[-80 80]); % 设置 Robinson 投影和显示范围
set(gca,'color','white');                        % 设置坐标区背景为白色
hold on                                          % 保持当前图层，继续叠加绘图
m_coast('patch',[0.8 0.8 0.8]);                  % 绘制灰色陆地
m_grid                                           % 绘制经纬网格
m_quiver(Lon(1:4:end,1:4:end),Lat(1:4:end,1:4:end), ... % 绘制冬季风矢量
    u_winter(1:4:end,1:4:end),v_winter(1:4:end,1:4:end),2,'k'); % 箭头缩放倍数为 2，颜色为黑色
title('冬季海面地转风场');                        % 设置图题

figure('color','white')                          % 新建白色背景图窗
m_proj('robinson','lon',[-30 329],'lat',[-80 80]); % 设置 Robinson 投影和显示范围
set(gca,'color','white');                        % 设置坐标区背景为白色
hold on                                          % 保持当前图层，继续叠加绘图
m_coast('patch',[0.8 0.8 0.8]);                  % 绘制灰色陆地
m_grid                                           % 绘制经纬网格
m_quiver(Lon(1:4:end,1:4:end),Lat(1:4:end,1:4:end), ... % 绘制夏季风矢量
    u_summer(1:4:end,1:4:end),v_summer(1:4:end,1:4:end),2,'k'); % 箭头缩放倍数为 2，颜色为黑色
title('夏季海面地转风场');                        % 设置图题
