function [freqList, res_absorption] = vacuum_cell_absorption_RbD2(output_file, varargin)
%VACUUM_CELL_ABSORPTION_RBD2 calculates the absorption spectrum of rubidium
%(Rb85 and Rb87) in a vacuum cell (without pressure broadening).
%
%   Syntax: 
%     [freq, absorption_spectrum] = vacuum_cell_absorption_RbD2(output_filename, parameters)
%
%       *parameters* are given by name-value pairs as
%         'Name1', value1, 'Name2', value2, ...
%
%       The output *absorption_spectrum* is the absorption cross section in [cm^2] as a function of *freq*.
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

    import Condition.Coil
    import Atom.AlkaliMetal
    import Gas.Gas
    import Laser.AlkaliLaserBeam
    import CellSystem.VacuumCell

%% parse args
    code_version = CodeVersion();
    fprintf('Using code with commit id: %s\n', code_version);
    start_at = datetime('now'); disp(start_at);

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
    parameters = parse_paremeters(default_parameters, varargin);
    
    disp(keys(parameters));
    disp(values(parameters));
    
%% ingredients - system
    coil = { Condition.Coil('coilx', parameters('Bx') ), ...
             Condition.Coil('coily', parameters('By') ), ...
             Condition.Coil('coilz', parameters('Bz') ) };

    rb85=AlkaliMetal('85Rb', coil);  rb87=AlkaliMetal('87Rb', coil);

    gases={  Gas(rb85, 'vapor', 273.15+parameters('Temperature'), Atom.Transition.D2), ...
             Gas(rb87, 'vapor', 273.15+parameters('Temperature'), Atom.Transition.D2)};

    pumpBeam=AlkaliLaserBeam(parameters('Power'), rb87, Atom.Transition.D2, 0.0,... 
                             [0 0 1], parameters('Polarization'), parameters('BeamRadius')); 
    
    sys=VacuumCell(gases, pumpBeam);

%% core
    freqList = parameters('Frequency'); t_pump = parameters('PumpTime');
    res_absorption = sys.total_absorption_cross_section(freqList, t_pump);
    
%% export
    finish_at = datetime('now'); disp(finish_at);

    save(output_file, 'start_at', 'finish_at', 'code_version', 'parameters', ...
                      'coil', 'rb85', 'rb87', 'gases', 'pumpBeam', 'sys', ...
                      'freqList', 'res_absorption');

end

