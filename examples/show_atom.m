function myui
    magB=1.0; Gmc=3.5e6; dw=-1.4217e10;
    
    redraw(magB, Gmc, dw);
    controler(magB, Gmc, dw);

    function changeB(source, callbackdata)
        magB=source.Value;
        redraw(magB, Gmc, dw);
        controler(magB, Gmc, dw);
    end

    function changeGmc(source, callbackdata)
        Gmc=source.Value;
        redraw(magB, Gmc, dw);
        controler(magB, Gmc, dw); 
    end

    function changeDw(source, callbackdata)
        dw=source.Value;
        redraw(magB, Gmc, dw);
        controler(magB, Gmc, dw);
    end

    function controler(magB, Gmc, dw)
        magBmin=0.0; magBmax=500.0;
        txt1 = uicontrol('Style', 'text',   'Position', [25 30 300 50], 'FontSize', 18, 'String', sprintf('magB=%5.2f',magB) );
        sld1 = uicontrol('Style', 'slider', 'Position', [25 20 300 20], 'Min',magBmin,'Max',magBmax, 'Value', magB, 'Callback', @changeB);
    
        GmcMin=0; GmcMax=5e7;
        txt2 = uicontrol('Style', 'text',   'Position', [350 30 300 50], 'FontSize', 18, 'String', sprintf('Gmc=%5.2e',Gmc) );
        sld2 = uicontrol('Style', 'slider', 'Position', [350 20 300 20], 'Min',GmcMin,'Max',GmcMax,'Value',Gmc, 'Callback', @changeGmc); 

        dwMin=-2e10; dwMax=2e10;
        txt3 = uicontrol('Style', 'text',   'Position', [675 30 300 50], 'FontSize', 18, 'String', sprintf('Dw=%5.2e',dw) );
        sld3 = uicontrol('Style', 'slider', 'Position', [675 20 300 20], 'Min',dwMin,'Max',dwMax,'Value',dw, 'Callback', @changeDw);
        
    end
        
    
    function res=redraw(magB, Gmc, dw) 
        atom=atomParameters('Rb87D1');

        power=40;
        detuning=-2256;
        thetaD = 0;
        phiD = 0;
        Etheta = 1;
        Ephi= 1i;
        beam=setBeam(power,detuning,thetaD,phiD,Etheta,Ephi);

        beam.Dw=dw;

        G=evolutionOperator(atom,magB,Gmc,beam);
        LS=LiouvilleSpace(atom);

        rho=null(G); rho=rho/(LS.rP*rho);
        pop=diag([real(rho(LS.LrNg)); real(rho(LS.LrNe))]);

        res = plotPumping(atom, beam, magB, pop);
    end
end