clear;clc;

import Condition.Coil
import Atom.AlkaliMetal 
import Atom.Buffer.Nitrogen
import Atom.Buffer.He4
import Gas.VaporGas Gas.BufferGas
import Laser.AlkaliLaserBeam
%import CellSystem.VacuumCell
import CellSystem.VaporCell

%% Ingredients
coil = { ... 
    Condition.Coil('coilx', 0.00000), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.0000003)};

rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);
n2=Nitrogen();
he4=He4();

temperature=273.15+70;
gases={  VaporGas(rb85, 'vapor', temperature, Atom.Transition.D1), ...
         VaporGas(rb87, 'vapor', temperature, Atom.Transition.D1) ...
         BufferGas(n2, temperature, 50*Torr2Pa, 'N2'), ...
         BufferGas(he4, temperature, 700*Torr2Pa) ...
         };

pumpBeam_lin=AlkaliLaserBeam(300e-6, ...                     % power in [W]
                         rb87, Atom.Transition.D1, -2.25e3,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 4e-3);       % direction, pol, spot size
                     
pumpBeam_cir=AlkaliLaserBeam(300e-6, ...                     % power in [W]
                         rb87, Atom.Transition.D1, -2.25e3,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, -1i], 4e-3);       % direction, pol, spot size

t_pump = 1e4;
%% approximation ground state pumping

sysApproxGS_lin=VaporCell(gases, pumpBeam_lin, 'high-pressure');
sysApproxGS_cir=VaporCell(gases, pumpBeam_cir, 'high-pressure');

freqList=-150e3:2000:150e3;  beam_index = 1;
res_absorption_lin=sysApproxGS_lin.total_absorption_cross_section(beam_index, freqList, t_pump);
res_absorption_cir=sysApproxGS_cir.total_absorption_cross_section(beam_index, freqList, t_pump);

figure;plot(freqList, sum(res_absorption_lin, 1), 'rd-', freqList, sum(res_absorption_cir, 1), 'b*-')

% timeList = linspace(0, 5e4, 101);
% state=sysApproxGS_cir.evolution(3, timeList);
% popG = cell2mat(cellfun(@(s)  s.population(2), state, 'UniformOutput', false));
% figure;plot(timeList, popG)


%% dispMat
se=gases{2}.atom.operator.SE;
sd=gases{2}.atom.operator.SD;

interaction = sysApproxGS_cir.get_interaction(1, 3);
ker=interaction.getKernel(3);
kerSD=sysApproxGS_cir.interaction{3, 4}.matrix.kernel{2};

id8=eye(8); id8c=id8(:);
reorder = [find(id8c==1); find(id8c==0)];
reorder_ker=ker(reorder, reorder);
kerPop=ker(id8c==1, id8c==1);
kerSDPop=kerSD(id8c==1,id8c==1);

figure;dispMatC(reorder_ker);
figure; dispMat(kerPop);

se3pop=se(id8c==1, id8c==1, 3);
sdpop=sd(id8c==1, id8c==1);
figure;dispMat(se3pop)
figure;dispMat(sdpop)

%% evolution

pumpMat = sdpop+0.5*se3pop;

nt=101; res = zeros(8, nt);
tlist=linspace(0, 10, nt);
for k=1:101
    res(:,k)=expm(-2*pi* (pumpMat+1.5*sdpop) *tlist(k))*ones(8,1)/8.0;
end
plot(tlist, res)

smat=gases{2}.atom.matEigen.Smat{1};
sz=smat(:,:,3);
spinZ=diag(sz).'*res;

figure; plot(tlist, -spinZ)
