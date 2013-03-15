function queens_dec = binToDec(queens)

    queens_dec = zeros(8,1);

    for i=1:size(queens,1),
        queen = queens(i,:);
        queens_dec(i) = queen(1)*2^2 + queen(2)*2^1 + queen(3)*2^0 + 1;
    end
end