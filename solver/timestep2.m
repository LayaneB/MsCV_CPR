function [d_t] = timestep2(S_old,influx,bflux,CFL,nw,no,inedge,bedge)
%

global F porousarea q

d_t = 1e49;

[dfdS1] = calcdfdS1T(S_old,nw,no);

for i=1:size(F,1)
   for j=1:size(F,2)
       if F(i,j)~=0
          if F(i,j)<=size(inedge,1)
              Q = q(i);
              VN = influx(F(i,j));
              dfdS = 0.5*(dfdS1(inedge(F(i,j),3))+dfdS1(inedge(F(i,j),4)));
              d_t0 = (porousarea(i)*CFL)/(abs(dfdS*VN)+abs(Q));
          else
              Q = q(i);
              VN = bflux(F(i,j)-size(inedge,1));
              dfdS = dfdS1(bedge(F(i,j)-size(inedge,1),3));
              d_t0 = (porousarea(i)*CFL)/(abs(dfdS*VN)+abs(Q));
          end          
       end
       if d_t0 < d_t
           d_t = d_t0;
       end
   end
end
                       
end

