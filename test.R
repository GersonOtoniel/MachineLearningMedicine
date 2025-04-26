install.packages("glmnet")
library(glmnet)


cancer = read.csv(paste0("http://archive.ics.uci.edu/ml/machine-learning-databases/", "breast-cancer-wisconsin/breast-cancer-wisconsin.data"), header = FALSE,  stringsAsFactors = F)

names(cancer) = c("ID", "thickness", "cell_size", "cell_shape", "adhesion","epithelial_size", "bare_nuclei", "bland_cromatin", "normal_nucleoli", "mitoses","class")

cancer = as.data.frame(cancer)
cancer$bare_nuclei = replace(cancer$bare_nuclei, cancer$bare_nuclei == "?", NA)
cancer = na.omit(cancer)
cancer$class = as.numeric(cancer$class)
cancer$class = (cancer$class / 2) - 1

head(cancer)

set.seed(80817)
index = 1:nrow(cancer)
testindex = sample(index, trunc(length(index)/3))
testset = cancer[testindex,]
trainset = cancer[-testindex,]

x_train = data.matrix(trainset[, 2:10]) 
y_train = as.numeric(trainset[, 11]) 
x_test = data.matrix(testset[, 2:10]) 
y_test = as.numeric(testset[, 11]) 

require(glmnet) 
glm_model = cv.glmnet(x_train, y_train, alpha=1, nfolds=10) 
lambda.min = glm_model$lambda.min 
glm_coef = round(coef(glm_model,s= lambda.min),2)
plot(glm_model)

plot(glmnet(x_train,y_train, family="gaussian", alpha=1),"lambda",label=T, main="")