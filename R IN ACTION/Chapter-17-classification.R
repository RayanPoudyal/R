### Chapiter 17:  Classification

library(rpart)
library(rpart.plot)

## 17.1 Preparing the data
loc <- "http://archive.ics.uci.edu/ml/machine-learning-databases/"
ds <- "breast-cancer-wisconsin/breast-cancer-wisconsin.data"
url <- paste(loc, ds, sep = "")
  
breast <- read.table(url, sep = ",", header = F, na.strings = "?")  
names(breast) <- c("ID", "clumpThickness", "sizeUniformity", "shapeUniformity",
                   "maginalAdhesion", "singleEpithelialCellSize", "bareNuclei",
                   "blandChromatin", "normalNucleoli", "mitosis", "class")

df <- breast[-1]
df$class <- factor(df$class, levels = c(2, 4),
                   labels = c("benign", "malignant"))

set.seed(1234)
train <- sample(nrow(df), 0.7*nrow(df))
df.train <- df[train, ]
df.validate <- df[-train, ]

table(df.train$class)
table(df.validate$class)

## 17.3 Decision trees
# Classical decision trees
set.seed(1234)
dtree <- rpart(class ~ ., data = df.train, method = "class",
               parms = list(split = "information"))
dtree$cptable

plotcp(dtree)

dtree.pruned <- prune(dtree, cp = 0.09375)

prp(dtree.pruned, type = 2, extra = 104,
    fallen.leaves = T, main = "Decision Tree")

dtree.pred <- predict(dtree.pruned, df.validate, type = "class")
dtree.perf <- table(df.validate$class, dtree.pred,
                    dnn = c("Actual", "Predicted"))
dtree.perf