#!/usr/bin/env Rscript
# ============================================================
#  MR Bioinfo Toolkit - 一键安装脚本
#  生信分析 / 孟德尔随机化常用 R 包
#  清单快照: 2026-11-10（共 50 个工具 = 43 个 R 包 + 7 个外部工具）
#
#  用法:
#    source("install.R")
#    或先改下面的开关再 source
# ============================================================

## ------------------------- 开关 -------------------------
INSTALL_CORE      <- TRUE   # 核心：TwoSampleMR / coloc / ieugwasr
INSTALL_OPTIONAL  <- TRUE   # 方法学：敏感性分析 / 共定位 / TWAS / 数据 / 出图
INSTALL_HEAVY     <- FALSE  # 重量级易翻车：MR-PRESSO(Java)、CAUSE、GSMR、MR-CUE
GITHUB_PAT        <- Sys.getenv("GITHUB_PAT", "")  # 可选，避免 GitHub 限流

## ----------------------- 环境准备 -----------------------
options(repos = c(CRAN = "https://cloud.r-project.org"))
options(timeout = 600)

if (nzchar(GITHUB_PAT)) {
  Sys.setenv(GITHUB_PAT = GITHUB_PAT)
  message("✓ 已设置 GITHUB_PAT")
}

if (!requireNamespace("remotes", quietly = TRUE)) {
  if (!requireNamespace("devtools", quietly = TRUE)) install.packages("remotes")
}
.install_gh <- function(repo, ...) {
  if (requireNamespace("remotes", quietly = TRUE)) {
    remotes::install_github(repo, upgrade = "never", ...)
  } else {
    devtools::install_github(repo, upgrade = "never", ...)
  }
}

.ok <- character(0); .fail <- list()
.record <- function(pkg, ok, err = NULL) {
  if (ok) { .ok <<- c(.ok, pkg); message(sprintf("  ✓ %s", pkg)) }
  else    { .fail[[pkg]] <<- conditionMessage(err)
            message(sprintf("  ✗ %s  <- %s", pkg, conditionMessage(err))) }
}
.try <- function(pkg, expr) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("  · %s 已安装，跳过", pkg)); .ok <<- c(.ok, pkg); return(invisible(TRUE))
  }
  message(sprintf("  → 安装 %s ...", pkg))
  tryCatch({ force(expr); .record(pkg, requireNamespace(pkg, quietly = TRUE)) },
           error = function(e) .record(pkg, FALSE, e))
  invisible(NULL)
}

## ---------------------- 1. CRAN 依赖 ----------------------
message("\n===== [1/6] CRAN 基础依赖 =====")
for (p in c("data.table","dplyr","tidyr","ggplot2","knitr","rmarkdown",
            "MASS","Matrix","numDeriv","glmnet","survey","metafor",
            "Rcpp","RcppArmadillo","jsonlite","curl","httr")) {
  .try(p, install.packages(p, dependencies = TRUE))
}

## ---------------------- 2. 核心 MR ------------------------
if (INSTALL_CORE) {
  message("\n===== [2/6] 核心 MR 包 =====")
  .try("ieugwasr",      .install_gh("MRCIEU/ieugwasr"))       # 必须早于 TwoSampleMR
  .try("TwoSampleMR",   .install_gh("MRCIEU/TwoSampleMR"))
  .try("MRInstruments", .install_gh("MRCIEU/MRInstruments"))
  .try("MendelianRandomization", install.packages("MendelianRandomization"))

  message("\n----- 共定位（MR 前置验证）-----")
  .try("coloc",  install.packages("coloc"))
  .try("susieR", install.packages("susieR"))   # coloc.susie 依赖

  message("\n----- 数据接口 -----")
  .try("gwasglue2", .install_gh("MRCIEU/gwasglue2"))
}

