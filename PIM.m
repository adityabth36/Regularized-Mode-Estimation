 clc;
clear all;

s = rng;

%rng(s);
for dist = 1:8
    if dist == 1
        pd = makedist('Normal','mu',10,'sigma',5);
    elseif dist == 2
        pd = makedist('gamma','a',2,'b',5);
    elseif dist ==3
        pd = makedist('beta','a',9,'b',2);
    elseif dist == 4
       pd = makedist('Lognormal','mu',0,'sigma',0.25);
    elseif  dist == 5
         pd = makedist('InverseGaussian','mu',2,'lambda',4);
    elseif dist ==6
           pd = makedist('Logistic','mu',2,'sigma',4);
    elseif dist == 7
            pd = makedist('Rayleigh','B',15) ;
    else
       pd = makedist('Rician','s',1,'sigma',20);
    end

    total_runs = 100;
    store_modes = zeros(total_runs,1);

    %s = rng;

    %rng(s);

    for run = 1:total_runs



        no_of_samples = 100000 ; %1000 for initial point selection.
        samples = random(pd,no_of_samples,1);
                mode =0;
              


        for i = 1:no_of_samples
         
 
            epsilon_n =10^5/(i^(1/4)+10^5) ;

             direction=((2*epsilon_n)/pi)*(samples(i)-mode)/((epsilon_n^2+(mode-samples(i))^2)^2); %cauchy kernel
            % direction = (1/sqrt(2*pi))*(1/epsilon_n)^3 *(samples(i)-mode)*(exp(-0.5*((mode-samples(i))/epsilon_n)^2)); %gaussian kernel
            mode = mode + (10^4 /((i)+10^4))*(direction - (1/(i+1)^1.5)*mode);

        end

        store_modes(run,1) = mode;

    end

    fprintf('\n %.3f - %.3f \n',mean(store_modes),std(store_modes));
    % fprintf('\n %f \n',mean(store_modes));

end

