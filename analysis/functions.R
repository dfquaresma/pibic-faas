interval = function(data, p0, p1, p2, names) {
  p0 = quantile(data, p0)
  p1 = quantile(data, p1)
  p2 = quantile(data, p2)
  p3 = max(results$execution_time)
  
  data[as.numeric(data) <= p0] = p0
  data[as.numeric(data) > p0 & as.numeric(data) <= p1] = p1
  data[as.numeric(data) > p1 & as.numeric(data) <= p2] = p2
  data[as.numeric(data) > p2] = p3
  
  data[data == p0] = names[1]
  data[data == p1] = names[2]
  data[data == p2] = names[3]
  data[data == p3] = names[4]
  
  return(data)
}

plot_ecdf = function(nocollect, withcollect) {
  ecdf_nocollect = ecdf(nocollect$execution_time)
  ecdf_withcollect = ecdf(withcollect$execution_time)
  
  plot(ecdf_nocollect, verticals=TRUE, do.points=FALSE
       , main="ECDF", xlab="tempo de execução (ms)"
       , ylab="frequencia", col='blue',
       xlim=c(0, 100)) 
  plot(ecdf_withcollect, verticals=TRUE
       , do.points=FALSE, add=TRUE, col='red',
       xlim=c(0, 100))
  
  legend("bottomright", 
         legend=c("Não ocorreu coleta", "Ocorreu coleta"),
         col=c("blue", "red"), pch = c(16,16), bty = "n", 
         pt.cex = 1, cex = 1.2, text.col = "black", 
         horiz = F , inset = c(0.1, 0.1))
}

build_barplot = function(results) {
  time_running = interval(results$execution_time, .25, .75, .95
                          , c("06 ms", "06-07 ms", "07-14 ms", "14-181 ms"))
  time_collencting = interval(results$scavenge_time, .25, .99, .99
                              , c("0 ms collecting", "1-2 ms collecting"
                                  , "2-18 ms collecting", "2-18 ms collecting"))
  
  counts <- table(time_collencting, time_running)
  barplot(counts, main="",
          xlab="tempo de execução", ylab="Frequência", col=c("white","gray", "black"),
          names = c("6 ms", "6-7 ms", "7-14 ms", "14-181 ms"), legend = rownames(counts))
}

meanVarSd = function(nocollect, withcollect) {
  
  noCollect = c(mean(nocollect$execution_time),
                var(nocollect$execution_time),
                sd(nocollect$execution_time))
  
  withCollect = c(mean(withcollect$execution_time),
                  var(withcollect$execution_time),
                  sd(withcollect$execution_time))
  
  data.frame(
    statistic = c("mean", "var", "sd"), 
    noCollect = noCollect, 
    withCollect = withCollect,
    comparison = withCollect / noCollect)
}

coletas_dataframe = function(results) {
  data.frame(
     tipo = c("scavenge (young gen)", 
                      "marksweep (old gen)"),
     coletas = c(sum(results$scavenge_count), 
                sum(results$marksweep_count))
     )
}

cor_dataframe = function(results) {
  data.frame(
    correlacao = c("Tempo de serviço X número de coletas", 
                   "Tempo de serviço X tempo coletando"), 
    valor = c(cor(results$execution_time, results$scavenge_count + results$marksweep_count), 
              cor(results$execution_time, time_collecting))
    )
}

quantile_wrapped = function(data) {
  quantile(data, c(.0, .25, .50, .75, .90, .95, .99, .999, .9999, .99999, 1))
}

quantile_wrapped_for_execution_time = function(data) {
  quantile_wrapped(data$execution_time)
}

quantiles_dataframe_comparison = function(nocollect, withcollect) {
  comparison = (quantile_wrapped_for_execution_time(withcollect) 
                / quantile_wrapped_for_execution_time(nocollect))
  data.frame(
    nocollect = quantile_wrapped_for_execution_time(nocollect),
    withcollect = quantile_wrapped_for_execution_time(withcollect),
    comparison = comparison
  )
}

