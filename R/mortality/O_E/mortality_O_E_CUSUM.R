source("mortality_O_E_CUSUM_generate.R")
data=CUSUM_data_gen(mu=0,yr_size=2000,tau=4,yr_er=0.1,yr_int=1,start_yr=0,seed=1,x=NULL,beta=NULL,change_yr=F,change_rate=0)

#' plots the mortality O-E CUSUM for each facility/center strata
#'
#' The function takes the information for survival analysis and returns the signal situation and plots
#'
#' @param data The data user put in
#' @param gamma1 relative risk under alternative hypothesis, could be any length, as long as consisting with number of theta0
#' @param gamma0 relative risk under null hypothesis
#' @param tau number of follow-up years
#' @param start_yr baseline year (usually year 0)
#' @param yr_er the control population's yearly mortality rate ER=(total new events in one-year follow-up)/(total patient-years)
#' @param mu true relative risk
#' @param yr_int follow-up years of interest
#' @param h control limit (generated or set according to the user's need)
#' @param restart the scale for restart
#' @return the signal points and not signal points
#' @examples
#' mortality_O_E_CUSUM(data,startdate,enddate,HPT1,HPT2,year_event_rate,h_val_path,rho)
#' #Output: graphs
#' @export
mortality_O_E_CUSUM<-function(data,gamma1=c(log(1.2),log(0.8)),gamma0=c(log(1),-log(1)),tau=4,start_yr=0,yr_er=0.1,mu=0,yr_int=1,h,restart=c(0,0)){

  ####alert message part
#nloop=1000,data=data,gamma1=c(log(1.2),log(0.8)),gamma0=c(log(1),-log(1)),p=0.05,tau=4,N_list=NULL,merge=NULL,start_yr=0,yr_er=0.1,mu=0,yr_int=1
  ####computing the result
  #####load the data
  N=length(data$delta_list)

  delta=data$delta_list
  enrl_t=data$enrl_t
  cho_time=data$cho_time

  if(is.null(data$xbeta)){
    x=rnorm(N)
    beta=rep(0,N)
    xbeta=x*beta
  }
  else{
    xbeta=data$xbeta
  }
  Hazard0=data$Hazard0

  h_val=NULL
  c1=(exp(gamma1)-exp(gamma0))/(gamma1-gamma0)-1
  sign_c1=sign(c1)
  abs_c1=abs(c1)
  n_days=ceiling(366*(tau))

  #####conduct O_E CUSUM
  E_t_pre=O_t_pre=matrix(0,nrow=N,ncol=n_days)

  for (i in 1:N){
    if(delta[i]){
      O_t_pre[i,(cho_time[i]+1):n_days]=1
    }
    E_t_pre[i,(cho_time[i]+1):n_days]=Hazard0[cho_time[i]-enrl_t[i]+1]*exp(xbeta[i])
    E_t_pre[i,(enrl_t[i]:cho_time[i]+1)]=Hazard0[1:(cho_time[i]-enrl_t[i]+1)]*exp(xbeta[i])
  }

  E_t=colSums(E_t_pre)
  O_t=colSums(O_t_pre)
  O_E_t=O_t-E_t

  ###M1,M2 for "worse" and "better"
  M1_pre=O_E_t-c1[1]*E_t #use for M_t_restart
  M2_pre=-O_E_t+c1[2]*E_t

  M1_pt1=NULL #vectors
  M1_pt2=NULL
  M2_pt1=NULL
  M2_pt2=NULL
  cross1=0
  cross1_t=0
  cross2=0
  cross2_t=0

  M1_restart=rep(0,n_days)
  M2_restart=rep(0,n_days)
  M1_min=M1_pre[1]
  M2_min=M2_pre[1]
  start1 = 1
  start2 = 1

  #####check signal points
  result <- matrix(0, nrow = n_days, ncol = 6) # storage matrix for alarms
  cross_1 = NULL
  cross_2 = NULL

  for(t in 1:ndays){
    M1_min=min(M1_min,M1_pre[t])
    M2_min=min(M2_min,M2_pre[t])
    M1_pt1=M1_min-M1_pre[t]+h[1]          ###xmding: both M1 deduce M1_pre[i,start1[i]]
    M2_pt1=M2_min-M2_pre[t]+h[2]
    if(!is.null(restart[1]) && cross1>0) M1_pt2=restart[1]*h[1]-(M1_pre[t]-M1_pre[start1]) #incoporate restart mechanism in the difference
    ###xmding: why -M1_pre[i,start1[i]]? restart ignore past information
    if(!is.null(restart[2]) && cross2>0) M2_pt2=restart[2]*h[2]-(M2_pre[t]-M2_pre[start2])
    M1_restart[t]=min(M1_pt1,M1_pt2,na.rm=T)
    M2_restart[t]=min(M2_pt1,M2_pt2,na.rm=T)
    if (M1_restart[t] < 0) {
      # test for signal
      result[t, 5] <- 1 # store signal for worse
      start1=t #remove previous information
      cross_1 = c(cross_1,t)
    } else {
      result[t, 5] <- 0
    }
    if (M2_restart[t] < 0) {
      # test for signal
      result[t, 6] <- 1 # store signal for better
      start2=t #remove previous information
      cross_2 = c(cross_2,t)
    } else {
      result[t, 6] <- 0
    }
    result[t, 1] <-  t# store patient id
    result[t, 2] <- O_E_t[t] # store CUSUM value
    result[t, 3] <- O_E_t[t]+M1_restart[t] # store upper limit
    result[t, 4] <- O_E_t[t]-M2_restart[t] # store lower limit

  }

  result <- as.data.frame(result)
  names(result) <- c("t", "O_E", "O_E_M1", "O_E_M2", "signal_worse","signal_better")

  class(result) <- c("cusum", "data.frame")
  return(result)
  ####creating the plot

  ####interpretation

}


res=mortality_O_E_CUSUM(data,gamma1=c(log(1.2),log(0.8)),gamma0=c(log(1),-log(1)),tau=4,start_yr=0,yr_er=0.1,mu=0,yr_int=1,h=c(6.706183,10.454591),restart=c(0,0))
