%% code for Bivariate distribution for the algorithm PIM,RIM and CIM


clc;
clear all;
close all;
s = rng();
no_of_samples = 100000; 

mu=[10,5]';             % mean vector of bivariate normal distribution
sigma=[3,2;2,3];        % covariance matrix

total_runs = 100;     %Total number of independent runs
store_modes = zeros(total_runs,2);

for j = 1 : 3 % three algorithm PIM,RIM,CIM
    for run = 1:total_runs
              samples = drchrnd([3 3],no_of_samples);   % Generate sample for Drichlet

             % samples = mvnrnd(mu,sigma,no_of_samples);   % Generate sample for Bivariate Normal

          mode=[5,5]';  % Initial Mode
          % mode = [30,30];

        vv= zeros(no_of_samples,2);

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

        store_modes(run,:) = mode;
        %fprintf('\n %f \n',mode)

    end
    fprintf('\n %.3f , %.3f \n',mean(store_modes),std(store_modes));
end

