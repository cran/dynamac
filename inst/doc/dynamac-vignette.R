## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(dynamac)
head(ineq)

## -----------------------------------------------------------------------------
library(urca)
ts.plot(ineq$concern)
ts.plot(ineq$incshare10)
ts.plot(ineq$urate)

## -----------------------------------------------------------------------------
summary(ur.df(ineq$concern, type = c("none"), lags = 1))
summary(ur.pp(ineq$concern, type = c("Z-tau"), model = c("constant"), use.lag = 1))
summary(ur.ers(ineq$concern, type = c("DF-GLS"), model = c("constant"), lag.max = 1)) 
summary(ur.kpss(ineq$concern, type = c("mu"), use.lag = 1))

## ----eval = FALSE-------------------------------------------------------------
#  summary(ur.df(diff(ineq$concern), type = c("none"), lags = 1))
#  summary(ur.pp(diff(ineq$concern), type = c("Z-tau"), model = c("constant"), use.lag = 1))
#  summary(ur.ers(diff(ineq$concern), type = c("DF-GLS"), model = c("constant"), lag.max = 1))
#  summary(ur.kpss(diff(ineq$concern), type = c("mu"), use.lag = 1))

## -----------------------------------------------------------------------------
head(ineq$incshare10)
head(lshift(ineq$incshare10, 1))
head(dshift(ineq$incshare10))

## ---- eval = TRUE, error = TRUE-----------------------------------------------
summary(lm(diff(ineq$concern) ~ lshift(ineq$concern, 1) + lshift(ineq$incshare10, 1) + dshift(ineq$incshare10) + dshift(ineq$urate)))

## ---- eval = FALSE------------------------------------------------------------
#  dynardl(concern ~ incshare10 + urate, data = ineq,
#          lags = list("concern" = 1, "incshare10" = 1),
#          diffs = c("incshare10", "urate"),
#          ec = TRUE, simulate = FALSE)

## ---- eval = FALSE------------------------------------------------------------
#  dynardl(concern ~ incshare10 + urate, data = ineq,
#          lags = list("concern" = 1, "incshare10" = 1),
#          diffs = c("incshare10", "urate"),
#          lagdiffs = list("urate" = c(1, 2)),
#          ec = TRUE, simulate = FALSE)

## -----------------------------------------------------------------------------
res1 <- dynardl(concern ~ incshare10 + urate, data = ineq, 
        lags = list("concern" = 1, "incshare10" = 1),
        diffs = c("incshare10", "urate"), 
        ec = TRUE, simulate = FALSE)
summary(res1)

## -----------------------------------------------------------------------------
dynardl.auto.correlated(res1)

## -----------------------------------------------------------------------------
res2 <- dynardl(concern ~ incshare10 + urate, data = ineq, 
        lags = list("concern" = 1, "incshare10" = 1),
        diffs = c("incshare10", "urate"), 
        lagdiffs = list("concern" = 1),
        ec = TRUE, simulate = FALSE)
summary(res2)

## -----------------------------------------------------------------------------
dynardl.auto.correlated(res2)
length(res2$model$residuals)

## -----------------------------------------------------------------------------
coef(res2$model)
# The second coefficient is the LDV, and the last coefficient is also a first lag. So they're both restricted

B <- coef(res2$model)
V <- vcov(res2$model)

# tag restrictions on LDV and l.1.incshare10
R <- matrix(c(0, 1, 0, 0, 0, 0, 
			  0, 0, 0, 0, 0, 1), byrow = T, nrow = 2)
k.plus1 <- sum(R)

# Restriction is that it is equal to 0
q <- 0
fstat <- (1/k.plus1)*t(R%*%B-q)%*%solve(R%*%V%*%t(R))%*%(R%*%B-q)	
fstat

## -----------------------------------------------------------------------------
pssbounds(obs = 47, fstat = 12.20351, tstat = -3.684, case = 3, k = 1)

## -----------------------------------------------------------------------------
pssbounds(res2)

## -----------------------------------------------------------------------------
pssbounds(res2, restriction = TRUE)

## ---- eval = FALSE------------------------------------------------------------
#  res2 <- dynardl(concern ~ incshare10 + urate, data = ineq,
#          lags = list("concern" = 1, "incshare10" = 1),
#          diffs = c("incshare10", "urate"),
#          lagdiffs = list("concern" = 1),
#          ec = TRUE, simulate = FALSE)
#  summary(res2)

## -----------------------------------------------------------------------------
set.seed(020990)
res2 <- dynardl(concern ~ incshare10 + urate, data = ineq, 
        lags = list("concern" = 1, "incshare10" = 1),
        diffs = c("incshare10", "urate"), 
        lagdiffs = list("concern" = 1),
        ec = TRUE, simulate = TRUE,
        shockvar = "incshare10")
summary(res2$model)

## -----------------------------------------------------------------------------
dynardl.simulation.plot(res2, type = "area", response = "levels")

## -----------------------------------------------------------------------------
set.seed(020990)
res3 <- dynardl(concern ~ incshare10 + urate, data = ineq, 
        lags = list("concern" = 1, "incshare10" = 1),
        diffs = c("incshare10", "urate"), 
        lagdiffs = list("concern" = 1),
        ec = TRUE, simulate = TRUE, range = 30,
        shockvar = "incshare10")
dynardl.simulation.plot(res3, type = "area", response = "levels")

## -----------------------------------------------------------------------------
dynardl.simulation.plot(res3, type = "spike", response = "levels")

## -----------------------------------------------------------------------------
res3$model
res3$pssbounds
res3$simulation

## -----------------------------------------------------------------------------
set.seed(020990)
res4 <- dynardl(concern ~ incshare10 + urate, data = ineq, 
        lags = list("concern" = 1, "incshare10" = 1),
        diffs = c("incshare10", "urate"), 
        lagdiffs = list("concern" = 1),
        ec = TRUE, simulate = TRUE, range = 30, sims = 10000,
        shockvar = "incshare10")
dynardl.simulation.plot(res4, type = "spike", response = "levels", bw = TRUE)

## -----------------------------------------------------------------------------
set.seed(020990)
res5 <- dynardl(concern ~ incshare10 + urate, data = ineq, 
        lags = list("concern" = 1, "incshare10" = 1),
        diffs = c("incshare10", "urate"), 
        lagdiffs = list("concern" = 1),
        ec = TRUE, simulate = TRUE, range = 30,
        shockvar = "incshare10", qoi = "median")
dynardl.simulation.plot(res5, type = "area", response = "levels")

## -----------------------------------------------------------------------------
set.seed(020990)
res6 <- dynardl(concern ~ incshare10 + urate, data = ineq, 
        lags = list("concern" = 1, "incshare10" = 1),
        diffs = c("incshare10", "urate"), 
        lagdiffs = list("concern" = 1),
        ec = TRUE, simulate = TRUE, range = 30,
        shockvar = "incshare10", fullsims = TRUE)

par(mfrow = c(2, 3))
dynardl.simulation.plot(res6, type = "area", response = "levels")
dynardl.simulation.plot(res6, type = "area", response = "levels.from.mean")
dynardl.simulation.plot(res6, type = "area", response = "diffs")
dynardl.simulation.plot(res6, type = "area", response = "shock.effect.decay")
dynardl.simulation.plot(res6, type = "area", response = "cumulative.diffs", axes = F)
dynardl.simulation.plot(res6, type = "area", response = "cumulative.abs.diffs")

## -----------------------------------------------------------------------------
dynardl.simulation.plot(res6, response = "shock.effect.decay", start.period = 9)

## -----------------------------------------------------------------------------
dynardl.all.plots(res6)

