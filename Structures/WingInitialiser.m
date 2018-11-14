%{
This file is used at the start of the optimisation to create the "Wing"
object with default values
%}


clear all
close all
clc

% General Data
Wing.MTOW = 46040;
Wing.MZF = 37421;
Wing.n_max = 2.5;
Wing.displayoption = 1;

% Engine Data
Wing.Engines.n = 4; % Total amount of engines!!!
Wing.Engines.loc = [0.315 0.5];
Wing.Engines.w = [628 628];

% Airfoil Data
Wing.Airfoils.names = ["e553" "e553"];  % RJ115 uses 15.3% thickness at root and 12.2% thickness at tip
Wing.Airfoils.loc = [0 1];
Wing.Airfoils.n = size(Wing.Airfoils.loc,2);

% Planform inputs
Wing.Planform.n_sec = 3;
Wing.Planform.b = 26.21; % Total Span!!!
Wing.Planform.rchord = 3.5;
Wing.Planform.taper = 0.356;
Wing.Planform.sweep_LE = deg2rad(5);
Wing.Planform.fspar_loc = [0.2 0.2 0.2];
Wing.Planform.rspar_loc = [0.8 0.8 0.8];
Wing.Planform.ftank_start = 0.1;
Wing.Planform.ftank_end = 0.7;
Wing.Planform.kink_loc = 0.4*Wing.Planform.b/2; % Replace with value to lock absolute location
% Wing.Planform.kink_chord
Wing.Planform.dihedral = deg2rad(0);

% Planform calculations
Wing.Planform.tchord = Wing.Planform.rchord.*Wing.Planform.taper;
Wing.Planform.kink_chord = Wing.Planform.rchord*Wing.Planform.kink_loc*Wing.Planform.taper; 
% Use kink_chord if no actual kink is present, replace with value to lock
Wing.Planform.chord = [Wing.Planform.rchord Wing.Planform.kink_chord Wing.Planform.tchord];
Wing.Planform.S = (Wing.Planform.chord(1) + Wing.Planform.chord(3))/2 .* Wing.Planform.b;
Wing.Planform.n_sec = size(Wing.Planform.chord,2);
Wing.Planform.x = [0 Wing.Planform.kink_loc*tan(Wing.Planform.sweep_LE) Wing.Planform.b/2*tan(Wing.Planform.sweep_LE)];
Wing.Planform.y = [0 Wing.Planform.kink_loc Wing.Planform.b/2];
Wing.Planform.z = [0 Wing.Planform.kink_loc*tan(Wing.Planform.dihedral) Wing.Planform.b/2*tan(Wing.Planform.dihedral)];