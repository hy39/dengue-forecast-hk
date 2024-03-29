rm(list=ls(all=TRUE))
# 1. Cheun Chau(CC)  
# Temprature 
library(openxlsx)
HKCDCC=read.xlsx("../../dat/climate/HKCD.xlsx",sheet = "HKCDCC",startRow = 1,colNames = TRUE,detectDates = TRUE)

for (fieldLabel in c("Daily.Mean.Temperature", "Absolute.Daily.Min.Temperature")) {
  HKCDCC[fieldLabel] <- as.numeric(gsub("[^.0-9]", "", HKCDCC[fieldLabel][,]))
}

# Minimum Month Temprature  (CC)
MMTCC=aggregate(HKCDCC$Daily.Mean.Temperature,list(HKCDCC$Month,HKCDCC$Year),min,na.rm=TRUE)
names(MMTCC)[1]="Month"
names(MMTCC)[2]="Year"
names(MMTCC)[3]="MMT"

# Average Monthly Temprature (CC)
AMTCC=aggregate(HKCDCC$Daily.Mean.Temperature,list(HKCDCC$Month,HKCDCC$Year),mean,na.rm=TRUE)
names(AMTCC)[1]="Month"
names(AMTCC)[2]="Year"
names(AMTCC)[3]="AMT"

# Average Daily Minimum Temprature (CC)
ADMTCC=aggregate(HKCDCC$Absolute.Daily.Min.Temperature,list(HKCDCC$Month,HKCDCC$Year),mean,na.rm=TRUE)
names(ADMTCC)[1]="Month"
names(ADMTCC)[2]="Year"
names(ADMTCC)[3]="ADMT"

# Rainfall(CC)

RCC=read.xlsx("../../dat/climate/changzhou_climate(clean).xlsx",sheet = "Sheet1",startRow = 1,colNames = TRUE,detectDates = TRUE)
for (fieldLabel in c("totalrain")) {
  RCC[fieldLabel] <- as.numeric(gsub("[^.0-9]", "", RCC[fieldLabel][,]))
}

# 2. Tat's Cairn (TC)
# Temprature Data
library(openxlsx)

HKCDTC=read.xlsx("../../dat/climate/HKCD.xlsx",sheet = "HKCDTC",startRow = 1,colNames = TRUE,detectDates = TRUE)

for (fieldLabel in c("Daily.Mean.Temperature", "Absolute.Daily.Min.Temperature")) {
  HKCDCC[fieldLabel] <- as.numeric(gsub("[^.0-9]", "", HKCDCC[fieldLabel][,]))
}

# Minimum Month Temprature (cc)
MMTTC=aggregate(HKCDTC$Daily.Mean.Temperature,list(HKCDTC$Month,HKCDTC$Year),min,na.rm=TRUE)
names(MMTTC)[1]="Month"
names(MMTTC)[2]="Year"
names(MMTTC)[3]="MMT"

# Average Monthly Temparature (TC)
AMTTC=aggregate(HKCDTC$Daily.Mean.Temperature,list(HKCDTC$Month,HKCDTC$Year),mean,na.rm=TRUE)
names(AMTTC)[1]="Month"
names(AMTTC)[2]="Year"
names(AMTTC)[3]="AMT"

#Average Daily Minimum Temprature (TC)
ADMTTC=aggregate(HKCDCC$Absolute.Daily.Min.Temperature,list(HKCDCC$Month,HKCDCC$Year),mean,na.rm=TRUE)
names(ADMTTC)[1]="Month"
names(ADMTTC)[2]="Year"
names(ADMTTC)[3]="ADMT"

# Rainfall (TC)

RTC=read.xlsx("../../dat/climate/tate_climate(clean).xlsx",sheet = "Sheet1",startRow = 1,colNames = TRUE,detectDates = TRUE)
for (fieldLabel in c("totalrain")) {
  RTC[fieldLabel] <- as.numeric(gsub("[^.0-9]", "", RTC[fieldLabel][,]))
}
# 3. King's Park (KP)
# Temprature 
HKCDKP=read.xlsx("../../dat/climate/HKCD.xlsx",sheet = "HKCDKP",startRow = 1,colNames = TRUE,detectDates = TRUE)


