#!/bin/Rscript

library(tidyverse)
library(lubridate)

seila <- function(x)
{
  ret_ <- x - lag(x, default = 0)
  ret_[which(ret_ < 0)] <- 0
  ret_
}

Sys.setlocale("LC_TIME", "pt_BR.UTF-8")

dados <- read_csv("../data/maringa.csv") %>%
  mutate(data = dmy(data))

dados1 <- dados %>%
  mutate(data = as.character(data)) %>%
  separate(data, c("ano", "mes", "dia"), "-") %>%
  mutate(novos_obitos = seila(obitos)) %>%
  group_by(ano, mes) %>%
  summarize(novos_obitos = sum(novos_obitos)) %>%
  unite("data", mes:ano, sep = "/") %>%
  mutate(data = dmy(paste0("1/", data))) 

print(dados1)

dados1 %>%
  ggplot(aes(x = data, y = novos_obitos)) +
  geom_col() +
  geom_label(aes(label = novos_obitos), nudge_y = 5) +
  labs(x = "Data (Mês)", y = "Novos Obitos",
       title = "Obitos por COVID-19 em Maringá por mês"
       #, caption = "Fonte: Prefeitura de Maringá"
       ) +
  scale_x_date(breaks = dados1$data,
               labels = format(dados1$data, format = "%b-%y")) +
  theme(axis.text.x = element_text(angle = 10))
ggsave("temp.png", width = 10, height = 8)


dados %>% mutate(obitos_novos = seila(obitos)) %>%
  ggplot(aes(x = data, y = obitos_novos)) +
  #geom_col(data = dados1, mapping = aes(x = data, y = novos_obitos)) +
  geom_line() +
  scale_x_date(breaks = dados1$data,
               labels = format(dados1$data, format = "%b/%Y")) +
  labs(x = "", y = "Novos Óbitos Diarios")
ggsave("obitosnovos.png", width = 12, height = 4)
