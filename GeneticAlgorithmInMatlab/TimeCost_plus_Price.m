function Waiting_Time = TimeCost_plus_Price(Station_Distribution)
road_length=28;
Station_Distribution=reshape(Station_Distribution, 3,road_length);
PT1 = 100;
PT2 = 450;
PT3 = 2100;


load data.mat

road = data.road;


for k = 1 : length(road)
   if strcmp(cell2mat(road(k)),'A1');
      IMDA1(k) = data.imd(k); 
   end
end



Power_Distribution = (Station_Distribution(1,:)*PT1 + Station_Distribution(2,:)*PT2 + Station_Distribution(3,:)*PT3);

Power_Distribution;

Range = 2;
Power_Usage = 1.25;  % 
Percentage_of_cars_stopping = 0.01;
road_length = length(IMDA1);
t1 = 10;
t2 = 16;
a1 = 0.021;
a2 = 0.104;


for k = 1: length(Station_Distribution);
    Stations_in_the_neighbourhood(k) = sum(max(Station_Distribution(1:3,max(k-Range,1):min(k+Range,road_length))));
end


Station_Presence = max(Station_Distribution);
Demand = zeros(1,length(Station_Distribution));
Waiting_Time = zeros(1,length(Station_Distribution));


for k = 1 : road_length
    for l = max(k - Range,1) : min(k + Range,road_length) ;
        Demand(k) = Station_Presence(k).*(Demand(k) + Power_Usage*Percentage_of_cars_stopping*Station_Presence(l)*abs(k-l)*IMDA1(l)/Stations_in_the_neighbourhood(l));
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
s=size(Waiting_Time);
Price_T1=28900;
Price_T2=289000;
Price_T3=578000;
x=Station_Distribution';
num_of_T=sum(x);
prices=[Price_T1 Price_T2 Price_T3];
price=prices*num_of_T';
alpha=0.5;

Waiting_Time = alpha*max(Waiting_Time)+(1-alpha)*price
end