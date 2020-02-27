function [ M,I ] = addMPFAD(M,I, edgesOnCoarseBoundary, oneNodeEdges, fluxMs, wsdynamic, Kde, Ded, Kn, Kt, nflag, Hesq ,mobility)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global  npar inedge elemloc bedge semiEdges
auxmobility1=mobility(1:size(inedge,1),:);
auxmobility2=mobility((size(inedge,1)+1):(size(inedge,1)+size(bedge,1)),:);
mobility(1:size(bedge,1),:)=auxmobility2;
mobility((size(bedge,1)+1):(size(inedge,1)+size(bedge,1)),:)=auxmobility1;
%%Adicionar a influência em ambos os lados do fluxo
w = 0;
s = 0;

for index = 1:size(edgesOnCoarseBoundary)
    
    refEdge = edgesOnCoarseBoundary(index);
    leftElem = inedge(refEdge,3);
    rightElem = inedge(refEdge,4);
    
%         leftSign = elemloc(leftElem)
%         rightSign = elemloc(rightElem)
%     
    
  %  ¨PARECE QUEEXISTE ALGUMA DIFERENÇA NO SINAL DO FLUXO DE FERNANDO
    I(leftElem) = I(leftElem) - fluxMs(index);
    I(rightElem) = I(rightElem) +  fluxMs(index);
    
end


for index=1:size(oneNodeEdges,1)
    iface = oneNodeEdges(index,1);
    iflag = oneNodeEdges(index,2);
    region = elemloc(inedge(iface,3));    
   
    %%readding influnce of prescribed dirichet nodes if somehow they got
    %subtracted from M and I 
    
 %    quando o nó pertece ao contorno interno, adiciona-se Neumann
    
    
    
    % %    quando o nó pertece ao contorno interno de Neumann
%     if nflag(inedge(iface,1),1)==202        
%         I(inedge(iface,3))=I(inedge(iface,3))+Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
%         I(inedge(iface,4))=I(inedge(iface,4))-Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
%     end
%     if nflag(inedge(iface,2),1)==202        
%         I(inedge(iface,3))=I(inedge(iface,3))-Kde(iface)*Ded(iface)*s(inedge(iface,2)); %ok
%         I(inedge(iface,4))=I(inedge(iface,4))+Kde(iface)*Ded(iface)*s(inedge(iface,2)); %ok
%     end
    
    
    
    %contorno com dirichlet prescrito
    %if iflag == 1 || iflag  == 3
    if true 
        if nflag(inedge(iface,1),1)<200
            I(inedge(iface,3))=I(inedge(iface,3))-mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
            I(inedge(iface,4))=I(inedge(iface,4))+mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
        end
    end
    
    %if iflag == 2 || iflag  == 3
    if true
        if nflag(inedge(iface,2),1)<200
            I(inedge(iface,3))=I(inedge(iface,3))+mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
            I(inedge(iface,4))=I(inedge(iface,4))-mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
        end
    end
    
    
    %adding S to the equation
    if nflag(inedge(iface,1),1) > 200 && (iflag == 1 || iflag  == 3) %==202
        point = inedge(iface,1);
%         point
%         region
%         if region == 84
%             1+1
%         end
        sWeight =  wsdynamic.readS(point,region);
        %         I(inedge(iface,3))=I(inedge(iface,3))-Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
        %         I(inedge(iface,4))=I(inedge(iface,4))+Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
        I(inedge(iface,3))=I(inedge(iface,3))-mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*sWeight; %ok
        I(inedge(iface,4))=I(inedge(iface,4))+mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*sWeight; %ok
    end
    %pode dar erro aqui
    if nflag(inedge(iface,2),1) > 200  && (iflag == 2 || iflag  == 3) %==202
        point = inedge(iface,2);
%         point
%         region
        sWeight =  wsdynamic.readS(point,region);
        I(inedge(iface,3))=I(inedge(iface,3))+mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*sWeight; %ok
        I(inedge(iface,4))=I(inedge(iface,4))-mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*sWeight; %ok
    end

    
    %% Checking and add flux around I and J
    
    
    %Contabilização das contribuições dos nós que não estão na
    %fronteiras de Dirichlet.
    %Ponto 1
   % if iflag == 1 || iflag  == 3
     if true
       if nflag(inedge(iface,1),1)>200
            point = inedge(iface,1);
            elemAround = [esurnOrd(point,region)];
            wWeight = wsdynamic.readW(point,region);
            for ii = 1:size(elemAround,1)
                locElem = elemAround(ii);           
            
%             for j=1:(esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1)))
%                 post_cont=esurn2(inedge(iface,1))+j;

                
                M(inedge(iface,3), locElem)=M(inedge(iface,3),locElem) +mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*wWeight(ii);
                M(inedge(iface,4), locElem)=M(inedge(iface,4),locElem) -mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*wWeight(ii);
            end
        end
    end
    %if iflag == 2 || iflag  == 3
    if true
        %Ponto 2
        if nflag(inedge(iface,2),1)>200
            point = inedge(iface,2);
            elemAround = [esurnOrd(point,region)];
            wWeight = wsdynamic.readW(point,region);
            
            for ii = 1:size(elemAround,1)
                locElem = elemAround(ii);
%             for j=1:(esurn2(inedge(iface,2)+1)-esurn2(inedge(iface,2))), ...
%                     post_cont=esurn2(inedge(iface,2))+j;
                M(inedge(iface,3), locElem)=M(inedge(iface,3),locElem) - mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*wWeight(ii);
                M(inedge(iface,4), locElem)=M(inedge(iface,4),locElem) + mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*wWeight(ii);

