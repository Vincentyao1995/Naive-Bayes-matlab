function bayes
M=3;
% trainingImageLabeler;
choice=input('Choose your data file type: \n1:txt  \n2:picture  \n');
%C_text=textscan(file,'%s',n,'Delimiter','')
if choice==1
%file=fopen('data.txt','r');
C_data=importdata('data.txt');
%C_data=cell2mat(C_data);
[m,n]=size(C_data);
%fclose(file);
end
if choice==2
     %   img=input('input your picture name');
    img='original.jpg';
    C_data_temp=imread(img);
    temp_samples=1;
    data=load ('land.mat');
    [rows,lines,deep]=size(C_data_temp);
    train=zeros(rows*lines,deep,M);
    for i=1:M
        if i==1
            data=importdata('clouds.mat');
            [num_roi_temp,useless]=size(data.ImageSet.ImageStruct.objectBoundingBoxes);
        end
        if i==2
            data=importdata('land.mat');
            [num_roi_temp,useless]=size(data.ImageSet.ImageStruct.objectBoundingBoxes);
        end
        if i==3
            data=importdata('ocean.mat');
            [num_roi_temp,useless]=size(data.ImageSet.ImageStruct.objectBoundingBoxes);
        end
        for j=1:num_roi_temp
            x=data.ImageSet.ImageStruct.objectBoundingBoxes(j,1);
            y=data.ImageSet.ImageStruct.objectBoundingBoxes(j,2);
            width=data.ImageSet.ImageStruct.objectBoundingBoxes(j,3);
            length=data.ImageSet.ImageStruct.objectBoundingBoxes(j,4);
            for ii=1:width
                for jj=1:length
                    train(temp_samples,:,i)=C_data_temp(y+jj,x+ii,:); %д������train�ռ�
                    temp_samples=temp_samples+1;
                end
            end
        end
    end
    


%����ά�������ʽת��һ�£���Ϊ��д�����ݸ�ʽ��
[rows,lines,deep]=size(C_data_temp);
new_img=zeros(rows,lines);
m=rows*lines;
n=deep;
for i=1:rows
    for j=1:lines
        for k=1:deep
            C_data((i-1)*lines+j,k)=C_data_temp(i,j,k);
        end
    end
end
C_data=double(C_data);
end

if choice~=1&&choice~=2
    disp('your input number is wrong, please reinput it!\n');
    return;
end
%ע�⣬����C_data��Ҫ�����ң��ͼ��
for i=1:M
    for j=1:n
    class_f(i,j)=mean(train(:,n,i));
    end
end
sigma1=cov(train(:,:,1));
sigma2=cov(train(:,:,2));
sigma3=cov(train(:,:,3));
if choice==1
disp('��������б�������')
R=input('');
R=R';
end
pw1=1/3;
pw2=1/3;
pw3=1/3;

disp('��ѡ����з���������1��2����1ΪЭ�������ͬ�ķ��෽��������ΪЭ���������ͬ���෨:\n')
Choice_2=1;
%Choice=input('');

%ע�⣬�����class_f(1,:) �Ǹ������������Ը���ʽ��ת��������෴��
for i=1:rows
    for j=1:lines
        R=C_data((i-1)*lines+j,:)';
        if Choice_2==1
            g1=-1/2*R'*inv(sigma1)*R+class_f(1,:)*inv(sigma1)*R-1/2*class_f(1,:)*inv(sigma1)*class_f(1,:)'-1/2*log(abs(det(sigma1)))+log(pw1);
            g2=-1/2*R'*inv(sigma2)*R+class_f(2,:)*inv(sigma2)*R-1/2*class_f(2,:)*inv(sigma2)*class_f(2,:)'-1/2*log(abs(det(sigma2)))+log(pw2);
            g3=-1/2*R'*inv(sigma3)*R+class_f(3,:)*inv(sigma3)*R-1/2*class_f(3,:)*inv(sigma3)*class_f(3,:)'-1/2*log(abs(det(sigma3)))+log(pw3);
            
        else if Choice_2==2
                g1=class1_f'*inv(sigma1+sigma2+sigma3)*R-1/2*class_f(1,:)*inv(sigma1+sigma2+sigma3)*class_f(1,:)'+log(pw1);
                g2=class2_f'*inv(sigma1+sigma2+sigma3)*R-1/2*class_f(2,:)*inv(sigma1+sigma2+sigma3)*class_f(2,:)'+log(pw2);
                g3=class3_f'*inv(sigma1+sigma2+sigma3)*R-1/2*class_f(3,:)*inv(sigma1+sigma2+sigma3)*class_f(3,:)'+log(pw3);
            else
                disp('ѡ����������������');
            end
        end
        
        Gi=[g1,g2,g3];
        G=max(Gi);
        
        if G==g1
            New_Img(i,j,1)=255;
            New_Img(i,j,2)=0;
            New_Img(i,j,3)=0;
        end
            if G==g2
                New_Img(i,j,1)=0;
                New_Img(i,j,2)=255;
                New_Img(i,j,3)=0;
            end
            if G==g3
                New_Img(i,j,1)=0;
                New_Img(i,j,2)=0;
                New_Img(i,j,3)=255;
            end
        
    end
end
imshow(New_Img);
imwrite(New_Img,'New','bmp');

end



