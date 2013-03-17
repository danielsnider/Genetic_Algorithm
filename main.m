runloops = 40000; % number of loops (estimated runtime for 20000 run loops: 10 minutes)
num_queens = 8;
bit_depth = 3;
pop = 6; % must be an even number because a child must have 2 parents
cost = zeros(pop,1);
fitness = zeros(pop,1);
roulette = zeros(pop,1);
crossover_prob = 0.003;
mutation_prob = 0.0001;
child1 = zeros(num_queens,bit_depth);
child2 = zeros(num_queens,bit_depth);
temp = zeros(num_queens,bit_depth);
cost_history = [];

chroms = {round(rand(num_queens,bit_depth)), round(rand(num_queens,bit_depth)), round(rand(num_queens,bit_depth)), round(rand(num_queens,bit_depth)), round(rand(num_queens,bit_depth)), round(rand(num_queens,bit_depth))}; % pop is 6

% chroms = list of 8x3 binary matricies (each row is a queen represented with:
% chroms list index number = Y-coord
% chroms list value (stored in binary 3 bits) = X-coord

for x=1:runloops,

    %%% calc fitness of each chrom (lower is better)
    for i=1:pop,
        cost(i)=fitnessFunc(chroms{i});
        if cost(i)==0,
            binToDec(chroms{i}) % print a solution to puzzle
            return
        end
    end

    % save all fitness values for graphing later
    cost_history = [cost_history; cost];

    %%% calc roulette wheel
    fitness = abs(cost.-max(cost)) + 1; % convert cost to fitness (ie. conversion from lower is better to higher is better)
    roulette_wheel = cumsum(fitness.*(100/sum(fitness)));

    %%% operations to produce next generation (parent selection, crossover, mutation)
    for i=1:pop/2,

        %%% perform parent selection
        found_parent1 = false;
        found_parent2 = false;
        r1 = rand*100;
        r2 = rand*100;

        for j=1:pop,
            if (r1 < roulette_wheel(j)) && (found_parent1 == false),
                found_parent1 = true;
                child1 = chroms{j}; % child selected to move to next generation
            end
            if (r2 < roulette_wheel(j)) && (found_parent2 == false),
                found_parent2 = true;
                child2 = chroms{j}; % child selected to move to next generation
            end
        end

        %%% perform crossover
        crossover=false;
        cross_point=1;

        for j=1:bit_depth,
            if (rand < crossover_prob) && (crossover_prob == false),
                crossover=true;
                cross_point++;
            end
            if (crossover == true),
                temp = child1;
                child1 = child1(:,[1:bit_depth - cross_point]) + child2(:,[cross_point:bit_depth]); % mutation
                child2 = child2(:,[1:bit_depth - cross_point]) + temp(:,[cross_point:bit_depth]); % mutation
            end
        end

        %%% perform mutation
        for j=1:num_queens,
            for h=1:bit_depth,
                if rand < crossover_prob,
                    child1(j,h) = abs(child1(j,h)-1);
                end
                if rand < crossover_prob,
                    child2(j,h) = abs(child2(j,h)-1);
                end
            end
        end


        chroms{i} = child1; % move child to next generation
        chroms{i+(pop/2)} = child2; % move child to next generation
    end
end

xlabel('time')
ylabel('cost')
plot(cost_history)