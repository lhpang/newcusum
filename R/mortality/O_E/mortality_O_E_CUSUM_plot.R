setwd("C:/Users/lhpan/OneDrive/Desktop/He project/newcusum/R/mortality/O_E")
#' Title
#'
#' @param x An object of class cusum
#' @param onesignal if true, only show the first signal point; if false,
#'
#' @return
#' @export
#'
#' @examples
mortality_O_E_CUSUM_plot <- function(x, onesignal = TRUE) {

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
  reference_date <- as.Date("2018-10-01")
  data_fun$x <- reference_date + data_fun$x
  curve_colors <- c("black", "blue", "blue")
  myplot=ggplot(data_fun,                                   # Draw ggplot2 plot
                aes(x, values, col = curve)) + geom_line()+xlab("Date") +  # Set the x-axis label as "Date"
    scale_x_date(date_labels = "%Y/%m/%d")+scale_color_manual(values = curve_colors)+
    geom_vline(data = data_fun[p_signal, ], aes(xintercept = x), col = "red", lwd = 0.5)

  print(myplot)


  # y_lim = c(1.5*min(x$O_E_M2),1.5*max(x$O_E_M1))
  #
  # plot(
  #   x = x$t,
  #   y = x$O_E,
  #   type = "n",
  #   xlim = c(0, max(x$t)),
  #   ylim = y_lim,
  #   ylab = expression(CUSUM[t]), xlab = "t"
  # )
  #
  # if (onesignal == TRUE) {
  #   p_signal <- which(x$signal_worse==1|x$signal_better==1)[1]
  #   points(
  #     x = x$t[p_signal],
  #     y = x$O_E[p_signal],
  #     col = "orange",
  #     cex = 1.8,
  #     pch = 8,
  #     lwd = 2.5
  #   )
  # }else{
  #    p_signal <- which(x$signal_worse==1|x$signal_better==1)
  #    points(
  #      x = x$t[p_signal],
  #      y = x$O_E[p_signal],
  #      col = "orange",
  #      cex = 1.8,
  #      pch = 8,
  #      lwd = 2.5
  #    )
  #  }
  #
  #
  # lines(
  #   x = x$t,
  #   y = x$O_E
  # )
  #
  # lines(
  #   x = x$t,
  #   y = x$O_E_M1,
  #   col = "Blue"
  # )
  #
  # lines(
  #   x = x$t,
  #   y = x$O_E_M2,
  #   col = "red"
  # )
  #
  # points(
  #   x = x$t,
  #   y = x$O_E,
  #   cex = .1,
  #   pch = 16
  # )
}

