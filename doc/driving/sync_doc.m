% 将matlab中已翻译好的文档拷贝到仓库中
help_doc_dir = fullfile(matlabroot, 'help', 'driving');

% 扫描自动驾驶工具箱帮助文档目录中以"_zh_CN.html"结尾的文件名

% 列出driving文件夹和子文件夹下已翻译的文件
html_infos = dir(fullfile(help_doc_dir, '**/*_zh_CN.html'));

% 逐个拷贝
for i = 1 : numel(html_infos)
    cur_html = html_infos(1);
    folder_splits = strsplit(cur_html.folder, 'driving');
    if numel(folder_splits) >=2 && ~isempty(folder_splits{2})
        src_file = fullfile(cur_html.folder, cur_html.name);
        dst_dir = fullfile(fileparts(mfilename("fullpath")), folder_splits{2});
        
        out_info = sprintf("Copy file from %s to %s.", src_file, dst_dir);  disp(out_info);
        copyfile(src_file, dst_dir);
        disp("Copy done");
    end
end