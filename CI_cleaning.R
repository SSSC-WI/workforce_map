df = read_csv("../workforce_map/data/MDSF_data_22 March 2021.csv") %>%
  select(CSNumber, CareService, Subtype, ServiceType, Service_Postcode,
         ServiceStatus, TotalBeds, NumberStaff, Registered_Places, Client_group)

postcode = read_csv("~/GIS/OS/postcode.csv")


# geo-code ----------------------------------------------------------------

postcode = postcode %>%
  select(postcode = V1, easting = V3, northing = V4) %>%
  mutate(postcode = str_remove_all(postcode, " "))

df1 = df %>%
  mutate(postcode = str_remove_all(Service_Postcode, " ")) %>%
  left_join(postcode) %>%
  select(-Service_Postcode)



# IO ----------------------------------------------------------------------

write_csv(df1, "../workforce_map/data/CI_clean.csv")
