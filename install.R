#!/usr/bin/env Rscript
# ============================================================
#  MR Bioinfo Toolkit - 一键安装脚本
#  生信分析 / 孟德尔随机化常用 R 包
#  清单快照: 2026-11-10
#
#  用法:
#    source("install.R")          # 装核心 + 可选
#    或先改下面的开关再 source
# ============================================================

## ------------------------- 开关 -------------------------
INSTALL_CORE      <- TRUE   # 核心组：TwoSampleMR / coloc / ieugwasr 等
INSTALL_OPTIONAL  <- TRUE   # 可选组：各类敏感性分析方法
INSTALL_HEAVY     <- FALSE  # 重量级/易出问题的：MR-PRESSO(Java)、CAUSE、GSMR
GITHUB_PAT        <- Sys.getenv("GITHUB_PAT", "")  # 可选，避免 GitHub 限流

## ----------------------- 环境准备 -----------------------
options(repos = c(CRAN = "https://cloud.r-project.org"))
options(timeout = 600)

if (nzchar(GITHUB_PAT)) {
  Sys.setenv(GITHUB_PAT = GITHUB_PAT)
  message("✓ 已设置 GITHUB_PAT")
}

# 基础工具：优先用 remotes，退回 devtools
if (!requireNamespace("remotes", quietly = TRUE)) {
  if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("remotes")
  }
}
.install_gh <- function(repo, ...) {
  if (requireNamespace("remotes", quietly = TRUE)) {
    remotes::install_github(repo, upgrade = "never", ...)
  } else {
    devtools::install_github(repo, upgrade = "never", ...)
  }
}

.ok    <- character(0)
.fail  <- list()

.record <- function(pkg, ok, err = NULL) {
  if (ok) {
    .ok <<- c(.ok, pkg)
    message(sprintf("  ✓ %s", pkg))
  } else {
    .fail[[pkg]] <<- conditionMessage(err)
    message(sprintf("  ✗ %s  <- %s", pkg, conditionMessage(err)))
  }
}

.try <- function(pkg, expr) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("  · %s 已安装，跳过", pkg))
    .ok <<- c(.ok, pkg)
    return(invisible(TRUE))
  }
  message(sprintf("  → 安装 %s ...", pkg))
  tryCatch({ force(expr); .record(pkg, requireNamespace(pkg, quietly = TRUE)) },
           error = function(e) .record(pkg, FALSE, e))
  invisible(NULL)
}

## ---------------------- 1. CRAN 依赖 ----------------------
message("\n===== [1/4] CRAN 基础依赖 =====")
cran_deps <- c(
  "data.table", "dplyr", "tidyr", "ggplot2", "knitr", "rmarkdown",
  "MASS", "Matrix", "numDeriv", "glmnet", "survey", "metafor",
  "Rcpp", "RcppArmadillo", "jsonlite", "curl", "httr"
)
for (p in cran_deps) {
  .try(p, install.packages(p, dependencies = TRUE))
}

## ---------------------- 2. 核心组 -------------------------
if (INSTALL_CORE) {
  message("\n===== [2/4] 核心 MR 包 =====")

  # ieugwasr 必须在 TwoSampleMR 之前
  .try("ieugwasr",   .install_gh("MRCIEU/ieugwasr"))
  .try("TwoSampleMR", .install_gh("MRCIEU/TwoSampleMR"))
  .try("MRInstruments", .install_gh("MRCIEU/MRInstruments"))

  # CRAN 上的多方法实现
  .try("MendelianRandomization", install.packages("MendelianRandomization"))

  # 共定位
  .try("coloc", install.packages("coloc"))

  # 数据转换
  .try("gwasglue2", .install_gh("MRCIEU/gwasglue2"))
}

## -------------------- 3. 可选：敏感性 ---------------------
if (INSTALL_OPTIONAL) {
  message("\n===== [3/4] 敏感性分析与进阶方法 =====")

  .try("RadialMR", .install_gh("WSpiller/RadialMR"))
  .try("MVMR",     .install_gh("WSpiller/MVMR"))
  .try("RMVMR",    .install_gh("WSpiller/RMVMR"))
  .try("mr.raps",  .install_gh("qingyuanzhao/mr.raps"))
  .try("MRMix",    .install_gh("gqi/MRMix"))
  .try("nlmr",     .install_gh("jrs95/nlmr"))
  .try("MRAPSS",   .install_gh("YangLabHKUST/MR-APSS"))
  .try("mrbma",    .install_gh("mglev1n/mrbma"))
  .try("BWMR",     .install_gh("jiazhao97/BWMR"))
  .try("mrclust",  .install_gh("cnfoley/mrclust"))
  .try("MRBEE",    .install_gh("noahlorinczcomi/MRBEE"))
  .try("mrsensemakr", .install_gh("carloscinelli/mrsensemakr"))
  .try("OneSampleMR", .install_gh("remlapmot/OneSampleMR"))
  .try("pecotmr",  .install_gh("StatFunGen/pecotmr"))
}

## ------------------ 4. 重量级 / 易踩坑 --------------------
if (INSTALL_HEAVY) {
  message("\n===== [4/4] 重量级包（可能失败，需手工处理）=====")

  # --- MR-PRESSO：依赖 Java ---
  java_ok <- tryCatch({
    jd <- system2("java", "-version", stdout = TRUE, stderr = TRUE)
    TRUE
  }, error = function(e) FALSE, warning = function(w) FALSE)

  if (!java_ok) {
    message("  ! 未检测到 java，跳过 MR-PRESSO")
    message("    请先安装 JDK 8+，然后在 R 里执行: R CMD javareconf")
    .fail[["MR-PRESSO"]] <- "缺少 Java 运行环境"
  } else {
    .try("rJava", install.packages("rJava"))
    if (requireNamespace("rJava", quietly = TRUE)) {
      .try("MRPRESSO", .install_gh("rondolab/MR-PRESSO", ref = "HEAD"))
    }
  }

  # --- CAUSE：mixsqp/ashr 版本敏感，锁 v1.2.0 ---
  .try("ashr",  install.packages("ashr"))
  .try("mixsqp", install.packages("mixsqp"))
  .try("cause", .install_gh("jean997/cause", ref = "v1.2.0"))

  # --- GSMR：需外部 GCTA ---
  .try("gsmr2", .install_gh("JianYang-Lab/gsmr2"))
  message("  ! GSMR 还需单独下载 GCTA 并加入 PATH:")
  message("    https://yanglab.westlake.edu.cn/software/gcta/")

  # --- SMR / MR-CUE ---
  .try("MR.CUE", .install_gh("QingCheng0218/MR.CUE"))
}

## ------------------------- 汇总 --------------------------
message("\n================ 安装结果 ================")
message(sprintf("成功: %d 个", length(unique(.ok))))
if (length(.fail) > 0) {
  message(sprintf("失败: %d 个", length(.fail)))
  for (nm in names(.fail)) {
    message(sprintf("  - %-18s %s", nm, .fail[[nm]]))
  }
  message("\n失败项多为外部依赖（Java / GCTA / 版本冲突），")
  message("请对照 README 的「已知安装坑」逐项处理。")
} else {
  message("全部安装成功 🎉")
}

message("\n验证核心包是否可用:")
message('  library(TwoSampleMR); library(coloc); library(ieugwasr)')