for (fieldLabel in c("Daily.Mean.Temperature", "Absolute.Daily.Min.Temperature")) {
  HKCDKP[fieldLabel] <- as.numeric(gsub("[^.0-9]", "", HKCDKP[fieldLabel][,]))
}

# Minimum Month Temprature (KP)
MMTKP=aggregate(HKCDKP$Daily.Mean.Temperature,list(HKCDKP$Month,HKCDKP$Year),min,na.rm=TRUE)
names(MMTKP)[1]="Month"
names(MMTKP)[2]="Year"
names(MMTKP)[3]="MMT"


# Average Monthly Temparature (KP)

AMTKP=aggregate(HKCDKP$Daily.Mean.Temperature,list(HKCDKP$Month,HKCDKP$Year),mean,na.rm=TRUE)
names(AMTKP)[1]="Month"
names(AMTKP)[2]="Year"
names(AMTKP)[3]="AMT"

#Average Daily Minimum Temprature (KP)
ADMTKP=aggregate(HKCDKP$Absolute.Daily.Min.Temperature,list(HKCDKP$Month,HKCDKP$Year),mean,na.rm=TRUE)
names(ADMTKP)[1]="Month"
names(ADMTKP)[2]="Year"
names(ADMTKP)[3]="ADMT"

# Rainfall (TC)

RKP=read.xlsx("../../dat/climate/kingspark_climate.xlsx",sheet = "Sheet1",startRow = 1,colNames = TRUE,detectDates = TRUE)
for (fieldLabel in c("totalrain")) {
  RKP[fieldLabel] <- as.numeric(gsub("[^.0-9]", "", RKP[fieldLabel][,]))
}

# AICC


library('MASS')
source('../lib/stepAICc.R')
startyear <- 2002


# collectData

Cases.HK <- read.xlsx("../../dat/cases/hk_annual_cases.xlsx",sheet = "Sheet1",startRow = 1,colNames = TRUE,detectDates = TRUE)


# 1. GLm model fitting  Cheung Chau(CC)

# Monthly Minimum Temprature (MMTCC)

# initialize data
T <- 0
R <- 0
df <- data.frame()

for (Year in 2002:2018) {
  print(Year)
  for (Month in 1:7) {
    T[Month] <- MMTCC[MMTCC$Month==Month & MMTCC$Year==Year,'MMT']
    R[Month] <- RCC[RCC$month==Month & RCC$year==Year,'totalrain'] 
  }
  df <- rbind(df, c(Year, 1,T , R))
}
names(df)<-c('YEAR','CASES','T1','T2','T3','T4','T5','T6','T7','R1','R2','R3','R4','R5','R6','R7')
df$CASES <- Cases.HK$CASES
dfnew <- df

# GLM 
glm_fin <- stepAIC(glm(CASES ~ 1, data = dfnew),
                   scope = CASES ~ T1 + T2 + T3 + T4 + T5 + T6 + T7 + R1 + R2 + R3 + R4 + R5 + R6 + R7,
                   direction = "forward")

# Logistic regression 


# logReg1 <- stepAIC(glm(CASES ~ 1, family = "binomial",data = dfnew),
#                    scope = CASES ~ T1 + T2 + T3 + T4 + T5 + T6 + T7 + R1 + R2 + R3 + R4 + R5 + R6 + R7,
#                    direction = "forward")

# AVerage Mean Temprature(AMTCC)
#initialize data
T <- 0
R <- 0
df2 <- data.frame()

for (Year in 2002:2018) {
  print(Year)
  for (Month in 1:7) {
    T[Month] <- AMTCC[AMTCC$Month==Month & AMTCC$Year==Year,'AMT']
    R[Month] <- RCC[RCC$month==Month & RCC$year==Year,'totalrain'] 
  }
  df2 <- rbind(df2, c(Year, 1,T , R))
}
names(df2)<-c('YEAR','CASES','T1','T2','T3','T4','T5','T6','T7','R1','R2','R3','R4','R5','R6','R7')
df2$CASES <- Cases.HK$CASES
df2new <- df2

