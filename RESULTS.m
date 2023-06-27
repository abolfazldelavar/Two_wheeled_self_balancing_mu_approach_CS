%% ------------------------------------------- FINAL ROBUST CONTROLLER ----

Ksim = SelectedController; %  This is robust controller and Gnom just is a notaions in this case.

[AA, BB, CC, DD]   = linmod('closeloop');
PKr                = ss(AA,BB,CC,DD); %P-K-Rob
GKrob              = PKr([11,12,13,9,10],Iw);
GKrob              = minreal(GKrob);
set(GKnom, 'inputname', {'Right Dist','Left Dist','Ref u','Ref theta','noise'},...
    'outputname',{'gamma','u','theta','RTE','LTE'});

ig  = 1;
iu  = 2;
it  = 3;
itr = 4;
itl = 5;
idr = 1;
idl = 2;
iru = 3;
irt = 4;
in  = 5;

ns                 = 1000;
time               = linspace(0,50,ns)';
Input_signals(:,1) = [zeros(400,1); 0.1*ones(200,1); zeros(ns-600,1)]; %Right Dist
Input_signals(:,2) = [zeros(600,1); 0.1*ones(200,1); zeros(ns-800,1)]; %Left Dist
Input_signals(:,3) = [zeros(50,1); ones(ns-50,1)];  %Ref u
Input_signals(:,4) = [zeros(250,1); ones(ns-250,1)]; %Ref theta
Input_signals(:,5) = zeros(ns,1); %Ref noise

% Input_signals(:,1) = zeros(ns,1); %Right Dist
% Input_signals(:,2) = [zeros(100,1); ones(ns-100,1)]; %Left Dist
% Input_signals(:,3) = zeros(ns,1);  %Ref u
% Input_signals(:,4) = zeros(ns,1); %Ref theta
% Input_signals(:,5) = zeros(ns,1); %Ref noise


data_mu = lsim(GKrob,Input_signals,time);
Input_signals(:,5) = varn*randn(ns,1) + 0.05; %Ref noise
data_mu_noise = lsim(GKrob,Input_signals,time);

figure();
subplot(511); hold on;
    yline(0, ':', 'HandleVisibility', 'off');
    plot(time, data_nominal(:,1), '--', 'Linewidth', 1);
    plot(time, data_mu(:,1), '-.', 'Linewidth', 1);
    plot(time, data_mu_noise(:,1), 'color', [0.2,0.2,0.2], 'Linewidth', 1);
    ylabel('$\gamma$');
%     lgd.Position(1) = 0.5 - lgd.Position(3)/2;
subplot(512); hold on;
    yline(1, ':', 'HandleVisibility', 'off');
    plot(time, data_nominal(:,2), '--', 'Linewidth', 1);
    plot(time, data_mu(:,2), '-.', 'Linewidth', 1);
    plot(time, data_mu_noise(:,2), 'color', [0.2,0.2,0.2], 'Linewidth', 1);
    ylabel('$u$');
    lgd = legend('$K_\infty$','$K_\mu$ without noise','$K_\mu$ with noise', 'Location', 'southeast', 'Orientation', 'horizontal');
subplot(513); hold on;
    yline(1, ':', 'HandleVisibility', 'off');
    plot(time, data_nominal(:,3), '--', 'Linewidth', 1);
    plot(time, data_mu(:,3), '-.', 'Linewidth', 1);
    plot(time, data_mu_noise(:,3), 'color', [0.2,0.2,0.2], 'Linewidth', 1);
    ylabel('$\theta$');
subplot(514); hold on;
    yline(0, ':', 'HandleVisibility', 'off');
    plot(time, data_nominal(:,4), '--', 'Linewidth', 1);
    plot(time, data_mu(:,4), '-.', 'Linewidth', 1);
    plot(time, data_mu_noise(:,4), 'color', [0.2,0.2,0.2], 'Linewidth', 1);
    ylabel('$\tau_r$');
subplot(515); hold on;
    yline(0, ':', 'HandleVisibility', 'off');
    plot(time, data_nominal(:,5), '--', 'Linewidth', 1);
    plot(time, data_mu(:,5), '-.', 'Linewidth', 1);
    plot(time, data_mu_noise(:,5), 'color', [0.2,0.2,0.2], 'Linewidth', 1);
    ylabel('$\tau_l$');
    xlabel('Time (s)');
sgtitle('Linear simulation');
plt.isi('hwratio', 1, 'save', 'linear_simulation');

%% --------------------------------------
GKpnom   = lft(P, Knom);
GKnomFrq = frd(GKpnom, frqs);
GKprob   = lft(P, Ksim);
GKrobFrq = frd(GKprob, frqs);

RobStbn  = mussv(GKnomFrq(Iz,Iv), blk);  %Robust  stability   - Nom Controller
RobPern  = mussv(GKnomFrq, blk2);        %Robust  Performance - Nom Controller
NomPern  = svd(GKnomFrq(Ie,Iw));         %Nominal Performance - Nom Controller

KRobStb  = mussv(GKrobFrq(Iz,Iv), blk);  %Robust  stability   - Rob Controller
KRobPer  = mussv(GKrobFrq, blk2);        %Robust  Performance - Rob Controller
KNomPer  = svd(GKrobFrq(Ie,Iw));         %Nominal Performance - Rob Controller

