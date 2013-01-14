function alignedims=vessel_align
tps_script1;
dlgans='Yes';
filetok=strtok(file1,'.');
eval(sprintf('alignedims.%s=result',filetok));
imwrite(eval(sprintf('alignedims.%s',filetok)),sprintf('%s/%s_aligned.jpg',path2,filetok));
dlgans=questdlg('Apply the same transform to another image?');
if strcmp(dlgans,'Yes')==1
    [filetmp,pathtmp]=uigetfile({'*.bmp';'*.jpg';'*.tif'},'Select Image to transform'...
        ,path2,'MultiSelect','on');
    if iscell(filetmp)==1
        for N=1:length(filetmp)
            filetok=strtok(filetmp{N},'.');
            i1 = imread(sprintf('%s/%s',pathtmp,filetmp{N}));
            img_src = double((i1));
            clear i1;
            img_src = img_src./max(max(img_src));
            imtmp = interp2(img_src,tmp_fx,tmp_fy,'linear',0);
            eval(sprintf('alignedims.%s=imtmp',filetok));
            imwrite(eval(sprintf('alignedims.%s',filetok)),sprintf('%s/%s_aligned.jpg',pathtmp,filetok));
        end
    else
        filetok=strtok(filetmp,'.');
        i1 = imread(sprintf('%s/%s',pathtmp,filetmp));
        img_src = double((i1));
        clear i1;
        img_src = img_src./max(max(img_src));
        imtmp = interp2(img_src,tmp_fx,tmp_fy,'linear',0);
        eval(sprintf('alignedims.%s=imtmp',filetok));
        imwrite(eval(sprintf('alignedims.%s',filetok)),sprintf('%s/%s_aligned.jpg',pathtmp,filetok));
    end
end
    