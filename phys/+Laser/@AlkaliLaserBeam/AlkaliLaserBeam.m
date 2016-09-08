classdef AlkaliLaserBeam < handle
    %BEAM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        power
        refAtom
        refTransition
        detune
        
        dir
        transDir1
        transDir2
        
        pol
        waist
        
        energyFlux
        amplitudeE
        vectorE
        
        photonSpin
        fictionSpin
    end
    
    methods
        function obj=AlkaliLaserBeam(power, refAtom, refTransition, detune, dir, pol, waist)
            obj.power = power;
            obj.refAtom = refAtom;
            obj.refTransition = refTransition;
            obj.detune = detune;
            obj.dir = dir/norm(dir);
            obj.pol = pol/norm(pol);
            obj.waist = waist;
            
            if all(obj.dir == [0 0 1])
                obj.transDir1 = [1 0 0];
                obj.transDir2 = [0 1 0];
            else
                dir1= cross( [0 0 1], obj.dir);       obj.transDir1 = dir1/norm(dir1);
                dir2= cross( obj.dir, obj.transDir1); obj.transDir2 = dir2/norm(dir2);
            end
            
            obj.energyFlux = power / (pi*waist*waist);
            obj.amplitudeE = sqrt(2.0*obj.energyFlux*VacImp);
            obj.vectorE = obj.amplitudeE * obj.transDir1 * obj.pol(1) ...
                        + obj.amplitudeE * obj.transDir2 * obj.pol(2);
            
            obj.photonSpin = 1i*cross(obj.vectorE, obj.vectorE')/obj.amplitudeE/obj.amplitudeE;
            if strcmp(refTransition, 'D1')
                obj.fictionSpin = 0.5*obj.photonSpin;
            elseif strcmp(refTransition, 'D2')
                obj.fictionSpin = -0.25*obj.photonSpin;
            end
        end
    end
    
end

