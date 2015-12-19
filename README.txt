Some test for playing around with Dual Tree Complex Wavelet Transform (DTCWT)

1. Denoising
To test various 

2. Unwrapping Test
For inputting into LASSO algorithms, need to rasterize the 5D dual tree into a 1D matrix. This script demonstrates the use of the two functions
	a. unwrap_tree -> converts the 5-D tree in cfs after using dddtree2, into a vector
	b. rewrap_tree -> converts the vector back into the tree