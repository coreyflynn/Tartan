function gctwrite(outputFilePath, sid, gn, gd, ge)

%open file for writing
f = fopen(outputFilePath,'at');

%write the required first field and the size of the data array
nRows = size(ge,1);
nCols = size(ge,2);
fprintf(f,'#1.2\n');
fprintf(f,'%i\t%i\n',nRows,nCols);

%write the name and file description column headings
fprintf(f,'Name\tDesc');
for ii = 1:nCols
	fprintf(f,'\t%s',sid{ii});
end
fprintf(f,'\n');
%write the name, description, and data for each row in the dataset
for ii = 1:nRows
	fprintf(f,'%s\t%s',gn{ii},gd{ii});
	for jj = 1:nCols
		fprintf(f,'\t%3.1f',ge(ii,jj));
	end
	fprintf(f,'\n');
end
%close file
fclose(f);