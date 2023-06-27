%% --------------------------------- Values -------------------------------
%Nominal values
    nom.m_ch   = 10;
    nom.m_w    = 1;
    nom.I_xxch = 0.038;
    nom.I_yych = 0.033; %~just in G_t
    nom.I_zzch = 0.033; % Just in G_t
    nom.I_w    = 0.032; % Just in G_t
    nom.g      = 9.81;
    nom.r_w    = 0.1;
    nom.l      = 0.2;
    nom.h      = 0.5;  %~Just in G_t  ------ *

%Perturbation values percent (%)
    per.delta_mch = 0.05;
    per.delta_m_w = 0;
    per.delta_Ixx = 0.10;
    per.delta_Iyy = 0.10;
    per.delta_Izz = 0.10;
    per.delta_Iw  = 0;
    per.delta_g   = 0;
    per.delta_r_w = 0;
    per.delta_l   = 0;
    per.delta_h   = 0.02;
% Others
    n = 500;
    
%--------------------------------------------------------------------------
K1 = nom.r_w*(3*nom.m_w + nom.m_ch);
K2 = nom.r_w*nom.h*nom.m_ch;
K3 = nom.r_w*(2*(nom.m_w*nom.l^2 + nom.I_w) + nom.m_w*nom.l^2 + nom.I_zzch);
K4 = nom.I_yych + nom.m_ch*nom.h^2;
K5 = -nom.m_ch*nom.g*nom.h;
K6 = nom.m_ch*nom.h;

A = [0, 1, 0, 0, 0; % gamma, dgamma, u, theta, dtheta
    K1*K5/(K2*K6 - K1*K4), 0, 0, 0, 0;
    K2*K5/(K1*K4 - K2*K6), 0, 0, 0, 0;
    0, 0, 0, 0, 1;
    0, 0, 0, 0, 0];
B = [0, 0;
    (K1 + K6)/(K2*K6 - K1*K4), (K1 + K6)/(K2*K6 - K1*K4);
    (K2 + K4)/(K1*K4 - K2*K6), (K2 + K4)/(K1*K4 - K2*K6);
    0, 0;
    1/K3, -1/K3];
C = [1 0 0 0 0;
     0 0 1 0 0;
     0 0 0 1 0];
D = 0;

Gn = ss(A, B, C, D);

% Perturbated system --------------------

dA = zeros(5,5,n);
dB = zeros(5,2,n);

for i = 1:n
    m_ch   = nom.m_ch  *(1 + 2*per.delta_mch*(rand-0.5));
    m_w    = nom.m_w   *(1 + 2*per.delta_m_w*(rand-0.5));
    I_xxch = nom.I_xxch*(1 + 2*per.delta_Ixx*(rand-0.5));
    I_yych = nom.I_yych*(1 + 2*per.delta_Iyy*(rand-0.5)); %~just in G_t
    I_zzch = nom.I_zzch*(1 + 2*per.delta_Izz*(rand-0.5)); % Just in G_t
    I_w    = nom.I_w   *(1 + 2*per.delta_Iw*(rand-0.5)); % Just in G_t
    g      = nom.g     *(1 + 2*per.delta_g*(rand-0.5));
    r_w    = nom.r_w   *(1 + 2*per.delta_r_w*(rand-0.5));
    l      = nom.l     *(1 + 2*per.delta_l*(rand-0.5));
    h      = nom.h     *(1 + 2*per.delta_h*(rand-0.5));  %~Just in G_t  ------ *

    K1 = r_w*(3*m_w + m_ch);
    K2 = r_w*h*m_ch;
    K3 = r_w*(2*(m_w*l^2 + I_w) + m_w*l^2 + I_zzch);
    K4 = I_yych + m_ch*h^2;
    K5 = -m_ch*g*h;
    K6 = m_ch*h;
    
    A = [0, 1, 0, 0, 0; % gamma, dgamma, u, theta, dtheta
        K1*K5/(K2*K6 - K1*K4), 0, 0, 0, 0;
        K2*K5/(K1*K4 - K2*K6), 0, 0, 0, 0;
        0, 0, 0, 0, 1;
        0, 0, 0, 0, 0];
    B = [0, 0;
        (K1 + K6)/(K2*K6 - K1*K4), (K1 + K6)/(K2*K6 - K1*K4);
        (K2 + K4)/(K1*K4 - K2*K6), (K2 + K4)/(K1*K4 - K2*K6);
        0, 0;
        1/K3, -1/K3];
    C = eye(5);
    D = 0;

    Gp{i} = ss(A, B, C, D);
    
    dA(:,:,i) = Gp{i}.A - Gn.A;
    dB(:,:,i) = Gp{i}.B - Gn.B;
    disp(['Perturbed system ' num2str(i) ' created.']);
end

Wa  = max(abs(dA),[],3);
Wb  = max(abs(dB),[],3);
Wa1 = Wa(2,1);
Wa2 = Wa(3,1);
Wb1 = Wb(2,1);
Wb2 = Wb(3,1);
Wb3 = Wb(5,1);


segway.Gn = Gn;
segway.Gp = Gp;
segway.n  = n;
segway.param.per = per;
segway.param.nom = nom;
segway.W.Wa1 = Wa1;
segway.W.Wa2 = Wa2;
segway.W.Wb1 = Wb1;
segway.W.Wb2 = Wb2;
segway.W.Wb3 = Wb3;

save('segway','segway');
disp('END PART: MODELING SYSTEM -------------------------------------------');

clear i C1 C2 G1 G2 G3 G4 G5 G_g G_t G_u G K1 K2 K3 K4 K5 K6 P1 tol delta_Iw;
clear delta_Ixx delta_Iyy delta_Izz delta_mch g delta_g delta_h delta_l;
clear delta_m_w delta_r_w h I_xxch I_yych I_zzch I m_ch m_w r_w l I_w;
clear Gp Gn nom per A B C D First_sys_poles K Wa Wa1 Wa2 Wb1 Wb2 Wb3 Wb dA dB;

