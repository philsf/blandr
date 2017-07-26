#' @title Bland-Altman plotting function, using basic R drawing functions
#'
#' @description Draws a Bland-Altman plot using data calculated using the other functions, using the in-built R graphics
#'
#' @author Deepankar Datta <deepankardatta@nhs.net>
#'
#' @param statistics.results A list of statistics generated by the blandr.statistics function: see the function's return list to see what variables are passed to this function
#' @param plot.limits A list of statistics generated by the blandr.plot.limits function to define the extent of the x- and y- axes: see the function's return list to see what variables are passed to this function
#' @param method1name (Optional) Plotting name for 1st method, default 'Method 1'
#' @param method2name (Optional) Plotting name for 2nd method, default 'Method 2'
#' @param plotTitle (Optional) Title name, default 'Bland-Altman plot for comparison of 2 methods'
#' @param annotate (Optional) TRUE/FALSE switch to provides annotations to plot, default=FALSE
#' @param ciDisplay (Optional) TRUE/FALSE switch to plot confidence intervals for bias and limits of agreement, default=TRUE
#' @param ciShading (Optional) TRUE/FALSE switch to plot confidence interval shading to plot, default=TRUE
#' @param normalLow (Optional) If there is a normal range, entering a continuous variable will plot a vertical line on the plot to indicate its lower boundary
#' @param normalHigh (Optional) If there is a normal range, entering a continuous variable will plot a vertical line on the plot to indicate its higher boundary
#' @param point_size (Optional) Size of marker for each dot. Default is cex=0.8
#'
#' @importFrom grDevices rgb
#' @importFrom graphics abline mtext par plot rect
#'
#' @examples
#' # Generates two random measurements
#' measurement1 <- rnorm(100)
#' measurement2 <- rnorm(100)
#'
#' # Generates a basic plot
#' # Do note the basic.plot function wasn't meant to be used on it's own
#' # and is generally called via the bland.altman.display.and.draw function
#'
#' # Passes data to the blandr.statistics function to generate Bland-Altman statistics
#' statistics.results <- blandr.statistics( measurement1 , measurement2 )
#' # Passed data to the blandr.plot.limits function to generate plot limits
#' plot.limits <- blandr.plot.limits( statistics.results )
#'
#' # Generates a basic plot, with no optional arguments
#' blandr.basic.plot( statistics.results , plot.limits )
#'
#' # Generates a basic plot, with title changed
#' blandr.basic.plot( statistics.results , plot.limits , plotTitle = 'Bland-Altman example plot' )
#' # Generates a basic plot, with title changed, and confidence intervals off
#' blandr.basic.plot( statistics.results , plot.limits , plotTitle = 'Bland-Altman example plot' ,
#' ciDisplay = FALSE , ciShading = FALSE )
#'
#' @export

blandr.basic.plot <- function(statistics.results, plot.limits, method1name = "Method 1",
    method2name = "Method 2", plotTitle = "Bland-Altman plot for comparison of 2 methods",
    annotate = FALSE, ciDisplay = TRUE, ciShading = TRUE, normalLow = FALSE, normalHigh = FALSE,
    point_size = 0.8) {

    # Plot data
    if (annotate == TRUE) {
        par.default <- par(no.readonly = TRUE)  # Original values
        par(oma = c(1.5, 0, 0, 0))  # 1.5 line2 at the bottom
    }
    plot(statistics.results$differences ~ statistics.results$means, main = plotTitle, xlab = "Means",
        ylab = "Differences", xaxs = "i", xlim = c(plot.limits$x_lower, plot.limits$x_upper),
        ylim = c(plot.limits$y_lower, plot.limits$y_upper), pch = 21, bg = "black", cex = point_size)

    # Drawing mean difference and limit of agreement lines
    ba.lines <- c(-statistics.results$sig.level.convert.to.z, 0, statistics.results$sig.level.convert.to.z)
    abline(h = 0, lty = 1)
    abline(h = statistics.results$bias + ba.lines * statistics.results$biasStdDev, lty = 2)

    # Drawing confidence intervals (OPTIONAL)
    if (ciDisplay == TRUE) {
        abline(h = c(statistics.results$biasUpperCI, statistics.results$biasLowerCI, statistics.results$upperLOA_upperCI,
            statistics.results$upperLOA_lowerCI, statistics.results$lowerLOA_upperCI, statistics.results$lowerLOA_lowerCI),
            lty = 3)
        # Shading areas for 95% confidence intervals (OPTIONAL)
        if (ciShading == TRUE) {
            rect(plot.limits$x_lower, statistics.results$biasLowerCI, plot.limits$x_upper,
                statistics.results$biasUpperCI, border = NA, col = rgb(0, 0, 1, 0.5))
            rect(plot.limits$x_lower, statistics.results$upperLOA_lowerCI, plot.limits$x_upper,
                statistics.results$upperLOA_upperCI, border = NA, col = rgb(0, 1, 0, 0.5))
            rect(plot.limits$x_lower, statistics.results$lowerLOA_lowerCI, plot.limits$x_upper,
                statistics.results$lowerLOA_upperCI, border = NA, col = rgb(1, 0, 0, 0.5))
        }
    }

    if (normalLow != FALSE) {
        abline(v = normalLow, col = 6, lty = 1)
    }

    if (normalHigh != FALSE) {
        abline(v = normalHigh, col = 6, lty = 1)
    }

    # Outer margin legend text (OPTIONAL)
    if (annotate == TRUE) {
        mtext(paste(" Bland-Altman plot for ", method1name, "minus", method2name, "- each plotted point may represent multiple values - with plotted bias, limits of agreement and respective confidence intervals",
            "\n", "In Bland-Altman analyses we want the difference to be as close to 0 as possible with narrow 95% limits of agreement (LOA).",
            "\n", "n =", length(statistics.results$differences), "\n", "Upper 95% LOA (in green) =",
            round(statistics.results$upperLOA, 1), "(95% CI", round(statistics.results$upperLOA_lowerCI,
                2), "-", round(statistics.results$upperLOA_upperCI, 2), ")", "\n", "Mean difference (in blue) =",
            round(statistics.results$bias, 1), "(95% CI", round(statistics.results$biasLowerCI,
                2), "-", round(statistics.results$biasUpperCI, 2), ")", "\n", "Lower 95% LOA (in red) =",
            round(statistics.results$lowerLOA, 1), "(95% CI", round(statistics.results$lowerLOA_lowerCI,
                2), "-", round(statistics.results$lowerLOA_upperCI, 2), ")"), cex = 0.3,
            line = 0, side = SOUTH <- 1, adj = 0, outer = TRUE)
        par(par.default)  # Reset to original values
    }

    # END OF FUNCTION
}
