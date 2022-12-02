%% Read in Data
function [images,oct_marks] = load_data(folder1,folder2)

%Vanessa's Images
oct_marks = {};
filename = './DVC_Marking_Points_10-11-2022.xlsx';
opt=detectImportOptions(filename);
%shts=sheetnames(filename);
shts = string(["LC471";
                "LC472";
                "LC494_v2";
                "LC496_v2";
                "LC498";
                "LC499";
                "LC503";
                "LC504"
                %"LC506"
                ]);

for i=1:numel(shts)
  oct_marks{i}=readtable(filename,opt,'Sheet',shts(i));
end
imgs  = string(["LC471";
                "LC472";
                "LC494";
                "LC496";
                "LC498";
                "LC499";
                "LC503";
                "LC504";
                %"LC506"
                ]);
bestbefore = string(['1';
    '1';
    '1';
    '2';
    '3';
    '2';
    '2';
    '2';
    '3']);	

for i=1:numel(imgs)
    for j = 1:24
        filename = folder2+imgs(i)+'/Before'+bestbefore(i)+'/1HOCT_'+imgs(i)+'L0_24s_3DCE.tif';
        images{i,j}=imread(filename,j);
    end
end
%% Cameron's Images

%Removing duplicate files
listing = dir("./mainfiles/*.m");
datafolder = listing(1).folder;
for i = 1:length(listing)
    splitfilename = split(string(listing(i).name),{'mainRDVC_','_','.'});
    LCidx = find(contains(splitfilename,'LC'));
    LCnum_file(i) = splitfilename(LCidx);
end
[uniqueList,~,uniqueNdx] = unique(LCnum_file);
N = histc(uniqueNdx,1:numel(uniqueList));
dupNames = uniqueList(N>1);
dupNdxs = arrayfun(@(x) find(uniqueNdx==x), find(N>1),'UniformOutput',false);

for i = 1:length(listing)
    filenames(i) = string(listing(i).name);
end
filenames = filenames(filenames~='mainRDVC_LC240.m');
filenames = filenames(filenames~='mainRDVC_LC268.m');
filenames = filenames(filenames~='mainRDVC_LC356_1_gamma_ch.m');
LCnum_file = unique(LCnum_file,'stable');

[rows,~] = size(images);

listing = dir(folder1);
for i = 1:length(listing)
    imgfilenames(i) = string(listing(i).name);
end

imgfilenames = imgfilenames(imgfilenames~='.');
imgfilenames = imgfilenames(imgfilenames~='..');

for i = 1:length(imgfilenames)
    splitfilename = split(string(imgfilenames(i)),{'_gamma','_'});
    LCidx = find(contains(splitfilename,'LC'));
    LCnum_imgfile(i) = splitfilename(LCidx);
end
[uniqueList,~,uniqueNdx] = unique(LCnum_imgfile);
N = histc(uniqueNdx,1:numel(uniqueList));
dupNames = uniqueList(N>1);
dupNdxs = arrayfun(@(x) find(uniqueNdx==x), find(N>1),'UniformOutput',false);
imgfilenames = imgfilenames(imgfilenames~='LC356_1_gamma');
LCnum_imgfile = unique(LCnum_imgfile,'stable');

for i = 1:length(LCnum_imgfile)
    LCidx = find(contains(LCnum_file,LCnum_imgfile(i)));
    if ~isempty(LCidx)
        LCnum_file_new(i) = LCnum_file(LCidx);
        LCidx = find(contains(filenames,LCnum_imgfile(i)));
        filenames_new(i) = filenames(LCidx);
    end
end
LCnum_file = LCnum_file_new;
filenames = filenames_new;
TF = ismissing(filenames);
idx = find(TF==0);
LCnum_file = LCnum_file(idx);
filenames = filenames(idx);
LCnum_imgfile  = LCnum_imgfile(idx);
imgfilenames = imgfilenames(idx);

%% 
[~,col] = size(oct_marks);
for i = 1:length(filenames)
    filename = string(datafolder)+'\'+string(filenames(i));
    fid = fopen(fullfile(filename));
    C = readlines(filename);
    fclose(fid);
    linestart = find(contains(C,'uncomment this section once to add tracing information'))+1;
    lineend = find(contains(C,"save(fullfile(savepath,[LCnum1 '-dividers.mat']),'BMO','BML','BMR','ALC','CSL','CSR')"))-1;
    LCnumline = find(contains(C,"LCnum="));
    bestbefline = find(contains(C,"bestbef1="));
    for j = linestart:lineend
        tmp = regexp(C(j),'%'); % find '%'
        C{j}(tmp) = ''; % substitute '%' with nothing
        tmp2 = regexp(C(j),char(9));
        C{j}(tmp2) = ' ';
    end
    eval(string(strjoin(C(LCnumline:bestbefline),'\n')));
    eval(string(strjoin(C(linestart:lineend),'\n')));
    best_bef(i) = bestbef1;
    LC_num{i} = LCnum;
    [row(1),~] = size(BMO);
    [row(2),~] = size(BML);
    [row(3),~] = size(BMR);
    [row(4),~] = size(ALC);
    [row(5),~] = size(CSL);
    [row(6),~] = size(CSR);
    Maxrows = max(row);
    BMO = [BMO;nan(Maxrows-row(1),3)];
    BML = [BML;nan(Maxrows-row(2),3)];
    BMR = [BMR;nan(Maxrows-row(3),3)];
    ALC = [ALC;nan(Maxrows-row(4),3)];
    CSL = [CSL;nan(Maxrows-row(5),3)];
    CSR = [CSR;nan(Maxrows-row(6),3)];
    T_BMO = array2table(BMO,'VariableNames',{'R_pixel_','Z_pixel_','T_Slice_'});
    T_BML = array2table(BML,'VariableNames',{'R_pixel__1','Z_pixel__1','T_Slice__1'});
    T_BMR = array2table(BMR,'VariableNames',{'R_pixel__2','Z_pixel__2','T_Slice__2'});
    T_ALC = array2table(ALC,'VariableNames',{'R_pixel__3','Z_pixel__3','T_Slice__3'});
    T_CSL = array2table(CSL,'VariableNames',{'R_pixel__4','Z_pixel__4','T_Slice__4'});
    T_CSR = array2table(CSR,'VariableNames',{'R_pixel__5','Z_pixel__5','T_Slice__5'});
    oct_marks{col+i} = [T_BMO T_BML T_BMR T_ALC T_CSL T_CSR];
end
%% 
for i = 1:length(imgfilenames)
    for j = 1:24
        imgfilename = folder1+imgfilenames(i)+"\1HOCT_"+LCnum_imgfile(i)+"L0_Before"+best_bef(i)+"_3DCE.tif";
        images{rows+i,j}=imread(imgfilename,j);
    end
end 
