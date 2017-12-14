global fuzz1

%%
% parametry pochodna uchybu
fuzz1 = fuzznaj;
reg_de_zero_1 = fuzz1.input(1).mf(1).params(1);
reg_de_zero_2 = fuzz1.input(1).mf(1).params(2);
reg_de_zero_3 = fuzz1.input(1).mf(1).params(3);

reg_de_pos_1 = fuzz1.input(1).mf(2).params(1);
reg_de_pos_2 = fuzz1.input(1).mf(2).params(2);
reg_de_pos_3 = fuzz1.input(1).mf(2).params(3);

reg_de_neg_1 = fuzz1.input(1).mf(3).params(1);
reg_de_neg_2 = fuzz1.input(1).mf(3).params(2);
reg_de_neg_3 = fuzz1.input(1).mf(3).params(3);

%%
% parametry uchyb

reg_e_neg_1 = fuzz1.input(2).mf(1).params(1);
reg_e_neg_2 = fuzz1.input(2).mf(1).params(2);
reg_e_neg_3 = fuzz1.input(2).mf(1).params(3);

reg_e_zero_1 = fuzz1.input(2).mf(2).params(1);
reg_e_zero_2 = fuzz1.input(2).mf(2).params(2);

reg_e_pos_1 = fuzz1.input(2).mf(3).params(1);
reg_e_pos_2 = fuzz1.input(2).mf(3).params(2);
reg_e_pos_3 = fuzz1.input(2).mf(3).params(3);

%%
% parametry sterowanie

reg_u_neg_1 = fuzz1.output.mf(1).params(1);
reg_u_neg_2 = fuzz1.output.mf(1).params(2);
reg_u_neg_3 = fuzz1.output.mf(1).params(3);
reg_u_neg_4 = fuzz1.output.mf(1).params(4);

reg_u_zero_1 = fuzz1.output.mf(2).params(1);
reg_u_zero_2 = fuzz1.output.mf(2).params(2);

reg_u_pos_1 = fuzz1.output.mf(3).params(1);
reg_u_pos_2 = fuzz1.output.mf(3).params(2);
reg_u_pos_3 = fuzz1.output.mf(3).params(3);
reg_u_pos_4 = fuzz1.output.mf(3).params(4);

reg_u_pos_p1 = fuzz1.output.mf(4).params(1);
reg_u_pos_p2 = fuzz1.output.mf(4).params(2);
reg_u_pos_p3 = fuzz1.output.mf(4).params(3);

reg_u_neg_p1 = fuzz1.output.mf(5).params(1);
reg_u_neg_p2 = fuzz1.output.mf(5).params(2);
reg_u_neg_p3 = fuzz1.output.mf(5).params(3);

par0 = [reg_de_zero_1 reg_de_zero_2 reg_de_zero_3 ...
    reg_de_pos_1 reg_de_pos_2 reg_de_pos_3 ...
    reg_de_neg_1 reg_de_neg_2 reg_de_neg_3 ...
    reg_e_neg_1 reg_e_neg_2 reg_e_neg_3 ...
    reg_e_zero_1 reg_e_zero_2 ...
    reg_e_pos_1 reg_e_pos_2 reg_e_pos_3 ...
    reg_u_neg_1 reg_u_neg_2 reg_u_neg_3 reg_u_neg_4 ...
    reg_u_zero_1 reg_u_zero_2 ...
    reg_u_pos_1 reg_u_pos_2 reg_u_pos_3 reg_u_pos_4 ...
    reg_u_pos_p1 reg_u_pos_p2 reg_u_pos_p3 ...
    reg_u_neg_p1 reg_u_neg_p2 reg_u_neg_p3];

options = optimoptions(@lsqnonlin,'Display','iter');

[par_full,fval]=lsqnonlin(@fuzzy_cel, par0, [],[], options);

sim('model_2015a', 5)

