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
      geom_jitter(width = 0.2, pch = 16, alpha = 0.5) +
      scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9")) +
      theme(legend.position="bottom")
  
  
#   ____________________________________________________________________________
#   PARTITIONING                                                            ####

  # normalizar los datos
  fallas_scaled      <- fallas.1
  fallas_scaled[-1] <- as.data.frame(scale(fallas_scaled[-1]))
  
##  ............................................................................
##  K-MEANS                                                                 ####
 
  colores <- c('steelblue', 'yellow1', 'tomato')
  
  pairs.panels(x   = fallas_scaled[-1],
               gap = 0, 
               bg  = colores[fallas_scaled$zona],
               pch = 21, hist.col = 'gold1')
  
  # notas: observamos una alta correlacion entre
  
  
  # distance matrix
  distance <- dist(fallas_scaled[-1])
  print(distance, digits = 2)  
  
  