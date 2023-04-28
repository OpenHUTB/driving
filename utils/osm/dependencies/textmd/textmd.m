function [varargout] = textmd(x, str, varargin)
%TEXTMD     Text annotation in 2D or 3D.
%
% input
%   x = point where text is placed
%     = [#dim x 1]
%   str = annotation text string
%
% File:      textmd.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.01.22 - 
% Language:  MATLAB R2011b
% Purpose:   multi-dimensional text annotation
% Copyright: Ioannis Filippidis, 2012-

ndim = size(x, 1);

if ndim == 2
    y = x(2, 1);
    x = x(1, 1);
    h = text(x, y, str, varargin{:} );
elseif ndim == 3
    z = x(3, 1);
    y = x(2, 1);
    x = x(1, 1);
    h = text(x, y, z, str, varargin{:} );
end

if nargout == 1
    varargout{1, 1} = h;
end
