function write_pairs_file(pairs,Time,fileID)
if isempty(pairs)
    fprintf(fileID,'No pairs for Frame = %d \n',Time);
else
    fprintf(fileID,'The label pairs in Frame = %d are: \n',Time);
    for k=1:size(pairs,2)
        fprintf(fileID,'The vehicle (%d,%d) has vehicle (%d,%d) in front. \n',pairs(1,k),pairs(2,k),pairs(3,k),pairs(4,k));
    end
end
end