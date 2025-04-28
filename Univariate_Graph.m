
clc;
close all;
total_run = 100;
s = rng;
a=40;
b=60;
initial_modes = [a; b];
for k = 1 :2
    figure; % Create a new figure
    hold on; % Hold on to add multiple plots to the same figure

    style=["-",":","-.","--.","--","."];

    for q=1:3
        for p = 1:2
            mode_trajectories = zeros(total_run, 100000); % Adjusted to match the plotting range

            % Run the algorithm 100 times for each initial mode
            for run_count = 1:total_run
                mode = initial_modes(p); % Get the current initial mode
                no_of_samples = 100000; % Total number of samples

                %choose the distribution
                switch k
                    case 1
                        pd = makedist('Normal', 'mu', 20, 'sigma', 5);
                    case 2
                        pd = makedist('gamma','a',4,'b',5);
                        % pd = makedist('Logistic','mu',10,'sigma',4);
                end
                samples = random(pd, no_of_samples, 1);  % Generate sample from distribution
                epsilon = 1.0;   %parameter for PIM
                count = 2;
                j = 1;

                % Store the initial mode in the first position
                mode_trajectories(run_count, 1) = mode;

                % Robins-Monro starts
                for i = 1:no_of_samples
                    epsilon_n = 10^5 / (i^0.25 + 10^5);
                    % direction = (1/sqrt(2*pi))*(1/epsilon_n)^3 *(samples(i)-mode)*(exp(-0.5*((mode-samples(i))/epsilon_n)^2)); %gaussian kernel
                    % direction_1 = (1/sqrt(2*pi))*(1/epsilon)^3 *(samples(i)-mode)*(exp(-0.5*((mode-samples(i))/epsilon)^2));    %gaussian kernel

                    direction = ((2*epsilon_n) / (pi)) * (samples(i) - mode) / ((epsilon_n^2 + (mode - samples(i))^2)^2);  %cauchy kernel

                    direction_1 = ((2*epsilon) / (pi)) * (samples(i) - mode) / ((epsilon^2 + (mode - samples(i))^2)^2);     %cauchy kernel
                    if q ==1

                        mode = mode + (10^4 / (i + 10^4)) * (direction - (1 / (i + 6)^1.5) * mode);
                    elseif q == 2
                        mode = mode + (10^4 / (i + 10^4)) * (direction_1 - 0.00001 * mode);
                    else
                        mode = mode + (10^4 / (i + 10^4)) * (direction);
                    end
                    if i > 1 && rem(i, j) == 0
                        mode_trajectories(run_count, count) = mode;
                        count = count + 1;
                    end
                end
            end

            % Calculate average mode trajectories
            average_trajectories = mean(mode_trajectories, 1);
            switch k
                case 1
                    no_of_itr =7000;
                case 2
                    no_of_itr =30000;
            end
            % Plot the average trajectories
            if q==1
                plot(average_trajectories(1, 1:no_of_itr),style(p), 'LineWidth', 2.5)
            elseif q == 2
                plot(average_trajectories(1, 1:no_of_itr),style(p+3), 'LineWidth', 2.5)
            else
                plot(average_trajectories(1, 1:no_of_itr),style(p+3), 'LineWidth', 2.5)
            end

        end
    end

    xlabel('Number of Iterations','Interpreter','latex','Fontsize',12,'FontWeight','bold')
    ylabel('$x_{n}$','Interpreter','latex','Fontsize',12,'FontWeight','bold')

    ax = gca;
    ax.FontSize = 24;
    ax.Box = 'on'; % Ensure the box is on

    legendEntries = {
        sprintf('PIM $x_0$ = %d', a),
        sprintf('PIM $x_0$ = %d', b),
        sprintf('RIM $x_0$ = %d', a),
        sprintf('RIM $x_0$ = %d', b)
        sprintf('CIM $x_0$ = %d', a),
        sprintf('CIM $x_0$ = %d', b)
        };
    legend(legendEntries, 'Location', 'northeast', 'Interpreter','latex','Fontsize',16,'FontWeight','bold');
    hold off;
    lgd.FontName='Times New Roman';
    ylim([0,80]);
end