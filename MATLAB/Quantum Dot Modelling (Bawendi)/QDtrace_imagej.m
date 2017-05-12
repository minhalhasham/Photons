%% 5.38 URIECA Module 10
% Massachusetts Institute of Technology
% Thomas Bischof
% 18 February 2011
%
% This function is intended for use in post-processing intensity data for
% different dots, to determine blinking time distributions. In particular,
% the function reads in data from a trajectory file generated by ImageJ,
% which should be stored as an Excel-style file, with commas delimiting
% columns. Each row represents a different frame, and each column reresents
% a different particle. The first row contains names and the first column
% contains the frame number, so we throw these out. If you run the particle
% analysis routine in ImageJ for multiple particles and frames (Multi
% Measure under the ROI Manager menu) and save the result, the format
% should be correct.
%
% The function requires:
% filename: string containing in name of the data file
% dt: integration time for a frame, in seconds
%
% The function returns:
% t: a 1xN array with the times associated with each frame.
% timetrace: an NxM array with the intensity for each selected region at
%            each frame
% threshold: the threshold value for each region of interest, which
%            defines the division between an off and an on dot.
% ontimes, offtimes: 1xP vectors with on and off times for the regions
%
function [t, timetrace, threshold, ontimes, offtimes] = ...
    QDtrace_imagej(filename, dt)
% Load the data into memory.
timetrace = read_imagej(filename);

% Now that we have the data, we want to iterate through all of the
% particles, setting a threshold for each and collecting the statistics.
[n_frames, n_particles] = size(timetrace);
t = 0:dt:(dt*(n_frames-1));
threshold = zeros(n_particles,1);
ontimes = [];
offtimes = [];

tracefig = figure();

for j=1:n_particles
    threshold(j) = set_threshold(t, timetrace(:,j), tracefig)
    [myontimes, myofftimes] = dotsonoff(timetrace(:,j), threshold(j));
    ontimes = [ontimes myontimes]; 
    offtimes = [offtimes myofftimes];
end

plotonoff(ontimes, offtimes, dt);
