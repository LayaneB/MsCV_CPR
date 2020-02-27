load a 
load b
colormat = load('color.dat');
n = size(a,2);
w = 2/3;
ap = zeros(size(a));

op = zeros([size(a,1),3]);
or = zeros([3 size(a,1)]);

or(1,1:3) = 1;
or(2,4:6) = 1;
or(3,7:9) = 1;

opt = or';

% pre condicona

ap = a;
ap(1:n+1:end) = diag(a) - sum(a,2);

D = diag(diag(ap))^-1;
max = 10;

for ii = 1 : max
d = - w*D*ap*opt;

d(1,1) = 0;
d(5,2) = 0;
d(9,3) = 0;

d(5:end,1) = 0;
d(1:5,3) = 0;

d(1:2,2) = 0;

d(8:9,2) = 0;
op = opt + d



opt = op;





end
op = opt;
hold on
whitebg('black')
text = num2str(max);

xSize = 2.4;
title(['Prolongation Operator after ', text ,' iterations'],'FontSize', 14)
    whitebg('black')
plot(op(:,1),'color', colormat(5,:),'LineWidth',xSize ,'DisplayName', 'IR 1');
plot(op(:,2), 'color', colormat(4,:),'LineWidth',xSize ,'DisplayName','IR 2');
plot(op(:,3),'color',  colormat(3,:),'LineWidth',xSize ,'DisplayName','IR 3');

lgd = legend('show','Location','east');


ac = or*a*op;
bc = or*b;

%clf

p = [1 (a^-1*b)' 0];
xp = [0 0.5:8.5 9];


pc = ac^-1*bc;
hold on

%plot(xp,p,'color',colormat(5,:),'LineWidth',xSize ,'DisplayName', 'Fine Scale Solution')


x = [0 0.5 4.5 8.5 9]
pcn2 = [1 , pc' , 0]


%plot(x,pcn2,'color',colormat(4,:),'LineWidth',xSize ,'DisplayName', 'Coarse Scale Solution');



pfms = [ 1 (op*pc)' 0]

%plot(xp,pfms,'color',colormat(3,:),'LineWidth',xSize ,'DisplayName', 'Multiscale Solution')

title(['1D Problem Pressure Solution'],'FontSize', 14)

legend('show','Location','northeast');


