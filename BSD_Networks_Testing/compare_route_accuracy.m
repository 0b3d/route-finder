% compare route accuracy
clear all
dataset = 'unionsquare5k';
load(['results_for_bsd/',dataset,'_route_accuracy_real','.mat'],'p_bit');
p_bit_r = p_bit;
load(['results_for_bsd/',dataset,'_route_accuracy_simulated','.mat'],'p_bit');
p_bit_s = p_bit;
clear p_bit;

load(['results_for_bsd/',dataset,'_failed_routes_real','.mat'],'failed_estimated_routes');
failed_estimated_routes_r = failed_estimated_routes;
load(['results_for_bsd/',dataset,'_failed_routes_simulated','.mat'],'failed_estimated_routes');
failed_estimated_routes_s = failed_estimated_routes;
clear failed_estimated_routes;

