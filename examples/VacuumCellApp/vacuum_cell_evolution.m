clear;clc;

import Condition.Coil
import Atom.AlkaliMetal
import Gas.VaporGas
import Laser.AlkaliLaserBeam
import CellSystem.VaporCell

%% Ingredients
coil = { ... 
    Condition.Coil('coilx', 0.00001), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.00003)};

rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);

temperature=273.15+20;
gases={  VaporGas(rb85, 'vapor', temperature, Atom.Transition.D1), ...
         VaporGas(rb87, 'vapor', temperature, Atom.Transition.D1) ...
         };

pumpBeam=AlkaliLaserBeam(500e-6, ...                     % power in [W]
                         rb87, Atom.Transition.D1, 4575,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, 1i], 2e-3);       % direction, pol, spot size


                     
%% full
sysfull=VaporCell(gases, pumpBeam, 'vacuum-full');
%sysfull.interaction{1, 3}.calc_matrix();

timeList = linspace(0, 10, 101);
fprintf('begin full evolution...\n');  tic;
states_full=sysfull.evolution(3, timeList);  timefull =toc;

%% approximation quasi-static pumping

sysApproxQS=VaporCell(gases, pumpBeam, 'vacuum');
%sysApproxQS.interaction{1, 3}.calc_matrix();
fprintf('begin QS evolution...\n'); tic;
states_QS=sysApproxQS.evolution(3, timeList); timeQS=toc;

%% approximation ground state pumping

sysApproxGS=VaporCell(gases, pumpBeam, 'vacuum-ground');
%sysApproxGS.interaction{1, 3}.calc_matrix();
fprintf('begin GS evolution...\n'); tic;
states_GS=sysApproxGS.evolution(3, timeList); timeGS=toc;

%% approximation ground state pumping

sysApproxGSrate=VaporCell(gases, pumpBeam, 'vacuum-ground-rate');
%sysApproxGSrate.interaction{1, 3}.calc_matrix();
fprintf('begin GS rate evolution...\n'); tic;
states_GSrate=sysApproxGSrate.evolution(3, timeList); timeGSrate=toc;

%% plot
Smat = rb87.matEigen.Smat{1};
Imat = rb87.matEigen.Imat{1};
Fmat = rb87.matEigen.Fmat{1};
F2mat = rb87.matEigen.F2{1};

popE_t = cell2mat(cellfun(@(s)  s.population(1),       states_full, 'UniformOutput', false));
popG_t = cell2mat(cellfun(@(s)  s.population(2),       states_full, 'UniformOutput', false));
cohE_t = cell2mat(cellfun(@(s)  s.max_coherence(1),    states_full, 'UniformOutput', false));
cohG_t = cell2mat(cellfun(@(s)  s.max_coherence(2),    states_full, 'UniformOutput', false));
cohEG_t = cell2mat(cellfun(@(s) s.max_coherence(1, 2), states_full, 'UniformOutput', false));
Svect_t = cell2mat(cellfun(@(s) s.meanGS(Smat),        states_full, 'UniformOutput', false));
Ivect_t = cell2mat(cellfun(@(s) s.meanGS(Imat),        states_full, 'UniformOutput', false));
Fvect_t = cell2mat(cellfun(@(s) s.meanGS(Fmat),        states_full, 'UniformOutput', false));
F2_t    = cell2mat(cellfun(@(s) s.meanGS(F2mat),       states_full, 'UniformOutput', false));

popE_t_QS = cell2mat(cellfun(@(s)  s.population(1),       states_QS, 'UniformOutput', false));
popG_t_QS = cell2mat(cellfun(@(s)  s.population(2),       states_QS, 'UniformOutput', false));
cohE_t_QS = cell2mat(cellfun(@(s)  s.max_coherence(1),    states_QS, 'UniformOutput', false));
cohG_t_QS = cell2mat(cellfun(@(s)  s.max_coherence(2),    states_QS, 'UniformOutput', false));
cohEG_t_QS = cell2mat(cellfun(@(s) s.max_coherence(1, 2), states_QS, 'UniformOutput', false));
Svect_t_QS = cell2mat(cellfun(@(s) s.meanGS(Smat),        states_QS, 'UniformOutput', false));
Ivect_t_QS = cell2mat(cellfun(@(s) s.meanGS(Imat),        states_QS, 'UniformOutput', false));
Fvect_t_QS = cell2mat(cellfun(@(s) s.meanGS(Fmat),        states_QS, 'UniformOutput', false));
F2_t_QS    = cell2mat(cellfun(@(s) s.meanGS(F2mat),       states_QS, 'UniformOutput', false));

