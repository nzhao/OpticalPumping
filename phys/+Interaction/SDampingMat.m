function [mat, rate] = SDampingMat( gas1, gas2 )
%SDAMPINGMAT Summary of this function goes here
%   Detailed explanation goes here
    
    sd_cross_section = Interaction.SD_Crosssection(gas1, gas2);
    relative_velocity = sqrt(gas1.velocity.^2 + gas2.velocity.^2);
    if strcmp(gas1.type, 'vapor')
        sd_mat   = gas1.atom.operator.SD;
        sd_rate1 = gas2.density*1e-6 ... % m-3 to cm-3
                 * sd_cross_section ...        % cm2
                 * relative_velocity*1e2 ...   % m/s to cm/s;
                 * 1e-6/2/pi;                  % s-1 to MHz;
        mat1 = sd_rate1 * sd_mat;
    else
        mat1 = 0.0;
        sd_rate1 = 0.0;
    end

    if strcmp(gas2.type, 'vapor')
        sd_mat   = gas2.atom.operator.SD;
        sd_rate2 = gas1.density*1e-6 ...       % m-3 to cm-3
                 * sd_cross_section ...        % cm2
                 * relative_velocity*1e2 ...   % m/s to cm/s;
                 * 1e-6/2/pi;                  % s-1 to MHz;
        mat2  = sd_rate2 * sd_mat;
    else
        mat2 = 0.0;
        sd_rate2 = 0.0;
    end
    mat = {mat1, mat2};
    rate = {sd_rate1, sd_rate2};
end

