arq='mscv-p1ep0.xls';
pla=1;
[Cum_oil_FOU]=xlsread(arq,pla,'H1:H20000'); %MsRB
[Oil_Rec_FOU]=xlsread(arq,pla,'G1:G20000');
[Wat_Cut_FOU]=xlsread(arq,pla,'F1:F20000');
[VPI_FOU]=xlsread(arq,pla,'E1:E20000');
[Cum_oil_P1]=xlsread(arq,pla,'D1:D20000');
[Oil_Rec_P1]=xlsread(arq,pla,'C1:C20000');
[Wat_Cut_P1]=xlsread(arq,pla,'B1:B20000');
[VPI_P1]=xlsread(arq,pla,'A1:A20000');
% [Cum_oil_P2]=xlsread(arq,pla,'X3:X20000');
% [Oil_Rec_P2]=xlsread(arq,pla,'W3:W20000');
% [Wat_Cut_P2]=xlsread(arq,pla,'V3:V20000');
% [VPI_P2]=xlsread(arq,pla,'U3:U20000');
% [Cum_oil_P3]=xlsread(arq,pla,'N3:N20000');
% [Oil_Rec_P3]=xlsread(arq,pla,'M3:M20000');
% [Wat_Cut_P3]=xlsread(arq,pla,'L3:L20000');
% [VPI_P3]=xlsread(arq,pla,'K3:K20000');
% [Cum_oil_P00]=xlsread(arq,pla,'S3:S4487');%MPFA
% [Oil_Rec_P00]=xlsread(arq,pla,'R3:R4487');
% [Wat_Cut_P00]=xlsread(arq,pla,'Q3:Q4487');
% [VPI_P00]=xlsread(arq,pla,'P3:P4487');
%% Plot cum_Oil
figure(1)
% plot(VPI_P00,Cum_oil_P00,'-k');hold on;
plot(VPI_FOU,Cum_oil_FOU,'-b');hold on;
plot(VPI_P1,Cum_oil_P1,'-r');hold on;
% plot(VPI_P2,Cum_oil_P2,'-g');hold on;
% plot(VPI_P3,Cum_oil_P3,'-m');hold off;
xlabel('VPI')
% legend('MPFA-FOU','MsCV-FOU-P0','MsCV-CPR-P1','MsCV-CPR-P3')
% legend('MPFA-FOU','MsCV-CPR-P1-S2','MsCV-CPR-P1-S1')
% legend('MPFA-FOU','MsCV-FOU-P0','MsCV-CPR-P1','MsCV-CPR-P2','MsCV-CPR-P3')
% legend('MPFA-FOU','MPFA-CPR-P1','MsCV-CPR-P1-S1','MsCV-CPR-P1-S2')
legend('MPFA-FOU','MsCV-CPR-P1')
title('Cumulate Oil'); grid on; grid minor;
%% Plot water_cut
figure(2)
% plot(VPI_P00,Wat_Cut_P00,'-k');hold on;
plot(VPI_FOU,Wat_Cut_FOU,'-b');hold on;
plot(VPI_P1,Wat_Cut_P1,'-r');hold on;
% plot(VPI_P2,Wat_Cut_P2,'-g');hold on;
% plot(VPI_P3,Wat_Cut_P3,'-m');hold off;

% legend('MPFA-FOU','MsCV-FOU-P0','MsCV-CPR-P1','MsCV-CPR-P2','MsCV-CPR-P3')
% legend('MPFA-FOU','MsCV-FOU-P0','MsCV-CPR-P1','MsCV-CPR-P3')
% legend('MPFA-FOU','MsCV-CPR-P1-S2','MsCV-CPR-P1-S1')
% legend('MPFA-FOU','MPFA-CPR-P1','MsCV-CPR-P1-S1','MsCV-CPR-P1-S2')
legend('MPFA-FOU','MsCV-CPR-P1')
title('Water Cut');
xlabel('VPI');  grid on; grid minor;
%% Plot Oil Rec
figure(3)

% plot(VPI_P00,Oil_Rec_P00,'-k');hold on;
plot(VPI_FOU,Oil_Rec_FOU,'-b');hold on;
plot(VPI_P1,Oil_Rec_P1,'-r');hold on;
% plot(VPI_P2,Oil_Rec_P2,'-g');hold on;
% plot(VPI_P3,Oil_Rec_P3,'-m');hold off;
% legend('MPFA-FOU','MsCV-FOU-P0','MsCV-CPR-P1','MsCV-CPR-P3')
% legend('MPFA-FOU','MsCV-CPR-P1-S2','MsCV-CPR-P1-S1')
% legend('MPFA-FOU','MPFA-CPR-P1','MsCV-CPR-P1-S1','MsCV-CPR-P1-S2')
% legend('MPFA-FOU','MsCV-FOU-P0','MsCV-CPR-P1','MsCV-CPR-P2','MsCV-CPR-P3');
legend('MPFA-FOU','MsCV-CPR-P1')
xlabel('VPI'); grid on; grid minor;
title('Oil Recovery')