#we provide two ways to generate the control limit. One way is
#data-driven, using resampling of the original data to generate
#the observed cumulative failures, also applying to the expected
#cumulative failures, the other way is to generate observed
#cumulative failures from an assumed distribution also without
#resampling for the expected cumulative failures. Users can choose
#based on their interest.
#
#

#version now is using original data

source("mortality_O_E_CUSUM_generate.R")
data=CUSUM_data_gen(mu=0,yr_size=2000,tau=4,yr_er=0.1,yr_int=1,start_yr=0,seed=1,x=NULL,beta=NULL,change_yr=F,change_rate=0)



  nloop=10
  data=data
  gamma1=c(log(1.2),log(0.8))
  gamma0=c(log(1),-log(1))
  p=0.05
  tau=4
  N_list=trunc(quantile(data$total_size))
  merge=4
  start_yr=0
  yr_er=0.1
  start_day=trunc(start_yr*365)
  c1=(exp(gamma1)-exp(gamma0))/(gamma1-gamma0)-1
  sign_c1=sign(c1)
  abs_c1=abs(c1)
  gamma_subject=-log(1-yr_er)/365
  ndays=trunc(tau*365)
  mu=0
  yr_int=1

  N=length(data$delta_list)

  delta=data$delta_list
  enrl_t=data$enrl_t
  cho_time=data$cho_time

  if(is.null(data$xbeta)){
    x=rnorm(N)
    beta=rep(0,N)
    xbeta=x*beta
  }else{
    xbeta=data$xbeta
  }
  Hazard0=data$Hazard0

  h_val=NULL
  c1=(exp(gamma1)-exp(gamma0))/(gamma1-gamma0)-1
  sign_c1=sign(c1)
  abs_c1=abs(c1)
  n_days=ceiling(366*(tau))


  h_temp=matrix(NA,nrow=nloop,ncol=length(c1))
  for(j in 1:nloop){

    #select=sample(N,size=N,replace=F)
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
  E_t=colSums(E_t_pre)
  O_t=colSums(O_t_pre)
  O_E_t=O_t-E_t


  for(k in 1:length(c1)){
    M_t_pre=sign_c1[k]*O_E_t-abs_c1[k]*E_t
    M_t_pre2 = cummin(M_t_pre) #longhao:select the min among all subjects and time
    h_temp[j,k]=max(M_t_pre-M_t_pre2)
  }
  }
h_temp
