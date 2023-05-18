function Write_XML(X,N,L,Time,fileID)
    if N == 0
         fprintf(fileID,'\t<frame number="%d">\n',Time);
         fprintf(fileID,'\t\t<objectlist>\n');
         fprintf(fileID,'\t\t</objectlist>\n');
         fprintf(fileID,'\t</frame>\n');
    else
        fprintf(fileID,'\t<frame number="%d">\n',Time);
        fprintf(fileID,'\t\t<objectlist>\n');
        for i = 1 : N
            fprintf(fileID,'\t\t\t<object time="%d" birth="%d">\n',L(1,i),L(2,i));
            fprintf(fileID,'\t\t\t\t<location X="%d" Y="%d" X_V="%d" Y_V="%d"', ...
                        (round(X(1,i))),(round(X(3,i))), ...
                        (round(X(2,i))),(round(X(4,i))));
            fprintf(fileID,'\t\t\t</object>\n');
        end
        fprintf(fileID,'\t\t</objectlist>\n');
        fprintf(fileID,'\t</frame>\n');
    end
end