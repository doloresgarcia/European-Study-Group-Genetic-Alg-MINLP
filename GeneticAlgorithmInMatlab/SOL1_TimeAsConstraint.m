clc
close all
clear all

    
load data.mat


road = data.road;


for k = 1 : length(road)
   if strcmp(cell2mat(road(k)),'A7');
      IMDA1(k) = data.imd(k); 
   end
end

Coordinates_all=zeros(28,2);

for k = 1 : length(road)
   if strcmp(cell2mat(road(k)),'A1');
      Coordinates_all(k,1) = data.latitude(k); 
      Coordinates_all(k,2) = data.longitude(k); 
   end
end

road_length = length(IMDA1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% % f= @(x)[sum(x)];
f=@Price;


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
nonlcon = @TimeCost_constraint;
IntCon = 1:x_size;


[x,f1] = ga(f,x_size,A,b,Aeq,beq,lb,ub,nonlcon,IntCon);

figure(1);
plot(x(1:number_of_km_points),'xr')
figure(2);
plot(x(number_of_km_points+1:2*number_of_km_points),'xb')
figure(3);
plot(x(2*number_of_km_points+1:3*number_of_km_points),'xk')

figure(4);
% plot(IMDA1)
plot(10^3*ones(1,28))
hold on
plot(1*10^4*x(1:number_of_km_points),'xr')
hold on
plot(2*10^4*x(number_of_km_points+1:2*number_of_km_points),'xb')
hold on
plot(3*10^4*x(2*number_of_km_points+1:3*number_of_km_points),'xk')

active=x(1:number_of_km_points)+x(number_of_km_points+1:2*number_of_km_points)+x(2*number_of_km_points+1:3*number_of_km_points);
active=active>0;
Coordinates_active=Coordinates_all;
for i=1:28
    if active(i)==0
        Coordinates_active(i,:)=0;
    end
end

Coordinates_active(Coordinates_active(:,1)==0,:)=[];
X=zeros(3,28);
X(1,:)=x(1:number_of_km_points);
X(2,:)=x(number_of_km_points+1:number_of_km_points*2);
X(3,:)=x(2*number_of_km_points+1:number_of_km_points*3);
X=X';
X(active==0,:)=[];
sol=[Coordinates_active  X];


