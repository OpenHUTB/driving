function measurement = helperBBMeasurementFcn(state)
u = state(1,:);
v = state(2,:);
s = state(3,:);
r = state(4,:);

w = sqrt(abs(s.*r));
h = abs(w./r);
x = u - w/2;
y = v - h/2;

measurement = [x ; y; w; h];
end