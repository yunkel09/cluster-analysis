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
    'lubridate',         # 
    'dplyr', 
    'ggplot2', 
    'data.table', 
    'magrittr',
    'psych',
    'tidyquant'
  )
  
  # instalar paquetes necesarios y cargar librerias
  ipak(pkgs)

#   ____________________________________________________________________________
#   LEER DATASET                                                            ####

  # read dataset
  fallas <- fread(
    input      = 'fallas.csv',
    data.table = FALSE
  )
  
  
  
##  ............................................................................
##  DATA CARPENTRY                                                          ####

  fallas.1 <- fallas %>%
    mutate_at('zona', as.factor) %>%
    select(-ttk, -fecha) %>%
    filter(duracion > 0, duracion < 5)
  
  

##  ............................................................................
##  SUMMARY                                                                 ####

  summary(fallas.1)
  
  p <- ggplot(fallas.1, aes(x = zona, y = duracion, fill = zona)) 
  
  p + geom_boxplot(size = 1) + 
      theme_classic() +
      labs(title = "Duracion de fallas por zonas de Guatemala", x = "",
       subtitle = "01-Junio-2017 al 31-Agosto-2017", y = 'Horas',
       caption = "CONFIDENCIAL") +
      geom_jitter(width = 0.2) +
      scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9")) +
      theme(legend.position="bottom")
  
  
#   ____________________________________________________________________________
#   PARTITIONING                                                            ####

  # normalizar los datos
  osp_scaled     <- osp
  osp_scaled[-1] <- as.data.frame(scale(osp_scaled[-1]))
  
  # convertir a factor departamento
  osp_scaled$departamento %<>% as.factor
  
##  ............................................................................
##  K-MEANS                                                                 ####
 
  colores <- c('snow3', 'steelblue', 'thistle3', 'yellow1', 'tomato',
               'tan4', 'beige','blueviolet', 'chocolate4', 'cyan2', 'coral2',
               'cadetblue', 'cornsilk4', 'darkgray', 'darkred', 'goldenrod',
               'deeppink', 'gold3', 'red', 'blue', 'yellow', 'green')
  
  pairs.panels(x = osp_scaled[-1], gap = 0, bg = colores[osp_scaled$departamento], pch = 21)
  
  
  
  
  