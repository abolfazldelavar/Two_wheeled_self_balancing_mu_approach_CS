nof        = 300;           %Number of frequencies
ff         = 1e-4;          %First frequency
lf         = 1e+4;          %Last  frequency
frqs       = logspace(log10(ff),log10(lf),nof)';

blk        = [1, 0;   %Stability Uncertainty
              1, 0;
              1, 0;
              1, 0;
              1, 0];

blk2       = [1, 0;   %Performance Uncertainty
              1, 0;
              1, 0;
              1, 0;
              1, 0;
              5, 5];
          