## -------------------- 3. 敏感性与稳健性 -------------------
if (INSTALL_OPTIONAL) {
  message("\n===== [3/6] 敏感性分析 / 稳健性 =====")
  .try("RadialMR",   .install_gh("WSpiller/RadialMR"))
  .try("MVMR",       .install_gh("WSpiller/MVMR"))
  .try("RMVMR",      .install_gh("WSpiller/RMVMR"))
  .try("mr.raps",    .install_gh("qingyuanzhao/mr.raps"))
  .try("MRMix",      .install_gh("gqi/MRMix"))
  .try("nlmr",       .install_gh("jrs95/nlmr"))
  .try("MRAPSS",     .install_gh("YangLabHKUST/MR-APSS"))
  .try("mrbma",      .install_gh("mglev1n/mrbma"))
  .try("BWMR",       .install_gh("jiazhao97/BWMR"))
  .try("mrclust",    .install_gh("cnfoley/mrclust"))
  .try("MRBEE",      .install_gh("noahlorinczcomi/MRBEE"))
  .try("mrsensemakr",.install_gh("carloscinelli/mrsensemakr"))
  .try("OneSampleMR",.install_gh("remlapmot/OneSampleMR"))
  .try("FLOWMR",     .install_gh("ZixuanWu1/FLOW-MR"))

  message("\n----- 样本重叠 / winner's curse 校正 -----")
  .try("MRlap",           .install_gh("n-mounier/MRlap"))
  .try("GRAPPLE",         .install_gh("jingshuw/GRAPPLE"))
  .try("mrSampleOverlap", .install_gh("mglev1n/mrSampleOverlap"))
  .try("lhcMR",           .install_gh("LizaDarrous/lhcMR"))

  ## ---------------- 4. 共定位 / TWAS / 数据 ----------------
  message("\n===== [4/6] 共定位、数据接口与出图 =====")
  .try("hyprcoloc",  .install_gh("jrs95/hyprcoloc"))
  .try("colocboost", .install_gh("StatFunGen/colocboost"))
  .try("pecotmr",    .install_gh("StatFunGen/pecotmr"))

  .try("gwasvcf",    .install_gh("MRCIEU/gwasvcf"))
  .try("bigsnpr",    install.packages("bigsnpr"))
  .try("gwasrapidd", install.packages("gwasrapidd"))
  .try("PheWAS",     install.packages("PheWAS"))

  .try("CMplot",       install.packages("CMplot"))
  .try("forestploter", install.packages("forestploter"))
  .try("locuszoomr",   install.packages("locuszoomr"))
}

## ------------------ 5. 重量级 / 易踩坑 --------------------
if (INSTALL_HEAVY) {
  message("\n===== [5/6] 重量级包（可能失败，需手工处理）=====")

  # --- MR-PRESSO：依赖 Java ---
  java_ok <- tryCatch({ system2("java", "-version", stdout = TRUE, stderr = TRUE); TRUE },
                      error = function(e) FALSE, warning = function(w) FALSE)
  if (!java_ok) {
    message("  ! 未检测到 java，跳过 MR-PRESSO")
    message("    请先装 JDK 8+，然后在终端执行: R CMD javareconf")
    .fail[["MR-PRESSO"]] <- "缺少 Java 运行环境"
  } else {
    .try("rJava", install.packages("rJava"))
    if (requireNamespace("rJava", quietly = TRUE))
      .try("MRPRESSO", .install_gh("rondolab/MR-PRESSO"))
  }

  # --- CAUSE：mixsqp/ashr 版本敏感，锁 v1.2.0 ---
  .try("ashr",   install.packages("ashr"))
  .try("mixsqp", install.packages("mixsqp"))
  .try("cause",  .install_gh("jean997/cause", ref = "v1.2.0"))

  # --- GSMR：需外部 GCTA ---
  .try("gsmr2", .install_gh("JianYang-Lab/gsmr2"))
  message("  ! GSMR 还需单独下载 GCTA 并加入 PATH:")
  message("    https://yanglab.westlake.edu.cn/software/gcta/")

  # --- 其他方法 ---
  .try("MR.CUE", .install_gh("QingCheng0218/MR.CUE"))
  .try("MR2",    .install_gh("lb664/MR2"))
}

## ------------------- 6. 无法自动安装的 --------------------
message("\n===== [6/6] 需手工安装的工具（不在 R 包体系内）=====")
message("  · FUSION (TWAS)        git clone https://github.com/gusevlab/fusion_twas")
message("  · MetaXcan (TWAS)      Python: pip install metaxcan 或 git clone hakyimlab/MetaXcan")
message("  · PHESANT (pheWAS)     Java 工具: git clone https://github.com/MRCIEU/PHESANT")
message("  · mRnd (功效计算)      无包结构，用在线版 https://cnsgenomics.com/shiny/mRnd/")
message("  · LDSC (遗传相关)      Python: git clone https://github.com/bulik/ldsc")
message("  · PLINK / GCTA         外部可执行文件，需手动下载并加入 PATH")

## ------------------------- 汇总 --------------------------
message("\n================ 安装结果 ================")
message(sprintf("成功: %d 个", length(unique(.ok))))
if (length(.fail) > 0) {
  message(sprintf("失败: %d 个", length(.fail)))
  for (nm in names(.fail)) message(sprintf("  - %-18s %s", nm, .fail[[nm]]))
  message("\n失败项多为外部依赖（Java / GCTA / 版本冲突），")
  message("请对照 README 的「已知安装坑」逐项处理。")
} else {
  message("全部安装成功")
}

message("\n验证核心包:")
message('  library(TwoSampleMR); library(coloc); library(ieugwasr); library(MRlap)')
