function [X,N,L]=extract_estimates(tt_lmb,model,im_width,im_height)
%extract estimates via MAP cardinality and corresponding tracks
rvect= get_rvals(tt_lmb); rvect= min(rvect,0.999); rvect= max(rvect,0.001);
cdn= prod(1-rvect)*esf(rvect./(1-rvect));
[~,mode] = max(cdn);
N = min(length(rvect),mode-1);
X= zeros(model.x_dim,N);
L= zeros(2,N);

[~,idxcmp]= sort(rvect,'descend');
for n=1:N
    [~,idxtrk]= max(tt_lmb{idxcmp(n)}.w);
    X(:,n)= tt_lmb{idxcmp(n)}.x*tt_lmb{idxcmp(n)}.w(:);
    L(:,n)= tt_lmb{idxcmp(n)}.l;
%     hold on;
%     plot(X(1,n),X(3,n),'Marker','s','MarkerSize',15,'MarkerEdgeColor','b');
%     text(round(X(1,n)),round(X(3,n)),strcat(int2str(L(1,n)),',',int2str(L(2,n))),'Color','k','FontSize',10);
%     pause(0.1)
%     hold off;
    
end

end
