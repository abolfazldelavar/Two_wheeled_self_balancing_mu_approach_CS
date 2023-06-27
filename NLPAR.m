
Ksim = SelectedController;

h8 = figure();
subplot(511); hold on;
    yline(0, ':', 'HandleVisibility', 'off');
    ylabel('$\gamma$');
    title('Nonlinear system outputs - $K_\mu$');
subplot(512); hold on;
    yline(1, ':', 'HandleVisibility', 'off');
    ylabel('$u$');
subplot(513); hold on;
    yline(1, ':', 'HandleVisibility', 'off');
    ylabel('$\theta$');
subplot(514); hold on;
    yline(0, ':', 'HandleVisibility', 'off');
    ylabel('$\tau_r$');
subplot(515); hold on;
    yline(0, ':', 'HandleVisibility', 'off');
    xlabel('Time (s)');
    ylabel('$\tau_l$');
    
for i = 1:4
    NLsimpar = [segway.param.nom.m_ch   *(1 + 2*segway.param.per.delta_mch*(rand-0.5));
                segway.param.nom.m_w    *(1 + 2*segway.param.per.delta_m_w*(rand-0.5));
                segway.param.nom.I_xxch *(1 + 2*segway.param.per.delta_Ixx*(rand-0.5));
                segway.param.nom.I_yych *(1 + 2*segway.param.per.delta_Iyy*(rand-0.5));
                segway.param.nom.I_zzch *(1 + 2*segway.param.per.delta_Izz*(rand-0.5));
                segway.param.nom.I_w    *(1 + 2*segway.param.per.delta_Iw*(rand-0.5));
                segway.param.nom.g      *(1 + 2*segway.param.per.delta_g*(rand-0.5));
                segway.param.nom.r_w    *(1 + 2*segway.param.per.delta_r_w*(rand-0.5));
                segway.param.nom.l      *(1 + 2*segway.param.per.delta_l*(rand-0.5));
                segway.param.nom.h      *(1 + 2*segway.param.per.delta_h*(rand-0.5))];
    
    test = sim('NLclose');
    
    seli = floor(linspace(1, size(test.gamma.Time, 1), 600));
    
    figure(h8);
    subplot(511);
        hold on;
        plot(test.gamma.Time(seli), test.gamma.Data(seli), 'Linewidth', 1);
    subplot(512);
        hold on;
        plot(test.u.Time(seli), test.u.Data(seli), 'Linewidth', 1);
    subplot(513);
        hold on;
        plot(test.theta.Time(seli), test.theta.Data(seli), 'Linewidth', 1);
    subplot(514);
        hold on;
        plot(test.Tr.Time(seli), test.Tr.Data(seli), 'Linewidth', 1);
    subplot(515);
        hold on;
        plot(test.Tl.Time(seli), test.Tl.Data(seli), 'Linewidth', 1);
    disp(['Nonlinear model - ' num2str(i)]);
end
plt.isi('hwratio', 1, 'save', 'nonlinear_simulation_mu');


seli = floor(linspace(1, size(test.sens.Time, 1), 1000));
figure();
subplot(311);
    plot(test.sens.Time(seli), test.sens.Data(seli,1), 'color', [0.2,0.2,0.2]);
    ylabel('$\gamma$');
    title('Nonlinear system measurements - $K_\mu$');
subplot(312);
    plot(test.sens.Time(seli), test.sens.Data(seli,2), 'color', [0.2,0.2,0.2]);
    ylabel('$u$');
subplot(313);
    plot(test.sens.Time(seli), test.sens.Data(seli,3), 'color', [0.2,0.2,0.2]);
    ylabel('$\theta$');
    xlabel('Time (s)');
plt.isi('save', 'measurements');

% ---------------------------

%Run Nonlinear with 'Knom' and Uncertainty
% In this section, 5 simulations are plotted whose data has been provided
% before. However, you can run the above piece of code with 'Knom' to check
% the nonlinear system under uncertainty controlled by infinity controller.

load UN.mat
figure();
time = struct();
numvec = struct();
seli = struct();
nosamp = 500;

for i = 1:5
    
    a = UN{i}.gamma.Time(2:end) - UN{i}.gamma.Time(1:(end-1));
    ind = a >= a(1) - eps;
    time.gamma = UN{i}.gamma.Time(ind);
    numvec.gamma = UN{i}.gamma.Data(ind);
    seli.gamma = floor(linspace(1, size(time.gamma, 1), nosamp));
    
    a = UN{i}.u.Time(2:end) - UN{i}.u.Time(1:(end-1));
    ind = a >= a(1) - eps;
    time.u = UN{i}.u.Time(ind);
    numvec.u = UN{i}.u.Data(ind);
    seli.u = floor(linspace(1, size(time.u, 1), nosamp));
    
    a = UN{i}.theta.Time(2:end) - UN{i}.theta.Time(1:(end-1));
    ind = a >= a(1) - eps;
    time.theta = UN{i}.theta.Time(ind);
    numvec.theta = UN{i}.theta.Data(ind);
    seli.theta = floor(linspace(1, size(time.theta, 1), nosamp));
    
    a = UN{i}.Tr.Time(2:end) - UN{i}.Tr.Time(1:(end-1));
    ind = a >= a(1) - eps;
    time.Tr = UN{i}.Tr.Time(ind);
    numvec.Tr = UN{i}.Tr.Data(ind);
    seli.Tr = floor(linspace(1, size(time.Tr, 1), nosamp));
    
    a = UN{i}.Tl.Time(2:end) - UN{i}.Tl.Time(1:(end-1));
    ind = a >= a(1) - eps;
    time.Tl = UN{i}.Tl.Time(ind);
    numvec.Tl = UN{i}.Tl.Data(ind);
    seli.Tl = floor(linspace(1, size(time.Tl, 1), nosamp));
        
    subplot(511); hold on;
        yline(0, ':', 'HandleVisibility', 'off');
        plot(time.gamma(seli.gamma), numvec.gamma(seli.gamma));
        ylim([-0.2 0.2]);
        ylabel('$\gamma$');
        title('Nonlinear system outputs - $K_\infty$');
    subplot(512); hold on;
        yline(1, ':', 'HandleVisibility', 'off');
        plot(time.u(seli.u), numvec.u(seli.u));
        ylim([-0.5 2.5]);
        ylabel('$u$');
    subplot(513); hold on;
        yline(1, ':', 'HandleVisibility', 'off');
        plot(time.theta(seli.theta), numvec.theta(seli.theta));
        ylim([-0.5 2.5]);
        ylabel('$\theta$');
    subplot(514); hold on;
        yline(0, ':', 'HandleVisibility', 'off');
        plot(time.Tr(seli.Tr), numvec.Tr(seli.Tr));
        ylim([-0.8 0.8]);
        ylabel('$\tau_r$');
    subplot(515); hold on;
        yline(0, ':', 'HandleVisibility', 'off');
        plot(time.Tl(seli.Tl), numvec.Tl(seli.Tl));
        ylim([-0.8 0.8]);
        xlabel('Time (s)');
        ylabel('$\tau_l$');
end
plt.isi('hwratio', 1, 'save', 'nonlinear_simulation_inf');
    
disp('END PART: NLPAR -----------------------------------------------------');