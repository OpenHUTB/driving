function entryTimes = generatePoissonEntryTimes(tMin,tMax,mu)
% generatePoissonEntryTimes 生成以时间 tMin 和tMax之间的速率mu（以车辆每小时为单位）
% 到达的车辆的进入时间的单调递增向量。
% minHeadway 保证车辆具有一定的最小车头时距（秒）。

t=tMin;
minHeadway = 1;
entryTimes = [];
while t<tMax
    headway = (-log(rand)*3600/mu);
    headway = max(minHeadway,headway);
    t = t+headway;
    if t<tMax
        entryTimes(end+1)=t;
    end
end

end

