% compare route accuracy
clear all
load('route_accuracy_v2.mat','p_bit');
p_bit_v2 = p_bit;
load('route_accuracy.mat','p_bit');

load('failed_estimated_route_v2.mat','failed_estimated_routes');
failed_estimated_routes_v2 = failed_estimated_routes;
load('failed_estimated_route.mat','failed_estimated_routes');

