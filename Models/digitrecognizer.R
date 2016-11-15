library(plyr)
library(ggplot2)
library(lattice)
library(readr)
library(caret)
library(xgboost)

#functions to load data files from MSB first format
image_data <- function(filename) {
  ret = list()
  f <- file(filename,'rb')
  readBin(f,'integer',n=1,size=4,endian= 'big')
  ret$n <- readBin(f,'integer',n=1,size = 4,endian = 'big')
  nrows <- readBin(f,'integer',n=1,size=4,endian= 'big')
  ncols <- readBin(f,'integer',n=1,size=4,endian= 'big')
  x = readBin(f,'integer',n= ret$n*nrows*ncols,size = 1,signed = F)
  close(f)
  ret
}
label_data <- function(filename){
  f = file(filename,'rb')
  readBin(f,'integer',n=1,size=4,endian='big')
  n = readBin(f,'integer',n=1,size=4,endian='big')
  y = readBin(f,'integer',n=n,size=1,signed=F)
  close(f)
  y
}


#loading data files using aformentioned functions
train <- image_data('../data/train-images-idx3-ubyte')
test <- image_data('../data/t10k-images-idx3-ubyte')
train_labels <- label_data('../data/train-labels-idx1-ubyte')
test_labels <- label_data('../data/t10k-labels-idx1-ubyte')


#dimensions of training and test data
dim(train)
dim(test)

#model 
set.seed(626262)
num_classes <- max(train_labels)+1

 
model_xgboost.cv <- xgb.cv(params = param,
                           data = train,
                           label = train_labels,
                           nfold = cv.nfold,
                           nrounds = cv.nrounds)
model_xgboost <- xgboost(data = train ,
                         label = train_labels,
                         num_class = num_classes,
                         nrounds = 124,
                         nthread = 2,
                         
                         early.stop.round = 4,
                         param = list(objective = "multi:softmax", eval = "merror"))
xgb.basic.tTime <- proc.time() - xgb.basic.tTime 
saveRDS(model_xgboost,"model_xgboost")


#prediction
pred <- predict(model_xgboost,test)

#error 







                                       


                                       

                                       

                                       




