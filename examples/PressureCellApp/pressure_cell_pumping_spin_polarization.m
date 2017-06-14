clear;clc;

magBx=10e-9; magBz=-200e-9 : 2e-9 : 200e-9;
Sarray=cell2mat( arrayfun(@(bz) SpinPol(magBx, bz),magBz, 'UniformOutput', false) ).';
figure
subplot(2, 1, 1)
plot(magBz,atan( magBz/magBx ) /pi*180, 'bo-', magBz, atan(Sarray(:, 3)./Sarray(:,1))/pi*180, 'rd-')
subplot(2, 1, 2)
plot(magBz, Sarray(:,1), 'rd-', magBz, Sarray(:,2), 'bo-')
%% Ingredients
function Svect = SpinPol(Bx, Bz)
    import Condition.Coil
    import Atom.AlkaliMetal 
    import Atom.Buffer.Nitrogen
    import Atom.Buffer.He4
    import Gas.VaporGas Gas.BufferGas
    import Laser.AlkaliLaserBeam
    %import CellSystem.VacuumCell
    import CellSystem.VaporCell

    coil = { ... 
        Condition.Coil('coilx', Bx), ...
        Condition.Coil('coily', 0.0), ...
        Condition.Coil('coilz', Bz)};

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

    pumpBeam_cir=AlkaliLaserBeam(100e-6, ...                     % power in [W]
                             rb87, Atom.Transition.D1, -2.25e3,...%-2.25e3, ... % ref Atom 
                             [0 0 1], [1, 1i], 4e-3);       % direction, pol, spot size

    %% approximation ground state pumping

    sysApproxGS_cir=VaporCell(gases, pumpBeam_cir, 'high-pressure');

    pumpTime=1e5;
    state = sysApproxGS_cir.evolution(2, pumpTime);

    Smat = rb85.matEigen.Smat{1};
    Svect=state.meanGS(Smat);
end

 