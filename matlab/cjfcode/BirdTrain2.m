function [networks,activation]=BirdTrain2(networks,activation,duration)
plottrig=0;
current=activation.current;
for i=1:duration
    vocselect=round(rand*7+1);
    tmpd=activation.pd(:,vocselect);
    for N=1:16
        [networks.HVC_RA,tmpHVC_RA]=adapt(networks.HVC_RA,...
                                          activation.HVC_RA(:,current)...
                                          +tmpd,...
                                          tmpd);
        activation.HVC_RA=horzcat(activation.HVC_RA,tmpHVC_RA);

        [networks.HVC_AFP,tmpHVC_AFP]=adapt(networks.HVC_AFP,...
                                            activation.HVC_AFP(:,current)...
                                            +activation.HVC_RA(:,current-1)...
                                            +activation.RA(:,current-10),...
                                            activation.HVC_RA(:,current-1)...
                                            +activation.RA(:,current-10));
        activation.HVC_AFP=horzcat(activation.HVC_RA,tmpHVC_AFP);

        [networks.RA,tmpRA]=adapt(networks.RA,...
                                  activation.HVC_RA(:,current-1)...
                                  +activation.RA(:,current)...
                                  +activation.AFP(:,current-8),...
                                  activation.HVC_RA(:,current-1)...
                                  +activation.AFP(:,current-8));
        activation.RA=horzcat(activation.RA,tmpRA);

        [networks.AFP,tmpAFP]=adapt(networks.AFP,...
                              activation.HVC_AFP(:,current-1)...
                              +activation.AFP(:,current),...
                              activation.template(:,vocselect));
        activation.AFP=horzcat(activation.AFP,tmpAFP);
        if mod(current,500)==0
        if size(activation.RA,2)<102
            figure(1);
            subplot(2,3,1);imagesc(activation.HVC_RA);title('HVC_RA');
            subplot(2,3,2);imagesc(activation.HVC_AFP);title('HVC_AFP');
            subplot(2,3,3);imagesc(activation.RA);title('RA');
            subplot(2,3,4);imagesc(activation.AFP);title('AFP');
            drawnow;
        else
            plottrig=1;
        end
        if plottrig==1;
            figure(1);
            subplot(2,3,1);imagesc(activation.HVC_RA(:,current-100:current));title('HVC_RA');
            subplot(2,3,2);imagesc(activation.HVC_AFP(:,current-100:current));title('HVC_AFP');
            subplot(2,3,3);imagesc(activation.RA(:,current-100:current));title('RA');
            subplot(2,3,4);imagesc(activation.AFP(:,current-100:current));title('AFP');
            drawnow;
        end
        activation.errorlog=horzcat(activation.errorlog,mean(activation.template(:,vocselect)-activation.RA(:,current))^2);
        subplot(2,3,5);semilogy(activation.errorlog);title(current);drawnow;
        end
        current=current+1;
    end
end
activation.current=current;