figure();
    semilogx(frqs, reshape(RobStbn.ResponseData(1,1,:),[],1), 'b'); hold on;
    semilogx(frqs, reshape(RobStbn.ResponseData(1,2,:),[],1), 'b', 'HandleVisibility','off');
    semilogx(frqs, reshape(RobPern.ResponseData(1,1,:),[],1), 'r');
    semilogx(frqs, reshape(RobPern.ResponseData(1,2,:),[],1), 'r', 'HandleVisibility','off');
    semilogx(frqs, reshape(NomPern.ResponseData(1,1,:),[],1), 'k--');
    semilogx(frqs, reshape(NomPern.ResponseData(2,1,:),[],1), 'k--', 'HandleVisibility','off');
    semilogx(frqs, reshape(NomPern.ResponseData(3,1,:),[],1), 'k--', 'HandleVisibility','off');
    semilogx(frqs, reshape(NomPern.ResponseData(4,1,:),[],1), 'k--', 'HandleVisibility','off');
    semilogx(frqs, reshape(NomPern.ResponseData(5,1,:),[],1), 'k--', 'HandleVisibility','off');
xlim([ff, lf]);
legend('Robust stability','Robust Performance','Nominal Performance');
title('Close-loop robustness analysis - $K_\infty$');
xlabel('Frequency (rad/s)');
ylabel('Amp');
grid on;
plt.isi('save', 'kinf_robustness');

figure();
    semilogx(frqs, reshape(KRobStb.ResponseData(1,1,:),[],1), 'b'); hold on;
    semilogx(frqs, reshape(KRobStb.ResponseData(1,2,:),[],1), 'b', 'HandleVisibility','off');
    semilogx(frqs, reshape(KRobPer.ResponseData(1,1,:),[],1), 'r');
    semilogx(frqs, reshape(KRobPer.ResponseData(1,2,:),[],1), 'r', 'HandleVisibility','off');
    semilogx(frqs, reshape(KNomPer.ResponseData(1,1,:),[],1), 'k--');
    semilogx(frqs, reshape(KNomPer.ResponseData(2,1,:),[],1), 'k--', 'HandleVisibility','off');
    semilogx(frqs, reshape(KNomPer.ResponseData(3,1,:),[],1), 'k--', 'HandleVisibility','off');
    semilogx(frqs, reshape(KNomPer.ResponseData(4,1,:),[],1), 'k--', 'HandleVisibility','off');
    semilogx(frqs, reshape(KNomPer.ResponseData(5,1,:),[],1), 'k--', 'HandleVisibility','off');
xlim([ff, lf]);
legend('Robust stability','Robust Performance','Nominal Performance');
title('Close-loop robustness analysis - $K_\mu$');
xlabel('Frequency (rad/s)');
ylabel('Amp');
grid on;
plt.isi('save', 'kmu_robustness');

%% -------------------------------
figure();
    bodemag(GKnom(iu,iru),'k--'); hold on;
    bodemag(GKrob(iu,iru),'b');
    bodemag(GKnom(it,irt),'g--');
    bodemag(GKrob(it,irt),'r');
    legend('$K\infty: r_{u} \rightarrow{} u$', ...
           '$K\mu: r_u \rightarrow{} u$', ...
           '$K\infty: r_\theta \rightarrow \theta$', ...
           '$K\mu: r_\theta \rightarrow \theta$', ...
           'Location', 'southwest');
    axis([1e-4 1e+4 -200 20]);
    title('')
    grid on;
    plt.isi('save' , 'fr_utheta');
    
    
figure();
    bodemag(GKnom(ig,iru),'k--'); hold on;
    bodemag(GKrob(ig,iru),'b');
    bodemag(GKnom(ig,irt),'g--');
    bodemag(GKrob(ig,irt),'r');
    legend({'$K\infty: r_u \rightarrow{} \gamma$','$K\mu: r_u \rightarrow{} \gamma$', ...
        '$K\infty: r_\theta \rightarrow \gamma$','$K\mu: r_\theta \rightarrow \gamma$'}, ...
        'Location','southwest');
    title('')
    grid on;
    plt.isi('save' , 'fr_rgamma');
    
figure();
    bodemag(GKnom(ig,in),'k:'); hold on;
    bodemag(GKrob(ig,in),'b');
    bodemag(GKnom(iu,in),'k--');
    bodemag(GKrob(iu,in),'k');
    bodemag(GKnom(it,in),'g--');
    bodemag(GKrob(it,in),'r');
    legend({'$K\infty: noise \rightarrow{} \gamma$','$K\mu: noise \rightarrow{} \gamma$',...
        '$K\infty: noise \rightarrow{} u$','$K\mu: noise \rightarrow{} u$', ...
        '$K\infty: noise \rightarrow \theta$','$K\mu: noise \rightarrow \theta$'}, ...
        'Location','southwest', 'NumColumns', 3);
%     axis([1e-4 1e+4 -200 20]);
    grid on;
    title('')
    plt.isi('save' , 'fr_nout');
    
figure();
    bodemag(GKnom(ig,idr),'k:'); hold on;
    bodemag(GKrob(ig,idr),'b');
    bodemag(GKnom(iu,idr),'k--');
    bodemag(GKrob(iu,idr),'k');
    bodemag(GKnom(it,idr),'g--');
    bodemag(GKrob(it,idr),'r');
    legend({'$K\infty: dist \rightarrow{} \gamma$','$K\mu: dist \rightarrow{} \gamma$',...
        '$K\infty: dist \rightarrow{} u$','$K\mu: dist \rightarrow{} u$', ...
        '$K\infty: dist \rightarrow \theta$','$K\mu: dist \rightarrow \theta$'}, ...
        'Location','southwest', 'NumColumns', 3);
%     axis([1e-4 1e+4 -200 20]);
    grid on;
    title('')
    plt.isi('save' , 'fr_dout');

disp('END PART: RESULTS ---------------------------------------------------');