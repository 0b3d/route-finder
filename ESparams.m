% choose features type
params = struct 
params.features_type = 'ES'
params.dataset = 'wallstreet5k'
params.model = 'v1'
params.tile_test_zoom = 'z18'
params.turns = 'true'
params.probs = 'false'

params.option = [params.features_type, params.turns ,params.probs];
params.ESResultsPath = fullfile('results/ES', params.model, params.tile_test_zoom, params.dataset,[params.option,'.mat'])
params.ESFeaturesPath = fullfile('features/ES',params.model, params.tile_test_zoom, [params.dataset, '.mat'])