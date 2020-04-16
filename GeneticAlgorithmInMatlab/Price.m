function y = Price(y)
road_length=length(y)/3;
x=reshape(y',road_length,3);
x=x';

Price_T1=28900;
Price_T2=289000;
Price_T3=578000;
x=x';
num_of_T=sum(x);
prices=[Price_T1 Price_T2 Price_T3];
y=prices*num_of_T';
end