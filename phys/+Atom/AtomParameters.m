function parameters = AtomParameters( name )
%ATOMPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

            switch char(name)
                case '85Rb'
                    parameters.dim=12+12+24;
                    parameters.spin_S=0.5;
                    parameters.LgS=2.00231;% Lande g-value of S1/2 state
                    parameters.LgJ1=(2*0.5+1)/3.0;
                    parameters.LgJ2=(2*1.5+1)/3.0;

                    % fine-structure parameters
                    parameters.config='[Kr]5s';     %electron configuation
                    parameters.IP=4.1771;           %ionization potential in eV
                    parameters.lambda_D1=794.979014933;   %wave length of D1 transition in nm % Daniel Steck, transition diagram
                    parameters.lambda_D2=780.241368271;   %wave length of D2 transition in nm % Daniel Steck, transition diagram

                    parameters.delta_FS=237.60;     %Fine-structure splitting in cm^(-1)
                    parameters.tau_1=27.75;         %lifetime of P_1/2 states
                    parameters.tau_2=26.25;         %lifetime of P_3/2 states
                    parameters.osc_1=0.341;         %oscillator strength of P_1/2 stats
                    parameters.osc_2=0.695;         %oscillator strength of P_3/2 stats
                    
                    % hyperfine-structure parameters
                    parameters.abundance=0.7217;    %natural abundance
                    parameters.spin_I=5./2.;        %nuclear spin number
                    parameters.mu_I=1.35335;        %nuclear magnetic moment in [mu_N]
                    parameters.lamJ1=7802e-10;       %D2 wavelength in m when J=1.5
                    parameters.te1=26.23e-9;          %spontaneous P1/2 lifetime in s  J=1.5
                    parameters.lamJ2=7947e-10;        %D1 wavelength in m    J=0.5
                    parameters.lambda = [7947e-10, 7800e-10];
                    parameters.te2=27.68e-9;          %spontaneous P1/2 lifetime in when J=0.5
                    parameters.te = [27.68e-9, 26.23e-9];
                    parameters.hf_gs=1011.91;   %  hf coeff of ground state S_1/2 in MHz
                    parameters.hf_es1=120.527;       %hf coeff of excited state P_1/2 in MHz
                    parameters.hf_es2A=25.00;       %hf coeff_A of excited state P_3/2 state in MHz
                    parameters.hf_es2B=25.790;       %hf coeff_B of excited state P_3/2 state in MHz
                    
                    parameters.mass = 84.912;         % approx. grams/mole
                    parameters.Tmelt = 39.3+273.15;
                    
                    parameters.LambdaRef = parameters.lambda_D1;
                case '87Rb'
                    parameters.dim=8+8+16;
                    parameters.spin_S=0.5;
                    parameters.LgS=2.00231;% Lande g-value of S1/2 state
                    parameters.LgJ1=(2*0.5+1)/3.0;
                    parameters.LgJ2=(2*1.5+1)/3.0;

                    % fine-structure parameters
                    parameters.config='[Kr]5s';     %electron configuation
                    parameters.IP=4.1771;           %ionization potential in eV
                    parameters.lambda_D1=794.978851156;   %wave length of D1 transition in nm % Daniel Steck, transition diagram
                    parameters.lambda_D2=780.241209686;   %wave length of D2 transition in nm % Daniel Steck, transition diagram

                    parameters.delta_FS=237.60;     %Fine-structure splitting in cm^(-1)
                    parameters.tau_1=27.75;         %lifetime of P_1/2 states
                    parameters.tau_2=26.25;         %lifetime of P_3/2 states
                    parameters.osc_1=0.341;         %oscillator strength of P_1/2 stats
                    parameters.osc_2=0.695;         %oscillator strength of P_3/2 stats
                    
                    % hyperfine-structure parameters
                    parameters.abundance=0.2783;    %natural abundance
                    parameters.spin_I=3./2.;        %nuclear spin number
                    parameters.mu_I=2.75182;        %nuclear magnetic moment in [mu_N]
                    parameters.lamJ1=7800e-10;       %D2 wavelength in m when J=1.5
                    parameters.te1=25.5e-9;          %spontaneous P1/2 lifetime in s  J=1.5
                    parameters.lamJ2=7947e-10;        %D1 wavelength in m    J=0.5
                    parameters.lambda = [7947e-10, 7800e-10];
                    parameters.te2=28.5e-9;          %spontaneous P1/2 lifetime in when J=0.5
                    parameters.te = [25.5e-9, 28.5e-9];
                    parameters.hf_gs=3417.35;   %  hf coeff of ground state S_1/2 in MHz
                    parameters.hf_es1=406.12;       %hf coeff of excited state P_1/2 in MHz
                    parameters.hf_es2A=84.72;       %hf coeff_A of excited state P_3/2 state in MHz
                    parameters.hf_es2B=12.50;       %hf coeff_B of excited state P_3/2 state in MHz
                    
                    parameters.mass = 86.909;         % approx. grams/mole
                    parameters.Tmelt = 39.3+273.15;
                    
                    parameters.LambdaRef = parameters.lambda_D1;


                case '133Cs'
                    parameters.dim=16+16+32;
                    parameters.spin_S=0.5;
                    parameters.LgS=2.00231;% Lande g-value of S1/2 state
                    parameters.LgJ1=(2*0.5+1)/3.0;
                    parameters.LgJ2=(2*1.5+1)/3.0;

                    % fine-structure parameters
                    parameters.config='[Xe]6s';     %electron configuation
                    parameters.IP=3.8939;           %ionization potential in eV
                    parameters.lambda_D1=894.59295986;   %wave length of D1 transition in nm % Daniel Steck, transition diagram
                    parameters.lambda_D2=852.34727582;   %wave length of D2 transition in nm % Daniel Steck, transition diagram
                    parameters.delta_FS=554.04;     %Fine-structure splitting in cm^(-1)
                    parameters.tau_1=34.88;         %lifetime of P_1/2 states
                    parameters.tau_2=30.462;         %lifetime of P_3/2 states
                    parameters.osc_1=0.344;         %oscillator strength of P_1/2 stats
                    parameters.osc_2=0.715;         %oscillator strength of P_3/2 stats
                    
                    % hyperfine-structure parameters
                    parameters.abundance=1;    %natural abundance
                    parameters.spin_I=7./2.;        %nuclear spin number
                    parameters.mu_I=2.58203;        %nuclear magnetic moment in [mu_N]
                    parameters.lamJ1=8523.47e-10;       %D2 wavelength in m when J=1.5
                    parameters.te1=30.462e-9;          %spontaneous P3/2 lifetime in s  J=1.5
                    parameters.lamJ2=8945.93e-10;        %D1 wavelength in m    J=0.5
                    parameters.lambda = [8945.93e-10, 8523.47e-10];
                    parameters.te2=34.88e-9;          %spontaneous P1/2 lifetime in when J=0.5
                    parameters.te = [30.462e-9, 34.88e-9];
                    parameters.hf_gs=2298.1579425;   %  hf coeff of ground state S_1/2 in MHz
                    parameters.hf_es1=291.91;       %hf coeff of excited state P_1/2 in MHz
                    parameters.hf_es2A=50.29;       %hf coeff_A of excited state P_3/2 state in MHz
                    parameters.hf_es2B=-0.49;       %hf coeff_B of excited state P_3/2 state in MHz
                    
                    parameters.mass = 133;         % approx. grams/mole
                    parameters.Tmelt = 28.5+273.15;
                    
                    parameters.LambdaRef = parameters.lambda_D1;
                    
                case '131Xe'
                    parameters.mass = 131;         % approx. grams/mole
                    parameters.spin_K = 0.5;
                    
                case '4He'
                    parameters.mass = 4;
                
                case '14N'
                    parameters.mass = 14;
                    
                case 'N2'
                    parameters.mass = 28;
                    
                otherwise
                        error('no atomic data.');
            end
            
            if ismember(name, {'85Rb', '87Rb', '133Cs'})
                    parameters.wavenumber_D1 = 2*pi/(parameters.lambda_D1*1e-9);
                    parameters.wavenumber_D2 = 2*pi/(parameters.lambda_D2*1e-9);
                    parameters.wavenumber = [parameters.wavenumber_D1, parameters.wavenumber_D2];
                    parameters.omega_D1 = c_velocity*parameters.wavenumber_D1;
                    parameters.omega_D2 = c_velocity*parameters.wavenumber_D2; 
                    parameters.omega = [parameters.omega_D1, parameters.omega_D2];
                    
                    parameters.dipole_D1 = sqrt( (3*h_bar) * (4*pi*eps0) / (4*parameters.tau_1*1e-9*parameters.wavenumber_D1^3) );
                    parameters.dipole_D2 = sqrt( (3*h_bar) * (4*pi*eps0) / (4*parameters.tau_2*1e-9*parameters.wavenumber_D2^3) * 2 );
                    parameters.dipole = [parameters.dipole_D1, parameters.dipole_D2];                
                    parameters.gamma_s = 1./parameters.te /2/pi * 1e-6; %spontaneous decay rate in MHz
            end
end









