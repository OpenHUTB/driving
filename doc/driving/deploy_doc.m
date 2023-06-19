% 将仓库中已翻译的文档部署到matlab软件中
help_doc_dir = fullfile(matlabroot, 'help', 'driving');

% 列出当前文件夹和子文件夹下已翻译的文件
html_infos = dir(fullfile(fileparts(mfilename("fullpath")), '**/*_zh_CN.html'));

for i = 1 : numel(html_infos)
    cur_html = html_infos(i);
    src_file = fullfile(cur_html.folder, cur_html.name);
    folder_splits = strsplit(cur_html.folder, 'doc\\driving');  % 为了区分仓库名driving和工具箱名driving重复
    if numel(folder_splits) >=2 && ~isempty(folder_splits{2})
        dst_dir = fullfile(help_doc_dir, folder_splits{2});
        out_info = sprintf("Copy file from %s to %s.", src_file, dst_dir);  disp(out_info);
        copyfile(src_file, dst_dir);
        disp("Copy done");
    end
end