popE_t_GS = cell2mat(cellfun(@(s)  s.population(1),       states_GS, 'UniformOutput', false));
popG_t_GS = cell2mat(cellfun(@(s)  s.population(2),       states_GS, 'UniformOutput', false));
cohE_t_GS = cell2mat(cellfun(@(s)  s.max_coherence(1),    states_GS, 'UniformOutput', false));
cohG_t_GS = cell2mat(cellfun(@(s)  s.max_coherence(2),    states_GS, 'UniformOutput', false));
cohEG_t_GS = cell2mat(cellfun(@(s) s.max_coherence(1, 2), states_GS, 'UniformOutput', false));
Svect_t_GS = cell2mat(cellfun(@(s) s.meanGS(Smat),        states_GS, 'UniformOutput', false));
Ivect_t_GS = cell2mat(cellfun(@(s) s.meanGS(Imat),        states_GS, 'UniformOutput', false));
Fvect_t_GS = cell2mat(cellfun(@(s) s.meanGS(Fmat),        states_GS, 'UniformOutput', false));
F2_t_GS    = cell2mat(cellfun(@(s) s.meanGS(F2mat),       states_GS, 'UniformOutput', false));

popE_t_GSrate = cell2mat(cellfun(@(s)  s.population(1),       states_GSrate, 'UniformOutput', false));
popG_t_GSrate = cell2mat(cellfun(@(s)  s.population(2),       states_GSrate, 'UniformOutput', false));
cohE_t_GSrate = cell2mat(cellfun(@(s)  s.max_coherence(1),    states_GSrate, 'UniformOutput', false));
cohG_t_GSrate = cell2mat(cellfun(@(s)  s.max_coherence(2),    states_GSrate, 'UniformOutput', false));
cohEG_t_GSrate = cell2mat(cellfun(@(s) s.max_coherence(1, 2), states_GSrate, 'UniformOutput', false));
Svect_t_GSrate = cell2mat(cellfun(@(s) s.meanGS(Smat),        states_GSrate, 'UniformOutput', false));
Ivect_t_GSrate = cell2mat(cellfun(@(s) s.meanGS(Imat),        states_GSrate, 'UniformOutput', false));
Fvect_t_GSrate = cell2mat(cellfun(@(s) s.meanGS(Fmat),        states_GSrate, 'UniformOutput', false));
F2_t_GSrate    = cell2mat(cellfun(@(s) s.meanGS(F2mat),       states_GSrate, 'UniformOutput', false));

figure;
subplot(3,3,1); plot(timeList,popE_t, '.-', timeList,popE_t_QS, 'o', timeList,popE_t_GS, 'd' , timeList,popE_t_GSrate, '+'); title('excited state population');
subplot(3,3,2); plot(timeList,popG_t, '.-', timeList,popG_t_QS, 'o', timeList,popG_t_GS, 'd', timeList,popG_t_GSrate, '+'); title('ground state population');
subplot(3,3,3); plot(timeList,sum(popG_t,1)+sum(popE_t, 1), '.-', timeList,sum(popG_t_QS,1)+sum(popE_t_QS, 1), 'o', timeList,sum(popG_t_GS,1)+sum(popE_t_GS, 1), 'd', timeList,sum(popG_t_GSrate,1)+sum(popE_t_GSrate, 1), '+') ; title('prob. identity');

subplot(3,3,4);plot(timeList,cohE_t, '.-', timeList,cohE_t_QS, 'o', timeList,cohE_t_GS, 'd', timeList,cohE_t_GSrate, '+'); title('excited state coherence');
subplot(3,3,5);plot(timeList,cohG_t, '.-', timeList,cohG_t_QS, 'o', timeList,cohG_t_GS, 'd', timeList,cohG_t_GSrate, '+'); title('ground state coherence');
subplot(3,3,6);plot(timeList,cohEG_t, '.-', timeList,cohEG_t_QS, 'o', timeList,cohEG_t_GS, 'd', timeList,cohEG_t_GSrate, '+'); title('optical coherence');

subplot(3,3,7); plot(timeList, Svect_t, '.-', timeList, Svect_t_QS, 'o', timeList, Svect_t_GS, 'd', timeList, Svect_t_GSrate, '+'); title('S vector');
subplot(3,3,8); plot(timeList, Ivect_t, '.-', timeList, Ivect_t_QS, 'o', timeList, Ivect_t_GS, 'd', timeList, Ivect_t_GSrate, '+'); title('I vector');
subplot(3,3,9); plot(timeList, F2_t, '.-', timeList, F2_t_QS, 'o', timeList, F2_t_GS, 'd', timeList, F2_t_GSrate, '+'); title('F2');
