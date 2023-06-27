Wg    = zpk([],[],0.01);
Wu    = zpk([],[-1e-2],0.1);
Wt    = zpk([],[-3e-3],0.04);
Wn    = zpk([-0.1],[-100], 100);
Wtaur = zpk([-1],[-1000],6);
Dactr = zpk([],[-0.2],0.15);

Wtaul = Wtaur;
Dactl = Dactr;

figure();
    bodemag(Wg,Wu,Wt,Wn,Wtaur,Dactr);
    legend('gamma','u','theta','noise','Torque','Disturbance');
    title('Weights');
    grid on;
    axis([1e-5, 1e+4, -80, 60]);
    plt.isi('save', 'weights');
disp('END PART: WEIGHTS ---------------------------------------------------');