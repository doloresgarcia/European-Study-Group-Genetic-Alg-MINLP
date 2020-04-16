%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% final function only takes into account prices with intlinprog
%%% Price of the dif stations
price_T1=2;
price_T2=5;
price_T3=10;
number_of_km_points=100;
number_check=20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

variable_size=number_of_km_points*3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%inequality for checking number of km
%%%%%%%%%%%%%%
check_km=ones(1,number_check);
rest=number_of_km_points-number_check;
rest_km=zeros(1, rest);
vector_constraint_Km=[check_km  rest_km];
how_many=number_of_km_points-number_check+1;
A=zeros(how_many,number_of_km_points);

for i=1:how_many
    A(i,:)=-circshift(vector_constraint_Km,i-1);
end
A=repmat(A,1,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%linear programming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lb=zeros(variable_size,1);
b = -1*ones(how_many,1);
Aeq = [];
beq = [];
ub = [];
nonlcon = [];
IntCon = 1:variable_size;
%x = ga(f,x_size,A,b,Aeq,beq,lb,ub,nonlcon,IntCon);
f=[price_T1*ones(1,number_of_km_points) price_T2*ones(1,number_of_km_points) price_T3*ones(1,number_of_km_points)];
% f1=(1-alpha)*3;
f_final=f;
%%%%%%%%%%%%%%%%%%%%%55
x = intlinprog(f_final,variable_size,A,b,Aeq,beq,lb,ub,IntCon);
%%%%%%%%%%%%%%%%%%


figure(1);
plot(x(1:number_of_km_points),'xr')
figure(2);
plot(x(number_of_km_points+1:2*number_of_km_points),'xb')
figure(3);
plot(x(2*number_of_km_points+1:3*number_of_km_points),'xk')

