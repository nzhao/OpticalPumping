function [res_absorption, parameters] = vacuum_cell_absorption_RbD1(output_file, varargin)
%VACUUM_CELL_ABSORPTION_RBD1 calculates the absorption spectrum of rubidium
%(Rb85 and Rb87) in a vacuum cell (without pressure broadening).
%
%   Syntax: 
%     [res_absorption, parameters] = vacuum_cell_absorption_RbD1(output_filename, parameters)
%
%       *parameters* are given by name-value pairs as
%         'Name1', value1, 'Name2', value2, ...
%
%       The output *res_absorption* is the absorption cross section in [cm^2] as a function of *parameters('Frequency')*.
%
%   Paramter names and default values:
%   * 'Bx': magnetic field along x in [Tesla], (0.00001)
%   * 'By': magnetic field along y in [Tesla], (0.00000)
%   * 'Bz': magnetic field along z in [Tesla], (0.00003)
%   * 'Temperature': cell temperature in [degree Celsius], (20.0)
%   * 'Power': laser beam power in [W], (5e-6)
%   * 'Polarization': beam polarization, [1, 0] (linearly polarized)
%   * 'BeamRadius': beam radius in [m], (2e-3) 
%   * 'Frequency': laser beam frequency (relative to atom transition) in [MHz], (-5e3:50:6e3)
%   * 'PumpingTime': pumping time in [micro-second], (10.0)
%   * 'Mode': option 'vacuum', 'vacuum-ground', 'vacuum-full', 'vacuum-ground-rate'

    import Condition.Coil
    import Atom.AlkaliMetal
    import Gas.VaporGas
    import Laser.AlkaliLaserBeam
    import CellSystem.VaporCell

%% parameters
    default_parameters = containers.Map();
    default_parameters('Bx') = 0.00001;             % [Tesla]
    default_parameters('By') = 0.0;                 % [Tesla]
    default_parameters('Bz') = 0.00003;             % [Tesla]
    default_parameters('Temperature') = 20.0;       % [degree Celsius]
    default_parameters('Power') = 5e-6;             % [W]
    default_parameters('Polarization') = [1, 0];    % linearly polarized
    default_parameters('BeamRadius') = 2e-3;        % [m]
    default_parameters('Frequency') = -5e3:50:6e3;  % [MHz]
    default_parameters('PumpTime') = 10.0;          % [micro-second]
    default_parameters('Mode') = 'vacuum-ground';   % string: 'vacuum', 'vacuum-ground', 'vacuum-full', 'vacuum-ground-rate'
    default_parameters('Display') = 'on';           % Screen display: 'on', 'off'
    parameters = parse_paremeters(default_parameters, varargin);
    
    if strcmp(parameters('Display'), 'on')
        disp(keys(parameters));
        disp(values(parameters));
    end

%% parse args
    code_version = CodeVersion();
    start_at = datetime('now');
    if strcmp(parameters('Display'), 'on')
        fprintf('Using code with commit id: %s\n', code_version);
        disp(start_at);
    end

    
%% ingredients - system
    coil = { Condition.Coil('coilx', parameters('Bx') ), ...
             Condition.Coil('coily', parameters('By') ), ...
             Condition.Coil('coilz', parameters('Bz') ) };

    rb85=AlkaliMetal('85Rb', coil);  rb87=AlkaliMetal('87Rb', coil);

    gases={  VaporGas(rb85, 'vapor', 273.15+parameters('Temperature'), Atom.Transition.D1), ...
             VaporGas(rb87, 'vapor', 273.15+parameters('Temperature'), Atom.Transition.D1)};

    pumpBeam=AlkaliLaserBeam(parameters('Power'), rb87, Atom.Transition.D1, 0.0,... 
                             [0 0 1], parameters('Polarization'), parameters('BeamRadius')); 
    
    sys=VaporCell(gases, pumpBeam, parameters('Mode') );

%% core
    beam_index = 1;
    freqList = parameters('Frequency'); t_pump = parameters('PumpTime');
    res_absorption = sys.total_absorption_cross_section(beam_index, freqList, t_pump);
    
%% export
    finish_at = datetime('now'); 
    
    if strcmp(parameters('Display'), 'on')
        disp(finish_at);
    end

    if ~isempty(output_file)
        save(output_file, 'start_at', 'finish_at', 'code_version', 'parameters', ...
                          'coil', 'rb85', 'rb87', 'gases', 'pumpBeam', 'sys', ...
                          'freqList', 'res_absorption');
    end
end

