classdef VaporVaporInteraction < Interaction.AbstractInteraction
    %GASGASINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name_pair
        vapor1
        vapor2
    end
    
    methods
        function obj = VaporVaporInteraction(comp1, comp2)
            obj@Interaction.AbstractInteraction(comp1, comp2);
            
            obj.vapor1 = comp1.stuff;
            obj.vapor2 = comp2.stuff;
            obj.name_pair = [comp1.name, '-', comp2.name];
        end
        
        function obj = calc_matrix(obj)
            [sd_mat, sd_rate]=Interaction.SDampingMat(obj.vapor1, obj.vapor2);
            switch obj.type
                case 'self'
                    obj.matrix.kernel = sd_mat(1);
                    obj.parameter.sd_rate = sd_rate{1}; 
                case 'mutual'
                    obj.parameter.sd_rate = sd_rate; 
                    obj.matrix.kernel={sd_mat{1}, sd_mat{2}, 0.0};
            end
        end

    end
    
end

