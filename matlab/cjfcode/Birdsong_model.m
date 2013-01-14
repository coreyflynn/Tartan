%% Initialize the network and its components
inputspace=zeros(40,2);
inputspace(:,2)=2;
inputspace(:,1)=-2;
networks.HVC_RA=newff(inputspace,40);
networks.HVC_AFP=newff(inputspace,40);
activationlog.HVC_RA=zeros(40,8000);
activationlog.HVC_AFP=zeros(40,8000);
voclog=[];
t=1:400;
%% Train the network.
for N=1:100
    drive=mod(N,8)+1;
    %drive=round(rand*7+1);
    [networks,tmplog]=BirdTrain(networks,drive,80);
    activationlog.HVC_RA(:,((N-1)*80+1):N*80)=tmplog.HVC_RA;
    activationlog.HVC_AFP(:,((N-1)*80+1):N*80)=tmplog.HVC_AFP;
    figure(2);subplot(4,1,1);imagesc(activationlog.HVC_RA);title('HVC-RA');
    figure(2);subplot(4,1,2);imagesc(activationlog.HVC_AFP);title('HVC-AFP');
    tmp=zeros(1,400);
    for i=1:40
        tmp=tmp+sin(t*2*pi/i*10)*activationlog.HVC_RA(i,N*80);
    end
    voclog=horzcat(voclog,tmp);
    figure(2);subplot(4,1,3);plot(tmp);title('current vocalization');
    figure(2);subplot(4,1,4);spectrogram(tmp,256,250);
    soundsc(tmp);
    drawnow;
end
