function [W_w] = StructuresInit(x,MTOW,MZF)
%STRUCTURES This function runs the structures discipline, including pre-
%and post-processing
%   Input: Design vector (non-normalised!!!)
%   Output: Wing weight

global Const;

%% Convert design vector into useful values for EMWET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INSERT CALCULATIONS %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% CURRENT VALUES FOR 737 %%%%%%%%%%%%%%%%%%%%%%
chords = [7.38 4.02 1.51]; % [Root chord, kink chord, tip chord]
x_loc = [12.9 16.25 21.29]; % [x_LE_r, x_LE_k, x_LE_t]
y_loc = [0 4.7 14.175]; % [y_LE_r, y_LE_k, y_LE_t]
z_loc = [5 5.84 6.67]; % [z_LE_r, z_LE_k, z_LE_t]

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

fid = fopen("wing.init", 'wt');
fprintf(fid, '%g %g\n', MTOW, MZF);
fprintf(fid, '%g\n', Const.AC.n_max);
fprintf(fid, '%g %g %g %g\n', x(1)/2, x(2)/2, Const.Wing.n_sec+1, Const.Wing.n_airfoils);
fprintf(fid, '%g %s\n', 0, "airfoil_root");
fprintf(fid, '%g %s\n', 1, "airfoil_tip");
for i = 1:(Const.Wing.n_sec+1)
    fprintf(fid, '%g %g %g %g %g %g\n', chords(i), x_loc(i), y_loc(i), z_loc(i), Const.Structure.loc_fspar, Const.Structure.loc_rspar);
end
fprintf(fid, '%g %g\n', Const.Fuel.tank_start, Const.Fuel.tank_end);
fprintf(fid, '%g \n', Const.Engines.n/2);
for i = 1:Const.Engines.n/2
    fprintf(fid, '%g %g\n', Const.Engines.loc(i), Const.Engines.w(i));
end
for i = 1:4
    fprintf(fid, '%g %g %g %g\n', Const.Material.ymodulus, Const.Material.density, Const.Material.ystress_t, Const.Material.ystress_c);
end
fprintf(fid, '%g %g\n', Const.Structure.panelfact, Const.Structure.rib_pitch);
fprintf(fid, '%g', Const.Structure.displayoption);

%% Execute EMWET

EMWET wing

%% Read data from file

res = fopen("wing.weight", 'r'); % Open weight file for reading
data = textscan(res, '%s %s %s %f'); % Read first float and assign to W_w
W_w = data{4};

end

