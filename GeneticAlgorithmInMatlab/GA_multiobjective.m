clc
close all
clear all


load data.mat

road = data.road;


for k = 1 : length(road)
   if strcmp(cell2mat(road(k)),'A1');
      IMDA1(k) = data.imd(k); 
   end
end


road_length = length(IMDA1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% % f= @(x)[sum(x)];
f=@TimeCost;


number_of_km_points=road_length;
x_size=number_of_km_points*3;
number_check=7;
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
lb=zeros(x_size,1);
ub=ones(x_size,1);
b = -1*ones(how_many,1);
Aeq = [];
beq = [];
nonlcon = [];
IntCon = 1:x_size;


[x] = gamultiobj(f,x_size,A,b,Aeq,beq,lb,ub,nonlcon,IntCon);

figure(1);
plot(x(1:number_of_km_points),'xr')
figure(2);
plot(x(number_of_km_points+1:2*number_of_km_points),'xb')
figure(3);
plot(x(2*number_of_km_points+1:3*number_of_km_points),'xk')

