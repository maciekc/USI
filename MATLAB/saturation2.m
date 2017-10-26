X0 = -2;
%      K   T     
options = optimoptions(@lsqnonlin,'Display','iter');
par = lsqnonlin(@cel, X0, [],[],options)