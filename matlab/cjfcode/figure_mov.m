function figure_mov(fig,start_view,step,step_size,save_dir)
figure(fig);
view(start_view);
for N=1:step
    disp(sprintf('%g',N));
    camorbit(step_size,0);
    drawnow;
    fr=getframe(gcf,[0 0 1500 1500]);
    imwrite(fr.cdata,sprintf('%s/im%g.jpg',save_dir,N));
end
disp('woot');