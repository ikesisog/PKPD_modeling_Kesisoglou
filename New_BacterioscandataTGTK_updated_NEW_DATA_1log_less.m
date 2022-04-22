%%2nd file after Integration_fitting_Ntotal_TK_logscale_3_updated file
%Part 1 bacterio scan ploting
%Part 2 m(t) and s(t) ploting
 clearvars -except Initial_point_Ntotal Final_values Initial_point_Nlive y_modeled_values RESIDUAL Error_all Initial_point Kg Nmax Kd Best_FIT_FINAL Best_fit_A Best_fit_rmin Best_fit_lambda SD  y1% parameters taken from file Integration_fitting_Ntotal_TK
 clc
 Nmax = 10^8;
xq1 = [6.121403527	6.072776203	6.154033559	6.02196923	6.162064308];
xq1=10.^xq1;
 %MODIFY SET OF DATA TO BE EXTRACTED FROM EXCEL HERE
dataset=xlsread('BacterioScan CAZ+AMK AB747 (5 log) raw data 0222_AKIS.xlsx','Data','AQ3:AW191'); %updated data set 
X=dataset;


%% NTOTAL 

%% C=1_0.5

Final_values(1,1) = 0.0966820169011865;
Final_values(2,1) = 0.0983122178214555;
Final_values(3,1) = 6.55414785476369;

xq1(1) = 10^(6.121403527-1);

Final_rmin(1) = Final_values(1,1);
Final_A(1) = Final_values(2,1);
Final_lambda(1) = Final_values(3,1);
% 
%% C=4_2

Final_values(1,2) = 3.61274034035565;% NTOTAL ONLY DATA 
Final_values(2,2) = 0.11601696745786;% NTOTAL ONLY DATA 
Final_values(3,2) = 1.85185879025294;% NTOTAL ONLY DATA 

xq1(2) =  10^(log10(1.1824e+06)-1);

Final_rmin(2) = Final_values(1,2);
Final_A(2) = Final_values(2,2);
Final_lambda(2) = Final_values(3,2);

 %% C=16_8
% 
Final_values(1,3) = 9.06094713889759;
Final_values(2,3) = 0.141353500024784;
Final_values(3,3) = 9.42356666831896;

xq1(3) = 10^(6.154033559-1);

Final_rmin(3) = Final_values(1,3);
Final_A(3) = Final_values(2,3);
Final_lambda(3) = Final_values(3,3);
% 
 %% C=64_32
% 
Final_values(1,4) = 23.8949300513201;
Final_values(2,4) = 0.756700699942974;
Final_values(3,4) = 2.75567693898233;

xq1(4) = 10^(6.02196923-1);

Final_rmin(4) = Final_values(1,4);
Final_A(4) = Final_values(2,4);
Final_lambda(4) = Final_values(3,4);
% 
 %% C=256_128
% 
Final_values(1,5) =100;
Final_values(2,5) = 393.2395315;
Final_values(3,5) = 11.93383668;

xq1(5) = 10^(6.162064308-1);

Final_rmin(5) = Final_values(1,5);
Final_A(5) = Final_values(2,5);
Final_lambda(5) = Final_values(3,5);

%% NTOTAL + NLIVE

%% C=4_2
% 
% Final_values(1,2) = 2.30447071318006;% NTOTAL  % WITH NLIVE DATA 
% Final_values(2,2) = 0.140851550042861;% NTOTAL % WITH NLIVE DATA 
% Final_values(3,2) = 10.5638662532146;% NTOTAL % WITH NLIVE DATA 
% 
% xq1(2) =  1.1824e+06;
% 
% Final_rmin(2) = Final_values(1,2);
% Final_A(2) = Final_values(2,2);
% Final_lambda(2) = Final_values(3,2);
%% Notal equation 

%% TIME GROWTH


BacterioScan_Data_time_growth_average=dataset(:,2);
time_1=X(:,1);

TG_model=y1;
TIME_TG=X(:,1);

%% TK

value=189;

automation_1=value;%12;
automation_2=value;%8;
automation_3=value;%7;
automation_4=value;%6;
automation_5=value;%8;

time_TK_1(3,:) = {X(1:automation_1,1)};
time_TK_1(4,:) = {X(1:automation_2,1)};
time_TK_1(5,:) = {X(1:automation_3,1)};
time_TK_1(6,:) = {X(1:automation_4,1)};
time_TK_1(7,:) = {X(1:automation_5,1)};

linewidth=4;

dataset_new(3,:)={dataset(1:automation_1,3)-1};
dataset_new(4,:)={dataset(1:automation_2,4)-1};
dataset_new(5,:)={dataset(1:automation_3,5)-1};
dataset_new(6,:)={dataset(1:automation_4,6)-1};
dataset_new(7,:)={dataset(1:automation_5,7)-1};

dummy=linspace(1,240,240);
dt=5./60;
tspan = [0, dummy*dt]';
jmax = 2000;

