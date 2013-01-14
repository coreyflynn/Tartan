%Version 1.0 of BirdTrain2_Deafened.m
%This file simulates the effect of deafening the model
%
%This file takes as inputs the LifeHistory, activation, and networks
%structures returned by Birdsong_model2.m.
%
%USAGE:
%[networks,activation,LifeHistory]=BirdTrain2_audfeed(networks,activation,LifeHistory,duration,flag)
%
%VARIABLE DEFINITIONS:
%
%networks - structure of all of the four networks (HVC_RA, HVC_AFP, AFP,
%and RA) that are used in this model
%
%activation - structure of the activation histories of the above networks
%
%LifeHistory - stucture of the trainer, training syllable
%presentations, lesion, lesion syllables, and the creation or hatcher scipt
%
%duration - the number of syllable presentations to train the networks on
%
%flag - show or hide plotting after each syllable. set to 1 to show plots.
%anything else hides plots.


function [networks,activation,LifeHistory]=BirdTrain2_deafened(networks,activation,LifeHistory,duration,flag)
%% Initialize the plot trigger so plotting works properly, get the number of
%% time steps the network has already been trained for and initialize a
%% progress bar
plottrig=0;
current=activation.current;
h=waitbar(0,sprintf('Simulating syllable %d of %d',1,duration));
error_signal=zeros(1,8);
tmpE=zeros(1,8);
%% For each syllable presentation, randomly select a premotor drive 
for i=1:duration
    vocselect=round(rand*7+1);
    tmpd=activation.pd(:,vocselect);
%% For each syllable, Model it as 16 time steps long and adapt all of the
%% networks based on their connectivity patterns to one another
    for N=1:16
        %adapt HVC_RA
        [networks.HVC_RA,tmpHVC_RA]=adapt(networks.HVC_RA,...
                                          activation.HVC_RA(:,current)...
                                          +tmpd,...
                                          tmpd);
        activation.HVC_RA=horzcat(activation.HVC_RA,tmpHVC_RA);
        %adapt HVC_AFP
        [networks.HVC_AFP,tmpHVC_AFP]=adapt(networks.HVC_AFP,...
                                            activation.HVC_AFP(:,current)...
                                            +activation.HVC_RA(:,current-1),...
                                            activation.HVC_AFP(:,current-1));
        activation.HVC_AFP=horzcat(activation.HVC_RA,tmpHVC_AFP);
        %% simulate the error in training RA to the appropriate template
        %% and use this to determine how much of RA's target will come from
        %% its own activity and how much will come from AFP
        [dummy,dummyAct,E]=adapt(networks.AFP,...
                                  activation.HVC_AFP(:,current-1)...
                                  +activation.AFP(:,current),...
                                  activation.template(:,vocselect));
            tmpE(vocselect)=sum(E)^2;
            error_signal(vocselect)=networks.PrevError(vocselect)-tmpE(vocselect);
            networks.PrevError(vocselect)=tmpE(vocselect);
        % Use the error signal to adapt RA based on either its own activity
        % or the time delayed activity of AFP
        if error_signal(vocselect)<0 || error_signal(vocselect)==0
        [networks.RA,tmpRA]=adapt(networks.RA,...
                                  activation.HVC_RA(:,current-1)...
                                  +activation.RA(:,current),... 
                                  +activation.RA(:,current-1));
        activation.RA=horzcat(activation.RA,tmpRA); 
        end
        if error_signal(vocselect)>0
            [networks.RA,tmpRA]=adapt(networks.RA,...
                                  activation.HVC_RA(:,current-1)...
                                  +activation.RA(:,current),...
                                  +activation.AFP(:,current-6));
        activation.RA=horzcat(activation.RA,tmpRA); 
        end
        
        %adpat AFP
        [networks.AFP,tmpAFP]=adapt(networks.AFP,...
                              activation.HVC_AFP(:,current-1)...
                              +activation.AFP(:,current),...
                              activation.template(:,vocselect));
        activation.AFP=horzcat(activation.AFP,tmpAFP);
        %calculate the error between RA and the template for the current
        %syllable and place that value in the errorlog
                [dummy,dummyAct,E]=adapt(networks.RA,...
                                  activation.RA(:,current-1),...
                                  activation.template(:,vocselect));
            tmpE(vocselect)=sum(E)^2;
            
            
        activation.errorlog=horzcat(activation.errorlog,sum(tmpE)^2);
        %if plotting is requested, periodically output activities of all
        %networks as well as an plot of the errorlog.  Change the value 400
        %in the line "mod(current,400)==0" to a different number to plot
        %with a different frequency.  Otherwise, this will plot every 400
        %time steps.
        if flag==1
            if mod(current,400)==0
            %plot only latest 100 time steps unless there are fewer than
            %100 time steps to plot. 
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
            subplot(2,3,5);semilogy(activation.errorlog);title(current);drawnow;
            end
        end
        current=current+1;
    end
    %update the progress bar
    waitbar(i/duration,h,sprintf('Simulating syllable %d of %d',i,duration));
end
%close the progress bar and assign update a few variables in the structures
%to be returned
close(h);
activation.current=current;
LifeHistory.Deafener='BirdTrain2_deafned';
LifeHistory.DeafenerSyl=((activation.current-11)/16)-LifeHistory.TrainerSyl;