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
max = 200;

ir = zeros(size(opt));
ib = ir;
ic = [1,5,9];
ir(1:3,1) = 1;
ib(4,1) = 1;
ib(2,2) = 1;
ir(3:7,2) = 1;
ib(8,2) = 1;
ib(6,3) = 1;
ir(7:9,3) = 1;


for ii = 1 : max
    d = - w*D*ap*opt;
    do = d;
    tic
    spread = @(i,j)((1 - (opt(i,j)*(sum(d(i,:)) - d(i,j))))   /(1 + (sum(d(i,:)) - d(i,j))));
    toc
    
    
%     d(2,1) = spread(2,1)
%     d(2,2)
    
    
    
    
    % 1 on coarse scale centers
    d(ic(1),1) = 0;
    d(ic(2),2) = 0;
    d(ic(3),3) = 0;
%     
%     d(3,1) = spread(3,1);
%     d(3,2) = spread(3,2);
%     
%     d(4,1) = spread(4,1);
%     d(4,2) = spread(4,2);
%     
%     d(6,2) = spread(6,2);
%     
%     d(6,3) = spread(6,3);
%     
%     d(7,2) = spread(7,2);
%     d(7,3) = spread(7,3);
    

    d(~(ib+ir)) = 0;
  
    
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
xSize = 1.4;
%plot(xp,p,'color',colormat(5,:),'LineWidth',2.4 ,'DisplayName', 'Fine Scale Solution')


x = [0 0.5 4.5 8.5 9]
pcn2 = [1 , pc' , 0]


%plot(x,pcn2,'o','color',colormat(4,:),'LineWidth',5 ,'DisplayName', 'Coarse Scale Solution');



pfms = [ 1 (op*pc)' 0];

%plot(xp,pfms,'x','color',colormat(3,:),'LineWidth',5 ,'DisplayName', 'Multiscale Solution')
% 
% title(['1D Problem Pressure Solution'],'FontSize', 14)
% 
% legend('show','Location','northeast');
% 

