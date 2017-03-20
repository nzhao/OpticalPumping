function [len, vList, uList, wList, sigmaV] = velocity_sampling(obj)
    nRaw = obj.parameter.v_sampling.nRaw; 
    nFine = obj.parameter.v_sampling.nFine;
    xRange = obj.parameter.v_sampling.xRange; 
    gamma = obj.parameter.v_sampling.gamma;

    %if nRaw < 0 || nFine <0
    if ~obj.parameter.do_velocity_sampling
        len = 1;
        vList = obj.parameter.velocity;
        uList = 1;
        wList = 1;
        sigmaV = obj.parameter.velocity;
    else

    center_freq = obj.get_atom_beam_detuning();
    refTrans = obj.beam.refTransition;
    transFreq =obj.vapor.atom.eigen.transFreq{1+refTrans, 1}(:);


    resonance = center_freq - transFreq;
    intervals = [resonance - gamma, resonance + gamma];
    v_intervals = 2*pi* intervals *1e6/obj.beam.wavenumber;

    sigmaV = obj.vapor.velocity;
    v_range = xRange*[-sigmaV, sigmaV];

    [raw_range, fine_range] = interval_complement(v_intervals, v_range);

    vRaw = cell(1, size(raw_range, 1));
    wRaw = cell(1, size(raw_range, 1));
    for k=1:size(raw_range, 1)
        npoint = round(nRaw * (raw_range(k,2) - raw_range(k,1))/1000 );
        [vRaw{k}, wRaw{k} ] = lgwt(npoint, raw_range(k, 1), raw_range(k, 2));
    end
    vFine = cell(1, size(fine_range, 1));
    wFine = cell(1, size(fine_range, 1));
    for k=1:size(fine_range, 1)
        npoint = round(nFine* (fine_range(k,2) - fine_range(k,1))/50 );
        [vFine{k}, wFine{k} ] = lgwt(npoint, fine_range(k, 1), fine_range(k, 2));
    end
    vListTemp = cell2mat([vFine(:); vRaw(:)]);
    wListTemp = cell2mat([wFine(:); wRaw(:)]);
    [vList, idx] = sort(vListTemp);
    wList = wListTemp(idx);

    len = length(vList);
    uList = exp(-vList.*vList/2/sigmaV/sigmaV)/sqrt(2*pi)/sigmaV;

    end
end