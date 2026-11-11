# MR Bioinfo Toolkit

生信分析 —— **孟德尔随机化（Mendelian Randomization, MR）** 常用 R 包清单与一键安装脚本。

本项目不做代码搬运，只解决两个实际问题：

1. **哪些包值得用** —— 按功能分类，标注 GitHub 地址、star 数、最后更新时间、维护状态
2. **怎么一次装对** —— MR 生态的安装坑很多（GitHub-only 包、Java 依赖、版本互斥），`install.R` 把顺序和依赖都处理好了

> 清单快照：2026-11-10（star 数与最后提交时间取自 GitHub API 实时查询）

---

## 目录

- [快速开始](#快速开始)
- [一、核心 MR 分析](#一核心-mr-分析)
- [二、敏感性分析与多效性检验](#二敏感性分析与多效性检验)
- [三、多变量 MR 与中介分析](#三多变量-mr-与中介分析)
- [四、共定位与 TWAS](#四共定位与-twas)
- [五、数据获取与工具变量](#五数据获取与工具变量)
- [六、其他主流方法](#六其他主流方法)
- [已知安装坑](#已知安装坑)
- [数据源（非 R 包）](#数据源非-r-包)

---

## 快速开始

```r
# 安装全部（约 15-30 分钟，取决于网络和编译）
source("install.R")

# 或只装核心组（推荐第一次先跑这个）
source("install.R")
# 在脚本里把 INSTALL_OPTIONAL <- FALSE
```

只想要清单数据：见 `packages.csv`，可直接导入表格工具筛选。

---

## 一、核心 MR 分析

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **TwoSampleMR** | [MRCIEU/TwoSampleMR](https://github.com/MRCIEU/TwoSampleMR) | 562 | 2026-11-10 | **事实标准**。两样本 MR 全流程：IVW、MR-Egger、加权中位数、加权模式，含 harmonise 数据对齐与散点/森林/漏斗图 |
| **MendelianRandomization** | [cran/MendelianRandomization](https://github.com/cran/MendelianRandomization) | 46 | 2026-08-07 | CRAN 包镜像。方法覆盖更广（MR-Lasso、众数法、聚类稳健），适合做方法学对比 |
| **OneSampleMR** | [remlapmot/OneSampleMR](https://github.com/remlapmot/OneSampleMR) | 27 | 2026-10-23 | 个体数据（one-sample）MR，两阶段最小二乘及其变体 |

> 只用两样本汇总数据的话，`TwoSampleMR` 一个就够起步，其余按需补。

## 二、敏感性分析与多效性检验

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **MR-PRESSO** | [rondolab/MR-PRESSO](https://github.com/rondolab/MR-PRESSO) | 98 | 2023-07-25 | 水平多效性全局检验 + 离群值检测与校正。**需要 Java（rJava）** |
| **RadialMR** | [WSpiller/RadialMR](https://github.com/WSpiller/RadialMR) | 34 | 2026-10-07 | 径向 MR，把异质性直接可视化到散点图上，离群点一眼可见 |
| **mr.raps** | [qingyuanzhao/mr.raps](https://github.com/qingyuanzhao/mr.raps) | 42 | 2025-10-31 | RAPS 稳健调整轮廓得分，处理有无效工具（InSIDE 不成立）的情形 |
| **MRMix** | [gqi/MRMix](https://github.com/gqi/MRMix) | 25 | 2020-01-27 | 混合模型，允许部分工具变量无效。⚠️ 久未更新 |
| **MR-APSS** | [YangLabHKUST/MR-APSS](https://github.com/YangLabHKUST/MR-APSS) | 44 | 2026-08-28 | 同时建模多效性与样本结构，适合 UKB 类数据 |
| **nlmr** | [jrs95/nlmr](https://github.com/jrs95/nlmr) | 56 | 2024-01-04 | 非线性 MR（分层法 / 分数多项式），检验暴露-结局是否线性 |
| **mrbma** | [mglev1n/mrbma](https://github.com/mglev1n/mrbma) | 23 | 2023-02-21 | 贝叶斯模型平均，处理工具变量不确定性 |
| **BWMR** | [jiazhao97/BWMR](https://github.com/jiazhao97/BWMR) | 22 | 2023-06-14 | 贝叶斯加权 MR，对弱工具与多效性稳健 |
| **mrclust** | [cnfoley/mrclust](https://github.com/cnfoley/mrclust) | 19 | 2021-10-15 | 聚类异质性分析，识别来自不同通路的工具变量子群 |
| **mr.divw** | [tye27/mr.divw](https://github.com/tye27/mr.divw) | 10 | 2025-11-19 | 去偏 IVW，校正弱工具偏倚 |
| **MRBEE** | [noahlorinczcomi/MRBEE](https://github.com/noahlorinczcomi/MRBEE) | 9 | 2026-05-17 | 偏差校正估计方程，支持相关多效性与样本重叠 |
| **mrsensemakr** | [carloscinelli/mrsensemakr](https://github.com/carloscinelli/mrsensemakr) | 10 | 2026-02-12 | 遗漏变量偏倚的敏感性分析（R² 框架） |

> 常规投稿的组合拳：`TwoSampleMR`（主分析）+ `MR-PRESSO`（多效性）+ `RadialMR` 或 `mr.raps`（稳健性）。

## 三、多变量 MR 与中介分析

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **MVMR** | [WSpiller/MVMR](https://github.com/WSpiller/MVMR) | 57 | 2026-10-19 | 多变量 MR 标准实现，含条件 F 统计量与工具变量强度诊断 |
| **RMVMR** | [WSpiller/RMVMR](https://github.com/WSpiller/RMVMR) | 13 | 2026-10-07 | 径向多变量 MR，MVMR 的异质性可视化版本 |
| **FLOW-MR** | [ZixuanWu1/FLOW-MR](https://github.com/ZixuanWu1/FLOW-MR) | 18 | 2026-04-08 | 中介场景下的 MR，分解直接/间接效应 |

## 四、共定位与 TWAS

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **coloc** | [chr1swallace/coloc](https://github.com/chr1swallace/coloc) | 214 | 2026-10-30 | 共定位分析（ABF 法），判断两个性状是否共享同一因果变异。MR 前必做的"同一位点"验证 |
| **pecotmr** | [StatFunGen/pecotmr](https://github.com/StatFunGen/pecotmr) | 39 | 2026-11-10 | 一体化流程：PWAS / TWAS / 共定位 / MR，适合蛋白组学 QTL 研究 |

## 五、数据获取与工具变量

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **ieugwasr** | [MRCIEU/ieugwasr](https://github.com/MRCIEU/ieugwasr) | 113 | 2026-11-10 | OpenGWAS 数据库 API 客户端，按 ID 拉取 GWAS 汇总统计与 LD 信息 |
| **MRInstruments** | [MRCIEU/MRInstruments](https://github.com/MRCIEU/MRInstruments) | 49 | 2026-08-11 | 现成工具变量集合（BMI、吸烟、饮酒等常用暴露） |
| **gwasglue2** | [MRCIEU/gwasglue2](https://github.com/MRCIEU/gwasglue2) | 24 | 2024-03-25 | 汇总统计 → LD 矩阵 / VCF 格式转换，供 SMR、coloc 等下游使用 |
| **gwasglue** | [MRCIEU/gwasglue](https://github.com/MRCIEU/gwasglue) | 160 | 2022-05-20 | 上一代版本。⚠️ 已停更，新项目请用 gwasglue2 |

## 六、其他主流方法

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **CAUSE** | [jean997/cause](https://github.com/jean997/cause) | 59 | 2023-12-29 | 区分因果效应与相关多效性，贝叶斯模型比较（elpd）。**对 mixsqp/ashr 版本敏感** |
| **GSMR** | [JianYang-Lab/gsmr2](https://github.com/JianYang-Lab/gsmr2) | 24 | 2024-04-26 | GSMR + HEIDI 过滤，剔除多效性工具变量。需配合 GCTA |
| **MR-CUE** | [QingCheng0218/MR.CUE](https://github.com/QingCheng0218/MR.CUE) | 5 | 2023-11-27 | 允许工具变量间存在相关（LD），无需 clumping |
| **SMR** | [XudongHan-bio/SMR](https://github.com/XudongHan-bio/SMR) | 11 | 2020-12-27 | 汇总数据 MR，常用于 eQTL/pQTL 中介分析。⚠️ 官方主推 [SMR 官网](https://yanglab.westlake.edu.cn/software/smr/) |

---

## 已知安装坑

这些是实际踩过的，`install.R` 里已经处理，但手动装时要注意：

| 问题 | 现象 | 处理 |
|---|---|---|
| `TwoSampleMR` 不在 CRAN | `install.packages` 找不到 | 必须 `remotes::install_github("MRCIEU/TwoSampleMR")`，且依赖 `ieugwasr` 需先装 |
| `MR-PRESSO` 依赖 Java | `rJava` 加载失败 / `JAVA_HOME` 报错 | 装 JDK 8+，`R CMD javareconf`；Windows 还需 `Sys.setenv(JAVA_HOME=...)` |
| `CAUSE` 版本互斥 | 新版 `mixsqp`/`ashr` 与旧版 CAUSE 冲突 | 用 v1.2.0+：`remotes::install_github("jean997/cause@v1.2.0")` |
| `gwasglue` 已停更 | 装最新版报依赖错 | 换 `gwasglue2` |
| `GSMR` 需外部软件 | 函数调用报找不到 gcta | 单独下载 [GCTA](https://yanglab.westlake.edu.cn/software/gcta/) 并加入 PATH |
| `coloc` 与 `susieR` 冲突 | 同时加载时 `coloc.abf` 结果异常 | 分批加载，或锁定 `susieR` 版本 |
| GitHub 拉取超时（国内） | `install_github` 卡住 / 502 | 配置代理，或用 `GITHUB_PAT` + 镜像 |

## 数据源（非 R 包）

MR 分析的数据一般从这些地方取，配合 `ieugwasr` 使用：

- **OpenGWAS / IEU** —— https://gwas.mrcieu.ac.uk/ （`ieugwasr` 直接对接，最方便）
- **GWAS Catalog** —— https://www.ebi.ac.uk/gwas/
- **FinnGen** —— https://www.finngen.fi/en/access_results
- **UK Biobank** —— https://www.ukbiobank.ac.uk/ （需申请）
- **eQTLGen / GTEx** —— 用于 eQTL 中介分析
- **deCODE / UKB-PPP** —— 用于 pQTL 分析

---

## 说明

- star 数与最后提交时间仅为**活跃度参考**，不代表方法优劣；老旧但经典的包（如 `MRMix`）仍有使用价值
- 本项目只做索引与安装编排，各包版权归原作者，使用请引用对应方法学论文
- 欢迎提 Issue 补充遗漏的包

## License

本仓库的清单与脚本以 MIT 发布；所列第三方包遵循各自许可证。
