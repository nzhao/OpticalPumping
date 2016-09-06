function parameters = AtomParameters( name )
%ATOMPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

            switch char(name)
                case '87Rb'
                    parameters.dim=8+8+16;
                    parameters.spin_S=0.5;
                    parameters.LgS=2.00231;% Lande g-value of S1/2 state
                    parameters.LgJ1=(2*1.0+1)/3.0;
                    parameters.LgJ2=(2*2.0+1)/3.0;

                    % fine-structure parameters
                    parameters.config='[Kr]5s';     %electron configuation
                    parameters.IP=4.1771;           %ionization potential in eV
                    parameters.lambda_D1=794.978;   %wave length of D1 transition in nm
                    parameters.lambda_D2=780.241;   %wave length of D2 transition in nm
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
                    parameters.te2=28.5e-9;          %spontaneous P1/2 lifetime in when J=0.5
                    parameters.hf_gs=3417.35;   %  hf coeff of ground state S_1/2 in MHz
                    parameters.hf_es1=406.12;       %hf coeff of excited state P_1/2 in MHz
                    parameters.hf_es2A=84.72;       %hf coeff_A of excited state P_3/2 state in MHz
                    parameters.hf_es2B=12.50;       %hf coeff_B of excited state P_3/2 state in MHz
                case '133Cs'
                    parameters.dim=16+16+32;
                    parameters.spin_S=0.5;
                    parameters.LgS=2.00231;% Lande g-value of S1/2 state
                    parameters.LgJ1=(2*3.0+1)/3.0;
                    parameters.LgJ2=(2*4.0+1)/3.0;

                    % fine-structure parameters
                    parameters.config='[Xe]6s';     %electron configuation
                    parameters.IP=3.8939;           %ionization potential in eV
                    parameters.lambda_D1=894.593;   %wave length of D1 transition in nm
                    parameters.lambda_D2=852.347;   %wave length of D2 transition in nm
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
                    parameters.te2=34.88e-9;          %spontaneous P1/2 lifetime in when J=0.5
                    parameters.hf_gs=4596.315885;   %  hf coeff of ground state S_1/2 in MHz
                    parameters.hf_es1=291.91;       %hf coeff of excited state P_1/2 in MHz
                    parameters.hf_es2A=50.29;       %hf coeff_A of excited state P_3/2 state in MHz
                    parameters.hf_es2B=-0.49;       %hf coeff_B of excited state P_3/2 state in MHz
                otherwise
                        error('no atomic data.');
            end    

end

