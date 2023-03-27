function [ ] = kill_process(ProcessName)
% 参考：https://www.bilibili.com/read/cv13106181
% COPY:何其 2021年9月9日23:56:09

% ProcessName % 要杀死的指定进程 % 不得为空

% eg:'WINWORD.EXE' % 

%% %获取所有进程信息
[~,cmdout] = system('tasklist');

cmdout = split(cmdout,strcat(10));
WINWORD = cmdout(contains(cmdout,ProcessName),:);
if isempty(WINWORD)  % 进程不存在则不需要杀
    return;
end

%% %获取指定进程信息
WINWORD = split( WINWORD,' ');

%% % 杀死指定进程
system(strcat('taskkill /pid' , 32 , WINWORD{ find( ismember( WINWORD, 'Console' ) , 1 ) - 1 } , 32 , ' /f' ) );

end