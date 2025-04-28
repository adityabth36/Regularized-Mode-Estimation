  % clc;
close all;
s = rng;

%rng(s);
for dist = 1:6
    if dist == 1
        pd = makedist('Normal','mu',30,'sigma',5);    
    elseif dist ==2
        pd = makedist('Normal','mu',30,'sigma',20);   
    elseif dist == 3
         pd = makedist('Rayleigh','B',100) ;
    elseif dist ==4
        pd = makedist('gamma','a',2,'b',50);
    elseif dist == 5
        pd = makedist('Rician','s',10,'sigma',50);
    else
        pd = makedist('Lognormal','mu',5,'sigma',1);
    end
for k=1:3  % run for k=1 PIM, k=2 CCIM, k=3 RIM
    total_runs = 100;
    store_modes = zeros(total_runs,1);
    store_size = zeros(total_runs,1);
    % store_modes_value=zeros(total_runs,1);


    for run = 1:total_runs

        no_of_samples = 1000000+1000; %1000 for initial point selection.

        samples = random(pd,no_of_samples,1);
        % samples_1 = random(pd,no_of_samples,1);
          
           mode = mean(samples(1000001:1001000));
          
           y_n_1 = 0;

        

        for i = 1:no_of_samples-1000
             switch k 
                 case 1
            epsilon =10^5/(i^(1/4)+10^5) ;
            epsilon_1 =1/(i^(1/2)+1) ;
             direction_1 = (epsilon_1/pi)*(1/(epsilon_1^2+(mode-samples(i))^2));
           
            % direction=exp(-(mode-samples(i))^2/(2*epsilon^2))*(-1/(epsilon^3*(2*pi)^0.5))*(mode-samples(i));
            direction = (-2*epsilon*(mode-samples(i)))/(pi*(epsilon^2 + (mode-samples(i))^2)^2) ;
            if dist == 1 && dist  == 2
           mode = mode + (10^4 /((i)+10^4))*(direction -(1/(i+1000)^1.5)*mode  );
            elseif dist == 3
              mode = mode + (10^4 /((i)+10^4))*(direction -(1/(i+60)^1.5)*mode  );  
            elseif dist == 4
                mode = mode + (10^4 /((i)+10^4))*(direction -(1/(i+8)^1.5)*mode  );
            elseif dist == 5
                mode = mode + (10^4 /((i)+10^4))*(direction -(1/(i+50)^1.5)*mode  );
            else
                mode = mode + (10^4 /((i)+10^4))*(direction -(1/(i+400)^1.1)*mode  );
            end
          y_n_1 = y_n_1 + (10 /((i)^(1)+10))*(direction_1 - y_n_1) ;
                 case 2
                  epsilon =10^5/(i^(1/4)+10^5) ;
            epsilon_1 =1/(i^(1/2)+1) ;
             direction_1 = (epsilon_1/pi)*(1/(epsilon_1^2+(mode-samples(i))^2));
           
            % direction=exp(-(mode-samples(i))^2/(2*epsilon^2))*(-1/(epsilon^3*(2*pi)^0.5))*(mode-samples(i));
            direction = (-2*epsilon*(mode-samples(i)))/(pi*(epsilon^2 + (mode-samples(i))^2)^2) ;
           mode = mode + (10^4 /((i)+10^4))*(direction);
           y_n_1 = y_n_1 + (10 /((i)^(1)+10))*(direction_1 - y_n_1) ;   
                 case 3
                   epsilon=1;
                 epsilon_1 =1/(i^(1/2)+1) ;
             direction_1 = (epsilon_1/pi)*(1/(epsilon_1^2+(mode-samples(i))^2));
           
            % direction=exp(-(mode-samples(i))^2/(2*epsilon^2))*(-1/(epsilon^3*(2*pi)^0.5))*(mode-samples(i));
            direction = (-2*epsilon*(mode-samples(i)))/(pi*(epsilon^2 + (mode-samples(i))^2)^2) ;
           mode = mode + (10^4 /((i)+10^4))*(direction - 0.00001 * mode);
           y_n_1 = y_n_1 + (10 /((i)^(1)+10))*(direction_1 - y_n_1) ; 
             end 

            % store_modes_value(run,1)=y_n_1;

        end
        store_size(run,1) = y_n_1;
        store_modes(run,1) = mode;


    end
    fprintf('\n %.3f - %.3f \n',mean(store_modes),std(store_modes));
    fprintf('\n %.3f - %.3f \n',mean(store_size),std(store_size));
    % fprintf('\n %.3f - %.3f \n',mean(store_modes_value),std(store_modes_value));
    % fprintf('\n %f \n',mean(store_modes));
end
end