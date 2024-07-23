%
%��ʩ�Ż����֣�Max_Equality Multimodal Add Resource with PSO
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
global m;
global n;
global TNS;
global AS;

dc0=90; %����뾶����D���ݳ�ģʽ
dp0=90; %����뾶����D������ģʽ
TNS = 4622;  %������ʩ��ģ�ܺͣ���������������ҵʮ����滮������23.2%��

tic

load('pop2020.mat');
load('Actual_S.mat');
load('d_c.mat'); %�������
load('d_p.mat'); %�������
load('c_share.mat'); %�ݳ�ģʽ����
load('p_share.mat'); %����ģʽ����

h_c=(c_share.*h)'; %�ݳ�ģʽ����
h_p=(p_share.*h)'; %�ݳ�ģʽ����
m=size(dc',1); %����,��ѡ��ʩ��
n=size(dc,1); %�������������

%%���ݾ���˥������f(dij)--AC;Gaussian function
for i=1:n
    for j=1:m
        %%����dij���ڷ���뾶Dʱ��f(dij)Ϊ�㣻������Gaussian����
       
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
   Total_c(j)= sum(h_c*AC_c(:,j)) ; %��ʩ��j�����������������˿�-����Ȩ��
   Total_p(j)= sum(h_p*AC_p(:,j)) ; %��ʩ��j�����������������˿�-����Ȩ��
end
toc

num = m; %dimension 
range=zeros(num,2);
for i=1:num
   range(i,:)=[0,200];   %��ʩ��ģ����������;��Դ�С������
end
Max_V = 0.2*(range(:,2)-range(:,1)); %velocity
Pdef=[100 4000 48 2 2 0.9 0.4 1500 1e-15 400 NaN 0 0];
tic
rlt = pso_Trelea_vectorized('MAE_Multimodal_Add_fun',num,Max_V,range,0,Pdef); %pso;num+1�У����һ��ΪĿ�꺯��ֵ
toc

%�������Ž⣬�����Ż��ɴ���
optNS = rlt(1:m); %�Ż�������ģ
optS = optNS + AS;
for j=1:m
   for i=1:n
      bestB_c(i,j)=optS(j)*AC_c(i,j)*h_c(i)/(Total_c(j)+Total_p(j)); %�����i����ʩ��j���䵽�Ĵ�λ��
      bestB_p(i,j)=optS(j)*AC_p(i,j)*h_p(i)/(Total_c(j)+Total_p(j)); %�����i����ʩ��j���䵽�Ĵ�λ��
   end
end

for i=1:n
   bestAcc_c(i)=sum(bestB_c(i,:))/h_c(i); %��Ӧ/����ȣ����ݳ�ģʽ�ɴ���
   bestAcc_p(i)=sum(bestB_p(i,:))/h_p(i); %��Ӧ/����ȣ�������ģʽ�ɴ���
   bestAcc(i)=bestAcc_c(i)*c_share(i) + bestAcc_p(i)*p_share(i); %��ģʽ�ۺϿɴ���
end

%%ƽ������ƫ��MAD
hs = (h_c+h_p)/(sum(h_c)+sum(h_p));
avga=(TNS+sum(AS))/(sum(h_c)+sum(h_p));
A_diff = (bestAcc - avga).*hs;
bestMAD = mean(abs(A_diff));

