%
%��ʩ�Ż����֣�Max_Equality with PSO��by Zhuolin Tao @BNU
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
        S(:,i) = in(:,i); %��ʩ���ģ
        ssum=ssum+in(:,i);
    end
   
    %��������Ⱥk��Ŀ�꺯��ֵ
    for k=1:nx
        %�����ģʽ�ɴ���
        for j=1:m
           for i=1:n
              B_c(k,i,j)=S(k,j)*AC_c(i,j)*h_c(i)/(Total_c(j)+Total_p(j)); %�����i����ʩ��j���䵽�Ĵ�λ��
              B_p(k,i,j)=S(k,j)*AC_p(i,j)*h_p(i)/(Total_c(j)+Total_p(j)); %�����i����ʩ��j���䵽�Ĵ�λ��
           end
        end

        for i=1:n
           Bed_c(k,i)=sum(B_c(k,i,:)); % �����i���䵽���ܴ�λ��
           Bed_p(k,i)=sum(B_p(k,i,:)); % �����i���䵽���ܴ�λ��
           aBed_c(k,i)=Bed_c(k,i)/h_c(i); %��Ӧ/�����
           aBed_p(k,i)=Bed_p(k,i)/h_p(i); %��Ӧ/�����
           aBed(k,i)=aBed_c(k,i).*c_share(i) + aBed_p(k,i).*p_share(i); %��ģʽ�ۺϿɴ���
        end
        
        
        %���ݿɴ��Բ������Ŀ�꺯��ֵ
        avga=sumS/(sum(h_c)+sum(h_p));
 
        %%ƽ������ƫ��MAD
        hs = (h_c+h_p)/(sum(h_c)+sum(h_p));
        A_diff = (aBed(k,:) - avga).*hs;
        MAD = mean(abs(A_diff));

        z(k,:) = MAD + abs(sum(S(k,:))-sumS)/sumS/1000; 
        %�ɴ����ܲ�����С,�ӳͷ�����Լ����ʩ�ܹ�ģ���������1000�����ͷ�������Ȩ���Դﵽ�Ϻõ��Ż�Ч����
    end

end

