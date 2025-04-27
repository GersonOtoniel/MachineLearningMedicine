#install.packages("glmnet")
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
#plot(glm_model)
plot(glmnet(x_train,y_train, family="gaussian", alpha=1),"lambda",label=T, main="") #para la regularizacion

glm_pred = round(predict(glm_model, x_test, type="response"),0) #creacion del vector

#install.packages("caret")
require(caret) 
confusionMatrix(as.factor(glm_pred),as.factor(y_test)) #matriz de confusion



#probando nuevos datos
thickness = 8
cell_size = 7
cell_shape = 8
adhesion = 5
epithelial_size = 5
bare_nuclei = 7
bland_cromatin = 9
normal_nucleoli = 8
mitoses = 10
new_data = c(thickness,cell_size,cell_shape,adhesion,epithelial_size,bare_nuclei,bland_cromatin,normal_nucleoli ,mitoses) 
new_pred_glm = predict(glm_model ,data.matrix(t(new_data)),type="response") 
print(new_pred_glm)