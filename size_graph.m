clc;
clear all;

% Set the random seed
s = rng();
% Simulation parameters
total_run = 100;
no_of_samples = 100000;

% Define the probability distribution
pd_1 = makedist('Normal','mu',20,'sigma',5);
pd_2 = makedist('beta','a',9,'b',6);
pd_3 = makedist('Lognormal','mu',0,'sigma',0.25);
dist = [pd_1,pd_2,pd_3] ;
% % distname = {'Normal','beta','Lognormal'};
% distsize = [1.879,3.118,1.646];
figure; % Create a new figure
hold on; % Hold on to add multiple plots to the same figure
style = ["-", "-", "-.", "--", "--.", "."];
legendEntries = {};  % Initialize an empty cell array for legend labels
plotHandles = [];
h_dummy = plot(nan, nan, 'w'); % Invisible line (white on white)
legendEntries{end+1} = 'Normal(20,5),$(x_0,\mu_0)=(40,0)$, Actual Size = 0.0797';
for j = 1:1  % for different distribution
    for p =1:2   % for different method
        % Initialize storage for averaged trajectories
        mode_trajectories = zeros(total_run, no_of_samples);
        mu_trajectories = zeros(total_run, no_of_samples);
        % Run the algorithm 100 times for each method
        for run = 1:total_run
            samples = random(dist(j), no_of_samples, 1);

            mode = 40;
            mu = 0;
            count = 2;
            q =1 ;
            % Store the initial mode in the first position
            mode_trajectories(run, 1) = mode;
            mu_trajectories(run, 1) = mu;

            % Iterative update over samples
            for i = 1:no_of_samples
                epsilon   = 10^5 / (i^0.25 + 10^5);
                epsilon_1 = 1 / (i^(1/2) + 1);

                % Compute direction terms
                direction_1 = (epsilon_1 / pi) * (1 / (epsilon_1^2 + (mode - samples(i))^2));
                direction   = (-2 * epsilon * (mode - samples(i))) / (pi * (epsilon^2 + (mode - samples(i))^2)^2);

                % Update equations for mode and size
                if p == 1
                    mode   = mode + (10^4 / (i + 10^4)) * (direction - (1 / (i + 6)^1.5) * mode);
                    mu  = mu + (10 / (i + 10)) * (direction_1 - mu);
                else
                    mode   = mode + (10^4 / (i + 10^4)) * (direction);
                    mu  = mu + (10 / (i + 10)) * (direction_1 - mu);
                end
                % Store trajectory
                if i > 1 && rem(i, q) == 0
                    mode_trajectories(run, count) = mode;
                    mu_trajectories(run, count) = mu;
                    count = count + 1;
                end

            end
        end
        % Calculate average mode trajectories
        average_mode_trajectories = mean(mode_trajectories, 1);
        average_mu_trajectories = mean(mu_trajectories, 1);
        % Plot the average trajectories
        x_val = 1:10:no_of_samples ;
        % Plotting
        switch j
            case 1
                plot(x_val,average_mu_trajectories(1, x_val), style(p), 'LineWidth', 2.5);
            case 2
                plot(x_val,average_mu_trajectories(1, x_val), style(p + 2), 'LineWidth', 2.5);
            case 3
                plot(x_val,average_mu_trajectories(1, x_val), style(p + 4), 'LineWidth', 2.5);
        end
        % Add corresponding legend entry
        switch p
            case 1
                % legendEntries{end+1} = sprintf('Algorithm-%d ', p, distname{j},distsize(j));
                legendEntries{end+1} = sprintf('Algorithm-%d ', p);
            case 2
                legendEntries{end+1} = sprintf('CCIM');
        end
    end
end
xlabel('Number of Iterations','Interpreter','latex','Fontsize',12,'FontWeight','bold')
ylabel('$\mu_{n}$','Interpreter','latex','Fontsize',12,'FontWeight','bold')
ax = gca;
ax.FontSize = 24;
ax.Box = 'on'; % Ensure the box is on
legendEntryAll = [{'Normal(20,5), Actual Size = 0.0797'}, legendEntries];
legend(legendEntries, 'Location', 'northwest', 'Interpreter','latex','FontSize',16,'FontWeight','bold');
lgd = legend;

lgd.FontName = 'Times New Roman';
ylim([-0.01 0.5]);
% yline(3.1189,'b--','LineWidth',1)

hold off;
