function wsk = cel( par )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
   
   limit = 0.5;
%    ref1 = ones(1,40); 
   ref1 = ones(1,45); 
   y_ref = [ref1.*-limit,-1*limit:0.1:1*limit,ref1*limit];
   t = -5:0.1:5;
   y = 2*limit./(1+exp(par.*t))-limit;
   
   wsk = 1e3 * (y - y_ref);
end
