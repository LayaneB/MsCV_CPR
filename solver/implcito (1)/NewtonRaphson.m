function [ S1, r ] = NewtonRaphson( S0, nw, no, dt, C )
%

So = S0;
S = S0;
S1 = S + 1;

dtC = dt*C;

x = 1;
r = S1 - S;

while (max(abs(r)) > 10^-3)&&(x<=4)
    
%     if (size(af,2)>1)&&(x==1)&&(ref1==0)&&(dt_frat<dt)
%         [S1] = firstorderstdfrat(S1,S0,influx,f_elem,dt,dt_frat,elem,inedge);
%         Sf = S1;
%         ref1 = 1;
% %     elseif ref1==1
% %         S1(elem(:,5)>nd)=Sf(elem(:,5)>nd);
%     end

    S = S1;

    [ fw_n1k ] = fractionalflow(S,nw,no);

    [ dfwdS_n1 ] = calcdfdS1T(S,nw,no);

    dfwdS_n1 = diag(dfwdS_n1); 

    r = So + dtC*fw_n1k - S;

    J_n1 = dtC*dfwdS_n1;

    J_n1 = J_n1 - eye(size(C));

    s = J_n1\r;

    S1 = S1 - s;
    
    S1(abs(S1)<10^-7) = 0;

    S1(abs(S1-1)<10^-7) = 1;
    
%    [ S1 ] = satnodesinfrat( S1 );

    x = x + 1;

end

end

