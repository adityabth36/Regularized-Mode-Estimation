clc;
clear all
close all;
total_run = 100;
s = rng;
a=0;
b=0;
initial_modes = [a; b];


 pd = makedist('Normal', 'mu', 20, 'sigma', 5);
% for k = 1 :1
   figure; % Create a new figure
    hold on; % Hold on to add multiple plots to the same figure

    % style=["-",":","-.","--.","--","."];
     style=["-","-"];

    for q=1:2
        for p = 1:1
            mode_trajectories = zeros(total_run, 100000); % Adjusted to match the plotting range

            % Run the algorithm 100 times for each initial mode
            for run_count = 1:total_run
                mode = initial_modes(p); % Get the current initial mode
                no_of_samples = 100000; % Total number of samples

                %choose the distribution
                switch q
                    case 1
                       samples_1 = random(pd, no_of_samples, 1);  % Generate sample from distribution
                min_sample = min(samples_1);
               max_sample = max(samples_1);
               samples = (samples_1 - min_sample) / (max_sample - min_sample); % Normalize the samples.
                    case 2
                       samples = random(pd, no_of_samples, 1);  % Generate sample from distribution
                        % pd = makedist('Logistic','mu',10,'sigma',4);
                end
                
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
                    % if q ==1

                        mode = mode + (10^4 / (i + 10^4)) * (direction - (1 / (i + 1)^1.5) * mode);
                 
                    if i > 1 && rem(i, j) == 0
                        mode_trajectories(run_count, count) = mode;
                        count = count + 1;
                    end
                end
                if q==1
                   mode_trajectories(run_count,:)= mode_trajectories(run_count,:)*(max_sample - min_sample)+ min_sample;
                end
            end

            % Calculate average mode trajectories
            average_trajectories = mean(mode_trajectories, 1);
            switch q
                case 1
                    no_of_itr =100000;
                case 2
                    no_of_itr =100000;
            end
            % Plot the average trajectories
            if q==1
                % plot(1:100000,average_trajectories);
                % hold on;
                plot(1:200:no_of_itr,average_trajectories(1, 1:200:no_of_itr),style(q), 'LineWidth', 2.5)
            else 
                plot(average_trajectories(1, 1:no_of_itr),style(q), 'LineWidth', 2.5)
           
            end

        end
    end

    xlabel('Number of Iterations','Interpreter','latex','Fontsize',36,'FontWeight','bold')
    ylabel('$x_{n}$','Interpreter','latex','Fontsize',36,'FontWeight','bold')

    ax = gca;
    ax.FontSize = 36;
    ax.Box = 'on'; % Ensure the box is on

    legendEntries = {
        sprintf('PIM with Normalization and $x_0$ = %d', a),
        sprintf('PIM without Normalization and $x_0$ = %d', a),
        };
    legend(legendEntries, 'Location', 'northeast', 'Interpreter','latex','Fontsize',36,'FontWeight','bold');
    hold off;
    lgd.FontName='Times New Roman';
    ylim([0,100]);

