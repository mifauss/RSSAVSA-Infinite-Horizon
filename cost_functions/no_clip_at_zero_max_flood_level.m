function gx = no_clip_at_zero_max_flood_level(x, scenario) 

if scenario.dim == 1
    gx = max(x - scenario.K_max); 
else 
    gx = max(x - scenario.K_max',[],2);
end