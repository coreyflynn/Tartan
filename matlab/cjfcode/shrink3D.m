function new_stack=shrink3D(stack,nsize)
%% first scale all images in the stack
tmp=zeros(nsize(1),nsize(2),nsize(3));
for N=1:size(stack,3)
    tmp(:,:,N)=imresize(stack(:,:,N),[nsize(1) nsize(2)]);
end

%% now the second dim via a permuted stack
tmp2=permute(tmp,[1 3 2]);
tmp3=zeros(size(tmp2,1),nsize(3),size(tmp2,3));
for N=1:size(tmp2,3)
    tmp3(:,:,N)=imresize(tmp2(:,:,N),[size(tmp2,1) nsize(3)]);
end
new_stack=permute(tmp3,[1 3 2]);
