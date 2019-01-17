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

quantile_wrapped = function(data) {
  quantile(data, c(.0, .25, .50, .75, .90, .95, .99, .999, .9999, .99999, 1))
}

quantile_wrapped_for_execution_time = function(data) {
  quantile_wrapped(data$execution_time)
}