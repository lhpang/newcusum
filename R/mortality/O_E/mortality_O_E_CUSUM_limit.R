#we provide two ways to generate the control limit. One way is
#data-driven, using resampling of the original data to generate
#the observed cumulative failures, also applying to the expected
#cumulative failures, the other way is to generate observed
#cumulative failures from an assumed distribution also without
#resampling for the expected cumulative failures. Users can choose
#based on their interest.
#
#

source("mortality_O_E_CUSUM_generate.R")
data=CUSUM_data_gen(mu=0,yr_size=2000,tau=4,yr_er=0.1,yr_int=1,start_yr=0,seed=1,x=NULL,beta=NULL,change_yr=F,change_rate=0)


#' Title
#'
#' @param nloop total rounds for generating
#' @param N_list list of numbers of resampling
#' @param data data(generated or real dataset)
#' containing delta(indicator of qualifying failures), enrl_t
#' (chronological transplant time for each subject), cho_time
#' (chronological time for end of follow up for each subject),
#' xbeta (risk score for each subject), Hazard0 (cumulative
#' intensity or expected number of events for the center up
#'  to t under national average
#' @param gamma1 relative risk under alternative hypothesis, could be any length, as long as consisting with number of theta0
#' @param gamma0 relative risk under null hypothesis
#' @param p type I error we control for
#' @param tau number of follow-up years
#' @param merge number of loop for resampling for each number in resampling list
#'
#' @return control limits for each test of each resampling case (a dataframe)
#' @export
#'
#' @examples
mortality_O_E_CUSUM_limit_resample=function(nloop,data,gamma1,gamma0,p,tau,N_list,merge){

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



  #longhao: tau,merge determines the time length
  # if(n_days>length(Hazard0)) warning("Error:n_days>length(Hazard0).")
  E_t_pre=O_t_pre=matrix(0,nrow=N,ncol=n_days)
  for (i in 1:N){
    if(delta[i]){
      O_t_pre[i,(cho_time[i]+1):n_days]=1
    }
    E_t_pre[i,(cho_time[i]+1):n_days]=Hazard0[cho_time[i]-enrl_t[i]+1]*exp(xbeta[i])
    E_t_pre[i,(enrl_t[i]:cho_time[i]+1)]=Hazard0[1:(cho_time[i]-enrl_t[i]+1)]*exp(xbeta[i])
  }

  for(N3 in N_list){
    #longhao: N_list is a list of number of resampling, apply all of these to finish resampling
    print(paste0("size=",N3))
    pb <- txtProgressBar(min = 1, max = nloop, style = 3)
    h_temp=matrix(NA,nrow=nloop,ncol=length(c1))

    for(loop in 1:nloop){
      setTxtProgressBar(pb, loop)
      E_t=O_t=0
       #error! correctee on June 26 2018 size=round(N3/merge) should be changed to size=N3
      select=sample(N,size=N3,replace=T)
      #select = c(1:N3)
      #for(m in 1:merge){

        #O_t=c(O_t,O_t[length(O_t)]+colSums(O_t_pre[select,(merge-1)*366+1:366]))
        #E_t=c(E_t,E_t[length(E_t)]+colSums(E_t_pre[select,(merge-1)*366+1:366]))
        O_t=colSums(O_t_pre[select,])
        E_t=colSums(E_t_pre[select,])

      #}

      O_E_t=O_t-E_t

      for(k in 1:length(c1)){
        M_t_pre=sign_c1[k]*O_E_t-abs_c1[k]*E_t
        M_t_pre2 = cummin(M_t_pre) #longhao:select the min among all subjects and time
        h_temp[loop,k]=max(M_t_pre-M_t_pre2)
      }
    }
    h_size=sort(apply(h_temp,2,quantile,probs=1-p))
    print(h_size)
    h_val=rbind(h_val, h_size)
    close(pb)
  }
  return( data.frame(N_list,h_val))

}



