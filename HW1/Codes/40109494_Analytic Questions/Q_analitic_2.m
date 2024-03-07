clc
clear
% Define a known matrix B
B = [80 0   0  0;
     0  0.0001   0  0;
     0  0  0.1 0;
     0  0   0  6];

% Check if B is positive definite
if ispd(B)
    % Perform Cholesky decomposition
    C = chol(B, 'upper');

    % Reconstruct A
    A = C';

    % Display the result
    disp('Matrix A:');
    disp(A);
else
    disp('Error: B is not positive definite.');
end

% Function to check positive definiteness
function pd = ispd(X)
    pd = all(eig(X) > 0);
end