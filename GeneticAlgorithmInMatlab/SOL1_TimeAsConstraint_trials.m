
N_Trials=7;
SOL=cell(1,N_Trials);
F_sol=zeros(1,N_Trials);
for i=1:N_Trials
    [SOL{1,i},F_sol(i)]=GA_sol_time_constraint(i);
end
q=1;
for i=1:11
    q=q*i;
end