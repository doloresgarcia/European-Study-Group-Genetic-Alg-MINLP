% genetic algorithm implementation with simple cost function

f= @(x)[sum(x)];
number_of_km_points=100;
x_size=number_of_km_points;
number_check=20;
check_km=ones(1,number_check);
rest=number_of_km_points-number_check;
rest_km=zeros(1, rest);
vector_constraint_Km=[check_km  rest_km];
how_many=number_of_km_points-number_check+1;
A=zeros(how_many,number_of_km_points);

for i=1:how_many
    A(i,:)=-circshift(vector_constraint_Km,i-1);
end
lb=zeros(x_size,1);
ub=ones(x_size,1);
b = -1*ones(how_many,1);
Aeq = [];
beq = [];
% ub = [];
nonlcon = [];
IntCon = 1:x_size;
x_0=zeros(1,x_size);
options.InitialPopulationMatrix =x_0;

[x] = ga(f,x_size,A,b,Aeq,beq,lb,ub,nonlcon,IntCon,options);
%x = intlinprog(ones(1,x_size),x_size,A,b,Aeq,beq,lb,ub);

plot(x,'x')