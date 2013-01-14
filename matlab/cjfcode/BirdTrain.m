function [networks,activationlog]=BirdTrain(networks,premotor_drive,duration)
pd=zeros(40,1);
chunk=40/8*premotor_drive;
pd((chunk-4):chunk)=1;
%pd=pd+normrnd(0,.5,40,1);
activation.HVC_RA=sim(networks.HVC_RA,pd);
activation.HVC_AFP=sim(networks.HVC_AFP,normrnd(0,.5,40,1));
activationlog.HVC_RA=zeros(40,duration);
activationlog.HVC_AFP=zeros(40,duration);
for N=1:duration+5
    if N<=5
        networks.HVC_RA=adapt(networks.HVC_RA,activation.HVC_RA+pd,pd);
        activation.HVC_RA=sim(networks.HVC_RA,activation.HVC_RA+pd);
        activationlog.HVC_RA(:,N)=activation.HVC_RA;
    elseif N<=duration
        networks.HVC_RA=adapt(networks.HVC_RA,activation.HVC_RA+pd,pd);
        activation.HVC_RA=sim(networks.HVC_RA,activation.HVC_RA+pd);
        activationlog.HVC_RA(:,N)=activation.HVC_RA;
        
        networks.HVC_AFP=adapt(networks.HVC_AFP,activation.HVC_AFP+activationlog.HVC_RA(:,N-5),circshift(pd,[10 0]));
        activation.HVC_AFP=sim(networks.HVC_AFP,activation.HVC_AFP+activationlog.HVC_RA(:,N-5));
        activationlog.HVC_AFP(:,N-5)=activation.HVC_AFP;
    else
        networks.HVC_AFP=adapt(networks.HVC_AFP,activation.HVC_AFP+activationlog.HVC_RA(:,N-5),circshift(pd,[10 0]));
        activation.HVC_AFP=sim(networks.HVC_AFP,activation.HVC_AFP+activationlog.HVC_RA(:,N-5));
        activationlog.HVC_AFP(:,N-5)=activation.HVC_AFP;
    end
end