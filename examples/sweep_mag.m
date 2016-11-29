bz = -2e-4:0.2e-5:2e-4;

val = zeros(2, length(bz));
para = cell(1, length(bz));
for k=1:length(bz)
    [val(:, k), para{k}]=vacuum_cell_absorption_RbD1([], 'Frequency', -1450, 'Bz', bz(k), 'Polarization', [1, 1i], 'Power', 100e-6);
end