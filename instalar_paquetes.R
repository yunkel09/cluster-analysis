
# Instalar paquetes
ipak <- function(pkgs){
    new.pkgs <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
    if (length(new.pkgs)) 
        install.packages(new.pkgs, dependencies = TRUE)
    sapply(pkgs, require, character.only = TRUE)
}     