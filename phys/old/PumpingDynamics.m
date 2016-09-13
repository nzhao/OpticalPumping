function dynamics = PumpingDynamics( atom, beam, condition, tmin, tmax, dt, init_state )
%PUMPINGDYNAMICS Summary of this function goes here
%   Detailed explanation goes here
    %% Process
    % eigen system
    eigen   = EigenSystem(atom, condition);
    
    % pumping process
    pump    = OpticalPumping(atom, beam, condition, eigen);

    % relaxation rate
    rate = SelfSERate(atom, condition);


    %% Evolution

    population_projection=logical(atom.LS.cPg);

    nt=floor((tmax-tmin)/dt)+1;
    tlist = linspace(tmin, tmax, nt);
    
    rho_res=zeros(atom.sw.gg,nt);
    s_res=zeros(3, nt);
  
    rho=init_state;
    count=1; diff=1; t=tmin;    
    while t<=tmax && diff>1e-8
        % observable - record results
        Sval=rho'*eigen.operators.S.lv;        
        rho_res(:,count)=real(rho(population_projection));
        s_res(:,count)=real(Sval);
        
        % evolution kernel
        exchange= SpinExchange( atom, eigen, rho, eigen.operators.S, rate);
        G = eigen.G + pump.G + exchange.G;

        % step forward - update observables
        rho1=expm(-dt*G)*rho; 
        
        % convergency check
        diff=norm(rho-rho1);
        t=t+dt; count=count+1;
        rho=rho1;
        fprintf('evolution t = %5.2f microsecond.\n', t);
    end
    tlist=tlist(1:count-1);
    rho_res=rho_res(:, 1:count-1);
    s_res=s_res(:, 1:count-1);
    
    %% result collection
    dynamics.proc.eigen=eigen;
    dynamics.proc.pump=pump;
    dynamics.proc.rate=rate;
    dynamics.proc.exchange=exchange;
    
    dynamics.time=tlist;
    dynamics.state=rho_res;
    dynamics.observables.spin=s_res;    
end

