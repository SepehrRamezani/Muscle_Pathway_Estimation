function [filedata] = addfun(filedata,info)
        info=string(info);
        if ~isempty(filedata)
            if ~sum(contains(filedata,info))
                
                filedata=[filedata,info];
            end
        else
            filedata=info;
        end
    end