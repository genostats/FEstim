# a summary for a particular submap because depending on the submap markers differs
summary.submaps <- function(h)
{
  df <- as.data.frame(sapply(h@atlas, function(x) ncol(x)))
  n_submaps <- c()
  for(i in 1:length(h@atlas)) n_submaps <- c(n_submaps, paste("Submap", i))
  rownames(df) <- n_submaps
  colnames(df) <- "number_of_markers_used"
  df
  
  
  #res_HBD <- c()
  #res_FLOD <- c()
  #
  #for (i in 1:ncol(x@HBD.prob))
  #{
  #  res_HBD <- c(res_HBD, mean(x@HBD.prob[,i], na.rm = TRUE))
  #  res_FLOD <- c(res_FLOD, mean(x@FLOD[,i], na.rm = TRUE))
  #}
  #
  #df <- data.frame(
  #  marker           = x@map$id,
  #  chromosom        = x@map$chr,
  #  distance_in_chr  = x@map$distance,
  #  HBD              = res_HBD,
  #  FLOD             = res_FLOD
  #)
}

