% clc;
clear all;

rng();
l=50;
%rng(s);
for dist = 1:5
    if dist == 1
        pd = makedist('Normal','mu',l,'sigma',1);
    elseif dist ==2
        pd = makedist('Normal','mu',l,'sigma',3);
    elseif dist == 3
        pd = makedist('Normal','mu',l,'sigma',5);
    elseif dist ==4
        pd = makedist('Normal','mu',l,'sigma',10);
    else
        pd = makedist('Normal','mu',l,'sigma',20);
    end

    total_runs = 100;
    store_modes = zeros(total_runs,1);

    %s = rng;

    %rng(s);

    for run = 1:total_runs

        no_of_samples = 100000 ; %1000 for initial point selection.
        samples_1 = random(pd,no_of_samples,1);
        max_v=max(samples_1);
        min_v=min(samples_1);
        samples=(samples_1-min_v)/(max_v-min_v);

        mode =70;  % Initial mode



        for i = 1:no_of_samples


            epsilon_n =10^5/(i^(1/4)+10^5) ;
            % epsilon_n =1 ;
            direction=(2*epsilon_n/pi)*(samples(i)-mode)/((epsilon_n^2+(mode-samples(i))^2)^2);
            % direction = (1/e_n)^3 * ((exp(-2*((mode-samples(i))/e_n))- exp(-((mode-samples(i))/e_n)))/(1+exp(-((mode-samples(i))/e_n)))^3);
            mode = mode + (10^4 /((i)+10^4))*(direction - (1/(i+1)^1.5)*mode);

        end
        mode=mode*(max_v-min_v)+min_v;
        store_modes(run,1) = mode;

    end

    fprintf('\n %.3f ± %.3f \n',mean(store_modes),std(store_modes));
    % fprintf('\n %f \n',mean(store_modes));

end

