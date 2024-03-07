function result = gaussian_function(U, Center, Width)
  
result = ones(size(U, 1), 1);
for i = 1 : size(Center, 2)
    result = result.*gaussmf(U(:, i), [Width(i)/3, Center(i)]);
end