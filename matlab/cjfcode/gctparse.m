function output = gctparse(inputFilePath)
% Program: gctparse
% Author: Corey Flynn
% Date: 3/12/2011
% 
% This function reads a gct formatted file and creates an output sturcture with
% the fields listed below.
%
% OUTPUT STRUCTURE FIELDS:
% output.sid: sample id names
% output.gn: gene names
% output.gnd: gene descriptions
% output.ge: an MxN matrix of genes(M)xsamples(N).
%
% USAGE: output = gctparse(inputFilePath)
%
% INPUT VARIABLE DEFINITIONS
% inputFilePath: the file path of the .gct file to be read
%					 
% OUTPUT VARIABLE DEFINITIONS
% output: The ouput structure containing the fields sid, gn, gd, and ge decribed
%   	  above


% Get the number of genes and samples in the dataset
f=fopen(inputFilePath,'rt');
fscanf(f,'%s',1); %scan past the header number
numGenes = fscanf(f,'%i',1);
numSamples = fscanf(f,'%i',1);

% Store sample names
fscanf(f,'%s',2); %scan past name and descriptor collumn headers
output.sid = cell(numSamples,1);
for ii = 1:numSamples
	output.sid{ii} = fscanf(f,'%s',1);
end
fclose(f);
% Store gene names and descriptors into cell arrays. 
%namesAndDescriptors = textscan(f, '%s %s %*[^\n]','delimiter','\t');
%output.gn = namesAndDescriptors{1};
%output.gd = namesAndDescriptors{2};
%output.gn = cell(numGenes,1);
%output.gd = cell(numGenes,1);
%for ii = 1:numGenes
%	geneName = textscan(f,'%s\t',1,'Delimiter','\t');
%	output.gn{ii} = geneName{1}{1};
%	geneDesc = textscan(f,'%s\t',1,'Delimiter','\t');
%	output.gd{ii} = geneDesc{1}{1};
%	fscanf(f,'%f',numSamples);
%end
[output.gn output.gd]=textread(inputFilePath,'%s %s %*[^\n]','headerlines',3,...
								'bufsize',30000, 'delimiter','\t');


% Store data into an numGenes x numSamples matrix	
output.ge=dlmread(inputFilePath,'\t',[3 2 numGenes+2 numSamples+1]);
