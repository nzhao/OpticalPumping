clear;clc;

import Atom.AlkaliMetal 
import Gas.VaporGas Gas.BufferGas

%% Ingredients

rb85=AlkaliMetal('85Rb');
rb87=AlkaliMetal('87Rb');

%%
cross_section = 1e-12;%cm^2
cell_length=1.0; % cm

temperature_list = 0:5:250;
density_list = zeros(1, length(temperature_list));
for k = 1: length(temperature_list)
    temperature=273.15+temperature_list(k);
    rb85Gas=VaporGas(rb85, 'vapor', temperature, Atom.Transition.D1);
    rb87Gas=VaporGas(rb87, 'vapor', temperature, Atom.Transition.D1);
    density_list(k) = 1e-6*(rb85Gas.density + rb87Gas.density);
end

title('Rb density vs. temperature (theory)');

yyaxis left;
semilogy(temperature_list,density_list, 'bo')
xticks(0:10:250);
xlabel('temperature {^\circ}C');
ylabel('Rb density cm^{-3}');

yyaxis right;
yticks(logspace(-4,4,9));
semilogy(temperature_list,density_list*cross_section*cell_length, 'b-')
ylabel('Optical Depth (OD), Parameters: \sigma =1e-12 cm^2, L=1');
grid on;

