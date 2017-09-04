#   ____________________________________________________________________________
#   CLUSTER-ANALYSIS                                                        ####

  # opcion de visualizacion de estructura
  options(str = strOptions(vec.len = 2))
  
  # definir local
  Sys.setlocale("LC_TIME", "C")
  
  # cargar funciones
  source('instalar_paquetes.R')
  
  # definir paquetes a utilizar
  pkgs <- c(
    'tidyquant', 'dplyr', 'broom', 'ggplot2', 'purr',
    'stringr', 'data.table', 'timetk', 'cranlogs',
    'timekit', 'sweep', 'forecast', 'geofacet', 'magrittr'
  )
  
  # instalar paquetes necesarios y cargar librerias
  ipak(pkgs)

#   ____________________________________________________________________________
#   LEER DATASET                                                            ####

  # read dataset
  osp <- fread(
    input      = 'osp_materials.csv',
    data.table = FALSE
  ) %>% as.tibble()
  
  
  # borrar objetos innecesarios
  rm(list = setdiff(ls(), 'osp'))