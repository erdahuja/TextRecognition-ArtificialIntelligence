clear
imgSetVec=imageSet('newtrain/','recursive');
data={[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[]};
for j=0:62:62,
    for k=0:61,
        temp=imgSetVec(1,j+k+1);
        for i=1:temp.Count,
            temp1=(read(temp,i));
            if length(size(temp1))==3
                temp1=rgb2gray(temp1);
            end;
            level=graythresh(temp1);
            temp1=~im2bw(temp1,level);
            [l ne]=bwlabel(temp1);
            if ne==2,
                [r1 c1]=find(l==1);
                [r2 c2]=find(l==2);
                temp2=temp1(min([r1;r2]):max([r1;r2]),min([c1;c2]):max([c1;c2]));
            else
                [r c]=find(l==1);
                temp2=temp1(min(r):max(r),min(c):max(c));
            end;
            imshow(temp2);
            pause();
            %temp2=imresize(temp2,[10 10]);
            %imshow(bwmorph(temp2,'thin',Inf));
            temp3=temp2(:);
            a=[j k i]
            data{k+1}=[data{k+1};temp3];
        end;
        
        
    end;
end;

%{
for i=1:size(data,1),
    temp=data{i};
    temp2=reshape(temp,[400 ((size(temp,1))/400)]);
    data{i}=temp2';
end

for i=1:62,
    Y{i}=i.*ones(size(data{i},1),1);
    
end;

X=[];
y=[];
for i=1:size(data,1),
temp1=data{i};
temp2=Y{i};
X=[X;temp1];
y=[y;temp2];
end;



%}