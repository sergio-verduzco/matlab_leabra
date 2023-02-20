# matlab_leabra
### Matlab implementation of the Leabra Algorithm

This document describes a basic implementation of the Leabra algorithms in Matlab. This implementation serves two main purposes. The first is to clarify the specific computations performed by the basic Leabra algorithms as they were in April 2015. A description of these algorithms was available online (https://grey.colorado.edu/emergent/index.php/Leabra), but was insufficient to reproduce the computations done by the C++ Emergent implementation. The source code of the Emergent implementation is massive, so extracting its algorithms is not a trivial task. The [R implementation of Leabra](https://cran.r-project.org/web/packages/leabRa/vignettes/leabRa.html) (known as LeabRa) is a reproduction of the `matlab_leabra` codebase.

The second purpose of this Leabra implementation is to allow any adept Matlab user to test and modify the Leabra algorithms. To this end, the implementation has been kept as simple as possible. Emergent is a very large, very flexible program that wants to do everything for you. This Matlab implementation is small, and you have to do everything yourself. This gives even more power, flexibility, and understanding, at the expense of having to do more work, risking bugs, and slower run times. Also, this means that people who are not comfortable with Matlab programming could run into trouble.

For the more recent Go implementation of the Leabra Algorithm see: https://github.com/ccnlab/leabrax
