
s = tf('s');
Wa = 7*(s)/(((s/1.6)^2 + (0.2/1.6)*s + 1));
Wa = zpk(Wa);
clear s;

% A  = segway.Gn.A;
% B  = segway.Gn.B;
% C  = segway.Gn.C;
% D  = segway.Gn.D;
% K  = segway.K;
% Ac = A - B*K;
% Gn = ss(Ac,B,C,D);
% frq = logspace(-2,2,600);
% 
% figure(1);
% ssi();
% for i = 1:segway.n
%     A  = segway.Gp{i}.A;
%     B  = segway.Gp{i}.B;
%     C  = segway.Gp{i}.C;
%     D  = segway.Gp{i}.D;
%     Ac = A - B*K;
%     Gp = ss(Ac,B,C,D);
%     [singulars{i}, ~] = sigma(Gp-Gn, frq);
%     semilogx(frq, 20*log10(singulars{i}), 'color', [13, 141,227]/255);
%     disp(['Plot |G-Gn|: ' num2str(i)]);
%     hold on;
% end
% 
% bodemag(Wa, frq);
% grid on;
% legend('W_a','Singular values');
