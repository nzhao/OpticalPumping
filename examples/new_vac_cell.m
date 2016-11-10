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
    Condition.Coil('coilz', 0.00003)};

%rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);

temperature=273.15+20;
gases={ ...
%    Gas(rb85, 'vapor', temperature), ...
    Gas(rb87, 'vapor', temperature) ...
};

pumpBeam=AlkaliLaserBeam(5e-7, ...                     % power in [W]
                         rb87, Atom.Transition.D1, 4580,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 2e-3);       % direction, pol, spot size
                     
%% System
% sys=VacuumCell(gases, pumpBeam);
% ss=null(sys.interaction{1, 2}.matrix.qsG{1});
% proj=[rb87.operator.cProj{1}; rb87.operator.cProj{2}];
% pop=real(ss(logical(proj)));
% pop=pop/sum(pop);


%%

timeList = linspace(0, 1e3, 101);
pop=zeros(16, length(timeList));
id8=eye(8);
init_state=zeros(64+64+64+64, 1); init_state(end-63:end) = id8(:)/8;
projE=zeros(64+64+64+64, 1);projE(1:64) = id8(:);
projG=zeros(64+64+64+64, 1);projE(end-63:end) = id8(:);

sys=VacuumCell(gases, pumpBeam);
ker = sys.interaction{1, 2}.matrix.fullG;
sort(real(eig(ker)))
for k=1:length(timeList)
    t=timeList(k);
    fprintf('time = %f\n', t);
    state=expm(-ker*t)*init_state;
    pop(:,k)=state([logical(projE); logical(projG)]);
end
figure;
subplot(1,3,1)
plot(timeList,pop(1:8, :))
subplot(1,3,2)
plot(timeList,pop(9:16, :))
subplot(1,3,3)
plot(timeList,sum(pop,1))

%%
% proj=[rb87.operator.cProj{1}; rb87.operator.cProj{2}];
% init_state_qs=rb87.operator.thermal_state_qs{1};
% ker_qs = sys.interaction{1, 2}.matrix.qsG{1};
% for k=1:length(timeList)
%     t=timeList(k);
%     fprintf('time = %f\n', t);
%     state=expm(-ker_qs*t)*init_state_qs;
%     pop(:,k)=state(logical(proj));
% end
% figure;
% subplot(1,3,1)
% plot(timeList,pop(1:8, :))
% subplot(1,3,2)
% plot(timeList,pop(9:16, :))
% subplot(1,3,3)
% plot(timeList,sum(pop,1))


%%
% freqList = -10e3:50:10e3;
% 
% for k = 1:length(freqList)
%     freq = freqList(k);
%     fprintf('freq = %f\n', freq);
%     sys=VacuumCell(gases, pumpBeam.set_detuning(freq));
% %     sys.interaction{1,2}.set_velocity_list(1000);
% %     sys.interaction{1,2}.calc_matrix;
%     ss=null(sys.interaction{1, 2}.matrix.qsG{1});
%     ss0=ss(logical(proj));
%     pop0=abs(ss0);
%     max_pos=(pop0==max(pop0));
%     pop0=pop0/ss0(max_pos);
%     pop(:,k)=pop0/sum(pop0);
% end
% figure;
% plot(freqList, real(sum(pop(end-2:end, :), 1)), 'r*-', freqList, real(sum(pop(end-7:end-3, :), 1)), 'bd-',...
%     freqList, imag(sum(pop(end-2:end, :), 1)), 'k-', freqList, imag(sum(pop(end-7:end-3, :), 1)), 'k-')

%%
freqList = -10e3:20:10e3;

for k = 1:length(freqList)
    freq = freqList(k);
    fprintf('freq = %f\n', freq);
    sys=VacuumCell(gases, pumpBeam.set_detuning(freq));
    %ss=null(sys.interaction{1, 2}.matrix.fullG);
    ker_full=sys.interaction{1, 2}.matrix.fullG;
    t_inf = 1e3;
    ss=expm(-ker_full*t_inf)*init_state;
    ss0=ss([logical(projE); logical(projG)]);
    pop0=abs(ss0);
    max_pos=(pop0==max(pop0));
    pop0=pop0/ss0(max_pos);
    pop(:,k)=pop0/sum(pop0);
end
figure;
plot(freqList, real(sum(pop(end-2:end, :), 1)), 'r*-', freqList, real(sum(pop(end-7:end-3, :), 1)), 'bd-',...
    freqList, imag(sum(pop(end-2:end, :), 1)), 'k-', freqList, imag(sum(pop(end-7:end-3, :), 1)), 'k-')