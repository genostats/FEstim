#' Class HostspotsMatrix
#'
#' Class \code{HostspotsMatrix} This class is use to create an object that will represent the submap created       
#'
#' @rdname HostspotsMatrix-class
#' @exportClass HostspotsMatrix
#' @slot submap a vector of index
#' @slot ncol number of loci
#' @slot nrow number of individual
#' @slot ped  the first 6 columns of a .ped
#' @slot map  id, chr, distance
#' @slot epsilon value of epsilon = genotyping error rare, to use for computing log emission precalculated at initialisation
#' @slot delta.dist difference of map$distance 
#' @slot log.emiss matrix of log proba emission if statut = 0 or 1(2 nb inds x nb msats) 
#' @slot a value of a estimated by festim
#' @slot f value of f estimated by festim
#' @slot likelihood0 likelihood under H0 (f = 0)
#' @slot likelihood1 likelihood under H1 
#' @slot p.lrt likelihood ratio test
#' @slot HBD.prob proba HBD = 1 ; one individual per column : dim = (nb inds x nb msats)
#' @slot FLOD matrix of FLOD scores dim = (nb inds x nb msats)
setClass("HostspotsMatrix", representation(
       submap = 'numeric'              # vecteur d'indices
), contains = "fMatrix" )

#' Constructor method of HostspotsMatrix.
#'
#' @param .Object the object type
#' @param ncol number of loci
#' @param nrow number of individual
#' @param submap a list of submaps
#' @param ped  the first 6 columns of a .ped
#' @param map  id, chr, distance
#' @param log.emiss matrix of log proba emission if statut = 0 or 1(2 nb inds x nb msats) 
#' @param epsilon value of epsilon = genotyping error rare, to use for computing log emission precalculated at initialisation
setMethod('initialize', signature='HostspotsMatrix', definition=function(.Object, ncol, nrow, submap, ped, map, log.emiss, epsilon = 1e-3) {
  .Object@submap  <-  submap
  callNextMethod(.Object, ncol, nrow, ped, map, log.emiss, epsilon)
})

#' Show method of HostspotsMatrix.
#' 
#' @param object an HostspotsMatrix object
setMethod('show', signature("HostspotsMatrix"), function(object) {
    cat('A HostspotsMatrix with ', nrow(object), ' individual(s) and ', ncol(object), " markers\n")
  }
)


