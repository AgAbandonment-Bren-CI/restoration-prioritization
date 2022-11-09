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