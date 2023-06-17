#' Title
#'
#' @param x An object of class cusum
#' @param onesignal if true, only show the first signal point; if false,
#'
#' @return
#' @export
#'
#' @examples
test_plot <- function(x, onesignal = TRUE){

  library(checkmate)
  library(ggplot2)
  assert_logical(onesignal, len = 1)

  data_fun <- data.frame(x = x$t,            # Create data for ggplot2
                         values = c(x$O_E,
                                    x$O_E_M1,
                                    x$O_E_M2),
                         curve = rep(c("O_E", "O_E+M1", "O_E-M2"),each=length(x$t)))




  ###signal
  if (onesignal == TRUE) {
    p_signal <- which(x$signal_worse==1|x$signal_better==1)[1]
  }else{
    p_signal <- which(x$signal_worse==1|x$signal_better==1)
  }

  curve_colors <- c("black", "blue", "blue")
  myplot=ggplot(data_fun,                                   # Draw ggplot2 plot
                aes(x, values, col = curve)) + geom_line()+scale_color_manual(values = curve_colors)+
   geom_vline(data = data_fun[p_signal, ], aes(xintercept = x), col = "red")

  print(myplot)


}

source("mortality_O_E_CUSUM.R")
test_plot(res,TRUE)

