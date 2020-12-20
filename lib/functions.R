p_score <- function(seednum){
  set.seed(seednum)
  glm1 <- cv.glmnet(as.matrix(lx), ltr, family = "binomial", alpha = 0)
  
  glm1.fit <- predict(glm1$glmnet.fit, 
                      s = glm1$lambda.min, 
                      newx = as.matrix(lx),
                      type = "response")
  
  set.seed(seednum)
  glm2 <- cv.glmnet(as.matrix(hx), htr, family = "binomial", alpha = 0)
  
  glm2.fit <- predict(glm2$glmnet.fit, 
                      s = glm2$lambda.min, 
                      newx = as.matrix(hx),
                      type = "response")
  
  return(list(l=glm1.fit,h=glm2.fit))
  
}

dist_mat <- function(li){
  glm1.fit <- li$l
  glm2.fit <- li$h
  n1 <- length(glm1.fit)
  dt1 <- matrix(0,nrow = n1, ncol = n1) 
  for (i in 1:(n1-1)){
    dt1[i,i] <- 1
    for (j in (i+1):n1){
      dt1[i,j] <- abs(glm1.fit[i] - glm1.fit[j])
      dt1[j,i] <- dt1[i,j]
    }
  }
  
  
  
  n2 <- length(glm2.fit)
  dt2 <- matrix(0,nrow = n2, ncol = n2) 
  for (i in 1:(n2-1)){
    dt2[i,i] <- 1
    for (j in (i+1):n2){
      dt2[i,j] <- abs(glm2.fit[i] - glm2.fit[j])
      dt2[j,i] <- dt2[i,j]
    }
  }
  
  return(list(lm=dt1,hm=dt2))
  
}

cal_neighbour <- function(index,df,thresh,y,A){
  dt_vec <- df[index,]
  ind_vec <- which(dt_vec<thresh)
  ind_final <- ind_vec[A[index]!=A[ind_vec]]
  
  if (length(ind_final) == 0){
    return(NA)
  }
  else{
    return(list(mean(y[ind_final]),ind_final))
  }
  
}


get_ate_pair <- function(ind){
  dt1 <- dist_mat_list[[ind]]$lm
  a <- as.vector(dt1)
  
  ATE_low <- vector("double")
  pairs_low <- vector("double")
  for (percentage in seq){
    threshold <- quantile(a,percentage)
    
    n1_vec <- 1:nrow(dt1)
    list_1 <- lapply(n1_vec, cal_neighbour, df = dt1, thresh = threshold, y = ly, A = ltr)
    mean_list_1 <- lapply(n1_vec, function(x) unlist(list_1[[x]][1]))
    mean_cal_1 <- unlist(mean_list_1)
    neighbour_list_1 <- lapply(n1_vec, function(x) unlist(list_1[[x]][2]))
    
    df_1 <- (data.frame(Y = ly, A = ltr)
             %>%mutate(ind = row_number())
             %>%mutate(AAA = neighbour_list_1)
             %>%mutate(mean_cal = mean_cal_1)
             %>%filter(!is.na(mean_cal))
             %>%mutate(ATE = (Y-mean_cal)*ifelse(A==0,-1,1))
    )
    
    ATE_low <- append(ATE_low,mean(df_1$ATE))
    pairs_low <- append(pairs_low,sum(!is.na(unlist(neighbour_list_1)))/2)
  }
  
  return(list(ate=ATE_low,pair=pairs_low))
}


get_ate_pair <- function(ind){
  dt2 <- dist_mat_list[[ind]]$hm
  a_h <- as.vector(dt2)
  
  ATE_high <- vector("double")
  pairs_high <- vector("double")
  
  for (percentage in seq){
    threshold <- quantile(a_h,percentage)
    
    n2_vec <- 1:nrow(dt2)
    list_2 <- lapply(n2_vec, cal_neighbour, df = dt2, thresh = threshold, y = hy, A = htr)
    mean_list_2 <- lapply(n2_vec,function(x) unlist(list_2[[x]][1]))
    mean_cal_2 <- unlist(mean_list_2)
    neighbour_list_2 <- lapply(n2_vec,function(x) unlist(list_2[[x]][2]))
    
    df_2 <- (data.frame(Y = hy, A = htr)
             %>%mutate(ind = row_number())
             %>%mutate(AAA = neighbour_list_2)
             %>%mutate(mean_cal = mean_cal_2)
             %>%filter(!is.na(mean_cal))
             %>%mutate(ATE = (Y-mean_cal)*ifelse(A==0,-1,1))
    )
    
    ATE_high <- append(ATE_high,mean(df_2$ATE))
    pairs_high <- append(pairs_high,sum(!is.na(unlist(neighbour_list_2)))/2)
  }
  
  return(list(ate=ATE_high,pair=pairs_high))
}




