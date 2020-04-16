function [WT,ce] = TimeCost_constraint(Station_Distribution)
road_length=length(Station_Distribution)/3;
X=zeros(3,road_length);
X(1,:)=Station_Distribution(1:road_length);
X(2,:)=Station_Distribution(road_length+1:road_length*2);
X(3,:)=Station_Distribution(road_length*2+1:road_length*3);
Station_Distribution=X;
PT1 = 100;
PT2 = 450;
PT3 = 2100;
ce=[];
load data.mat

road = data.road;

j=1;
for k = 1 : length(road)
   if strcmp(cell2mat(road(k)),'A1');
      IMDA1(j) = data.imd(k); 
      j=j+1;
   end
end



Power_Distribution = (Station_Distribution(1,:)*PT1 + Station_Distribution(2,:)*PT2 + Station_Distribution(3,:)*PT3);

Power_Distribution;

Range = 20;
Power_Usage = 1.25;  % 
Percentage_of_cars_stopping = 0.01;
road_length = length(IMDA1);
t1 = 10;
t2 = 16;
a1 = 0.021;
a2 = 0.104;


for k = 1: length(Station_Distribution)
    Stations_in_the_neighbourhood(k) = sum(max(Station_Distribution(1:3,max(k-Range,1):min(k+Range,road_length))));
end


Station_Presence = max(Station_Distribution);
Demand = zeros(1,length(Station_Distribution));
Waiting_Time = zeros(1,length(Station_Distribution));


for k = 1 : road_length
    for l = max(k - Range,1) : min(k + Range,road_length) ;
        probability=1;
        %Demand(k) = Station_Presence(k).*(Demand(k) + Power_Usage*Percentage_of_cars_stopping*Station_Presence(l)*abs(k-l)*IMDA1(l)/Stations_in_the_neighbourhood(l));
        Demand(k) = Station_Presence(k).*(Demand(k) + Power_Usage*Station_Presence(l)*abs(k-l)*IMDA1(l)/(Stations_in_the_neighbourhood(l)^2));
        %Demand(k) = Station_Presence(k).*(Demand(k) + Power_Usage*Station_Presence(l)*abs(k-l)*10^3/(Stations_in_the_neighbourhood(l)^2));%% uniform stations
    end
    if Station_Presence(k)
        if (Demand(k)*a2 - Power_Distribution(k)) < 0
            Waiting_Time(k) = 0;
        elseif (Power_Distribution(k) - Demand(k)*a1) <0
            Waiting_Time(k) = 10^9;
        else
            Waiting_Time(k) = (Demand(k)*a2 - Power_Distribution(k))/(Power_Distribution(k) - Demand(k)*a1)*(t2 - t1);
        end
    end
end
hours_waiting_ok=sum(Station_Distribution.*[30/60 40/60 45/60]');
WT=Waiting_Time-hours_waiting_ok;
%WT=sum(Waiting_Time-hours_waiting>0);
end