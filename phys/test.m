classdef test < test1 & handle
    properties
        foo = 1;
    end
    methods
        function obj = test(b)
            obj = obj@test1(b);
        end
        function a = bar(obj)
            superclasses(obj)
        end
    end
end