% 启动服务
server = tcpserver("0.0.0.0",30000);

%% 从客户端读取数据
% data = read(server,server.NumBytesAvailable,"double");
% plot(data);

%% 像客户端发送数据
data = sin(1:64);
% plot(data);
write(server,data,"double")