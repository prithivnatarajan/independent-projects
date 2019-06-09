tic
load fisheriris
inds = ~strcmp(species,'setosa');
X = meas(inds,3:4);
y = species(inds);
SVMModel = fitcsvm(X,y);

% CVSVMModel = crossval(SVMModel);

classOrder = SVMModel.ClassNames;

sv = SVMModel.SupportVectors;
figure
gscatter(X(:,1),X(:,2),y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('versicolor','virginica','Support Vector')
hold on

meshsize = 40;
x1 = linspace(min(X(:,1)),max(X(:,1)),meshsize)';
x2 = linspace(min(X(:,2)),max(X(:,2)),meshsize)';

bb=SVMModel.Bias;
w=SVMModel.Beta;
yy=zeros(meshsize,meshsize);

figure;
for i=1:meshsize
    for j=1:meshsize
        yy(i,j) = sign([x1(i) x2(j)]*w + bb);
    end
end

pcolor(yy)
toc