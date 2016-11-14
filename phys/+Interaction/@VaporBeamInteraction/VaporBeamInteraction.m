classdef VaporBeamInteraction < Interaction.AbstractInteraction
    %GASBEAMINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vapor
        beam
    end
    
    methods
        function obj = VaporBeamInteraction(vapor, beam)
            obj@Interaction.AbstractInteraction(vapor, beam);
            obj.vapor = vapor.stuff;
            obj.beam = beam.stuff;
            obj.option = vapor.option;
            
            obj.parameter.velocity = 0.0;
            %obj.calc_matrix();
        end
        
        function obj = calc_matrix(obj)
            switch obj.option
                case 'vacuum'
                    obj.matrix_steady_state();
                case 'vacuum-full'
                    obj.matrix_full_state();
                case 'pressure'
                    obj.matrix_ground_state();
                otherwise
                    error('non-supported option %s', obj.vapor.option);
            end
        end
        
        function obj = set_velocity(obj, v)
            obj.parameter.velocity = v;
        end 
        
        function [len, vList, uList, wList, sigmaV] = velocity_sampling(obj, gamma)
            center_freq = obj.beam.detune;
            refTrans = obj.beam.refTransition;
            transFreq =obj.vapor.atom.eigen.transFreq{1+refTrans, 1}(:);
            
            [~, idx] = min(abs(center_freq-transFreq));
            det = center_freq-transFreq(idx);
            v_res = 2*pi*det*1e6/obj.beam.wavenumber;
            v_gamma = 2*pi*gamma*1e6/obj.beam.wavenumber;
            
            sigmaV = obj.vapor.velocity;
            nRaw = 4; nFine = 32; x = 5;
            if(v_gamma > 5*sigmaV)
                error('too large v_gamma %f', v_gamma);
            end
            
            left = v_res -v_gamma; right = v_res + v_gamma; width = x*sigmaV;
            if right < -width || left > width
                vListFine = []; wListFine = [];
                [vListRaw, wListRaw] = lgwt(nRaw,-width, width);
            elseif (left < -width) && (-width < right)
                [vListFine, wListFine] = lgwt(nFine, left, right);
                [vListRaw, wListRaw] = lgwt(nRaw, right, width);
            elseif (-width < left) && (right < width)
                [vListFine, wListFine] = lgwt(nFine, left, right);
                [vListRaw1, wListRaw1] = lgwt(nRaw, -width, left);
                [vListRaw2, wListRaw2] = lgwt(nRaw, right, width);
                vListRaw = [vListRaw1; vListRaw2];
                wListRaw = [wListRaw1; wListRaw2];
            else % left < width < right
                [vListFine, wListFine] = lgwt(nFine, left, right);
                [vListRaw, wListRaw] = lgwt(nRaw, -width, left);
            end
            vListTemp = [vListFine; vListRaw];
            wListTemp = [wListFine; wListRaw];
            [vList, idx] = sort(vListTemp);
            wList = wListTemp(idx);
            
            len = length(vList);
            uList = exp(-vList.*vList/2/sigmaV/sigmaV)/sqrt(2*pi)/sigmaV;
        end
        
%         function set_velocity_list(obj, varargin)
%             if nargin == 2
%                 v=varargin{1};
%                 obj.parameter.velocityList=v;
%             elseif nargin == 4
%                 minV=varargin{1}; maxV=varargin{2}; nV=varargin{3};
%                 obj.parameter.velocityList=linspace(minV, maxV, nV);
%             end
%                 
%         end
    end
    
end

