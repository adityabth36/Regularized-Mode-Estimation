%% code for Bivariate distribution for the algorithm PIM,RIM and CIM
% This section the code is without normalization

clc;
close all;
s = rng();
no_of_samples = 100000; %1000 for initial point selection.

mu=[20,15]';             % mean vector of bivariate normal distribution
sigma=[3,2;2,3];        % covariance matrix

total_runs = 100;     %Total number of independent runs
store_modes = zeros(total_runs,2);

for j = 1 : 3 % three algorithm PIM,RIM,CIM
    for run = 1:total_runs
         % samples = drchrnd([3 3],no_of_samples+1000);   % Generate sample for Drichlet

         samples = mvnrnd(mu,sigma,no_of_samples);   % Generate sample for Bivariate Normal

         mode=[50,50]';  % Initial Mode
        % mode = mean(samples(no_of_samples+1:no_of_samples+1000));




        for i = 1:no_of_samples
            if j==1
                epsilon_n =10^5/(i^(1/5)+10^5) ;  % parameter in PIM
                direction=((3*epsilon_n)/(2*pi))*(samples(i,:)'-mode)/((epsilon_n^2+norm(mode-samples(i,:)')^2)^2.5);   % Cauchy kernel in two dimensional
                % direction=exp(-norm(mode-samples(i,:)')^2/(2*epsilon_n^2))*(-2/(pi*epsilon_n^4))*(mode-samples(i,:)'); % Gaussian kernel in two dimensional
                mode = mode + (10^4 /((i)+10^4))*(direction - (1/(i+5)^1.5)*mode);
            elseif j==2
                epsilon=1.0;    %Parameter in RIM
                direction=((3*epsilon)/(2*pi))*(samples(i,:)'-mode)/((epsilon^2+norm(mode-samples(i,:)')^2)^2.5);   % Cauchy kernel in two dimensional
                % direction=exp(-norm(mode-samples(i,:)')^2/(2*epsilon^2))*(-2/(pi*epsilon^4))*(mode-samples(i,:)'); % Gaussian kernel in two dimensional
                mode = mode + (10^4 /((i)+10^4))*(direction - (0.00001*mode) );
            else
                epsilon_n =10^5/(i^(1/5)+10^5) ;  % parameter in PIM
                direction=((3*epsilon_n)/(2*pi))*(samples(i,:)'-mode)/((epsilon_n^2+norm(mode-samples(i,:)')^2)^2.5);   % Cauchy kernel in two dimensional
                % direction=exp(-norm(mode-samples(i,:)')^2/(2*epsilon_n^2))*(-2/(pi*epsilon_n^4))*(mode-samples(i,:)'); % Gaussian kernel in two dimensional
                mode = mode + (10^4 /((i)+10^4))*direction ;
            end

        end

        store_modes(run,:) = mode;
        %fprintf('\n %f \n',mode)

    end
    fprintf('\n %.3f ; %.3f \n',mean(store_modes),std(store_modes));
end



%% Same code with normalization of sample
% use the min max normalization for the sample
% normalize_samples = (samples - min_sample) ./ (max_sample - min_sample)
% after using the normalize sample we update the mod using denormalization.

clc;
close all;
tic
s = rng();
no_of_samples = 100000; %1000 for initial point selection.

mu=[10,5]';             % mean vector of bivariate normal distribution
sigma=[3,2;2,3];        % covariance matrix

total_runs = 100;     %Total number of independent runs
store_modes = zeros(total_runs,2);

for j = 1 : 3 % three algorithm PIM,RIM,CIM
    for run = 1:total_runs
        % samples_1 = drchrnd([3 3],no_of_samples);   % Generate sample for Drichlet

        samples_1 = mvnrnd(mu,sigma,no_of_samples);   % Generate sample for Bivariate Normal

        min_sample = min(samples_1);
        max_sample = max(samples_1);
        samples = (samples_1 - min_sample) ./ (max_sample - min_sample); % Normalize the samples.

        mode=[0,0]';  % Initial Mode




        for i = 1:no_of_samples
            if j==1
                epsilon_n =10^5/(i^(1/5)+10^5) ;  % parameter in PIM
                direction=((3*epsilon_n)/(2*pi))*(samples(i,:)'-mode)/((epsilon_n^2+norm(mode-samples(i,:)')^2)^2.5);   % Cauchy kernel in two dimensional
                % direction=exp(-norm(mode-samples(i,:)')^2/(2*epsilon_n^2))*(-2/(pi*epsilon_n^4))*(mode-samples(i,:)'); % Gaussian kernel in two dimensional
                mode = mode + (10^4 /((i)+10^4))*(direction - (1/(i+1)^1.5)*mode);
            elseif j==2
                epsilon=1.0;    %Parameter in RIM
                direction=((3*epsilon)/(2*pi))*(samples(i,:)'-mode)/((epsilon^2+norm(mode-samples(i,:)')^2)^2.5);   % Cauchy kernel in two dimensional
                % direction=exp(-norm(mode-samples(i,:)')^2/(2*epsilon^2))*(-2/(pi*epsilon^4))*(mode-samples(i,:)'); % Gaussian kernel in two dimensional
                mode = mode + (10^4 /((i)+10^4))*(direction - (0.00001*mode) );
            else
                epsilon_n =10^5/(i^(1/5)+10^5) ;  % parameter in PIM
                direction=((3*epsilon_n)/(2*pi))*(samples(i,:)'-mode)/((epsilon_n^2+norm(mode-samples(i,:)')^2)^2.5);   % Cauchy kernel in two dimensional
                % direction=exp(-norm(mode-samples(i,:)')^2/(2*epsilon_n^2))*(-2/(pi*epsilon_n^4))*(mode-samples(i,:)'); % Gaussian kernel in two dimensional
                mode = mode + (10^4 /((i)+10^4))*direction ;
            end

        end
        % Denormalize the final mode to the original scale
        mode = (mode' .* (max_sample - min_sample)) + min_sample;
        store_modes(run,:) = mode;


    end
    % Calculate and display mean and standard deviation
    fprintf('\n Mean: %.3f \n', mean(store_modes));
    fprintf('\n Std: %.3f \n', std(store_modes));


end
toc;
