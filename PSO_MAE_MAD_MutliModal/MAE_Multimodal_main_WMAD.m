%
%设施优化布局：Max_Multimodal_Equality with PSO；by Zhuolin Tao @BNU
%对多模式综合可达性MAD进行优化
%
clear
global AC_c;
global AC_p;
global h_c;
global h_p;
global c_share;
global p_share;
global Total_c;
global Total_p;
% global B;
% global Bed;
% global aBed;
global m;
global n;
global sumS;

dc0=90; %服务半径参数D，驾车模式
dp0=90; %服务半径参数D，公交模式
sumS = 19924;  %配置的设施规模总和

tic

load('pop2020.mat');
load('d_c.mat'); %距离矩阵
load('d_p.mat'); %距离矩阵
load('c_share.mat'); %驾车模式比例
load('p_share.mat'); %公交模式比例

h_c=(c_share.*h)'; %驾车模式需求
h_p=(p_share.*h)'; %驾车模式需求
m=size(dc',1); %列数,候选设施数
n=size(dc,1); %行数，需求点数

%%根据距离衰减函数f(dij)--AC;Gaussian function
for i=1:n
    for j=1:m
        %%距离dij大于服务半径D时，f(dij)为零；否则求Gaussian函数
       
        if dc(i,j)>dc0
            AC_c(i,j)=0;
        end        
        if dc(i,j)<=dc0               
            AC_c(i,j)=(exp(dc(i,j)^2/dc0^2*(-0.5))-exp(-0.5))/(1-exp(-0.5));               
        end
        if dp(i,j)>dp0
            AC_p(i,j)=0;
        end        
        if dp(i,j)<=dp0               
            AC_p(i,j)=(exp(dp(i,j)^2/dp0^2*(-0.5))-exp(-0.5))/(1-exp(-0.5));               
        end   
    end
end


for j=1:m
   Total_c(j)= sum(h_c*AC_c(:,j)) ; %设施点j所服务所有需求点的人口-距离权重
   Total_p(j)= sum(h_p*AC_p(:,j)) ; %设施点j所服务所有需求点的人口-距离权重
end
toc

num = m; %dimension 
range=zeros(num,2);
for i=1:num
   range(i,:)=[20,1000];   %设施规模的上限下限;相对大小起作用
end
Max_V = 0.2*(range(:,2)-range(:,1)); %velocity
Pdef=[100 3000 128 2 2 0.9 0.4 1500 1e-25 800 NaN 0 0];
tic
rlt = pso_Trelea_vectorized('MAE_Multimodal_fun_WMAD',num,Max_V,range,0,Pdef); %pso;num+1行，最后一行为目标函数值
toc

%根据最优解，计算优化可达性
bestS=rlt(1:m);
for j=1:m
   for i=1:n
      bestB_c(i,j)=bestS(j)*AC_c(i,j)*h_c(i)/(Total_c(j)+Total_p(j)); %需求点i从设施点j分配到的床位数
      bestB_p(i,j)=bestS(j)*AC_p(i,j)*h_p(i)/(Total_c(j)+Total_p(j)); %需求点i从设施点j分配到的床位数
   end
end

for i=1:n
   bestAcc_c(i)=sum(bestB_c(i,:))/h_c(i); %供应/需求比，即驾车模式可达性
   bestAcc_p(i)=sum(bestB_p(i,:))/h_p(i); %供应/需求比，即公交模式可达性
   bestAcc(i)=bestAcc_c(i)*c_share(i) + bestAcc_p(i)*p_share(i); %多模式综合可达性
end

%%平均绝对偏差MAD
hs = (h_c+h_p)/(sum(h_c)+sum(h_p));
avga=sumS/(sum(h_c)+sum(h_p));
A_diff = (bestAcc - avga).*hs;
bestMAD = mean(abs(A_diff));

