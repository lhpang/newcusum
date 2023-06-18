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
  reference_date <- as.Date("2022-10-01")
  data_fun$x <- reference_date + data_fun$x
  myplot=ggplot(data_fun,                                   # Draw ggplot2 plot
                aes(x, values, col = curve)) + geom_line()+xlab("Date") +  # Set the x-axis label as "Date"
    scale_x_date(date_labels = "%Y/%m/%d")+scale_color_manual(values = curve_colors)+
   geom_vline(data = data_fun[p_signal, ], aes(xintercept = x), col = "red")

  print(myplot)


}

#source("mortality_O_E_CUSUM.R")
test_plot(result,TRUE)

# Create a list of numbers representing days elapsed
number_list <- c(500, 700, 1000, 1200)

# Define the reference date
reference_date <- as.Date("2022-10-01")

# Calculate the corresponding dates by adding the numbers to the reference date
result_dates <- reference_date + number_list

# Print the resulting dates
print(result_dates)

