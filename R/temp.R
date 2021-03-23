library(tidyverse)

dados <- read_csv("../data/maringa.csv")

dados %>% 
  separate(data, c("dia", "mes", "ano"), "/") %>%
  mutate(novos_obitos = obitos - lag(obitos, default = 0)) %>%
  group_by(ano, mes) %>%
  summarize(novos_obitos = sum(novos_obitos))
