[AA, BB, CC, DD] = linmod('SYSTEM');
P  = ss(AA,BB,CC,DD);
set(P, 'inputname', {'v_1','v_2','v_3','v_4','v_5','Right Dist','Left Dist','Ref u','Ref theta',...
      'noise','Right Torgue','Left Torque'},'outputname',{'z_1','z_2','z_3','z_4','z_5',...
      'error_g_a_m_m_a','error_u','error_t_h_e_t_a','RTE','LTE',...
      'gamma','u','theta','Ref u','Ref theta'});
  
Iz = (1:5)';   %1->z1       2->z2      3->z3       4->z4      5->z5
Ie = (6:10)';  %6->eg       7->eu      8->et       9->taur    10->taul
Iy = (11:15)'; %11->gamma   12->u      13->theta   14->refu   15->reft

Iv = (1:5)';   %1->v1       2->v2      3->v3       4->v4      5->v5
Iw = (6:10)';  %6->dr       7->dl      8->ref_u    9->ref_t   10->noise
Iu = (11:12)'; %11->Tr      12->Tl

disp('END PART: LFT MODELING ----------------------------------------------');
clear AA BB CC DD;