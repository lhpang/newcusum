#' Title time scale is day
#'
#' @param mu true relative risk
#' @param yr_size the sample size at the beginning of follow-up
#' @param tau number of follow-up years
#' @param yr_er the control population's yearly mortality rate ER=(total new events in one-year follow-up)/(total patient-years)
#' @param yr_int follow-up years of interest
#' @param start_yr baseline year (usually year 0)
#' @param seed seed for generating time to event
#' @param x covariate vector for each subject
#' @param beta covariate effect for each subject
#' @param change_yr year changes or not
#' @param change_rate new yearly rate
#'
#' @return
#' @export
#'
#' @examples
CUSUM_data_gen=function(mu,yr_size,tau,yr_er,yr_int=1,start_yr=0,seed=1,x=NULL,beta=NULL,change_yr=F,change_rate=0){
  set.seed(seed)
  size=trunc(yr_size*tau) #longhao:sample size
  #size=trunc(yr_size) #longhao:sample size
  gamma_subject=-log(1-yr_er)/365 #longhao: hazard rate
  ndays=trunc(tau*365) #longhao: total number of days in monitor
  start_day=trunc(start_yr*365) #longhao: time 0 is the calendar time of start of follow up
  time_list=0:ndays #longhao: time(x lab) to show in the plot
  Hazard0=(0:ndays)*gamma_subject #longhao: cumulative hazard
  enrl_gp=rexp(size*2, yr_size)
  #enrl_gp=rexp(size, yr_size)
  enrl_t=cumsum(enrl_gp)
  enrl_t=floor((enrl_t[enrl_t<tau])*365)
  #longhao:only includes the subjects whose transplant time are observed within the follow-up years
  N3=length(enrl_t)
  pre_time=trunc(rexp(N3,(gamma_subject)*exp(mu)))
  if(change_yr!=F){
    ind_change <- which((pre_time+enrl_t)>(change_yr*365))
    pre_time[ind_change]<- ceiling((pre_time[ind_change]+enrl_t[ind_change]-pmax(change_yr*365,enrl_t)[ind_change])*exp(mu)/exp(change_rate)+pmax(change_yr*365,enrl_t)[ind_change]-enrl_t[ind_change])
  }
  delta_list=((pre_time<=365*yr_int) & ((enrl_t+pre_time)<(tau*365)))
  time=trunc(pmin(pre_time,pmin(365*yr_int,tau*365-enrl_t)))
  cho_time=enrl_t+time
  if(is.null(x)){
    x=rnorm(N3)
  }
  if(is.null(beta)){
    beta=rep(0,N3)
  }
  xbeta=x*beta
  return(list(time_list=time_list,delta_list=delta_list,cho_time=cho_time,enrl_t=enrl_t,xbeta=xbeta,Hazard0=Hazard0,total_size=N3))

}


###########################test case
#data=CUSUM_data_gen(mu=0,yr_size=2000,tau=4,yr_er=0.1,yr_int=1,start_yr=0,seed=1,x=NULL,beta=NULL,change_yr=F,change_rate=0)

