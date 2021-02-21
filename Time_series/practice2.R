setwd("C:/Users/WJ/Downloads/2018-2/�ð迭/�⸻ �غ�")
data <- scan("practice2.csv")
library(itsmr)
data_ts <- ts(data, start = c(1987,01), frequency = 12)
ts.plot(data_ts)
ts.plot(data)
test(data)
n = length(data)

# (a) Time plot, correlograms (ACF) 
#and discuss key features of the data.

# �����ϴ� trend�� ������ �ִ�. 
# ���� �л��� ������ �������� trend�� ������ ���� 
# �� ������ ���� �ϴ� ������ ���δ�. 
# �������� plot�����δ� Ȯ���ϱ� ����� ���δ�.
# 2013�� ���� ���Ұ� ���� ���. 


#acf������ ���� trend������ ������ �����ϴ� acf�� �� ���ִ�.
# pacf�� ar(1)���� ���� pacf�� ���̰� 12,24�� �ֱ⵵ �̾��ϰ� ���δ�. 
# qqplot�� ���� ���Լ��� �����ٰ� ���� ����� ���δ�. 
acf(data, lag.max = 80)

## data�� ó�� ���캼�� 

par(mfrow = c(4,4)) 
for ( i in 1:16) {
  plot(data[1:(n-i)], data[(i+1):n], xlab =  paste(" Y_{t-", as.character(i), "}") ,  ylab = "Y_t")
}

par(mfrow = c(4,4)) 
for ( i in 32:47) {
  plot(data[1:(n-i)], data[(i+1):n], xlab =  paste(" Y_{t-", as.character(i), "}") ,  ylab = "Y_t")
}

par(mfrow = c(4,4)) 
for ( i in 61:75) {
  plot(data[1:(n-i)], data[(i+1):n], xlab =  paste(" Y_{t-", as.character(i), "}") ,  ylab = "Y_t")
}

# plot���� �׷��� ���� acf�� Ȯ�� �� �� �־���. 

## (b) Is it stationary? Include your evidence.

# satationary�����ʴ�.  1. ����� �����ؾ������� ����� ������ 

test(data)  
#diff signs S, Rank p���� �͹������� �Ⱒ���� Ȯ���Ҽ��ִ�.
#diff signs S�� yi > yi-1 ���� y�� ������ ����� Ƚ��, �� y�� �����ϴ� Ƚ���� S��� �ϰ� S�� ũ�� �����ϴ� TREND�� �ִٰ� �ؼ��Ѵ�. 
#RANK test�� yj > yi �̰� j>i �� pair�� ���ڶ�� �Ѵ�. �׷��Ƿ� p�� ũ�� �����ϴ� trend�� �ִٰ� �Ѵ�. 
#�̴� data�� trend�� �����Ѵٴ� �ǹ̷� �ؼ� �� �� �ִ�.
#�����ϴ� trend�� ������ local level �� ����� �ٸ���. 
# 

# 2. Var�� �����Ѱ�? 
# plot�����δ� �ް��� �޶��� �ִ� 300�߹��� �����ϰ��� ������ ���δ�. 



s <- 12 # �ֱ� 
n <- length(data)
season_index <- matrix(NA,s, ceiling(n/s))
for ( i in 1:s) {
  s_d <- seq(from = i , to = n ,  by = s)
  if (i <= (n %% s)) {
    season_index[i,1:ceiling(n/s)] <- s_d
  } else season_index[i,1:floor(n/s)] <- s_d
}


### function
seasonalize <- function(x,s) {
  sea <- season_index[s,]
  season_data <- x[sea]
  season_data <- season_data[!is.na(season_data)] 
  return(season_data)
}

par(mfrow = c(3,4))
for (i in 1:s) {
  ts.plot(seasonalize(data,i),ylab = paste("season" ,as.character(i)))
}

for (i in 1:s) {
  acf(seasonalize(data,i))
}
# ������ �������� �����ϴ� trend�� ������ Ȯ���ߴ�.
# �л��� plot�󿡼� ���������ʴ� ������ ���δ�. 



for ( i in 16) {
  plot(data[1:(n-i)], data[(i+1):n], xlab =  paste(" X_{t-", as.character(i), "}") ,  ylab = "X_t")
}
points(data[(n-34):(n-14)],data[(n-20):n], col = "red")  # �ı��� �����͸� ���������� ���� 
points(data[(n-78):(n-48)],data[(n-64):(n-34)], col = "Blue1") # �ı⺸�� ���� ���� �����͸� �Ķ���# ���� ���� 
points(data[1:30],data[15:44], col = "green")  # �ʱ��� �����͸� ������� ���� 


# ���������� �����ϴ� trend�� ������ Ȯ���ߴ�. 

# Fidn the best model to describe the data and statistical reasonings for model selection
# including model diagnostics/checking.

