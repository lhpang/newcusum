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
  assert_logical(onesignal, len = 1)

  y_lim = c(1.5*min(x$O_E_M2),1.5*max(x$O_E_M1))

  plot(
    x = x$t,
    y = x$O_E,
    type = "n",
    xlim = c(0, max(x$t)),
    ylim = y_lim,
    ylab = expression(CUSUM[t]), xlab = "t"
  )

  if (onesignal == TRUE) {
    p_signal <- which(x$signal_worse==1|x$signal_better==1)[1]
    points(
      x = x$t[p_signal],
      y = x$O_E[p_signal],
      col = "orange",
      cex = 1.8,
      pch = 8,
      lwd = 2.5
    )
  }else{
     p_signal <- which(x$signal_worse==1|x$signal_better==1)
     points(
       x = x$t[p_signal],
       y = x$O_E[p_signal],
       col = "orange",
       cex = 1.8,
       pch = 8,
       lwd = 2.5
     )
   }


  lines(
    x = x$t,
    y = x$O_E
  )

  lines(
    x = x$t,
    y = x$O_E_M1,
    col = "Blue"
  )

  lines(
    x = x$t,
    y = x$O_E_M2,
    col = "red"
  )

  points(
    x = x$t,
    y = x$O_E,
    cex = .1,
    pch = 16
  )
}

source("mortality_O_E_CUSUM.R")
mortality_O_E_CUSUM_plot(res,TRUE)
