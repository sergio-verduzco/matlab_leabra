% test1.m
% test the initial form of my constructors for the network, layer,and unit
% objects. This isn't supposed to do anything, just call all the functions
% and allow examination of what they do.

dim_lays = {[2 5],[3 3],[5 1]};
is_connected = [0 1 0;
                1 0 1;
                0 1 1];
w0 = cell(3);
w0{1,2} = repmat(2,10,9);  %randi(5,10,9);
w0{2,1} = repmat(1,9,10);  %randi(3,9,10);
%w0{2,3} = repmat(3,9,5);   
w0{2,3} = randi(4,9,5);
w0{3,2} = reshape(1:45,5,9);
w0{3,3} = magic(5);

wt_scale_rel = [2 3 7];

netsy = network(dim_lays,is_connected,w0,wt_scale_rel);

inp1 = ones(10,1); % inputs can be matrices or vectors of the rights size
inp3 = (1:5)';

inputs = {inp1,[],inp3}; % inputs created

netsy.reset; % random values for all activities
netsy.cycle(inputs,1);  % testing cycle function
netsy.cycle(inputs,1);

netsy.layers{1}.units(10).updt_avg_l  % testing avg_l related functions
netsy.layers{1}.units(1).updt_avg_l
netsy.layers{3}.units(1).updt_avg_l
netsy.layers{2}.updt_avg_l
netsy.XCAL_learn