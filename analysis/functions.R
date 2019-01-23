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

build_barplot = function(results, running_names, collecting_names) {
  time_running = interval(results$execution_time, .25, .75, .95
                          , c("0-25", "25-75", "75-95", "95-100"))
  time_collencting = interval(results$scavenge_time, .25, .95, .99, collecting_names)
  
  counts <- table(time_collencting, time_running)
  barplot(counts, main="",
          xlab="tempo de execução", ylab="Frequência", col=c("white","gray", "black", "red"),
          names = running_names, legend = rownames(counts))
}

plot_ecdf = function(nocollect, withcollect, limit) {
  ecdf_nocollect = ecdf(nocollect$execution_time)
  ecdf_withcollect = ecdf(withcollect$execution_time)
  
  x_limit = c(0, limit)
  
  plot(ecdf_nocollect, verticals=TRUE, do.points=FALSE
       , main="ECDF", xlab="tempo de execução (ms)"
       , ylab="frequencia", col='blue',
       xlim=x_limit) 
  plot(ecdf_withcollect, verticals=TRUE
       , do.points=FALSE, add=TRUE, col='red',
       xlim=x_limit)
  
  legend("bottomright", 
         legend=c("Não ocorreu coleta", "Ocorreu coleta"),
         col=c("blue", "red"), pch = c(16,16), bty = "n", 
         pt.cex = 1, cex = 1.2, text.col = "black", 
         horiz = F , inset = c(0.1, 0.1))
}

graph_tail <- function(no_collect, with_collect, title, x_limit, annotate_y) {
  cmp <- rbind(
    data.frame("execution_time"=no_collect, Type="Não ocorreu coleta"),
    data.frame("execution_time"=with_collect, Type="Ocorreu coleta")
  )
  no_collect.color <- "blue"
  no_collect.p999 <- quantile(no_collect, 0.9999)
  no_collect.p50 <- quantile(no_collect, 0.5)
  
  with_collect.color <- "red"
  with_collect.p999 <- quantile(with_collect, 0.9999)
  with_collect.p50 <- quantile(with_collect, 0.5)
  
  size = 0.5
  alpha = 0.5
  angle = 90
  p <- ggplot(cmp, aes(execution_time, color=Type)) +
    stat_ecdf(size=size) +
    # P50
    annotate(geom="text", x=no_collect.p50, y=annotate_y, label="Median", angle=angle, color=no_collect.color) +
    geom_vline(xintercept=no_collect.p50, linetype="dotted", size=size, alpha=alpha, color=no_collect.color) +
    annotate(geom="text", x=with_collect.p50, y=annotate_y, label="Median", angle=angle, color=with_collect.color) + 
    geom_vline(xintercept=with_collect.p50, linetype="dotted", size=size, alpha=alpha, color=with_collect.color) +
    
    # P999
    annotate(geom="text", x=no_collect.p999, y=annotate_y, label="99.99th", angle=angle, color=no_collect.color) +
    geom_vline(xintercept=no_collect.p999, linetype="dotted", size=size, alpha=alpha, color=no_collect.color) +
    annotate(geom="text", x=with_collect.p999, y=annotate_y, label="99.99th", angle=angle, color=with_collect.color) + 
    geom_vline(xintercept=with_collect.p999, linetype="dotted", size=size, alpha=alpha, color=with_collect.color) +
    
    #scale_x_continuous(breaks=seq(0, max(cmp$latency), 10)) +
    #coord_cartesian(ylim = c(0.99, 1)) +
    xlim(0, x_limit) +
    theme(legend.position="top") +
    scale_color_manual(breaks = c("Não ocorreu coleta", "Ocorreu coleta"), values=c("blue", "red")) +
    theme_bw() +
    ggtitle(title) +
    xlab("tempo de execução (ms)") +
    ylab("frequência") 
  
  print(p)
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
