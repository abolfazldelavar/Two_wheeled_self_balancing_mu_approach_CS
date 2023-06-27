%% -------- ROBUSTNESS ----------------------------------------------------

Dfit{1}    = eye(5);
K{1}       = Knom;
Pit{1}     = P;

h1 = figure(); ssi3();
h2 = figure(); ssi4();
    
for IT = 1:40
    
    Pit{IT+1} = [Dfit{IT},   zeros(5,10);
         zeros(5,5), eye(5,5), zeros(5,5);
         zeros(5,10), eye(5,5)] ...
         *Pit{IT}* ...
         [Dfit{IT}^-1,   zeros(5,7);
         zeros(5,5), eye(5,5), zeros(5,2);
         zeros(2,10), eye(2,2)];
    
    if IT == 1
        Grob{IT} = lft(Pit{IT+1}, K{1});
    else
        [K{IT}, ~, ~, ~] = hinfsyn(Pit{IT+1}, numel(Iy), numel(Iu), 'METHOD', 'ric','TOLGAM', 0.1);
        Grob{IT}         = lft(Pit{IT+1}, K{IT});
    end

    GrobFrq{IT} = frd(Grob{IT}, frqs);

    RobStb{IT}               = mussv(GrobFrq{IT}(Iz,Iv), blk);  %Robust  stability
    [RobPer{IT}, muinfo{IT}] = mussv(GrobFrq{IT}, blk2);        %Robust  Performance
    NomPer{IT}               = svd(GrobFrq{IT}(Ie,Iw));         %Nominal Performance

    figure(); ssi2();
        semilogx(frqs, reshape(RobStb{IT}.ResponseData(1,1,:),[],1), 'b'); hold on;
        semilogx(frqs, reshape(RobStb{IT}.ResponseData(1,2,:),[],1), 'b');

        semilogx(frqs, reshape(RobPer{IT}.ResponseData(1,1,:),[],1), 'r');
        semilogx(frqs, reshape(RobPer{IT}.ResponseData(1,2,:),[],1), 'r');

        semilogx(frqs, reshape(NomPer{IT}.ResponseData(1,1,:),[],1), 'k--');
        semilogx(frqs, reshape(NomPer{IT}.ResponseData(2,1,:),[],1), 'k--');
        semilogx(frqs, reshape(NomPer{IT}.ResponseData(3,1,:),[],1), 'k--');
        semilogx(frqs, reshape(NomPer{IT}.ResponseData(4,1,:),[],1), 'k--');
        semilogx(frqs, reshape(NomPer{IT}.ResponseData(5,1,:),[],1), 'k--');

    xlim([ff, lf]);
    legend('Robust stability','Robust Performance','Nominal Performance');
    title(['Close-loop robustness analysis - Iteration ', num2str(IT)]);
    xlabel('Frequency (rad/s)');
    ylabel('Amp');


    [D,~]  = mussvunwrap(muinfo{IT});
    for i = 1:5
        D(i,i) = D(i,i)/D(end,end);
        D(i+5,i+5) = D(i+5,i+5)/D(end,end);
    end

    Dtest = D;
    for i = 1:5
        disp(['---------------------------------- Iteration ', num2str(IT), ' - D', num2str(i)]);
        Df{IT}{i} = D(i,i);
        figure(h2); hold off;
            semilogx(frqs, reshape(RobPer{IT}.ResponseData(1,1,:),[],1), 'k--', 'LineWidth',1);
            hold on;
        figure(h1); hold off;
            semilogx(frqs, 20*log10(reshape(Df{IT}{i}.ResponseData(1,1,:),[],1)),'k--', 'LineWidth',1);
            hold on;

        HELP = cell(5,1);
        for j = 0:2
            HELP{j+1} = fitfrd(genphase(Df{IT}{i}), j);
            figure(h1);
                bodemag(HELP{j+1});

            Dtest(i,i) = HELP{j+1};
            GrobTest   = Dtest*Grob{IT}*(Dtest^-1);
            [TEST2, ~] = mussv(GrobTest, blk2);  %Robust Performance
            figure(h2);
                semilogx(frqs, reshape(TEST2.ResponseData(1,1,:),[],1));
                semilogx(frqs, reshape(TEST2.ResponseData(1,2,:),[],1));
        end
        figure(h1);
            grid on;
            xlim([ff lf]);
            title(['D', num2str(i)]);
            legend(['D', num2str(i)],'Order 0','Order 1','Order 2');
        figure(h2);
            grid on;
            xlim([ff lf]);
            title(['Robust Performance - D', num2str(i)]);
            legend(['D', num2str(i)],'Order 0','Order 1','Order 2');

        k          = input('Order Number: ');
        Dfit{IT+1}(i,i) = HELP{k+1};
        Dtest(i,i) = HELP{k+1};
    end
    disp(['END PART: Iteration --------------------------------------------------- ' num2str(IT)]);
end




