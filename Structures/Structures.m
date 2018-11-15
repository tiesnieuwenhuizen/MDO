function [W_w] = Structures(x)
%STRUCTURES This function runs the structures discipline, including pre-
%and post-processing
%   Input: Design vector
%   Output: Wing weight

%% Convert design vector into useful values for EMWET
MTOW = x(32) + x(33) + Const.AWGroup.weight;
MZF = x(32) + Const.AWGroup.weight;

% Write airfoil data files
nx = 20; % Number of x-locations for coordinate files
coor = linspace(0,1,nx); % X-locations
airfoil_root = [fliplr(cstMap(x(8:13),coor)), cstMap(x(14:19),coor)]; % Root airfoil coordinates
airfoil_tip = [fliplr(cstMap(x(20:25),coor)), cstMap(x(26:31),coor)]; % Tip airfoil coordinates

arfile = fopen("airfoil_root.dat", 'wt');
for i = 1:nx
    fprintf(arfile, '%g %g\n', coor(nx-i+1), airfoil_root(i)); % Print upper curve from LE to TE as per manual
end
for j = 1:nx
    fprintf(arfile, '%g %g\n', coor(j), airfoil_root(nx+j)); % Print lower curve from TE to LE as per manual
end
fclose(arfile);

atfile = fopen("airfoil_tip.dat", 'wt');
for k = 1:nx
    fprintf(atfile, '%g %g\n', coor(nx-k+1), airfoil_tip(k)); % Print upper curve from LE to TE as per manual
end
for j = 1:nx
    fprintf(atfile, '%g %g\n', coor(k), airfoil_tip(nx+k)); % Print lower curve from TE to LE as per manual
end
fclose(atfile);

%% Write .init file for EMWET

%%%%%%%%%%%% NOT FINISHED %%%%%%%%%%%%%%

fid = fopen("test.init", 'wt');
fprintf(fid, '%g %g\n', MTOW, MZF);
fprintf(fid, '%g\n', Const.AC.n_max);
fprintf(fid, '%g %g %g %g\n', x(1), x(2)/2, Const.Wing.n_sec, Const.Wing.n_airfoils);
for i = 1:Const.Wing.n_airfoils
    fprintf(fid, '%g %s\n', Wing.Airfoils.loc(i), Wing.Airfoils.names(i));
end
for i = 1:Wing.Planform.n_sec
    fprintf(fid, '%g %g %g %g %g %g\n', Wing.Planform.chord(i), Wing.Planform.x(i), Wing.Planform.y(i), Wing.Planform.z(i), Wing.Planform.fspar_loc(i), Wing.Planform.rspar_loc(i));
end
fprintf(fid, '%g %g\n', Wing.Planform.ftank_start, Wing.Planform.ftank_end);
fprintf(fid, '%g \n', Wing.Engines.n/2);
for i = 1:Wing.Engines.n/2
    fprintf(fid, '%g %g\n', Wing.Engines.loc(i), Wing.Engines.w(i));
end
for i = 1:4
    fprintf(fid, '%g %g %g %g\n', Const.Material.ymodulus, Const.Material.density, Const.Material.ystress_t, Const.Material.ystress_c);
end
fprintf(fid, '%g %g\n', Const.Structure.panelfact, Const.Structure.rib_pitch);
fprintf(fid, '%g', Wing.displayoption);


%% %%%%%%%% CODE BELOW IS REFERENCE, USED FOR WRITING THE ABOVE %%%%%%%%%%

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

end