%                 M(inedge(iface,3), locElem)=M(inedge(iface,3),locElem) - Kde(iface)*Ded(iface)*wsdynamic.readW(point,region);
%                 M(inedge(iface,4), locElem)=M(inedge(iface,4),locElem) + Kde(iface)*Ded(iface)*wsdynamic.readW(point,region);           
%             
            end
        end
    end
end






%add semiEdges
for index=1:size(semiEdges,1)
    iface = semiEdges(index,1);
    iflag = semiEdges(index,2);
    region = elemloc(inedge(iface,3));    
   
    %%readding influnce of prescribed dirichet nodes if somehow they got
    %subtracted from M and I 
    
 %    quando o nó pertece ao contorno interno, adiciona-se Neumann
    
    
    
    % %    quando o nó pertece ao contorno interno de Neumann
%     if nflag(inedge(iface,1),1)==202        
%         I(inedge(iface,3))=I(inedge(iface,3))+Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
%         I(inedge(iface,4))=I(inedge(iface,4))-Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
%     end
%     if nflag(inedge(iface,2),1)==202        
%         I(inedge(iface,3))=I(inedge(iface,3))-Kde(iface)*Ded(iface)*s(inedge(iface,2)); %ok
%         I(inedge(iface,4))=I(inedge(iface,4))+Kde(iface)*Ded(iface)*s(inedge(iface,2)); %ok
%     end
    
    
    
    %contorno com dirichlet prescrito
    if iflag == 1 || iflag  == 3
        if nflag(inedge(iface,1),1)<200
            I(inedge(iface,3))=I(inedge(iface,3))-mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
            I(inedge(iface,4))=I(inedge(iface,4))+mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*nflag(inedge(iface,1),2);
        end
    end
    
    if iflag == 2 || iflag  == 3
        if nflag(inedge(iface,2),1)<200
            I(inedge(iface,3))=I(inedge(iface,3))+mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
            I(inedge(iface,4))=I(inedge(iface,4))-mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*nflag(inedge(iface,2),2);
        end
    end
    
    
    %adding S to the equation
    if nflag(inedge(iface,1),1) > 200 && (iflag == 1 || iflag  == 3) %==202
        point = inedge(iface,1);
%         point
%         region
%         if region == 84
%             1+1
%         end
        sWeight =  wsdynamic.readS(point,region);
        %         I(inedge(iface,3))=I(inedge(iface,3))-Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
        %         I(inedge(iface,4))=I(inedge(iface,4))+Kde(iface)*Ded(iface)*s(inedge(iface,1)); %ok
        I(inedge(iface,3))=I(inedge(iface,3))-mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*sWeight; %ok
        I(inedge(iface,4))=I(inedge(iface,4))+mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*sWeight; %ok
    end
    %pode dar erro aqui
    if nflag(inedge(iface,2),1) > 200  && (iflag == 2 || iflag  == 3) %==202
        point = inedge(iface,2);
%         point
%         region
        sWeight =  wsdynamic.readS(point,region);
        I(inedge(iface,3))=I(inedge(iface,3))+mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*sWeight; %ok
        I(inedge(iface,4))=I(inedge(iface,4))-mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*sWeight; %ok
    end

    
    %% Checking and add flux around I and J
    
    
    %Contabilização das contribuições dos nós que não estão na
    %fronteiras de Dirichlet.
    %Ponto 1
   if iflag == 1 || iflag  == 3
     if nflag(inedge(iface,1),1)>200
            point = inedge(iface,1);
            elemAround = [esurnOrd(point,region)];
            wWeight = wsdynamic.readW(point,region);
            for ii = 1:size(elemAround,1)
                locElem = elemAround(ii);           
            
%             for j=1:(esurn2(inedge(iface,1)+1)-esurn2(inedge(iface,1)))
%                 post_cont=esurn2(inedge(iface,1))+j;

                
                M(inedge(iface,3), locElem)=M(inedge(iface,3),locElem) +mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*wWeight(ii);
                M(inedge(iface,4), locElem)=M(inedge(iface,4),locElem) -mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*wWeight(ii);
            end
        end
    end
    if iflag == 2 || iflag  == 3
        %Ponto 2
        if nflag(inedge(iface,2),1)>200
            point = inedge(iface,2);
            elemAround = [esurnOrd(point,region)];
            wWeight = wsdynamic.readW(point,region);
            
            for ii = 1:size(elemAround,1)
                locElem = elemAround(ii);
%             for j=1:(esurn2(inedge(iface,2)+1)-esurn2(inedge(iface,2))), ...
%                     post_cont=esurn2(inedge(iface,2))+j;
                M(inedge(iface,3), locElem)=M(inedge(iface,3),locElem) - mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*wWeight(ii);
                M(inedge(iface,4), locElem)=M(inedge(iface,4),locElem) + mobility(iface+size(bedge,1),region)*Kde(iface)*Ded(iface)*wWeight(ii);

%                 M(inedge(iface,3), locElem)=M(inedge(iface,3),locElem) - Kde(iface)*Ded(iface)*wsdynamic.readW(point,region);
%                 M(inedge(iface,4), locElem)=M(inedge(iface,4),locElem) + Kde(iface)*Ded(iface)*wsdynamic.readW(point,region);           
%             
            end
        end
    end
end



end