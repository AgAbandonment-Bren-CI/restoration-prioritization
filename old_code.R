# code that wasn't needed anymore in other code
# keeping in case I need it in the future


# read in planning units for SSP1
ssp1_pu <- st_read("data/inputs/ssp1/ssp1_pu.shp") %>% 
  clean_names() %>% 
  
  # only keep select columns of interest
  select(join_count, target_fid, bioma, cd_bioma, shape_area) %>% 
  
  # rename some columns to make later merging easier
  rename(id = target_fid,
         biome_code = cd_bioma,
         biome = bioma) %>%
  
  #remove pus that are located outside Brazil biome boundaries
  filter(join_count != 0)

# read in planning units for SSP2 -------------------------------------------
ssp2_pu <- read_sf("data/inputs/ssp2/ssp2_pu.shp") %>% 
  clean_names() %>% 
  select(join_count, target_fid, bioma, cd_bioma, shape_area) %>% 
  rename(id = target_fid,
         biome_code = cd_bioma,
         biome = bioma) %>%
  filter(join_count != 0)

# read in planning units for SSP3 -------------------------------------------
ssp3_pu <- read_sf("data/inputs/ssp3/ssp3_pu.shp") %>% 
  clean_names() %>% 
  select(join_count, target_fid, bioma, cd_bioma, shape_area) %>% 
  rename(id = target_fid,
         biome_code = cd_bioma,
         biome = bioma) %>%
  filter(join_count != 0)

# read in planning units for SSP4 -------------------------------------------
ssp4_pu <- read_sf("data/inputs/ssp4/ssp4_pu.shp") %>% 
  clean_names() %>% 
  select(join_count, target_fid, bioma, cd_bioma, shape_area) %>% 
  rename(id = target_fid,
         biome_code = cd_bioma,
         biome = bioma) %>%
  filter(join_count != 0)

# read in planning units for SSP5 -------------------------------------------
ssp5_pu <- read_sf("data/inputs/ssp5/ssp5_pu.shp") %>% 
  clean_names() %>% 
  select(join_count, target_fid, bioma, cd_bioma, shape_area) %>% 
  rename(id = target_fid,
         biome_code = cd_bioma,
         biome = bioma) %>%
  filter(join_count != 0)




# select the restoration method and land status you want to use

# Looking at conducting natural regeneration and "unfavorable environmental conditions" (CAD)
costs_filtered <- costs %>% 
  filter(restoration_method == "conducting_natural_regeneration") %>% 
  filter(environmental_conditions == "CAD") %>% 
  select(!c(id, biome))  #remove id and biome columns


# now merge the filtered cost with planning units for each SSP

ssp1_pu_costs <- ssp1_pu %>% 
  full_join(costs_filtered, by = "biome_code") %>%  #merge objects
  relocate(geometry, .after = environmental_conditions)    #moves geometry column to end
#st_drop_geometry()   #may want to just drop geometry altogether? 

ssp2_pu_costs <- ssp2_pu %>% 
  full_join(costs_filtered, by = c("biome_code")) %>% 
  relocate(geometry, .after = environmental_conditions)   

ssp3_pu_costs <- ssp3_pu %>% 
  full_join(costs_filtered, by = c("biome_code")) %>% 
  relocate(geometry, .after = environmental_conditions)  

ssp4_pu_costs <- ssp4_pu %>% 
  full_join(costs_filtered, by = c("biome_code")) %>% 
  relocate(geometry, .after = environmental_conditions) 

ssp5_pu_costs <- ssp5_pu %>% 
  full_join(costs_filtered, by = c("biome_code")) %>% 
  relocate(geometry, .after = environmental_conditions) 










#-------------------------------------------------------------------------------


### Test code

Test code for cropping to one biome and getting problem to run. Delete later
```{r}
#### TEST CODE -------------------------

# create planning units just for amazon
amazon_cost_rast <- crop(biomes_cost_rast, amazon, mask = TRUE, touches = FALSE) #crop to just amazon

ssp1_abandoned_crop_amazon <- crop(ssp1_abandoned_crop, amazon, mask = TRUE, touches = FALSE)

ssp1_pu_amazon <- mask(amazon_cost_rast, ssp1_abandoned_crop_amazon)
#ssp1_pu_amazon <- raster(ssp1_pu_amazon)

# crop biodiv and carbon to amazon
biodiversity_amazon <- crop(biodiversity_brazil, amazon, mask = TRUE, touches = FALSE)
carbon_amazon <- crop(carbon_brazil, amazon, mask = TRUE, touches = FALSE)

# combine features into rasterStack
biodiversity_amazon <- raster(biodiversity_amazon)
carbon_amazon <- raster(carbon_amazon)
feat_amazon <- stack(biodiversity_amazon, carbon_amazon)

# problem
p_test <- problem(ssp1_pu_amazon, feat_amazon) %>% 
  add_min_set_objective() %>% 
  add_relative_targets(0.1) %>% 
  add_gurobi_solver(gap = 0.1)

# solve
s_test <- prioritizr::solve(p_test)

## Still giving error "feature(s) with very high target(s) (> 1e+06), try re-scaling the feature data to avoid numerical issues (e.g., convert units from m^2 to km^2)"
## Amazon still has 8,168,368 cells, so let's try looking at just pampa and see if that's under 1million pu

# create planning units just for pampa
pampa_cost_rast <- crop(biomes_cost_rast, pampa, mask = TRUE, touches = FALSE) #crop to just pampa

ssp1_abandoned_crop_pampa <- crop(ssp1_abandoned_crop, pampa, mask = TRUE, touches = FALSE)

ssp1_pu_pampa <- mask(pampa_cost_rast, ssp1_abandoned_crop_pampa)
ssp1_pu_pampa <- raster(ssp1_pu_pampa)

# crop biodiv and carbon to pampa
biodiversity_pampa <- crop(biodiversity_brazil, pampa, mask = TRUE, touches = FALSE)
carbon_pampa <- crop(carbon_brazil, pampa, mask = TRUE, touches = FALSE)

# combine features into rasterStack
biodiversity_pampa <- raster(biodiversity_pampa)
carbon_pampa <- raster(carbon_pampa)
feat_pampa <- stack(biodiversity_pampa, carbon_pampa)



## Pampa biome has 507,236 pus. Does start to run, but no solutions. 
## Gives "Error in .local(a, b = b, ...) : no solution found (e.g., due to problem infeasibility or time limits)
```
