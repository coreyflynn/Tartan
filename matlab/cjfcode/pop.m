function [matchIndList,array]=pop(array,string)
% finds all entries in an array that match the given value and returns
% those values in an array as well as the original array without those
% values included.

matchIndList=find(eval(sprintf('array%s',string)));
array(matchIndList)=[];