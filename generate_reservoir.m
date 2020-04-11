% generates the adjacency matrix of the reservoir
%adjacency matrix remains fixed
function A = generate_reservoir(size, radius, degree)

sparsity = degree/size;

A = sprand(size, size, sparsity);

e = max(abs(eigs(A)));

A = (A./e).*radius;