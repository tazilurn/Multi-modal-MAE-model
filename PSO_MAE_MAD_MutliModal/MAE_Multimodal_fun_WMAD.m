%
%设施优化布局：Max_Equality with PSO；by Zhuolin Tao @BNU
%

function z = MAE_Multimodal_fun_WMAD(in)
%   test_fun 
    global AC_c;
    global AC_p;
    global h_c;
    global h_p;
    global c_share;
    global p_share;
    global Total_c;
    global Total_p;
%    global B;
%    global Bed;
%    global aBed;
    global m;
    global n;
    global sumS;

    nn = size(in);
    nx=nn(1);
    ssum=0;
    for i=1:m
        S(:,i) = in(:,i); %设施点规模
        ssum=ssum+in(:,i);
    end
   
    %计算粒子群k的目标函数值
    for k=1:nx
        %计算各模式可达性
        for j=1:m
           for i=1:n
              B_c(k,i,j)=S(k,j)*AC_c(i,j)*h_c(i)/(Total_c(j)+Total_p(j)); %需求点i从设施点j分配到的床位数
              B_p(k,i,j)=S(k,j)*AC_p(i,j)*h_p(i)/(Total_c(j)+Total_p(j)); %需求点i从设施点j分配到的床位数
           end
        end

        for i=1:n
           Bed_c(k,i)=sum(B_c(k,i,:)); % 需求点i分配到的总床位数
           Bed_p(k,i)=sum(B_p(k,i,:)); % 需求点i分配到的总床位数
           aBed_c(k,i)=Bed_c(k,i)/h_c(i); %供应/需求比
           aBed_p(k,i)=Bed_p(k,i)/h_p(i); %供应/需求比
           aBed(k,i)=aBed_c(k,i).*c_share(i) + aBed_p(k,i).*p_share(i); %多模式综合可达性
        end
        
        
        %根据可达性差异计算目标函数值
        avga=sumS/(sum(h_c)+sum(h_p));
 
        %%平均绝对偏差MAD
        hs = (h_c+h_p)/(sum(h_c)+sum(h_p));
        A_diff = (aBed(k,:) - avga).*hs;
        MAD = mean(abs(A_diff));

        z(k,:) = MAD + abs(sum(S(k,:))-sumS)/sumS/1000; 
        %可达性总差异最小,加惩罚项以约束设施总规模；需调整“1000”即惩罚项的相对权重以达到较好的优化效果。
    end

end