for i=1:5%one for each concentration
    INITIAL(1:2) =[xq1(i) xq1(i) ];
    No=xq1(i); 
    %% When using fitnlm Notal 
    % Final_rmin(i)=Best_FIT_FINAL(1,i);
    % Final_A(i)=Best_FIT_FINAL(2,i);
    % Final_lambda(i)=Best_FIT_FINAL(3,i);
    %% When using Integration fitting log10 directly
    rmin=Final_rmin(i)
    A=Final_A(i)
    lambda=Final_lambda(i)
    %% Approach one,ODE APPROACH NOT AS ACCURATE AS EULERS
    % f = @(t,a)[(Kg*(1-a(2)/Nmax)+Kd)*a(2);...
    %     a(2)*(-Kg*a(2)/Nmax+Kg-rmin-lambda*A*exp(-A*t)) ];
    % 
    % options = odeset('RelTol',1e-30,'AbsTol',1e-60,'Maxstep',1e-1,'NormControl','on');%'Maxstep',1e-5,,'Stats','on'1 ,'NormControl','on'
    % 
    % [t,y]=ode45(f,time_TK_1{i+2},INITIAL,options); %added options
    %% EULER'S APPROACH to ODE integration
    N_live(1,1) = No;
    N_total(1,1) = No; 
    for k = 1: length(time_TK_1{i+2})-1  %reaching 20 hours 
        N_live_temp(1,1) = N_live(k,1);
        N_total_temp(1,1) = N_total(k,1);
        dt_internal = (tspan(k+1,1)-tspan(k,1))/jmax;  
        for j = 1 : jmax-1 %intermediate number of steps
            N_live_temp(j+1,1) = N_live_temp(j,1) + dt_internal*...
                (-Kg*N_live_temp(j,1)/Nmax+Kg-rmin-lambda*A*exp(-A*(tspan(k,1)...  
                +j*dt_internal)))*N_live_temp(j,1);
            N_total_temp(j+1,1) = N_total_temp(j,1) ...
                + dt_internal*(Kg*(1- N_live_temp(j,1)/Nmax)+ Kd) * N_live_temp(j,1) ;
        end
        N_live(k+1,1) = N_live_temp(jmax,1);
        N_total(k+1,1) = N_total_temp(jmax,1);
    end
    %% Approach two using the final equation
    t=time_TK_1{i+2};
    %% Ploting
    figure (1999)
    % WQ=rand(1,3);
    if i==1
        plot(time_1(1:21),BacterioScan_Data_time_growth_average(1:21)-1,'o','color',[0 0 0],...
            'MarkerFaceColor',[0.0745    0.6235    1.0000])
    end
    hold on
    WQ=[1.0000    0.8392    0.6000; 0.6706    0.5020    0.8196; 0.5843    0.9020    0.5059; 0 0 0;1 0.2 0.2];
    plot(time_TK_1{i+2},dataset_new{2+i},'o','color',[0 0 0],'MarkerFaceColor',WQ(i,:))%,'MarkerSize',15
    hold on 
    legend ({'C = 0 mg/L ','C = 1/0.5 mg/L','C = 4/2 mg/L','C = 16/8 mg/L','C = 64/32 mg/L','C = 256/128 mg/L'},...
       'FontSize',20,'Location','eastoutside','Orientation','vertical')
    %  plot(t,log10(y(:,1)),'--r')
    % hold on
    time_model(1:length(t),i)=t;
    grid on
    Ntotal_modeled_values(1:length(t),i)= N_total ; %y(:,1);
    N_live_modeled_values(1:length(t),i)= N_live; %y(:,2);
    xlabel('Time (h)','FontSize',20)
    ylabel('Log (Concentration) (CFU/ml)','FontSize',20)
    set(gca,'FontSize',20)
%     xlim([0 4])
%     ylim([6 8])
    xratio = 2;
    yratio = 1;
    widthWindow = 3.25;
    heightWindow = 2.5;
    grid on
end

Ntotal_modeled_values=log10(Ntotal_modeled_values);
N_live_modeled_values=log10(N_live_modeled_values);
Ndead=log10(10.^Ntotal_modeled_values-10.^N_live_modeled_values);
Ndead(Ndead<0.0001)=0; % used to convert -info to 0 

%%%%Color pickup c = uisetcolor([0.6 0.8 1])


%%   TIME KILL 1 mg/L

BacterioScan_Data_time_Kill_1_average=dataset_new{3};

TK_1_model=Ntotal_modeled_values(:,1);


TK_1_live=N_live_modeled_values(:,1);

TK_1_dead=Ndead(:,1);


%%   TIME KILL 4 mg/L 

BacterioScan_Data_time_Kill_4_average=dataset_new{4};

TK_4_model=Ntotal_modeled_values(:,2);

TK_4_live=N_live_modeled_values(:,2);

TK_4_dead=Ndead(:,2);

% Error of TK 4 
%% TIME KILL 16 mg/L

BacterioScan_Data_time_Kill_16_average=dataset_new{5};

TK_16_model=Ntotal_modeled_values(:,3);
% 
TK_16_live=N_live_modeled_values(:,3);

TK_16_dead=Ndead(:,3);


%% TIME KILL 64 mg/L

BacterioScan_Data_time_Kill_64_average=dataset_new{6};
TK_64_model=Ntotal_modeled_values(:,4);

TK_64_live=N_live_modeled_values(:,4);

TK_64_dead=Ndead(:,4);


%% TIME KILL 256 mg/L

BacterioScan_Data_time_Kill_256_average=dataset_new{7};
TK_256_model=Ntotal_modeled_values(:,5);

TK_256_live=N_live_modeled_values(:,5);


TK_256_dead=Ndead(:,5);

%% Introducting confidence bounds for Nlive cases 
%% TG Case 
time_1=time_1(1:21);


Nmax = 10^8;
XA=log10(Nmax);
No_TG=10^(log10(1330659.27332832)-1);
%  Kg = [2.31150862504853];


