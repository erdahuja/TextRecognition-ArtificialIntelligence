%% Image segmentation and extraction
%% Read Image
imagen=imread('text2.png');
%% Show ima4
figure;
imshow(imagen);
title('INPUT IMAGE WITH NOISE')
%% Convert to gray scale
if size(imagen,3)==3 % RGB image
  imagen=rgb2gray(imagen);
end
%% Convert to binary image
threshold = graythresh(imagen);
imagen1 =im2bw(imagen,threshold);
imagen2=~imagen1;
imagen1=imclearborder(imagen1);
imagen2=imclearborder(imagen2);
%figure;
%imshow(imagen);
%% Remove all object containing fewer than 30 pixels
%imagen2 = bwareaopen(imagen,20);
%figure;
%imshow(imagen2);
impixelinfo;
%% Show image binary image
%figure;
%imshow(~imagen2);
%impixelinfo;
%title('INPUT IMAGE WITHOUT NOISE')
%% Label connected components
[L1 Ne1]=bwlabel(imagen1);
[L2 Ne2]=bwlabel(imagen2);
if Ne1 > Ne2
    imagen=imagen1;
    L=L1;Ne=Ne1;
else
    imagen=imagen2;
    L=L2;Ne=Ne2;
end;
%% Measure properties of image regions
propied=regionprops(L,'BoundingBox');
hold on
%% Plot Bounding n1Box
for n=1:size(propied,1)
  rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
hold off
pause (1)
figure;
%% Objects extraction
compare_mat=[];
text_cell={[]};
for n=1:Ne
  [r,c] = find(L==n);
  n1=imagen(min(r):max(r),min(c):max(c));
  %imshow(n1);
  %pause();
  %imwrite(~n1,sprintf('%d.jpg',n));
  if size(compare_mat,1)==0
      
      compare_mat=[compare_mat;[min(r) max(r) min(c) max(c)]];
      text_cell{1}=[text_cell{1};[min(r) max(r) min(c) max(c)]];
  else
      flag=0;
      for i=1:size(compare_mat,1),
          if (((min(r)>=compare_mat(i,1)) && (max(r)<=compare_mat(i,2))) || ((min(r)<=compare_mat(i,1)) && (max(r)>=compare_mat(i,2))) || ((min(r)>=compare_mat(i,1)) && (max(r)>=compare_mat(i,2)) &&(min(r)<=compare_mat(i,2)) ) || ((min(r)<=compare_mat(i,1)) && (max(r)<=compare_mat(i,2)) &&(max(r)>=compare_mat(i,1))) )
              text_cell{i}=[text_cell{i};[min(r) max(r) min(c) max(c)]];
              flag=flag || 1;
              break;
          end;
      end;
      if flag==0
          compare_mat=[compare_mat;[min(r) max(r) min(c) max(c)]];
          text_cell{end+1}=[];
          text_cell{size(text_cell,2)}=[text_cell{size(text_cell,2)};[min(r) max(r) min(c) max(c)]];
      end;
  end;
          
%  imshow(~n1);
 % pause(0.5)
end;
X=[];
space=zeros(1,size(text_cell,2));
for i=1:size(text_cell,2),
    temp=text_cell{1,i};
    minr=min(temp(:,1));
    maxr=max(temp(:,2));
    for j=1:size(temp,1),
        temp1=temp(j,:);
        n1=imagen(minr:maxr,temp1(3):temp1(4));
        %n1=bwmorph(n1,'thin',Inf);
            %imshow(temp1);
            %pause();
            [l ne]=bwlabel(n1);
            l=padarray(l,[1 1]);
            %l=bwmorph(l,'thin',Inf);
            
            %imshow(l);
            
            %pause();
            
            if ne==2,
                [r1 c1]=find(l==1);
                [r2 c2]=find(l==2);
                %r1=min([r1;r2]);
                %r2=max([r1;r2]);
                %c1=min([c1;c2]);
                %c2=max([c1;c2]);
                %m=size([r1;r2],1);
                %temp2=[];
                %p=[r1 c1;r1 fix((c1+c2)/2) ;r1 c2;fix((r1+r2)/2) c1;fix((r1+r2)/2) fix((c1+c2)/2);fix((r1+r2)/2) c2;r2 c1;r2 fix((c1+c2)/2);r2 c2];
                %for ii=1:size(p,1)
                %    temp2=[temp2 sum(r-p(ii,1))/m];
                %    temp2=[temp2 sum(c-p(ii,2))/m];
                %end;
                %temp2=[temp2 (r2-r1)/(c2-c1)];
                temp2=l(round(min([r1;r2])-1):round(max([r1;r2])+1),round(min([c1;c2])-1):round(max([c1;c2])+1));
            else
                [r c]=find(l==1);
                %r1=min(r);
                %r2=max(r);
                %c1=min(c);
                %c2=max(c);
                %m=size(r,1);
                %temp2=[];
                %p=[r1 c1;r1 fix((c1+c2)/2) ;r1 c2;fix((r1+r2)/2) c1;fix((r1+r2)/2) fix((c1+c2)/2);fix((r1+r2)/2) c2;r2 c1;r2 fix((c1+c2)/2);r2 c2];
                %for ii=1:size(p,1)
                %    temp2=[temp2 sum(r-p(ii,1))/m];
                %    temp2=[temp2 sum(c-p(ii,2))/m];
                %end;
                %temp2=[temp2 (r2-r1)/(c2-c1)];
                temp2=l(round((min(r)-1)):round(max(r)+1),round(min(c)-1):round(max(c)+1));
            end;
            temp2=imresize(temp2,[20 20]);
            temp2=im2bw(temp2);
            %temp2=imerode(temp2,[1 1;1 1]);
            subplot(1,2,1);subimage(temp2);
            temp2=imdilate(temp2,[1 1;1 1]);
            subplot(1,2,2);subimage(temp2);
            %text=ocr(temp2);
            %text.Text
            space(i)=space(i) + 1;
            temp2=temp2(:)';
            X=[X;temp2];    
    end;
    %fprintf('\n');
end;
 %X=reshape(X,[400 ((size(X,1))/400)]);
 %X=X';
 %X=~X
 %displayData(X);
load('theta.mat');
%z=X;
%X=[];
%for i=1:size(z,1)
%X=z(i,:);
m = size(X, 1);
p = zeros(size(X, 1), 1);
%imshow(reshape(X,[10 10]));
X=[ones(m,1),X];
a2=sigmoid(X*Theta1');
a2=[ones(size(a2,1),1),a2];
a3=sigmoid(a2*Theta2');
a3=[ones(size(a3,1),1),a3];
a4=sigmoid(a3*Theta3');
a4=[ones(size(a4,1),1),a4];
h=sigmoid(a4*Theta4');
[dummy, p] = max(h, [], 2);
%pause();
%end;
%}
labels={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
result='';
for i=0:size(text_cell,2)-1,
    if i==0
    for j=1:space(i+1)
        
        result=strcat(result,labels{p(j)});
    end;
    else
        for j=sum(space(1:i))+1:sum(space(1:i))+space(i+1)
        
        result=strcat(result,labels{p(j)});
    end;
    end;
        
    result=strcat(result,'\n');
end;
fprintf(result);
fprintf('\n');
%{
%%
% x-coordinates of the region are in the vector x
x1 = min( size(propied,1) );
x2 = max( x(:) );
% y-coordinates of the region are in the vector y
y1 = min( y(:) );
y2 = max( y(:) );
submat = mainmat(y1:y2,x1:x2);
figure;
imshow(submat);
%}