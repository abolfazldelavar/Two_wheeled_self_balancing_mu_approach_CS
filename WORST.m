
% closeloop with Knom-----
Grob{1}                = lft(P, Knom);
GrobFrq{1}             = frd(Grob{1}, frqs);
[RobPer{1}, muinfo{1}] = mussv(GrobFrq{1}, blk2); %Robust  Performance


% find the maximum point in robust performance and get it index frequency
mudata = frdata(RobPer{1});
maxmu  = max(mudata);
maxidx = find(maxmu==max(maxmu));
maxidx = maxidx(1);

% get the Delta in maximum point of robust performance
Delta0       = mussvunwrap(muinfo{1});
Delta0data   = frdata(Delta0);
Delta0data_w = Delta0data(:,:,maxidx);

% Fit a stste-space dynamic model that is equal to Delta in maximum point
Delta0_wc = ss(zeros(length(Iv),length(Iz)));
s = tf('s');
for i = 1:5
    delta_i = Delta0data_w(i,i);
    gamma = abs(delta_i);
    if imag(delta_i)>0
        delta_i = -1*delta_i;
        gamma = -1*gamma;
    end
    x = real(delta_i)/abs(gamma);
    tau = 2*frqs(maxidx)*sqrt((1+x)/(1-x));
    Delta0_wc(i,i) = gamma*(-s + tau/2)/(s + tau/2);
end
% Normalized the dynamic model, because the norm of Delta is 1
nDelta = norm(Delta0data_w);
Delta0_wc = Delta0_wc/nDelta;

% Closeloop with un worst case uncertainty and Knom (Kinfty)---------------
Ksim              = Knom;
[AA, BB, CC, DD]  = linmod('closeloop');
Pclose            = ss(AA,BB,CC,DD); %P-K
set(Pclose, 'inputname', {'v_1','v_2','v_3','v_4','v_5','Right Dist','Left Dist','Ref u','Ref theta',...
      'noise'},'outputname',{'z_1','z_2','z_3','z_4','z_5',...
      'error_g_a_m_m_a','error_u','error_t_h_e_t_a','RTE','LTE',...
      'gamma','u','theta'});
Ppert = lft(Delta0_wc, Pclose);
Ppert_f = frd(Ppert, frqs);
GKWC1               = Ppert([6,7,8,4,5],:);    
GKWC1               = minreal(GKWC1);

ns                 = 1000;
time               = linspace(0,50,ns)';
Input_signals(:,1) = [zeros(400,1); 0.1*ones(200,1); zeros(ns-600,1)]; %Right Dist
Input_signals(:,2) = [zeros(600,1); 0.1*ones(200,1); zeros(ns-800,1)]; %Left Dist
Input_signals(:,3) = [zeros(50,1); ones(ns-50,1)];  %Ref u
Input_signals(:,4) = [zeros(250,1); ones(ns-250,1)]; %Ref theta
Input_signals(:,5) = 0.1*randn(ns,1) + 0.01; %noise

data_worst_inf = lsim(GKWC1, Input_signals,time);

% Closeloop with un worst case uncertainty and Krobust (Kmiu)--------------
Ksim              = SelectedController;
[AA, BB, CC, DD]  = linmod('closeloop');
Pclose            = ss(AA,BB,CC,DD); %P-K
set(Pclose, 'inputname', {'v_1','v_2','v_3','v_4','v_5','Right Dist','Left Dist','Ref u','Ref theta',...
      'noise'},'outputname',{'z_1','z_2','z_3','z_4','z_5',...
      'error_g_a_m_m_a','error_u','error_t_h_e_t_a','RTE','LTE',...
      'gamma','u','theta'});
Ppert = lft(Delta0_wc, Pclose);
Ppert_f = frd(Ppert, frqs);
GKWC2              = Ppert([6,7,8,4,5],:);    
GKWC2              = minreal(GKWC2);

ns                 = 1000;
time               = linspace(0,50,ns)';
Input_signals(:,1) = [zeros(400,1); 0.1*ones(200,1); zeros(ns-600,1)]; %Right Dist
Input_signals(:,2) = [zeros(600,1); 0.1*ones(200,1); zeros(ns-800,1)]; %Left Dist
Input_signals(:,3) = [zeros(50,1); ones(ns-50,1)];  %Ref u
Input_signals(:,4) = [zeros(250,1); ones(ns-250,1)]; %Ref theta
Input_signals(:,5) = 0.1*randn(ns,1) + 0.01; %noise

data_worst_mu = lsim(GKWC2, Input_signals,time);

inf_lim = 400;

figure();
subplot(511); hold on;
    yline(0, ':', 'HandleVisibility', 'off');
    plot(time, data_worst_mu(:,1), 'Linewidth', 1);
    plot(time(1:inf_lim), data_worst_inf(1:inf_lim,1), '--', 'Linewidth', 1);
    ylabel('$\gamma$');
    ylim([-0.05 0.05]);
subplot(512); hold on;
    yline(1, ':', 'HandleVisibility', 'off');
    plot(time, data_worst_mu(:,2), 'Linewidth', 1);
    plot(time(1:inf_lim), data_worst_inf(1:inf_lim,2), '--', 'Linewidth', 1);
    ylabel('$u$');
    ylim([-0.2 1.5]);
    lgd = legend('$K_\mu$','$K_\infty$', 'Location', 'southeast', 'Orientation', 'horizontal');
subplot(513); hold on;
    yline(1, ':', 'HandleVisibility', 'off');
    plot(time, data_worst_mu(:,3), 'Linewidth', 1);
    plot(time(1:inf_lim), data_worst_inf(1:inf_lim,3), '--', 'Linewidth', 1);
    ylabel('$\theta$');
    ylim([-0.2 1.5]);
subplot(514); hold on;
    yline(0, ':', 'HandleVisibility', 'off');
    plot(time, data_worst_mu(:,4), 'Linewidth', 1);
    plot(time(1:inf_lim), data_worst_inf(1:inf_lim,4), '--', 'Linewidth', 1);
    ylabel('$\tau_r$');
    ylim([-0.5 0.5]);
subplot(515); hold on;
    yline(0, ':', 'HandleVisibility', 'off');
    plot(time, data_worst_mu(:,5), 'Linewidth', 1);
    plot(time(1:inf_lim), data_worst_inf(1:inf_lim,5), '--', 'Linewidth', 1);
    ylabel('$\tau_l$');
    xlabel('Time (s)');
    ylim([-0.5 0.5]);
sgtitle('Linear simulation -- worst case');
plt.isi('hwratio', 1, 'save', 'linear_simulation_worst');

disp('END PART: WORST -----------------------------------------------------');


