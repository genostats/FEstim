#' Wrapper for the package Fantasio
#' 
#' This function is used as a wrapper for the package Fantasio to create segments list and submaps
#' 
#' @param bedmatrix a bed.matrix 
#' @param segments The method to use for submap creation ("Hotspots" or "Distance")
#' @param segment.options a list of arguments to the function that will create the segments list
#' @param n the number of submaps (default is 100)
#' @param n.cores number of cores to use if you want to compute submaps using parellelism (default is 1)
#' @param epsilon genotype error rate (default is 0.001)
#' @param run.proba whether you want to computes HBD, FLOD score and HFLOD score (default is TRUE)  
#' @param recap.by.segments if you want the summary of probabilities by snps or by segments (default is FALSE)
#' @param verbose whether you want informations about computations (default is TRUE)
#' @param HBD.threshold value of the HBD probability threshold used to determine whether a segment is HBD or not (default is 0.5)
#' @param q assumed frequency of the mutation involved in the disease for each individual (default is 0.0001)
#' @param quality minimal quality (in \%) to include an inbred individual into the analysis (default is 95)
#' @param n.consecutive.markers number of consecutive markers with a probability equal or greater to the value of `HBD.threshold`, used to find HBDsegments
#' 
#' 
#' @details This function is a wrapper to make the usage of the package easier. The function calls different functions: 
#' @details The first function, `segmentsListByDistance` or `segmentsListByHotspots`, is used to create a list of segments. 
#' @details The second function, `makeAtlasBySnsp` or `makeAtlasByHotspots`, is used to create submaps.
#' @details Depending on the value of the `segments` argument (Hotspots or Distance), the segments are created based on recombination hotspots,
#'  or based on markers' distance. In the latter case, the submaps are made by picking a random marker in
#'  every segments and going through each segment from left to right using a given step (by default it is 0.5 cM).
#' @details The arguments that can be included in `segment.options` are described in `segmentsListByDistance` and `segmentsListByHotspots`.
#' @details If `recap.by.segments = FALSE`, the quantities such as HBD probabilities, FLOD, HFLOD, 
#'   are recapitulated SNP by SNP, by taking the mean value accross submaps in which the SNP appear. 
#'   If `recap.by.segments = TRUE` (only with `segments = "Hotspots"`), 
#'   these quantities are averaged over all SNPs sampled in a segment.
#'  
#' 
#' @seealso read.bed.matrix
#' @seealso segmentsListByDistance
#' @seealso makeAtlasByDistance
#' @seealso makeAtlasByHotspots
#' @seealso makeAtlasByHotspots
#'
#' @examples
#' #Please refer to vignette 
#'
#' 
#' @export
Fantasio <- function (bedmatrix, segments = c("Hotspots", "Distance"), segment.options,
                      n = 100, n.cores = 1, epsilon = 0.001,
                      run.proba = TRUE, recap.by.segments = FALSE, verbose = TRUE,
                      HBD.threshold = 0.5, q = 1e-04, quality = 95,
                      n.consecutive.markers = 5) {
  segments <- match.arg(segments)
  if (missing(segment.options))
    segment.options <- list()
  if(!("verbose" %in% segment.options))
    segment.options$verbose = FALSE

  if (segments == "Distance" & recap.by.segments) {
    recap.by.segments <- FALSE
    warning("segments = \"Distance\" implies recap.by.segments = FALSE")
  }

  if(n.cores > 1) { # use hack to try avoiding "invalid external pointer" error
    if (segments == "Distance") {
      s <- do.call(segmentsListByDistance, c(bedmatrix = bedmatrix, segment.options))
      h <- makeAtlasByDistance(get(deparse(substitute(bedmatrix))), n, s, n.cores, epsilon)
      h <- festim(h, n.cores = n.cores, verbose = verbose)
      h <- setSummary(h, probs = run.proba, recap.by.segments = recap.by.segments, HBD.threshold = HBD.threshold, 
                      q = q, quality = quality, n.consecutive.markers = n.consecutive.markers)
    } else {
      s <- do.call(segmentsListByHotspots, c(bedmatrix = bedmatrix, segment.options))
      h <- makeAtlasByHotspots(get(deparse(substitute(bedmatrix))), n, s, n.cores, epsilon)
      h <- festim(h, n.cores = n.cores, verbose = verbose)
      h <- setSummary(h, probs = run.proba, recap.by.segments = recap.by.segments, HBD.threshold = HBD.threshold, 
                      q = q, quality = quality, n.consecutive.markers = n.consecutive.markers)
    }
  } else { # don't use hack (it can be problematic when calling Fantasio from other function)
    if (segments == "Distance") {
      s <- do.call(segmentsListByDistance, c(bedmatrix = bedmatrix, segment.options))
      h <- makeAtlasByDistance(bedmatrix, n, s, n.cores, epsilon)
      h <- festim(h, n.cores = n.cores, verbose = verbose)
      h <- setSummary(h, probs = run.proba, recap.by.segments = recap.by.segments, HBD.threshold = HBD.threshold, 
                      q = q, quality = quality, n.consecutive.markers = n.consecutive.markers)
    } else {
      s <- do.call(segmentsListByHotspots, c(bedmatrix = bedmatrix, segment.options))
      h <- makeAtlasByHotspots(bedmatrix, n, s, n.cores, epsilon)
      h <- festim(h, n.cores = n.cores, verbose = verbose)
      h <- setSummary(h, probs = run.proba, recap.by.segments = recap.by.segments, HBD.threshold = HBD.threshold, 
                      q = q, quality = quality, n.consecutive.markers = n.consecutive.markers)
    }
  }
  h
}