dKg=zeros(1,length(time_1));
dXA=zeros(1,length(time_1));
for i = 1:length(time_1(1:21))
dKg(i)=(time_1(i)*(Nmax - No_TG))/(log(10)*(Nmax - No_TG + No_TG*exp(Kg*time_1(i))));
dXA(i)=(No_TG*(exp(Kg*time_1(i)) - 1))/(No_TG*exp(Kg*time_1(i)) - No_TG + 10^XA);
% dNmax(i)=(No_TG*(exp(Kg*time_1(i)) - 1))/(Nmax*log(10)*(Nmax - No_TG + No_TG*exp(Kg*time_1(i))));
end

dKg=dKg';
dXA=dXA';
% dNmax=dNmax';

X_TG=[dKg,dXA];
conf_TG=0.67;

K_TG=2;

n_TG=length(time_1);

DOF_TG=n_TG-K_TG-1;%% do not include minus 1  look up standard reference. 

 for TG_loop=1:length(time_1)  
        %for time growth confidence 
        
        
       
 Error67_TG(TG_loop)=tinv(conf_TG+(1-conf_TG)/2,DOF_TG)...
                     *sqrt(X_TG(TG_loop,1:2)*(X_TG'*X_TG)^(-1)*X_TG(TG_loop,1:2)'); %For the time growth conf

 end 
 Error67_TG=Error67_TG';
%% TK case

%% C=1;
drmin=zeros(1,length(time_model((1:automation_1),1)));
dlambda=zeros(1,length(time_model((1:automation_1),1)));
dA=zeros(1,length(time_model((1:automation_1),1)));

for TK_loop=1:length(time_model((1:automation_1),1))
drmin(TK_loop)=-time_model(TK_loop,1)/log(10);
dlambda(TK_loop)=1/log(10);
dA(TK_loop)=-(time_model(TK_loop,1)*exp(-Final_A(1)*time_model(TK_loop,1)))/log(10);
end

drmin=drmin';
dlambda=dlambda';
dA=dA';

X_TK=[drmin,dlambda,dA];

K_TK=3;
n_TK=length(time_model((1:automation_1),1));
DOF_TK=n_TK-K_TK-1;

conf_TK=0.67;

for TK_loop_2=1:n_TK    
     
     Error67_TK(TK_loop_2)=tinv(conf_TK+(1-conf_TK)/2,DOF_TK)*sqrt(X_TK(TK_loop_2,1:3)*(X_TK'*X_TK)^(-1)*X_TK(TK_loop_2,1:3)'); %For the time kill conf

 end 
Error67_TK=Error67_TK';

%% C= 4 

drmin_4=zeros(1,length(time_model((1:automation_2),2)));
dlambda_4=zeros(1,length(time_model((1:automation_2),2)));
dA_4=zeros(1,length(time_model((1:automation_2),2)));

for TK_loop=1:length(time_model((1:automation_2),2))
    
drmin_4(TK_loop)=-time_model(TK_loop,2)/log(10);

dlambda_4(TK_loop)=1/log(10);

dA_4(TK_loop)=-(time_model(TK_loop,2)*exp(-Final_A(2)*time_model(TK_loop,2)))/log(10);

end

drmin_4=drmin_4';
dlambda_4=dlambda_4';
dA_4=dA_4';

X_TK_4=[drmin_4,dlambda_4,dA_4];

K_TK_4=3;
n_TK_4=length(time_model((1:automation_2),2));
DOF_TK_4=n_TK_4-K_TK_4-1;

conf_TK=0.67;

for TK_loop_2=1:n_TK_4    
     
     Error67_TK_4(TK_loop_2)=tinv(conf_TK+(1-conf_TK)/2,DOF_TK_4)*sqrt(X_TK_4(TK_loop_2,1:3)*(X_TK_4'*X_TK_4)^(-1)*X_TK_4(TK_loop_2,1:3)'); %For the time kill conf

 end 
Error67_TK_4=Error67_TK_4';

%% C=16
drmin_16=zeros(1,length(time_model((1:automation_3),3)));
dlambda_16=zeros(1,length(time_model((1:automation_3),3)));
dA_16=zeros(1,length(time_model((1:automation_3),3)));

for TK_loop=1:length(time_model((1:automation_3),3))
    
drmin_16(TK_loop)=-time_model(TK_loop,3)/log(10);

dlambda_16(TK_loop)=1/log(10);

dA_16(TK_loop)=-(time_model(TK_loop,3)*exp(-Final_A(3)*time_model(TK_loop,3)))/log(10);

end

drmin_16=drmin_16';
dlambda_16=dlambda_16';
dA_16=dA_16';

X_TK_16=[drmin_16,dlambda_16,dA_16];

K_TK_16=3;
n_TK_16=length(time_model((1:automation_3),3));
DOF_TK_16=n_TK_16-K_TK_16-1;

conf_TK=0.67;

for TK_loop_3=1:n_TK_16    
     
     Error67_TK_16(TK_loop_3)=tinv(conf_TK+(1-conf_TK)/2,DOF_TK_16)*sqrt(X_TK_16(TK_loop_3,1:3)*(X_TK_16'*X_TK_16)^(-1)*X_TK_16(TK_loop_3,1:3)'); %For the time kill conf

 end 
Error67_TK_16=Error67_TK_16';

%% C=64
drmin_64=zeros(1,length(time_model((1:automation_4),4)));
dlambda_64=zeros(1,length(time_model((1:automation_4),4)));
dA_64=zeros(1,length(time_model((1:automation_4),4)));

for TK_loop=1:length(time_model((1:automation_4),4))
    
drmin_64(TK_loop)=-time_model(TK_loop,4)/log(10);

dlambda_64(TK_loop)=1/log(10);

dA_64(TK_loop)=-(time_model(TK_loop,4)*exp(-Final_A(4)*time_model(TK_loop,4)))/log(10);

end

drmin_64=drmin_64';
dlambda_64=dlambda_64';
dA_64=dA_64';

X_TK_64=[drmin_64,dlambda_64,dA_64];

K_TK_64=3;
n_TK_64=length(time_model((1:automation_4),4));
DOF_TK_64=n_TK_64-K_TK_64-1;

conf_TK=0.67;

for TK_loop_2=1:n_TK_64    
     
     Error67_TK_64(TK_loop_2)=tinv(conf_TK+(1-conf_TK)/2,DOF_TK_64)*sqrt(X_TK_64(TK_loop_2,1:3)*(X_TK_64'*X_TK_64)^(-1)*X_TK_64(TK_loop_2,1:3)'); %For the time growth conf

 end 
Error67_TK_64=Error67_TK_64';

%% C=256
drmin_256=zeros(1,length(time_model((1:automation_5),5)));
dlambda_256=zeros(1,length(time_model((1:automation_5),5)));
dA_256=zeros(1,length(time_model((1:automation_5),5)));

for TK_loop=1:length(time_model((1:automation_5),5))
    
drmin_256(TK_loop)=-time_model(TK_loop,2)/log(10);

dlambda_256(TK_loop)=1/log(10);

dA_256(TK_loop)=-(time_model(TK_loop,2)*exp(-Final_A(5)*time_model(TK_loop,2)))/log(10);

end

drmin_256=drmin_256';
dlambda_256=dlambda_256';
dA_256=dA_256';

X_TK_256=[drmin_256,dlambda_256,dA_256];

K_TK_256=3;
n_TK_256=length(time_model((1:automation_5),5));
DOF_TK_256=n_TK_256-K_TK_256-1;

conf_TK=0.67;

for TK_loop_2=1:n_TK_256    
     
     Error67_TK_256(TK_loop_2)=tinv(conf_TK+(1-conf_TK)/2,DOF_TK_256)*sqrt(X_TK_256(TK_loop_2,1:3)*(X_TK_256'*X_TK_256)^(-1)*X_TK_256(TK_loop_2,1:3)'); %For the time growth conf

 end 
Error67_TK_256=Error67_TK_256';

%% Plotting characteristics 

alpha_shading=0.1;

% title('OpticalMethod Vs N_l_i_v_e Vs N_t_o_t_a_l Parameters based on OpticalMethod Results')
figure(1000)%Ntotal

Time_Growth_Model= log10(Nmax./(1+(Nmax./No_TG-1)*exp(-Kg*time_1(1:21)))); %log10 N(t)

plot(time_1(1:21),BacterioScan_Data_time_growth_average(1:21)-1,'o','color',[0 0 0],...
    'MarkerFaceColor',[0.0745    0.6235    1.0000])
hold on 

plot(TIME_TG(1:21,1),TG_model(1:21,1),'-','color',[0.4118    0.6000    0.7882],'LineWidth',linewidth)
hold on 

plot(X(1:21,1),Time_Growth_Model(1:21),'--','color',[0.4118    0.6000    0.7882],'LineWidth',linewidth)

x3=TIME_TG(1:21,1)';
x2 = [x3, fliplr(x3)];

hold on
inBetween = [Time_Growth_Model(1:21,1)'+Error67_TG', fliplr(Time_Growth_Model(1:21,1)')];
fill(x2, inBetween, 'b');
hold on
inBetween = [Time_Growth_Model(1:21,1)'-Error67_TG', fliplr(Time_Growth_Model(1:21,1)')];
fill(x2, inBetween, 'b');
alpha(alpha_shading)
 hold on
e=plot(TIME_TG(1:21,1),Time_Growth_Model(1:21,1)+Error67_TG,'-w','LineWidth',0.05);
 hold on
f= plot(TIME_TG(1:21,1),Time_Growth_Model(1:21,1)-Error67_TG,'-w','LineWidth',0.05);
hold on
plot(TIME_TG(1:21,1),Time_Growth_Model(1:21,1),'-w','LineWidth',0.05);


legend({' ${\mbox{Data}}$','${\mbox{Fitted Model}}$','$N_{\mbox{Live}}$  ${\mbox{Model}}$'},'Interpreter','latex',...
       'FontSize',20)

xlabel('Time (h)','FontSize',20)
ylabel('Log (Concentration) (CFU/ml)','FontSize',20)
set(gca,'FontSize',20)
% xlim([0 1.9])
% ylim([6.1 8.3])
xratio = 2;
yratio = 1;
widthWindow = 3.25;
heightWindow = 2.5;
title('C=0 mg/L','FontSize',20)
grid on

hold off
%% c=1
time_1=X(1:automation_1,1);
figure(1001)
plot(time_1(1:automation_1),BacterioScan_Data_time_Kill_1_average(1:automation_1),'o','color',[0 0 0],...
    'MarkerFaceColor',[1.0000    0.8392    0.6000])
    hold on
plot(time_model((1:automation_1),1),TK_1_model(1:automation_1),'-','color',[0.8588    0.6627    0.3686],'LineWidth',linewidth)
hold on 
plot(time_model((1:automation_1),1),TK_1_live(1:automation_1),'--','color',[0.8588    0.6627    0.3686],'LineWidth',linewidth)
hold on 
plot(time_model((1:automation_1),1),TK_1_dead(1:automation_1),'-.','color',[0.8588    0.6627    0.3686],'LineWidth',1)

hold on

x3=time_model((1:automation_1),1)';
x2 = [x3, fliplr(x3)];

inBetween = [TK_1_live(1:automation_1)'+Error67_TK', fliplr(TK_1_live(1:automation_1)')];
fill(x2, inBetween, 'y');
hold on
inBetween = [TK_1_live(1:automation_1)'-Error67_TK', fliplr(TK_1_live(1:automation_1)')];
fill(x2, inBetween, 'y');
alpha(alpha_shading+0.2)
 hold on
e=plot(time_model((1:automation_1),1),TK_1_live(1:automation_1)+Error67_TK,'-w','LineWidth',0.05);
 hold on
f= plot(time_model((1:automation_1),1),TK_1_live(1:automation_1)-Error67_TK,'-w','LineWidth',0.05);
hold on 
 plot(time_model((1:automation_1),1),TK_1_live(1:automation_1),'-w','LineWidth',0.05);

legend({'${\mbox{Data}}$','${\mbox{Model}}$','$N_{\mbox{Live}}$ ${\mbox{Model}}$','$N_{\mbox{Dead}}$ ${\mbox{Model}}$'},'Interpreter','latex',...
       'FontSize',20)
   
xratio = 2;
yratio = 1;
widthWindow = 4.25;
heightWindow = 3.5;   
xlabel('Time (h)')
ylabel('Log (Concentration) (CFU/ml)')
set(gca,'FontSize',20)
% xlim([0 1.1])
% ylim([6.1 7])
title('C=1/0.5 mg/L','FontSize',20)
grid on

%% C=4
figure(1002)
 plot(time_1(1:automation_2),BacterioScan_Data_time_Kill_4_average,'o','color',[0 0 0],...
    'MarkerFaceColor',[0.4078    0.2392    0.6588])
    hold on
plot(time_model(1:automation_2,2),TK_4_model(1:automation_2),'-','color',[0.6706    0.5020    0.8196],'LineWidth',linewidth)
hold on 
plot(time_model(1:automation_2,2),TK_4_live(1:automation_2),'--','color',[0.6706    0.5020    0.8196],'LineWidth',linewidth)
hold on 
plot(time_model(1:automation_2,2),TK_4_dead(1:automation_2),'-.','color',[0.6706    0.5020    0.8196],'LineWidth',1)


hold on

x3=time_model(1:automation_2,2)';
x2 = [x3, fliplr(x3)];

inBetween = [TK_4_live(1:automation_2)'+Error67_TK_4', fliplr(TK_4_live(1:automation_2)')];
fill(x2, inBetween,[0.6706    0.5020    0.8196]);
hold on
inBetween = [TK_4_live(1:automation_2)'-Error67_TK_4', fliplr(TK_4_live(1:automation_2)')];
fill(x2, inBetween, [0.6706    0.5020    0.8196]);
alpha(alpha_shading+0.4)
 hold on
e=plot(time_model(1:automation_2),TK_4_live(1:automation_2)+Error67_TK_4,'-w','LineWidth',0.05);
 hold on
f= plot(time_model(1:automation_2),TK_4_live(1:automation_2)-Error67_TK_4,'-w','LineWidth',0.05);
hold on 
 plot(time_model(1:automation_2),TK_4_live(1:automation_2),'-w','LineWidth',0.05);

hold on 
plot(20,1.6,'o','color',[0 0 0],...
    'MarkerFaceColor',[0.4078    0.2392    0.6588])
legend({'${\mbox{Data}}$','${\mbox{Model}}$','$N_{\mbox{Live}}$ ${\mbox{Model}}$','$N_{\mbox{Dead}}$ ${\mbox{Model}}$'},'Interpreter','latex',...
       'FontSize',20)
   
   
xratio = 2;
yratio = 1;
widthWindow = 3.25;
heightWindow = 2.5;   
xlabel('Time (h)')
ylabel('Log (Concentration) (CFU/ml)')
set(gca,'FontSize',20)
 xlim([0 20])
ylim([0 6.4])
title('C=4/2 mg/L','FontSize',20)
grid on


figure(1003)
plot(time_1(1:automation_3),BacterioScan_Data_time_Kill_16_average,'o','color',[0 0 0],...
    'MarkerFaceColor',[0.5843    0.9020    0.5059])
    hold on
plot(time_model(1:automation_3,3),TK_16_model(1:automation_3),'-','color',[0.2039    0.4392    0.2667 ],'LineWidth',linewidth)
hold on 
plot(time_model(1:automation_3,3),TK_16_live(1:automation_3),'--','color',[0.2039    0.4392    0.2667 ],'LineWidth',linewidth)
hold on  
plot(time_model(1:automation_3,3),TK_16_dead(1:automation_3),'-.','color',[0.2039    0.4392    0.2667 ],'LineWidth',1)
 
hold on

x3=time_model(1:automation_3,3)';
x2 = [x3, fliplr(x3)];

inBetween = [TK_16_live(1:automation_3)'+Error67_TK_16', fliplr(TK_16_live(1:automation_3)')];
fill(x2, inBetween,[0.2039    0.4392    0.2667 ]);
hold on
inBetween = [TK_16_live(1:automation_3)'-Error67_TK_16', fliplr(TK_16_live(1:automation_3)')];
fill(x2, inBetween, [0.2039    0.4392    0.2667 ]);
alpha(alpha_shading+0.2)
 hold on
e=plot(time_model(1:automation_3,3),TK_16_live(1:automation_3)+Error67_TK_16,'-w','LineWidth',0.05);
 hold on
f= plot(time_model(1:automation_3,3),TK_16_live(1:automation_3)-Error67_TK_16,'-w','LineWidth',0.05);
hold on 
 plot(time_model(1:automation_3,3),TK_16_live(1:automation_3),'-w','LineWidth',0.05);
 
 
legend({'${\mbox{Data}}$','${\mbox{Model}}$','$N_{\mbox{Live}}$ ${\mbox{Model}}$','$N_{\mbox{Dead}}$ ${\mbox{Model}}$'},'Interpreter','latex',...
       'FontSize',20)  

   
xratio = 2;
yratio = 1;
widthWindow = 3.25;
heightWindow = 2.5;   
xlabel('Time (h)')
ylabel('Log (Concentration) (CFU/ml)')
set(gca,'FontSize',20)
%   xlim([0 0.6])
%  ylim([6.1 6.3])
title('C=16/8 mg/L','FontSize',20)
grid on


figure(1004)
plot(time_1(1:automation_4),BacterioScan_Data_time_Kill_64_average,'o','color',[0 0 0],...
    'MarkerFaceColor',[0 0 0])
    hold on
plot(time_model(1:automation_4,4),TK_64_model(1:automation_4),'-','color',[0.5 0.5 0.5 ],'LineWidth',linewidth)
hold on 
plot(time_model(1:automation_4,4),TK_64_live(1:automation_4),'--','color',[0.5 0.5 0.5 ],'LineWidth',linewidth)
hold on 
plot(time_model(1:automation_4,4),TK_64_dead(1:automation_4),'-.','color',[0.5 0.5 0.5 ],'LineWidth',1)

hold on

x3=time_model(1:automation_4,4)';
x2 = [x3, fliplr(x3)];

inBetween = [TK_64_live(1:automation_4)'+Error67_TK_64', fliplr(TK_64_live(1:automation_4)')];
fill(x2, inBetween,[0 0 0 ]);
hold on
inBetween = [TK_64_live(1:automation_4)'-Error67_TK_64', fliplr(TK_64_live(1:automation_4)')];
fill(x2, inBetween, [0 0 0 ]);
alpha(alpha_shading+0.2)
 hold on
e=plot(time_model(1:automation_4,4),TK_64_live(1:automation_4)+Error67_TK_64,'-w','LineWidth',0.05);
 hold on
f= plot(time_model(1:automation_4,4),TK_64_live(1:automation_4)-Error67_TK_64,'-w','LineWidth',0.05);
hold on 
 plot(time_model(1:automation_4,4),TK_64_live(1:automation_4),'-w','LineWidth',0.05);
 
 

legend({'${\mbox{Data}}$','${\mbox{Model}}$','$N_{\mbox{Live}}$ ${\mbox{Model}}$','$N_{\mbox{Dead}}$ ${\mbox{Model}}$'},'Interpreter','latex',...
       'FontSize',20)
   
xratio = 2;
yratio = 1;
widthWindow = 3.25;
heightWindow = 2.5;   
xlabel('Time (h)')
ylabel('Log (Concentration) (CFU/ml)')
set(gca,'FontSize',20)
%    xlim([0 0.5])
%   ylim([5.9 6.1])
title('C=64/32 mg/L','FontSize',20)
grid on

%% C=256
figure(1005)
plot(time_1(1:automation_5),BacterioScan_Data_time_Kill_256_average,'o','color',[0.5 0.5 0.5],...
    'MarkerFaceColor',[1 0.2 0.2])
    hold on
plot(time_model(1:automation_5,5),TK_256_model(1:automation_5),'-','color',[1 0.2 0.2],'LineWidth',linewidth)
plot(time_model(1:automation_5,5),TK_256_live(1:automation_5),'--','color',[1 0.2 0.2],'LineWidth',linewidth)
hold on 
plot(time_model(1:automation_5,5),TK_256_dead(1:automation_5),'-.','color',[1 0.2 0.2],'LineWidth',1)

hold on

x3=time_model(1:automation_5,5)';
x2 = [x3, fliplr(x3)];

inBetween = [TK_256_live(1:automation_5)'+Error67_TK_256', fliplr(TK_256_live(1:automation_5)')];
fill(x2, inBetween,[1 0.2 0.2 ]);
hold on
inBetween = [TK_256_live(1:automation_5)'-Error67_TK_256', fliplr(TK_256_live(1:automation_5)')];
fill(x2, inBetween, [1 0.2 0.2 ]);
alpha(alpha_shading+0.2)
 hold on
e=plot(time_model(1:automation_5,5),TK_256_live(1:automation_5)+Error67_TK_256,'-w','LineWidth',0.05);
 hold on
f= plot(time_model(1:automation_5,5),TK_256_live(1:automation_5)-Error67_TK_256,'-w','LineWidth',0.05);
hold on 
 plot(time_model(1:automation_5,5),TK_256_live(1:automation_5),'-w','LineWidth',0.05);
 
 
legend({'${\mbox{Data}}$','${\mbox{Model}}$','$N_{\mbox{Live}}$ ${\mbox{Model}}$','$N_{\mbox{Dead}}$ ${\mbox{Model}}$'},'Interpreter','latex',...
       'FontSize',20)
   
xratio = 2;
yratio = 1;
widthWindow = 3.25;
heightWindow = 2.5;   
xlabel('Time (h)')
ylabel('Log (Concentration) (CFU/ml)')
set(gca,'FontSize',20)
%     xlim([0 0.7])
%    ylim([6 6.2])
title('C=256/128 mg/L','FontSize',20)
grid on

% figure(2000) %Nlive+Ndead

% plot(time_live,TG_live,'--','color',[0.4118    0.6000    0.7882],'LineWidth',linewidth)
% hold on   
% plot(time_dead,TG_dead,'+','color',[0.4118    0.6000    0.7882],'LineWidth',1)
% hold on

%% m(t) and s(t)
clearvars -except y_modeled_values  xq1 Kg Nmax Kd Final_rmin  Final_A Final_lambda SD Final_values Best_FIT_FINAL Final_values Error_all Ntotal_modeled_values time_1

dataset=xlsread('BacterioScan CAZ+AMK AB747 (5 log) raw data 0222_AKIS.xlsx','Data','AQ3:AW190'); %updated data set 

time11=dataset(:,1);

Coloration=[[0.8588    0.6627    0.3686],[0.6706    0.5020    0.8196],[0.2039    0.4392    0.2667 ],[0 0 0 ],[1 0.2 0.2]  ];


for i=1:length(Final_rmin)
    mew_time(1:length(time11),i)=Final_rmin(i)+Final_lambda(i)*Final_A(i)*exp(-Final_A(i).*time11);
    % figure(10)
    % plot(time11,mew_time(1:235,i),'-','color',[Coloration(i:i+2)],'LineWidth',4)
    % hold on
end

%% Confidence intervals of mu
for i =1:length(Final_rmin)  
    Par_rmin(1:length(time11),i)=1*ones(length(time11),1);
    Par_lambda(1:length(time11),i)=Final_A(i)*exp(-Final_A(i).*time11);
    Par_a(1:length(time11),i)=-Final_lambda(i)*exp(-Final_A(i).*time11).*(Final_A(i).*time11 - 1);
end

W_1=[Par_rmin(1:length(time11),1),Par_lambda(1:length(time11),1),Par_a(1:length(time11),1)];

W_4=[Par_rmin(1:length(time11),2),Par_lambda(1:length(time11),2),Par_a(1:length(time11),2)];
W_16=[Par_rmin(1:length(time11),3),Par_lambda(1:length(time11),3),Par_a(1:length(time11),3)];
W_64=[Par_rmin(1:length(time11),4),Par_lambda(1:length(time11),1),Par_a(1:length(time11),4)];
W_256=[Par_rmin(1:length(time11),5),Par_lambda(1:length(time11),5),Par_a(1:length(time11),5)];

DOF=4;
conf=[0.67];

    
for l=1:length(conf)    
    Error_67_1(l)=tinv(conf(1)+(1-conf(1))/2,DOF)*sqrt(W_1(l,1:3)*(W_1'*W_1)^(-1)*W_1(l,1:3)'); %
    Error_67_4(l)=tinv(conf(1)+(1-conf(1))/2,DOF)*sqrt(W_4(l,1:3)*(W_4'*W_4)^(-1)*W_4(l,1:3)'); %For the time growth conf
    Error_67_16(l)=tinv(conf(1)+(1-conf(1))/2,DOF)*sqrt(W_16(l,1:3)*(W_16'*W_16)^(-1)*W_16(l,1:3)'); %For the time growth conf
    Error_67_64(l)=tinv(conf(1)+(1-conf(1))/2,DOF)*sqrt(W_64(l,1:3)*(W_64'*W_64)^(-1)*W_64(l,1:3)'); %For the time growth conf
    Error_67_256(l)=tinv(conf(1)+(1-conf(1))/2,DOF)*sqrt(W_256(l,1:3)*(W_256'*W_256)^(-1)*W_256(l,1:3)'); %For the time growth conf
end 
time11=time11';
figure(10)

y1=mew_time(:,1)'+Error_67_1;
y2=mew_time(:,1)'-Error_67_1;

y3=mew_time(:,2)'+Error_67_4;
y4=mew_time(:,2)'-Error_67_4;

y5=mew_time(:,3)'+Error_67_16;
y6=mew_time(:,3)'-Error_67_16;

y7=mew_time(:,4)'+Error_67_64;
y8=mew_time(:,4)'-Error_67_64;

y9=mew_time(:,5)'+Error_67_256;
y10=mew_time(:,5)'-Error_67_256;

Coloration=[0 0 0.8588    0.6627    0.3686 1 0 1 0 0 1 1 0 0 0 1 0];

for i=1:length(Final_A)
    plot(time11,mew_time(1:length(time11),i),'--','color',[Coloration(3*i:3*i+2)],'LineWidth',4)
    hold on
    % SMART=Coloration(i:i+2)
end
hold on
patch([time11 fliplr(time11)], [ y1 fliplr(mew_time(:,1)')], 'y')
hold on 
patch([time11 fliplr(time11)], [ mew_time(:,1)' fliplr(y2)], 'y')
hold on 
plot(time11,mew_time(:,1)'+Error_67_1,'-w','LineWidth',0.01)
hold on 
plot(time11,mew_time(:,1)'-Error_67_1,'-w','LineWidth',0.01)
hold on 

patch([time11 fliplr(time11)], [ y3 fliplr(mew_time(:,2)')], 'm')
hold on 
patch([time11 fliplr(time11)], [ mew_time(:,2)' fliplr(y4)], 'm')
hold on 
plot(time11,mew_time(:,2)'+Error_67_4,'-w','LineWidth',0.01)
hold on 
plot(time11,mew_time(:,2)'-Error_67_4,'-w','LineWidth',0.01)
hold on 


patch([time11 fliplr(time11)], [ y5 fliplr(mew_time(:,3)')], 'b')
hold on 
patch([time11 fliplr(time11)], [ mew_time(:,3)' fliplr(y6)], 'b')
hold on 
plot(time11,mew_time(:,3)'+Error_67_16,'-w','LineWidth',0.01)
hold on 
plot(time11,mew_time(:,3)'-Error_67_16,'-w','LineWidth',0.01)
hold on 

patch([time11 fliplr(time11)], [ y7 fliplr(mew_time(:,4)')], 'r')
hold on 
patch([time11 fliplr(time11)], [ mew_time(:,4)' fliplr(y8)], 'r')
hold on 
plot(time11,mew_time(:,4)'+Error_67_64,'-w','LineWidth',0.01)
hold on 
plot(time11,mew_time(:,4)'-Error_67_64,'-w','LineWidth',0.01)
hold on 

patch([time11 fliplr(time11)], [ y9 fliplr(mew_time(:,5)')], 'g')
hold on 
patch([time11 fliplr(time11)], [ mew_time(:,5)' fliplr(y10)], 'g')
hold on 
plot(time11,mew_time(:,5)'+Error_67_256,'-w','LineWidth',0.01)
hold on 
plot(time11,mew_time(:,5)'-Error_67_256,'-w','LineWidth',0.01)
hold on 

alpha(0.3)
for i=1:length(Final_A)
plot(time11,mew_time(1:length(time11),i),'-w','LineWidth',4)

plot(time11,mew_time(1:length(time11),i),'--','color',[Coloration(3*i:3*i+2)],'LineWidth',4)
hold on
% SMART=Coloration(i:i+2)
end



legend({'\mu (C_m_a_x=1/0.5)  ','\mu (C_m_a_x=4/2)','\mu (C_m_a_x=16/8)','\mu (C_m_a_x=64/32)','\mu (C_m_a_x=256/128)'},...
       'FontSize',17,'Location','eastoutside','Orientation','vertical')
title('No redose''Decline of C') 
xlabel('Time (h)')
ylabel('\mu')
set(gca,'FontSize',19)
xlim([0 20])
grid on



for i=1:length(Final_A)
    sigma_time_squared(1:length(time11),i)=Final_lambda(i)*Final_A(i)^2*exp(-Final_A(i).*time11);
    figure(20)
    plot(time11,sigma_time_squared(1:length(time11),i),'--','color',[Coloration(i:i+2)],'LineWidth',4)
    hold on
end  
legend({'\sigma^2(C_m_a_x=1/0.5)','\sigma^2(C_m_a_x=4/2)','\sigma^2(C_m_a_x=16/8)','\sigma^2(C_m_a_x=64/32)','\sigma^2(C_m_a_x=256/128)'},...
       'FontSize',17,'Location','eastoutside','Orientation','vertical')
 
xlabel('Time (h)')
ylabel('\sigma^2')
set(gca,'FontSize',19)
xlim([0 20])
grid on
%% Rmin over time 
% dataset=xlsread('Akis_7_5_max_condition_NK_DATA_MODIFICATION.xlsx','Sheet1','BY6:BY8');


X=[1 4 16 64 256]';

beta0=[2.21 2.88 2.79];

modelfun=@(b,x)b(1).*x.^b(2)./(x.^b(2)+b(3)^b(2));

opts=statset('glmfit');

opts.MaxIter = 2000;


mdl = fitnlm(X,Final_rmin,modelfun,beta0,'Options',opts)

CM = mdl.CoefficientCovariance;

Nikolaou=inv(diag(sqrt(diag(CM))));
CM2=Nikolaou*CM*Nikolaou; %correlation matrxi 

for i=1:length(beta0)
    b(i)=mdl.Coefficients.Estimate(i,1);
end
b=b';
Kb=	b(1);
Hb=	b(2);
C50b=b(3);

C_original=[1 4 16 64 256]';%256
C_conf=linspace(0.001,256,1000);
Rmin_conf=Kb.*C_conf.^Hb./(C_conf.^Hb+C50b^Hb);

figure(1212)
q1=plot(C_original,Final_rmin,'or',...
    'MarkerFaceColor',[1 0 0]); % data points 
% hold on 
%  e=errorbar(C_original,Final_rmin,SD(1,1:5),'.');
%  e.Color='r';
%  e.CapSize = 15;
  
hold on 
q2= plot(C_conf,Rmin_conf,'-','color',[0.0745    0.6235    1.0000],...
    'MarkerFaceColor',[0.0745    0.6235    1.0000]); % Modeled data 
grid on 
hold off


half_life=2.5;%hours
% Period=8;%hours

Cmax=[1 4 16 64 256];

figure(30)
for i=1:length(Cmax)
    C(1:length(time11),i)=Cmax(i)*exp(-log(2)/half_life*time11);
    RMIN_time(1:length(time11),i)=Kb*C(1:length(time11),i).^Hb./(C(1:length(time11),i).^Hb+C50b^Hb);
    plot(time11,RMIN_time(1:length(time11),i),'--','color',[Coloration(i:i+2)],'LineWidth',4)
    hold on
end
hold on 
plot(time11,Kg*ones(length(time11),1),'-r','LineWidth',4)

legend({'r_m_i_n(C_m_a_x=1/0.5)','r_m_i_n(C_m_a_x=4/2)','r_m_i_n(C_m_a_x=16/8)','r_m_i_n(C_m_a_x=64/32)','r_m_i_n(C_m_a_x=256/128)','Kg'},...
       'FontSize',17,'Location','eastoutside','Orientation','vertical')

   title('No redose',' Decline of C: C=C_m_a_x \ite^{-a t}')
xlabel('Time (h)')
ylabel('r_m_i_n')
set(gca,'FontSize',19)
% xlim([0 1.5])
grid on

coefCI(mdl)