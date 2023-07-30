classdef cDirectionOfTravel < uint32
    % 旅行方向枚举类
    %   这个类定义了旅行方向的枚举值，继承自uint32类型。

    enumeration
        Unknown(0)     % 未知方向，值为0
        Backward(1)    % 向后方向，值为1
        Both(2)        % 双向，值为2
        Forward(3)     % 向前方向，值为3
        None(4)        % 无方向，值为4
    end
end
