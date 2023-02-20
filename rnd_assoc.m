% rnd_assoc.m
% This program constructs a 3-layer random associator using the 'network', 
% 'layer', and 'unit' objects. It is a test of these clases, and a tutorial
% in how to construct networks with them.

clear;
close all;

tic; % keeping track of how long this takes

%% 1) First, specify the dimensions and connectivity of the layers
%  At this point, layers are either fully connected or unconnected

% 1.1) Set the dimensions of the layers
dim_lays = {[5 5],[8 8],[5 5]}; % specifying 3 layers and their dimensions

% 1.2) Specify connectivity between layers
is_connected = [0 0 0;
                1 0 1;
                0 1 0];
   % is_connected(i,j) = 1 means that layer i receives connections from j
   
%% 2) Now specify the initial weight matrices
n_lays = length(dim_lays);  % number of layers
n_units = zeros(1,n_lays); % number of units in each layer
for i = 1:n_lays
    n_units(i) = dim_lays{i}(1)*dim_lays{i}(2);
end
w0 = cell(3); % this cell will contain all the initial connection matrices
for rcv = 1:n_lays
    for snd = 1:n_lays
        if is_connected(rcv,snd)
            % random initial weights between 0 and 1
            w0{rcv,snd} = rand(n_units(rcv),n_units(snd));
            % notice that the dimensions of the layer don't matter, only
            % the number of units. Layers are 2-dimensional only for
            % purposes of visualization.
        end
    end
end

%% 3) Setup a relative weight scale for the layers
wt_scale_rel = [1 1 .2];
% the larger wt_scale_rel(i) is, the larger the inputs coming from layer i
% will be, relative to those of other layers

%% 4) Create the network using the constructor
net = network(dim_lays, is_connected, w0, wt_scale_rel);

%% 5) Let's create some inputs
n_inputs = 40;  % number of input-output patterns to associate
patterns = cell(n_inputs,2); % patterns{i,1} is the i-th input pattern, and 
                             % patterns{i,2} is the i-th output pattern.
% This will assume that layers 1 and 3 are input and output respectively.
% Patterns will be binary.
prop = 0.3; % the proportion of active units in the patterns
for i = 1:n_inputs
    patterns{i,1} = round(2*prop*rand(1,n_units(1)));  % either 0 or 1
    patterns{i,2} = round(2*prop*rand(1,n_units(3)));
    patterns{i,1} = 0.01 + 0.95*patterns{i,1};  % either 0.01 or 0.96
    patterns{i,2} = 0.01 + 0.95*patterns{i,2};
end
    
%% 6) Train the network

% Specify parameters for training
n_epochs = 80;  % number of epochs. All input patterns are presented in one.
n_trials = n_inputs; % number of trials. One input pattern per trial.
n_minus = 50;  % number of minus cycles per trial.
n_plus = 25; % number of plus cycles per trial.
lrate_sched = linspace(1,0.1,n_epochs); % learning rate schedule

errors = zeros(n_epochs,n_trials); % cosine error for each pattern

for epoch = 1:n_epochs
    order = randperm(n_trials); % order of presentation of inputs this epoch
    net.lrate = lrate_sched(epoch); % learning rate for this epoch
    
    for trial = 1:n_trials
        net.reset;  % randomize the acts for all units
        pat = order(trial);  % input to be presented this trial
        %++++++ MINUS PHASE +++++++
        inputs = {patterns{pat,1},[],[]};
        for minus = 1:n_minus % minus cycles: layer 1 is clamped
            net.cycle(inputs,1);
        end
        outs = net.layers{3}.activities'; % saving the output for testing
        
        %+++++++ PLUS PHASE +++++++
        inputs = {patterns{pat,1},[],patterns{pat,2}};
        for plus = 1:n_plus % plus cycles: layers 1 and 3 are clamped
            net.cycle(inputs,1);
        end
        
        %+++++++ LEARNING +++++++
        net.XCAL_learn; % udates the avg_l vars and applies XCAL learning
        if mod(trial,10) == 0
            disp(['trial ', num2str(trial), ' finished'])
        end
        
        %+++++++ ERRORS +++++++
        errors(epoch,pat) = 1 - sum(outs.*patterns{pat,2}) / ...
                              ( norm(outs)*norm(patterns{pat,2}) );
    end
    net.updt_long_avgs; % update averages used for net input scaling
    disp(['epoch ', num2str(epoch), ' finished']);
end

toc; % elapsed time goes from first tic to this toc

%% 7) Visualize results
mean_errs = mean(errors,2);
figure;
plot(mean_errs);