#Calculating AIC
glm_fin2 <- stepAIC(glm(CASES ~ 1, data = df2new),
                    scope = CASES ~ T1 + T2 + T3 + T4 + T5 + T6 + T7 + R1 + R2 + R3 + R4 + R5 + R6 + R7,
                    direction = "forward")

# Average Daily Minimum Temprature (CC)
T <- 0
R <- 0
df11 <- data.frame()

for (Year in 2002:2018) {
  print(Year)
  for (Month in 1:7) {
    T[Month] <- ADMTCC[ADMTCC$Month==Month & ADMTCC$Year==Year,'ADMT']
    R[Month] <- RCC[RCC$month==Month & RCC$year==Year,'totalrain'] 
  }
  df11 <- rbind(df11, c(Year, 1,T , R))
}
names(df11)<-c('YEAR','CASES','T1','T2','T3','T4','T5','T6','T7','R1','R2','R3','R4','R5','R6','R7')
df11$CASES <- Cases.HK$CASES
df11new <- df11

#Calculating AIC
glm_fin11 <- stepAIC(glm(CASES ~ 1, data = df11new),
                     scope = CASES ~ T1 + T2 + T3 + T4 + T5 + T6 + T7 + R1 + R2 + R3 + R4 + R5 + R6 + R7,
                     direction = "forward")

#1. GLm model fitting for Tate's Carn
# Mean Monthly Temprature (MMTTC)

#initialize data
T <- 0
R <- 0
df3 <- data.frame()

for (Year in 2002:2018) {
  print(Year)
  for (Month in 1:7) {
    T[Month] <- MMTTC[MMTTC$Month==Month & MMTTC$Year==Year,'MMT']
    R[Month] <- RTC[RTC$month==Month & RTC$year==Year,'totalrain'] 
  }
  df3 <- rbind(df3, c(Year, 1,T , R))
}
names(df3)<-c('YEAR','CASES','T1','T2','T3','T4','T5','T6','T7','R1','R2','R3','R4','R5','R6','R7')
df3$CASES <- Cases.HK$CASES
df3new <- df3

#Calculating AIC
glm_fin3 <- stepAIC(glm(CASES ~ 1, data = df3new),
                    scope = CASES ~ T1 + T2 + T3 + T4 + T5 + T6 + T7 + R1 + R2 + R3 + R4 + R5 + R6 + R7,
                    direction = "forward")


# Average Monthly Temprature (AMTTC)

#initialize data
T <- 0
R <- 0
df4 <- data.frame()

for (Year in 2002:2018) {
  print(Year)
  for (Month in 1:7) {
    T[Month] <- AMTTC[AMTTC$Month==Month & AMTTC$Year==Year,'AMT']
    R[Month] <- RTC[RTC$month==Month & RTC$year==Year,'totalrain'] 
  }
  df4 <- rbind(df4, c(Year, 1,T , R))
}
names(df4)<-c('YEAR','CASES','T1','T2','T3','T4','T5','T6','T7','R1','R2','R3','R4','R5','R6','R7')
df4$CASES <- Cases.HK$CASES
df4new <- df4

#Calculating AIC
glm_fin4 <- stepAIC(glm(CASES ~ 1, data = df4new),
                    scope = CASES ~ T1 + T2 + T3 + T4 + T5 + T6 + T7 + R1 + R2 + R3 + R4 + R5 + R6 + R7,
                    direction = "forward")

# Average Daily Minimum Temprature (ADMTTC)
T <- 0
R <- 0
df12 <- data.frame()

