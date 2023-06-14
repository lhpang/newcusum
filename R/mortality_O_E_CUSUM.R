#' plots the mortality O-E CUSUM for each facility/center strata
#'
#' The function takes the information for survival analysis and returns the signal situation and plots
#'
#' @param data The data user put in
#' @param startdate The calendar time of start date of the follow up (0 point of the time scale)
#' @param enddate The calendar time of start date of the follow up
#' @param HPT1 The H_1 of deterioration
#' @param HPT2 The H_1 of improvement
#' @param year_event_rate The risk
#' @param h_val_path Path of control limits for different sample sizes
#' @param rho Parameter to control the restart
#'
#' @return the signal points and not signal points
#' @examples
#' mortality_O_E_CUSUM(data,startdate,enddate,HPT1,HPT2,year_event_rate,h_val_path,rho)
#' #Output: graphs
#' @export
mortality_O_E_CUSUM<-function(data,startdate,enddate,HPT1,HPT2,year_event_rate,h_val_path,rho){

  ####alert message part

  ####computing the result

  ####creating the plot

  ####interpretation

}
