tic
load fisheriris
inds = ~strcmp(species,'setosa');
X = meas(inds,3:4);
y1 = species(inds);
y = double(~strcmp(y1,'versicolor'));
y(y==0)=-1;
SVMModel = fitcsvm(X,y);
ww = [];
bb = [];

meshsize = 40;
x1 = linspace(min(X(:,1)),max(X(:,1)),meshsize)';
x2 = linspace(min(X(:,2)),max(X(:,2)),meshsize)';
bb=SVMModel.Bias;
w=SVMModel.Beta;
yy=zeros(meshsize,meshsize);

for i=1:5
    Xn = X(1:i,:);
    yn = y(1:i);
    Xp = X(51:50+i,:);
    yp = y(51:50+i);
    Xre = [Xn;Xp];
    yre = [yn;yp];
    SVMModel = fitcsvm(Xre,yre);
    bb = [bb SVMModel.Bias];
    ww = [ww SVMModel.Beta];
    figure;
    for ii=1:meshsize
        for jj=1:meshsize
            yy(ii,jj) = sign([x1(ii) x2(jj)]*SVMModel.Beta + SVMModel.Bias);
        end
    end
    pcolor(yy)  
%     figure
%     gscatter(Xre(:,1),Xre(:,2),yre)
%     axis([2.7,7.5,0.5,3])
end

figure
plot(ww(1,:))
hold on
plot(ww(2,:))
hold on
plot(bb)