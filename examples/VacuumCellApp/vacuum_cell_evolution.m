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

rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);

temperature=273.15+20;
gases={  Gas(rb85, 'vapor', temperature, Atom.Transition.D1), ...
         Gas(rb87, 'vapor', temperature, Atom.Transition.D1) ...
         };

pumpBeam=AlkaliLaserBeam(500e-6, ...                     % power in [W]
                         rb87, Atom.Transition.D1, 4575,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 2e-3);       % direction, pol, spot size


                     
%% full
sysfull=VacuumCell(gases, pumpBeam, 'vacuum-full');
sysfull.interaction{1, 3}.calc_matrix();

timeList = linspace(0, 10.0, 101);
fprintf('begin full evolution...\n');  tic;
states_full=sysfull.evolution(3, timeList);  timefull =toc;

%% approximation quasi-static pumping

sysApproxQS=VacuumCell(gases, pumpBeam, 'vacuum');
sysApproxQS.interaction{1, 3}.calc_matrix();
fprintf('begin QS evolution...\n'); tic;
states_QS=sysApproxQS.evolution(3, timeList); timeQS=toc;

%% approximation ground state pumping

sysApproxGS=VacuumCell(gases, pumpBeam, 'vacuum-ground');
sysApproxGS.interaction{1, 3}.calc_matrix();
fprintf('begin GS evolution...\n'); tic;
states_GS=sysApproxGS.evolution(3, timeList); timeGS=toc;

%% approximation ground state pumping

sysApproxGSrate=VacuumCell(gases, pumpBeam, 'vacuum-ground-rate');
sysApproxGSrate.interaction{1, 3}.calc_matrix();
fprintf('begin GS rate evolution...\n'); tic;
states_GSrate=sysApproxGSrate.evolution(3, timeList); timeGSrate=toc;

%% plot
popE_t = cell2mat(cellfun(@(s)  s.population(1),       states_full, 'UniformOutput', false));
popG_t = cell2mat(cellfun(@(s)  s.population(2),       states_full, 'UniformOutput', false));
cohE_t = cell2mat(cellfun(@(s)  s.max_coherence(1),    states_full, 'UniformOutput', false));
cohG_t = cell2mat(cellfun(@(s)  s.max_coherence(2),    states_full, 'UniformOutput', false));
cohEG_t = cell2mat(cellfun(@(s) s.max_coherence(1, 2), states_full, 'UniformOutput', false));

popE_t_QS = cell2mat(cellfun(@(s)  s.population(1),       states_QS, 'UniformOutput', false));
popG_t_QS = cell2mat(cellfun(@(s)  s.population(2),       states_QS, 'UniformOutput', false));
cohE_t_QS = cell2mat(cellfun(@(s)  s.max_coherence(1),    states_QS, 'UniformOutput', false));
cohG_t_QS = cell2mat(cellfun(@(s)  s.max_coherence(2),    states_QS, 'UniformOutput', false));
cohEG_t_QS = cell2mat(cellfun(@(s) s.max_coherence(1, 2), states_QS, 'UniformOutput', false));

popE_t_GS = cell2mat(cellfun(@(s)  s.population(1),       states_GS, 'UniformOutput', false));
popG_t_GS = cell2mat(cellfun(@(s)  s.population(2),       states_GS, 'UniformOutput', false));
cohE_t_GS = cell2mat(cellfun(@(s)  s.max_coherence(1),    states_GS, 'UniformOutput', false));
cohG_t_GS = cell2mat(cellfun(@(s)  s.max_coherence(2),    states_GS, 'UniformOutput', false));
cohEG_t_GS = cell2mat(cellfun(@(s) s.max_coherence(1, 2), states_GS, 'UniformOutput', false));

popE_t_GSrate = cell2mat(cellfun(@(s)  s.population(1),       states_GSrate, 'UniformOutput', false));
popG_t_GSrate = cell2mat(cellfun(@(s)  s.population(2),       states_GSrate, 'UniformOutput', false));
cohE_t_GSrate = cell2mat(cellfun(@(s)  s.max_coherence(1),    states_GSrate, 'UniformOutput', false));
cohG_t_GSrate = cell2mat(cellfun(@(s)  s.max_coherence(2),    states_GSrate, 'UniformOutput', false));
cohEG_t_GSrate = cell2mat(cellfun(@(s) s.max_coherence(1, 2), states_GSrate, 'UniformOutput', false));

figure;
subplot(2,3,1); plot(timeList,popE_t, '.-', timeList,popE_t_QS, 'o', timeList,popE_t_GS, 'd' , timeList,popE_t_GSrate, '+')
subplot(2,3,2); plot(timeList,popG_t, '.-', timeList,popG_t_QS, 'o', timeList,popG_t_GS, 'd', timeList,popG_t_GSrate, '+')
subplot(2,3,3); plot(timeList,sum(popG_t,1)+sum(popE_t, 1), '.-', timeList,sum(popG_t_QS,1)+sum(popE_t_QS, 1), 'o', timeList,sum(popG_t_GS,1)+sum(popE_t_GS, 1), 'd', timeList,sum(popG_t_GSrate,1)+sum(popE_t_GSrate, 1), '+')

subplot(2,3,4);plot(timeList,cohE_t, '.-', timeList,cohE_t_QS, 'o', timeList,cohE_t_GS, 'd', timeList,cohE_t_GSrate, '+')
subplot(2,3,5);plot(timeList,cohG_t, '.-', timeList,cohG_t_QS, 'o', timeList,cohG_t_GS, 'd', timeList,cohG_t_GSrate, '+')
subplot(2,3,6);plot(timeList,cohEG_t, '.-', timeList,cohEG_t_QS, 'o', timeList,cohEG_t_GS, 'd', timeList,cohEG_t_GSrate, '+')
