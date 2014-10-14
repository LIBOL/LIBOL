function [ mdata ] = arff2matlab(filename)
% Load data from a weka .arff file into matlab (a n*d data matrix)
%
wekaOBJ = loadARFF(filename);
mdata = weka2matlab(wekaOBJ);
