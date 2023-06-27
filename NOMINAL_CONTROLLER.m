%% --------- Stablizing nominal system ------- NOMINAL SYSTEM ANALYSIS ----
Gnom                = P([Ie;Iy],[Iw;Iu]);
Gnom                = minreal(Gnom);
[Knom, ~, ~, ~]     = hinfsyn(Gnom, numel(Iy), numel(Iu), 'METHOD', 'ric');
Ksim                = Knom;
[AA, BB, CC, DD]    = linmod('closeloop');
PKn                 = ss(AA,BB,CC,DD); %P-K-nominal
GKnom               = PKn([11,12,13,9,10],Iw);    
GKnom               = minreal(GKnom);
set(GKnom, 'inputname', {'Right Dist','Left Dist','Ref u','Ref theta','noise'},...
    'outputname',{'gamma','u','theta','RTE','LTE'});

ns                 = 1000;
time               = linspace(0,50,ns)';
varn               = 0.1;

Input_signals(:,1) = [zeros(400,1); 0.1*ones(200,1); zeros(ns-600,1)]; %Right Dist
Input_signals(:,2) = [zeros(600,1); 0.1*ones(200,1); zeros(ns-800,1)]; %Left Dist
Input_signals(:,3) = [zeros(50,1); ones(ns-50,1)];  %Ref u
Input_signals(:,4) = [zeros(250,1); ones(ns-250,1)]; %Ref theta
Input_signals(:,5) = zeros(ns,1); %noise

figure();
subplot(411); hold on;
    yline(0.1, ':');
    plot(time, Input_signals(:,1), 'Linewidth', 1);
    title('Inputs');
    ylabel('$D_r$');
    ylim([-0.02 0.12]);
subplot(412); hold on;
    yline(0.1, ':');
    plot(time, Input_signals(:,2), 'Linewidth', 1);
    ylabel('$D_l$');
    ylim([-0.02 0.12]);
subplot(413); hold on;
    yline(1, ':');
    plot(time, Input_signals(:,3), 'Linewidth', 1);
    ylabel('$R_u$');
    ylim([-0.1 1.15]);
subplot(414); hold on;
    yline(1, ':');
    plot(time, Input_signals(:,4), 'Linewidth', 1);
    ylabel('$R_\theta$');
    xlabel('Time (s)');
    ylim([-0.1 1.15]);
plt.isi('hwratio', 1, 'save', 'inputs');

data_nominal = lsim(GKnom, Input_signals, time);

disp('END PART: NOMINAL CONTROLLER ----------------------------------------');