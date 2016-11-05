 classdef VacuumCell < CellSystem.AbstractCellSystem
    %VACUUMCELL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = VacuumCell(gas, beam)
            obj@CellSystem.AbstractCellSystem(gas, beam);
            
        end
    end
    
end

