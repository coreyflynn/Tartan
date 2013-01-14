% Birdsong_model2
%
% This script defines a set of networks to simulate birdsong learning. One
% time step of the networks is meant to represent 5ms of real time.
%
%
%% Initialize the network and its components, with a predefined random
%% initial activity log for all components.This initial activity will allow
%% the begining of training implimented in any of the paired trainers
%% (BirdTrain2*.m) to run smoothly as they attempt to use the previous 
%% activity of the networks created here.
% define the parameters for network input.
inputspace=zeros(40,2);
inputspace(:,2)=1;
inputspace(:,1)=-1;
% Generate four single layer feed forward networks used to simulate bird song
networks.HVC_RA=newff(inputspace,40);
networks.HVC_AFP=newff(inputspace,40);
networks.RA=newff(inputspace,40);
networks.AFP=newff(inputspace,40);
% create an array to track error for different syllable types to be
% presented
networks.PrevError=zeros(1,8);
% pre-define the previous activity of the networks as random activation for
% 11 time steps.  This random activation is centered on 0.
activation.HVC_RA=normrnd(0,.5,40,11);
activation.HVC_AFP=normrnd(0,.5,40,11);
activation.RA=normrnd(0,.5,40,11);
activation.AFP=normrnd(0,.5,40,11);
% create variables to track the current time step and log of the total error
% at each time step.
activation.current=11;
activation.errorlog=[];
% create a structure to track how the networks were created and how they
% are trained
LifeHistory.Trainer=[];
LifeHistory.TrainerSyl=[];
LifeHistory.Lesion=[];
LifeHistory.LesionSyl=[];
LifeHistory.Deafener=[];
LifeHistory.DeafenerSyl=[];
clear inputspace
%% Define 8 random sets of premotor drives for the network to map into
%% vocalizations based on the template values also determined here
activation.pd=zeros(40,8);
for N=1:40
    reset=0;
    while reset==0
        pdbin=round(rand*7+1);
        if sum(activation.pd(:,pdbin))<5
            activation.pd(N,pdbin)=1;
            reset=1;
        end
    end
end
clear pdbin reset
activation.template=zeros(40,8);
for N=1:8
    activation.template((N-1)*5+1:(N-1)*5+5,N)=1;
end
clear N
%% Label the creation of this network with this file in its LifeHistory
 LifeHistory.Hatcher='Birdsong_model2.m version 1.0';

    