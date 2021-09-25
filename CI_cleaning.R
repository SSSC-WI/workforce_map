
# Packages ----------------------------------------------------------------

library(tidyverse)


# Data --------------------------------------------------------------------

f = list.files("data_ci/")
f = f[f != "CI_clean.csv"]

df = lapply(f, function(i){
  print(i)
  date = lubridate::dmy(paste0("15 ",
                        str_sub(i,
                                14,
                                nchar(i) - 4)))
  read_csv(paste0("data_ci/", i)) %>%
    janitor::clean_names() %>%
    filter(service_status == "Active") %>%
    select(client_group, service_type,
           service_postcode, number_staff) %>%
    add_column(date)
}) %>%
  bind_rows()

postcode = read_csv("~/GIS/OS/postcode.csv")


# geo-code ----------------------------------------------------------------

postcode = postcode %>%
  select(postcode = V1, easting = V3, northing = V4) %>%
  mutate(postcode = str_remove_all(postcode, " "))

df1 = df %>%
  mutate(postcode = str_remove_all(service_postcode, " ")) %>%
  left_join(postcode) %>%
  select(-service_postcode)



# IO ----------------------------------------------------------------------

write_csv(df1, "../workforce_map/data/CI_clean.csv")
