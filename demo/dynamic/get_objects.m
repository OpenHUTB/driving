% 新建客户端
client = tcpclient("localhost",30000);

%% 客户端发送数据
% data = sin(1:64);
% % plot(data);
% 
% write(client,data,"double")


%% 从服务端接收数据
data = read(client);
if ~isempty(data)
    plot(data);
end

