clear;clc;

import Condition.Coil
import Atom.AlkaliMetal
import Gas.Gas
import Laser.AlkaliLaserBeam
import CellSystem.VacuumCell

%% Ingredients
coil = { ... 
    Condition.Coil('coilx', 0.00001), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.00002)};

%rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);

temperature=273.15+20;
gases={ ...
%    Gas(rb85, 'vapor', temperature), ...
    Gas(rb87, 'vapor', temperature) ...
};

pumpBeam=AlkaliLaserBeam(5e-3, ...                     % power in [W]
                         rb87, Atom.Transition.D1, 0.0, ... % ref Atom 
                         [0 0 1], [1, 0], 2e-3);       % direction, pol, spot size
                     
%% System
% sys=VacuumCell(gases, pumpBeam);
% ss=null(sys.interaction{1, 2}.matrix.qsG{1});
% proj=[rb87.operator.cProj{1}; rb87.operator.cProj{2}];
% pop=real(ss(logical(proj)));
% pop=pop/sum(pop);


freqList = -10e3:50:10e3;
proj=[rb87.operator.cProj{1}; rb87.operator.cProj{2}];
pop=zeros(16, length(freqList));
for k = 1:length(freqList)
    freq = freqList(k);
    fprintf('freq = %f\n', freq);
    sys=VacuumCell(gases, pumpBeam.set_detuning(freq));
%     sys.interaction{1,2}.set_velocity_list(1000);
%     sys.interaction{1,2}.calc_matrix;
    ss=null(sys.interaction{1, 2}.matrix.qsG{1});
    ss0=ss(logical(proj));
    pop0=abs(ss0);
    max_pos=(pop0==max(pop0));
    pop0=pop0/ss0(max_pos);
    pop(:,k)=pop0/sum(pop0);
end
figure;
plot(freqList, real(sum(pop(end-2:end, :), 1)), 'r*-', freqList, real(sum(pop(end-7:end-3, :), 1)), 'bd-',...
    freqList, imag(sum(pop(end-2:end, :), 1)), 'k-', freqList, imag(sum(pop(end-7:end-3, :), 1)), 'k-')