# model�� �� 4������ ã�ƺ��ڴ�
# 1. plot�� ������ �Ǵ�. 2. information_creteria�� ����� �� ����
# 3. alasso�� ����� backward ��� 4. out of sample forecasting���� �ְ��� ������ ������ �� 

#plot
#plot�� ������ �������� �����ϴ� Ʈ���尡 ���̹Ƿ� lag =12�� ���ؼ� �����ϰڴ�. 
# lag 12�� ���� �����ص� 1-B^12 = (1-B)(1+B+B^2+...) �̹Ƿ� 
# 1�� POLYNOMIAL TREND�� �����ϱ⿡ ���� �ֱ� s�� ���� ���� �����ϰڵ� .

data_d12 <- diff(data, lag = 12)
# �� �����Ҷ����� data�� ���ڰ� �׸�ŭ �پ��� ���� �����̴�. �׷��Ƿ� 
# ������ data�� ����Ͽ� ������� ��ü�ϸ� �ȴ�. 
ts.plot(data_d12)
test(data_d12)
## lag =12�� ���� stationary �غ������ʾƼ� lag 1�� �ٽ� ���� 

data_d1 <- diff(data, lag =1)
ts.plot(data_d1)
test(data_d1)
 data_d1_sup <- c(rep(mean(data_d1),(length(data)-length(data_d1))),data_d1)
# �̷��� ���� �л��� Ŀ���� ���� ���δ�. logȭ�� ��Ű�� �ٽ� �����غ���
x = 1:length(data)
fit = boxcox(data~1, plotit=TRUE);
lambda = fit$x[which.max(fit$y)]
lambda
data <- data^1.555556
data_d1 <- diff(data, lag =1)
ts.plot(data_d1)
test(data_d1)

# �л��� ����ȭ �������� trend���� ������ �ʴ´�. test����� ljung_box, mecleod_li�� �Ⱒ�ߵ�. 
#acf,pacf �󿡼� pacf�� 12���� ������� 
# acf�� 12,24�� ��� ª������ ������ ���� sarima�� (1,0,0) �� �����غ��δ�. 
# arima������ pacf 1,2,311 , acf10,1�� ����()�� ����()�� �����ϰ� 0�� �ƴ��� �����ִ�. �׷��� arima(1,1,1) �������غ��ڴ�. 

model_plot <- arima(data,order=c(11,0,11),seasonal = list(order=c(1,1,0),period = s),include.mean = F)
tsdiag(model_plot)
ts.plot(model_plot$residuals)
test(model_plot$residuals)
plot(data)
library(forecast)
auto.arima(data_ts, approximation = F)
test(resid(auto.arima(data_ts)))
auto.arima(data_ts,approximation = F,max.D = 0)
test(resid(auto.arima(data_ts,approximation = F,max.D = 0)))


                                                   #1  2 3 4 5  6 7 8 9 10 1112 13 14 15  16 17 18 19 20 21 22 23 24
model_alsso <- arima(data,order=c(24,1,0),fixed = c(NA,0,0,0,0,NA,0,0,NA,0,0,NA,0 ,NA,NA, NA,NA,NA, 0,0,0   , NA,NA,NA))
test(model_alsso$residuals)                     
plot(forecast(model_alsso,n.ahead = 20))                     

# auto.arima d,�� D�� �����ؼ� ���� �ϵ��� ���� 
??auto.arima  # help ������ ic�� aicc, aic, bic ���� , parallel true�� ��� �� �ٸ���

model_alsso <- arima(data,order=c(24,1,0),fixed = c(NA,0,0,0,0,0,0,0,0,0,0,NA,0 ,NA,0, 0,0,NA, 0,0,0   , 0,0,NA))
test(model_alsso$residuals)                     
plot(forecast(model_alsso,n.ahead = 20))   


## 

t = 1:(n-1);
m1 = round(n/12);
m2 = m1*2;
costerm1 = cos(m1*2*pi/n*t);
sinterm1 = sin(m1*2*pi/n*t);
costerm2 = cos(m2*2*pi/n*t);
sinterm2 = sin(m2*2*pi/n*t);
out.lm1 = lm(data_d1 ~ 1 + costerm1 + sinterm1)
summary(out.lm1)
out.lm2 = lm(data_d1 ~ 1 + costerm1 + sinterm1 + costerm2 + sinterm2)
summary(out.lm2)
x = as.vector(time(data_d1))
plot.ts(data_d1_sup);
title("US accidental deaths")
lines(x, out.lm1$fitted, col="blue")
lines(x,out.lm2$fitted, col="red")
legend(1975, 10800, lty=c(1,1), col=c("blue","red"), c("k=1", "k=2"))

data_deseason <- data_d1 - out.lm2$fitted.values
ts.plot(data_deseason)



