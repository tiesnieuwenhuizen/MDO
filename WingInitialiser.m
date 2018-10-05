clear all
close all
clc

% General Data
Wing.MTOW = 20820;
Wing.MZF = 18600;
Wing.n_max = 2.5;

% Engine Data
Wing.Engines.n = 2; % Total amount of engines!!!
Wing.Engines.loc = [0.25];
Wing.Engines.w = [1200];

% Material Data (use matrices for info on all 4 panels)
Wing.Material.ymodulus = [7.1e10 7.1e10 7.1e10 7.1e10];
Wing.Material.density = [2800 2800 2800 2800];
Wing.Material.ystress_t = [4.8e8 4.8e8 4.8e8 4.8e8];
Wing.Material.ystress_c = [4.6e8 4.6e8 4.6e8 4.6e8];

% Structure Data
Wing.Structure.panelfact = 0.96; %% Z-type stringers
Wing.Structure.rib_pitch = 0.5;

% Airfoil Data
Wing.Airfoils.names = [e553 e553];
Wing.Airfoils.loc = [0 1];
Wing.Airfoils.n = size(Wing.Airfoil.loc,2);

% Planform inputs
Wing.Planform.n_sec = 3;
Wing.Planform.b = 28; % Total Span!!!
Wing.Planform.rchord = 3.5;
Wing.Planform.taper = 0.25;
Wing.Planform.sweep_LE = deg2rad(5);
Wing.Planform.fspar_loc = [0.2 0.2 0.2];
Wing.Planform.rspar_loc = [0.8 0.8 0.8];
Wing.Planform.ftank_start = 0.1;
Wing.Planform.ftank_end = 0.7;

% Planform calculations
Wing.Planform.tchord = Wing.Planform.rchord.*Wing.Planform.taper;
Wing.Planform.chord = [Wing.Planform.rchord Wing.Planform.tchord];
Wing.Planform.S = (Wing.Planform.(1) + Wing.Planform.chord(2))/2 .* Wing.Planform.b;
Wing.Planform.n_sec = size(Wing.Planform.Chord,2);
Wing.Planform.x = [0 ];
Wing.Planform.y = [0 ];
Wing.Planform.z = [0 ];