[resLinPower1, paraLinPower1]=vacuum_cell_absorption_RbD1('', 'Polarization', [1 0], 'Power', 1e-6);
[resCirPower1, paraCirPower1]=vacuum_cell_absorption_RbD1('', 'Polarization', [1 1i], 'Power', 1e-6);
[resLinPower30, paraLinPower30]=vacuum_cell_absorption_RbD1('', 'Polarization', [1 0], 'Power', 30e-6);
[resCirPower30, paraCirPower30]=vacuum_cell_absorption_RbD1('', 'Polarization', [1 1i], 'Power', 30e-6);

%% 
lin=cell(1, 50);cir=cell(1,50);
for k=1:50
    lin{k}=vacuum_cell_absorption_RbD1('', 'Polarization', [1 0], 'Frequency', -1450, 'Power', k*2e-6, 'Display', 'off');
    cir{k}=vacuum_cell_absorption_RbD1('', 'Polarization', [1 1i], 'Frequency', -1450, 'Power', k*2e-6, 'Display', 'off');
end

 powerList = 1:2:100;
linPower = cellfun(@(x) sum(x), lin);
cirPower = cellfun(@(x) sum(x), cir);
 %%
figure;
subplot(2, 2, 1)
plot(paraLinPower1('Frequency'), sum(resLinPower1, 1), 'rd-', paraCirPower1('Frequency'), sum(resCirPower1, 1), 'bo-');
xlabel('frequency MHz'); ylabel('cross section cm^{2}')
legend('lin. pol.', 'cir. pol.');
title('Power=1 \mu W')

subplot(2, 2, 2)
plot(paraLinPower30('Frequency'), sum(resLinPower30, 1), 'rd-', paraCirPower30('Frequency'), sum(resCirPower30, 1), 'bo-');
xlabel('frequency MHz'); ylabel('cross section cm^{2}')
legend('lin. pol.', 'cir. pol.');
title('Power=30 \mu W')


subplot(2, 2, 3)
plot(powerList, linPower, 'rd-', powerList,cirPower, 'bo-')
xlabel('Power \mu W'); ylabel('cross section cm^{2}')

subplot(2, 2, 4)
plot(powerList, (linPower-cirPower)./linPower)
xlabel('Power \mu W'); ylabel('relative change')