#' Title
#'
#' @param nloop total rounds for generating
#' @param data data(generated or real dataset)
#' containing delta(indicator of qualifying failures), enrl_t
#' (chronological transplant time for each subject), cho_time
#' (chronological time for end of follow up for each subject),
#' xbeta (risk score for each subject), Hazard0 (cumulative
#' intensity or expected number of events for the center up
#'  to t under national average
#' @param gamma1 relative risk under alternative hypothesis, could be any length, as long as consisting with number of theta0
#' @param gamma0 relative risk under null hypothesis
#' @param p type I error we control for
#' @param tau number of follow-up years
#' @param yr_er the control population's yearly mortality rate ER=(total new events in one-year follow-up)/(total patient-years)
#' @param mu true relative risk
#' @param yr_int follow-up years of interest
#' @param start_yr baseline year (usually year 0)
#'
#' @return control limits for each test (a vector)
#' @export
#'
#' @examples
mortality_O_E_CUSUM_limit_distribution=function(nloop,data,gamma1,gamma0,p,tau,start_yr=0,yr_er=0.1,mu=0,yr_int=1){

  N=length(data$delta_list)
  enrl_t=data$enrl_t
  start_day=trunc(start_yr*365)
  c1=(exp(gamma1)-exp(gamma0))/(gamma1-gamma0)-1
  sign_c1=sign(c1)
  abs_c1=abs(c1)
  gamma_subject=-log(1-yr_er)/365
  ndays=trunc(tau*365)

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
  n_days=ceiling(366*(tau))
  pb <- txtProgressBar(min = 1, max = nloop, style = 3)
  h_temp=matrix(NA,nrow=nloop,ncol=length(c1))



  for(loop in 1:nloop){
    setTxtProgressBar(pb, loop)

    pre_time=trunc(rexp(N,(gamma_subject)*exp(mu)))
    delta=((pre_time<=365*yr_int) & ((enrl_t+pre_time)<(tau*365)))
    time=trunc(pmin(pre_time,pmin(365*yr_int,tau*365-enrl_t)))
    cho_time=enrl_t+time
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

    for(k in 1:length(c1)){
      M_t_pre=sign_c1[k]*O_E_t-abs_c1[k]*E_t
      M_t_pre2 = cummin(M_t_pre) #longhao:select the min among all subjects and time
      h_temp[loop,k]=max(M_t_pre-M_t_pre2)
    }
  }
  h_size=apply(h_temp,2,quantile,probs=1-p)
  #print(h_size)
  h_val=rbind(h_val, h_size)
  close(pb)
  return(sort(h_size))
}

#limit function
#' Title
#'
#' @param nloop total rounds for generating
#' @param data data(generated or real dataset)
#' containing delta(indicator of qualifying failures), enrl_t
#' (chronological transplant time for each subject), cho_time
#' (chronological time for end of follow up for each subject),
#' xbeta (risk score for each subject), Hazard0 (cumulative
#' intensity or expected number of events for the center up
#'  to t under national average
#' @param gamma1 relative risk under alternative hypothesis, could be any length, as long as consisting with number of theta0
#' @param gamma0 relative risk under null hypothesis
#' @param p type I error we control for
#' @param tau number of follow-up years
#' @param N_list list of numbers of resampling
#' @param merge number of loop for resampling for each number in resampling list
#' @param yr_er the control population's yearly mortality rate ER=(total new events in one-year follow-up)/(total patient-years)
#' @param mu true relative risk
#' @param yr_int follow-up years of interest
#' @param start_yr baseline year (usually year 0)
#'
#' @return  control limits for each test of each resampling case (a dataframe)
#' or control limits for each test (a vector)
#' @export
#'
#' @examples
mortality_O_E_CUSUM_limit =  function(nloop=1000,data=data,gamma1=c(log(1.2),log(0.8)),gamma0=c(log(1),-log(1)),p=0.05,tau=4,N_list=NULL,merge=NULL,start_yr=0,yr_er=0.1,mu=0,yr_int=1){
  if(!is.null(N_list)&&!is.null(merge)){
    return(mortality_O_E_CUSUM_limit_resample(nloop,data,gamma1,gamma0,p,tau,N_list,merge))
  }
  else{
    return(mortality_O_E_CUSUM_limit_distribution(nloop,data,gamma1,gamma0,p,tau,start_yr,yr_er,mu,yr_int))
  }
}


###########################test case
##without resampling
h_val_distribution=NULL
# for(i in 1:5){
# h_val_distribution = rbind(h_val_distribution,mortality_O_E_CUSUM_limit(nloop=10,data=data,gamma1=c(log(1.2),log(0.8)),gamma0=c(log(1),-log(1)),p=0.05,tau=4,start_yr=0,yr_er=0.1,mu=0,yr_int=1)
# )
# }
#limit=apply(h_val_distribution,2,mean)
#23.22365 29.11835
##with resampling
O_E_limit_resample = mortality_O_E_CUSUM_limit(nloop=10,data=data,gamma1=c(log(1.2),log(0.8)),gamma0=c(log(1),-log(1)),p=0.05,tau=4,N_list=trunc(quantile(data$total_size)),merge=4)
h_val_resample=as.vector(apply(O_E_limit_resample,2,mean)[2:3])

