clc;
clear all;
tic
a=5;
b=10;
c=15;
% Number of runs for each initial mode
total_run = 100;
s = rng;
mu = [10; 5];
sigma = [3, 2; 2, 3];

initial_modes = [a, a; b, b; c, c]; % Three initial modes

% Initialize a cell array to store the mode trajectories for each initial mode
all_mode_trajectories = cell(size(initial_modes, 1), 1);

% Run the algorithm for each initial mode
for mode_idx = 1:size(initial_modes, 1)
    % Initialize mode_trajectories to store the x and y coordinates separately
    mode_trajectories = zeros(total_run, 20000, 2);  % Assume a maximum of 20000 points per run
    actual_counts = zeros(total_run, 1);  % To store the actual number of points collected in each run

    for run_count = 1:total_run
        mode = initial_modes(mode_idx, :)'; % Get the current initial mode
        no_of_samples = 10000;

        samples = mvnrnd(mu, sigma, no_of_samples);

        count = 1;

        % Store the initial mode in the first position
        mode_trajectories(run_count, count, :) = mode;

        % Robins-Monro starts
        for i = 1:no_of_samples
            epsilon_n = 10^5 / (i^(1/5) + 10^5);
            direction = ((3*epsilon_n) / (2 * pi)) * (samples(i, :)' - mode) / ((epsilon_n^2 + norm(mode - samples(i, :)')^2)^2.5);

            mode = mode + (10^4 / (i + 10^4)) * (direction - (1 / (i + 6)^1.5) * mode);

            if i <= 100 || (i > 100 && rem(i, 50) == 0)
                count = count + 1;
                mode_trajectories(run_count, count, :) = mode;
            end
        end

        % Record the actual number of points collected
        actual_counts(run_count) = count;
    end

    % Trim trajectories to the actual number of points collected
    trimmed_trajectories = zeros(total_run, max(actual_counts), 2);
    for run_count = 1:total_run
        trimmed_trajectories(run_count, 1:actual_counts(run_count), :) = mode_trajectories(run_count, 1:actual_counts(run_count), :);
    end

    % Store trajectories for the current initial mode
    all_mode_trajectories{mode_idx} = trimmed_trajectories;
end

% Calculate average mode trajectories for each initial mode
average_trajectories = cell(size(initial_modes, 1), 1);
for mode_idx = 1:size(initial_modes, 1)
    avg_traj = mean(all_mode_trajectories{mode_idx}, 1);
    average_trajectories{mode_idx} = avg_traj;
end

% Create a grid of (x, y) values
x = linspace(0, 16, 100);
y = linspace(0, 16, 100);
[X, Y] = meshgrid(x, y);

% Calculate the bivariate normal distribution at each grid point
Z = mvnpdf([X(:) Y(:)], mu', sigma);
Z = reshape(Z, size(X));

% Plot the contour plot of the bivariate normal distribution
figure;
contour(X, Y, Z, 20); % 20 contour levels
xlabel('$x_n^1$','Interpreter','latex','Fontsize',12,'FontWeight','bold');
ylabel('$x_n^2$','Interpreter','latex','Fontsize',12,'FontWeight','bold');
ax=gca;
ax.FontSize = 24 ;
% title('Bivariate Normal Distribution with Average Trajectories');
colorbar;
clim([0 0.08]);
hold on;

% Overlay the average trajectories for each initial mode with different markers
colors = {'r', 'g', 'b'};
markers = {'p', 's', 'o'};
for mode_idx = 1:size(initial_modes, 1)
    avg_traj = average_trajectories{mode_idx};

    indices = 1:size(avg_traj, 2);  % Use all indices in the second dimension
    x_vals = avg_traj(1, indices, 1);  % This will be 1×N
    y_vals = avg_traj(1, indices, 2);  % This will be 1×N
    plot(x_vals(:), y_vals(:), [colors{mode_idx} markers{mode_idx} '-']);  % Ensure column vectors for plotting
    % indices = [1:100, 101:1:max(actual_counts)]; % First 100 points and every 50th point thereafter

end
legendEntries = {
    sprintf('$(x_0^1,x_0^2) = (%d,%d)$', a, a);
    sprintf('$(x_0^1,x_0^2) = (%d,%d)$', b, b);
    sprintf('$(x_0^1,x_0^2) = (%d,%d)$', c, c);
    };

legendEntryAll = [{'Bivariate Normal Contours'}; legendEntries];  % vertical concatenation

legend(legendEntryAll, 'Interpreter','latex', ...
    'FontSize',16,'FontWeight','bold');


hold off;
lgd.FontName='Times New Roman';
toc
