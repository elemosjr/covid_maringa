import requests
import time
import re
import os
import pandas as pd
from selenium import webdriver
from selenium.webdriver.firefox.options import Options

def get_num(text):
  num = re.findall("\d", text)
  return(int("".join(num)))

#url = "https://notificasaude.com.br/"
url = "http://www2.maringa.pr.gov.br/notificasaude"

options = Options()
options.headless = True
options.accept_insecure_certs = True
print("options set.")

#options = FirefoxOptions()
#options.add_argument("--headless")

driver = webdriver.Firefox(options = options)
driver.set_window_size(1920, 2000)
print("setup driver.")

driver.get(url)
print("driver: get url")

time.sleep(3)

#data = re.sub(" ", "", re.search("^.* ", driver.find_element_by_css_selector("#card-confirm-data").text).group())
data = re.sub(" ", "", re.search("^.* ", driver.find_element_by_css_selector(".dthora-valor").text).group())
print("find 'data'")

#confirmados = get_num(driver.find_element_by_css_selector("#card-posit p").text)
confirmados = get_num(driver.find_element_by_css_selector(".total-confirmados").text)
print("find 'confirmados'")

#ativos = get_num(driver.find_element_by_css_selector("#card-tratam").text)
#print("find 'ativos'")

#recuperados = get_num(driver.find_element_by_css_selector("#card-curado").text)
recuperados = get_num(driver.find_element_by_css_selector(".total-recuperados").text)
print("find 'recuperados'")

#obitos = get_num(driver.find_element_by_css_selector("#card-obito").text)
obitos = get_num(driver.find_element_by_css_selector(".total-obitos").text)
print("find 'obitos'")

#novos = get_num(driver.find_element_by_css_selector("#ultimo-confi").text)
novos = get_num(driver.find_element_by_css_selector(".confirmados-valor").text)
print("find 'novos'")

ativos = int(confirmados) - int(obitos) - int(recuperados)

driver.quit()
print("closed driver connection.")

os.remove("geckodriver.log")

dados = pd.read_csv("../data/maringa.csv")
print("read data")

if dados.at[dados.shape[0] - 1, "data"] != data:
  print("data is new, appending")
  dados = dados.append({"data": data, "confirmados": confirmados, "ativos": ativos,
                        "recuperados": recuperados, "obitos": obitos, "novos": novos},
                        ignore_index = True)
  dados.to_csv("../data/maringa.csv", index = False)
else:
  print("data is already available, there's nothing to do.")