for (Year in 2002:2018) {
  print(Year)
  for (Month in 1:7) {
    T[Month] <- ADMTTC[ADMTTC$Month==Month & ADMTTC$Year==Year,'ADMT']
    R[Month] <- RTC[RTC$month==Month & RTC$year==Year,'totalrain'] 
  }
  df12 <- rbind(df12, c(Year, 1,T , R))
}
names(df12)<-c('YEAR','CASES','T1','T2','T3','T4','T5','T6','T7','R1','R2','R3','R4','R5','R6','R7')
df12$CASES <- Cases.HK$CASES
df12new <- df12

#Calculating AIC
glm_fin12 <- stepAIC(glm(CASES ~ 1, data = df12new),
                     scope = CASES ~ T1 + T2 + T3 + T4 + T5 + T6 + T7 + R1 + R2 + R3 + R4 + R5 + R6 + R7,
                     direction = "forward")

#1. GLm model fitting for King's Park
# Mean Monthly Temprature (MMTCC)

#initialize data
T <- 0
R <- 0
df5 <- data.frame()

for (Year in 2002:2018) {
  print(Year)
  for (Month in 1:7) {
    T[Month] <- MMTKP[MMTKP$Month==Month & MMTKP$Year==Year,'MMT']
    R[Month] <- RKP[RKP$month==Month & RKP$year==Year,'totalrain'] 
  }
  df5 <- rbind(df5, c(Year, 1,T , R))
}
names(df5)<-c('YEAR','CASES','T1','T2','T3','T4','T5','T6','T7','R1','R2','R3','R4','R5','R6','R7')
df5$CASES <- Cases.HK$CASES
df5new <- df5

#Calculating AIC
glm_fin5 <- stepAIC(glm(CASES ~ 1, data = df5new),
                    scope = CASES ~ T1 + T2 + T3 + T4 + T5 + T6 + T7 + R1 + R2 + R3 + R4 + R5 + R6 + R7,
                    direction = "forward")

# Average Monthly Temprature (AMTKP)

#initialize data
T <- 0
R <- 0
df6 <- data.frame()

for (Year in 2002:2018) {
  print(Year)
  for (Month in 1:7) {
    T[Month] <- AMTKP[AMTKP$Month==Month & AMTKP$Year==Year,'AMT']
    R[Month] <- RKP[RKP$month==Month & RKP$year==Year,'totalrain'] 
  }
  df6 <- rbind(df6, c(Year, 1,T , R))
}
names(df6)<-c('YEAR','CASES','T1','T2','T3','T4','T5','T6','T7','R1','R2','R3','R4','R5','R6','R7')
df6$CASES <- Cases.HK$CASES
df6new <- df6

#Calculating AIC
glm_fin6 <- stepAIC(glm(CASES ~ 1, data = df6new),
                    scope = CASES ~ T1 + T2 + T3 + T4 + T5 + T6 + T7 + R1 + R2 + R3 + R4 + R5 + R6 + R7,
                    direction = "forward")

# Average Daily Minimum Temprature (ADMTKP)

T <- 0
R <- 0
df13 <- data.frame()

for (Year in 2002:2018) {
  print(Year)
  for (Month in 1:7) {
    T[Month] <- ADMTKP[ADMTKP$Month==Month & ADMTKP$Year==Year,'ADMT']
    R[Month] <- RKP[RKP$month==Month & RKP$year==Year,'totalrain'] 
  }
  df13 <- rbind(df13, c(Year, 1,T , R))
}
names(df13)<-c('YEAR','CASES','T1','T2','T3','T4','T5','T6','T7','R1','R2','R3','R4','R5','R6','R7')
df13$CASES <- Cases.HK$CASES
df13new <- df13

#Calculating AIC
glm_fin13 <- stepAIC(glm(CASES ~ 1, data = df13new),
                     scope = CASES ~ T1 + T2 + T3 + T4 + T5 + T6 + T7 + R1 + R2 + R3 + R4 + R5 + R6 + R7,
                     direction = "forward")

#significance level of the predictors (T & RF) in the models 

summary(glm_fin)
summary(glm_fin2)
summary(glm_fin3)
summary(glm_fin4)
summary(glm_fin5)
summary(glm_fin6)
summary(glm_fin11)
summary(glm_fin12)
summary(glm_fin13)














