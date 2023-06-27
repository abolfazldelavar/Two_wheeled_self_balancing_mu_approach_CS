%% -------- ROBUSTNESS ----------------------------------------------------

Dfit{1}    = eye(5);
K{1}       = Knom;
Pit{1}     = P;
    
for IT = 1:5
    disp(['START PART: Iteration ------------------------------------------------ ' num2str(IT)]);
    
    Pit{IT+1} = [Dfit{IT},   zeros(5,10);
         zeros(5,5), eye(5,5), zeros(5,5);
         zeros(5,10), eye(5,5)] ...
         *Pit{1}* ...
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

    figure();
        h10 = semilogx(frqs, reshape(RobStb{IT}.ResponseData(1,1,:),[],1), 'b'); hold on;
        semilogx(frqs, reshape(RobStb{IT}.ResponseData(1,2,:),[],1), 'b');

        h11 = semilogx(frqs, reshape(RobPer{IT}.ResponseData(1,1,:),[],1), 'r');
        semilogx(frqs, reshape(RobPer{IT}.ResponseData(1,2,:),[],1), 'r');

        h12 = semilogx(frqs, reshape(NomPer{IT}.ResponseData(1,1,:),[],1), 'k--');
        semilogx(frqs, reshape(NomPer{IT}.ResponseData(2,1,:),[],1), 'k--');
        semilogx(frqs, reshape(NomPer{IT}.ResponseData(3,1,:),[],1), 'k--');
        semilogx(frqs, reshape(NomPer{IT}.ResponseData(4,1,:),[],1), 'k--');
        semilogx(frqs, reshape(NomPer{IT}.ResponseData(5,1,:),[],1), 'k--');
    
    xlim([ff, lf]);
    grid on;
    legend([h10, h11, h12], {'Robust stability','Robust Performance','Nominal Performance '});
    title(['Close-loop robustness analysis - Iteration ', num2str(IT)]);
    xlabel('Frequency (rad/s)');
    ylabel('Amp');
    plt.isi();
        
    [D,~]  = mussvunwrap(muinfo{IT});
    for i = 1:5
        D(i,i) = D(i,i)/D(end,end);
        D(i+5,i+5) = D(i+5,i+5)/D(end,end);
    end

    Dtest = D;
    for i = 1:5
        disp(['---------------------------------- Iteration ', num2str(IT), ' - D', num2str(i)]);
        
%         k = randi([0 1]);
        k = 1;
        HELP = fitfrd(genphase(D(i,i)), k);

        Dfit{IT+1}(i,i) = HELP;
        Dtest(i,i) = HELP;
    end
end

disp('END PART: ROBUSTNESS ------------------------------------------------ ');

