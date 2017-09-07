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
  
  # notas: observamos una alta correlacion entre bandejas e hilos, seguido de
  # fibra y mufas.  
  
  
  
### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### SAMPLING                                                                ####

  # tomar una muestra
  set.seed(1234)
  
  new <- sample(1:dim(fallas_scaled)[1], 15)
  
  ds <- fallas_scaled[new, ]
  
  # distance matrix
  distance <- dist(ds[-1])
  print(distance, digits = 2)  
  
  
  ## aqui vemos la distancia entre la observacion 94 y la 80.  La observacion
  ## 75 y 76 tienen distancia 0.  El valor por defecto de la funcion 'dist' es
  ## distancia Euclideana.  El objetivo del analisis de conglomerados es agrup-
  ## par aquellas observaciones que tengan una menor distancia entre ellas.
  
  
### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### DENDOGRAMA                                                              ####

  hc <- hclust(distance)
  plot(hc)  
  
  #' Analisis: En el eje Y podemos ver la altura que corresponde a la distancia
  #' entre los puntos.  Cuando dos observaciones estan cercas la una de la otra,
  #' forman un cluster.  Por ejemplo podriamos trazar una linea horizontal en
  #' 0.5 y decir que todas las observaciones debajo de esa linea tienen una 
  #' distancia entre ellas, menor a 0.5.
  
 hcd <- as.dendrogram(hc)
 nodePar <- list(lab.cex = 0.6, pch = c(NA, 19), 
                 cex = 0.7, col = "blue")
 plot(hcd, type = 'rectangle', xlab = 'Height', nodePar = nodePar)
 abline(h = 0.5, lty = 2)  
 