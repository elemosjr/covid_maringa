library(tidyverse)

Sys.setlocale("LC_TIME", "pt_BR.UTF-8")

dados <- read_csv("../data/maringa.csv")

dados1 <- dados %>%                                                            
  separate(data, c("dia", "mes", "ano"), "/") %>%
  mutate(novos_obitos = obitos - lag(obitos, default = 0)) %>%
  group_by(ano, mes) %>%
  summarize(novos_obitos = sum(novos_obitos)) %>% unite("data", mes:ano, sep = "/") %>% mutate(data = lubridate::dmy(paste0("1/", data))) 

dados1 %>%
  ggplot(aes(x = data, y = novos_obitos)) +
  geom_col() +
  geom_label(aes(label = novos_obitos), nudge_y = 5) +
  labs(x = "Data (Mês)", y = "Novos Obitos",
       title = "Obitos por COVID-19 em Maringá por mês",
       caption = "Fonte: Prefeitura de Maringá") +
  scale_x_date(breaks = dados1$data,
               labels = format(dados1$data, format = "%b-%y")) +
  theme(axis.text.x = element_text(angle = 10))

ggsave("temp.png")
