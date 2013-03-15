function fitness = fitnessFunc(queens)

    warning ("off", "Octave:divide-by-zero");

    % counts number of intesections in x-axis
    num_unique_queens = size(unique(queens, "rows"),1);
    num_non_unique = 8 - num_unique_queens;
    x_intersections = num_non_unique;

    % counts number of diagonal intersections
    queens_dec = binToDec(queens);
    diagonal_intersections = 0;
    for i=1:size(queens_dec,1),
        for j=1:size(queens_dec,1),
            slope = (i-j) / (queens_dec(i) - queens_dec(j));
            if abs(slope) == 1,
                diagonal_intersections++;
            end
        end
    end
    diagonal_intersections = diagonal_intersections / 2;

    fitness = x_intersections + diagonal_intersections;

end