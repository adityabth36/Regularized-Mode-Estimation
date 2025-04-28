clc;
clear all;

s = rng;

%rng(s);
for dist = 1:9
    if dist == 1
        pd = makedist('gamma','a',2,'b',5);
    elseif dist == 2
        pd = makedist('Normal','mu',10,'sigma',5);
    elseif dist ==3
        pd = makedist('beta','a',9,'b',2);
    elseif dist == 4
        pd = makedist('weibull','A',1,'B',1);
    elseif  dist == 5
        % pd = makedist('Normal','mu',30,'sigma',20);
        pd = makedist('Lognormal','mu',0,'sigma',0.25);
    elseif dist ==6
        % pd = makedist('gamma','a',11,'b',5);
        pd = makedist('InverseGaussian','mu',2,'lambda',4);
    elseif dist == 7
        % pd = makedist('Normal','mu',50,'sigma',30);
        pd = makedist('Logistic','mu',2,'sigma',4);
    elseif dist == 8
        pd = makedist('Rayleigh','B',15) ;
    else
        pd = makedist('Rician','s',1,'sigma',20);

    end

    total_runs = 100;
    store_modes = zeros(total_runs,1);

    for run = 1:total_runs



        no_of_samples = 100000; %1000 for initial point selection.

        samples = random(pd,no_of_samples,1);
        mode =50;
        % mode = mean(random(pd,1000,1));

        epsilon=1;

        for i = 1:no_of_samples


            % direction=exp(-(mode-samples(i))^2/(2*epsilon^2))*(-1/(epsilon^3*(2*pi)^0.5))*(mode-samples(i));
            direction = (-2*epsilon*(mode-samples(i)))/(pi*(epsilon^2 + (mode-samples(i))^2)^2) ;

            mode = mode + (10^4 /((i)+10^4))*(direction - (0.00001*mode) );

        end

        store_modes(run,1) = mode;

    end

    fprintf('\n %.3f - %.3f \n',mean(store_modes),std(store_modes));
    % fprintf('\n %f \n',mean(store_modes));

end
