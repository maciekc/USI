function val = neuron_cel(pars)
global L R Ke J z_min z_max U_g1 U_g2 b_nc T alpha_0;
kp1=pars(1);
kd1=pars(2);
ki1=pars(3);
kp2=pars(4);
kd2=pars(5);
ki2=pars(6);
sat_wsp1=pars(7);
sat_wsp2=pars(8);
W = [kd1 kp1 ki1 0;
    kd2 kp2 ki2 0;
    0 0 0 1];

opt = simset('SrcWorkspace','Current');
sim('Model_opt.slx',2, opt);

zadana = ScopeData1.signals(1).values(:,5);
alpha = ScopeData1.signals(1).values(:,2);

val = J3_n + 10*abs(zadana(end - 50) - alpha(end - 50));

end

