# MR Bioinfo Toolkit

生信分析 —— **孟德尔随机化（Mendelian Randomization, MR）** 常用 R 包清单与一键安装脚本。

本项目不做代码搬运，只解决两个实际问题：

1. **哪些包值得用** —— 按功能分类，标注 GitHub 地址、star 数、最后更新时间、维护状态
2. **怎么一次装对** —— MR 生态的安装坑很多（GitHub-only 包、Java 依赖、版本互斥），`install.R` 把顺序和依赖都处理好了

> 清单快照：2026-11-10（**共 50 个工具 = 43 个 R 包 + 7 个外部工具/Python 实现**，star 与最后提交时间均由 GitHub API 逐个核实）

---

## 目录

- [快速开始](#快速开始)
- [一、核心 MR 分析](#一核心-mr-分析)
- [二、敏感性分析与稳健性](#二敏感性分析与稳健性)
- [三、多变量 MR 与中介分析](#三多变量-mr-与中介分析)
- [四、共定位与精细定位](#四共定位与精细定位)
- [五、TWAS / PWAS](#五twas--pwas)
- [六、其他主流方法](#六其他主流方法)
- [七、功效计算与研究设计](#七功效计算与研究设计)
- [八、数据获取与工具变量](#八数据获取与工具变量)
- [九、可视化与出图](#九可视化与出图)
- [十、外部依赖工具（非 R 包）](#十外部依赖工具非-r-包)
- [典型分析链条](#典型分析链条)
- [已知安装坑](#已知安装坑)
- [数据源](#数据源)

---

## 快速开始

```r
# 安装核心 + 可选组（约 15-30 分钟，取决于网络和编译）
source("install.R")

# 只装核心组：把 install.R 里的 INSTALL_OPTIONAL 改成 FALSE
```

只想要清单数据：`packages.csv` 可直接导入表格工具筛选。

---

## 一、核心 MR 分析

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **TwoSampleMR** | [MRCIEU/TwoSampleMR](https://github.com/MRCIEU/TwoSampleMR) | 562 | 2026-11-10 | **事实标准**。IVW、MR-Egger、加权中位数、加权模式，含 harmonise 数据对齐、Steiger 过滤与散点/森林/漏斗图 |
| **MendelianRandomization** | [cran/MendelianRandomization](https://github.com/cran/MendelianRandomization) | 46 | 2026-08-07 | 方法覆盖更广：MR-Lasso、众数法、聚类稳健、MVMR-IVW，适合做方法学对比 |
| **OneSampleMR** | [remlapmot/OneSampleMR](https://github.com/remlapmot/OneSampleMR) | 27 | 2026-10-23 | 个体数据（one-sample）MR，两阶段最小二乘及其变体 |

> 只用两样本汇总数据的话，`TwoSampleMR` 一个就够起步，其余按需补。

## 二、敏感性分析与稳健性

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **MR-PRESSO** | [rondolab/MR-PRESSO](https://github.com/rondolab/MR-PRESSO) | 98 | 2023-07-25 | 水平多效性全局检验 + 离群值检测与校正。**需要 Java（rJava）** |
| **MRlap** | [n-mounier/MRlap](https://github.com/n-mounier/MRlap) | 71 | 2025-01-09 | 同时校正 **winner's curse** 与**样本重叠**偏倚，观察性样本重叠时的必备工具 |
| **nlmr** | [jrs95/nlmr](https://github.com/jrs95/nlmr) | 56 | 2024-01-04 | 非线性 MR（分层法 / 分数多项式），检验暴露-结局是否线性 |
| **MR-APSS** | [YangLabHKUST/MR-APSS](https://github.com/YangLabHKUST/MR-APSS) | 44 | 2026-08-28 | 同时建模多效性与样本结构，适合 UKB 类数据 |
| **mr.raps** | [qingyuanzhao/mr.raps](https://github.com/qingyuanzhao/mr.raps) | 42 | 2025-10-31 | RAPS 稳健调整轮廓得分，处理有无效工具（InSIDE 不成立） |
| **GRAPPLE** | [jingshuw/GRAPPLE](https://github.com/jingshuw/GRAPPLE) | 40 | 2024-03-27 | 用 GWAS 全汇总统计校正 **winner's curse**，适合工具变量从同一 GWAS 选出时 |
| **RadialMR** | [WSpiller/RadialMR](https://github.com/WSpiller/RadialMR) | 34 | 2026-10-07 | 径向 MR，把异质性直接可视化到散点图上，离群点一眼可见 |
| **LHC-MR** | [LizaDarrous/lhcMR](https://github.com/LizaDarrous/lhcMR) | 26 | 2024-03-24 | 潜在遗传混杂 MR，同时估计因果效应与混杂/反向因果 |
| **MRMix** | [gqi/MRMix](https://github.com/gqi/MRMix) | 25 | 2020-01-27 | 混合模型，允许部分工具变量无效。⚠️ 久未更新 |
| **mrbma** | [mglev1n/mrbma](https://github.com/mglev1n/mrbma) | 23 | 2023-02-21 | 贝叶斯模型平均，处理工具变量不确定性 |
| **BWMR** | [jiazhao97/BWMR](https://github.com/jiazhao97/BWMR) | 22 | 2023-06-14 | 贝叶斯加权 MR，对弱工具与多效性稳健 |
| **mrclust** | [cnfoley/mrclust](https://github.com/cnfoley/mrclust) | 19 | 2021-10-15 | 聚类异质性分析，识别来自不同通路的工具变量子群 |
| **mrSampleOverlap** | [mglev1n/mrSampleOverlap](https://github.com/mglev1n/mrSampleOverlap) | 12 | 2022-09-01 | 估计两样本样本重叠导致的偏倚大小 |
| **mr.divw** | [tye27/mr.divw](https://github.com/tye27/mr.divw) | 10 | 2025-11-19 | 去偏 IVW，校正弱工具偏倚 |
| **mrsensemakr** | [carloscinelli/mrsensemakr](https://github.com/carloscinelli/mrsensemakr) | 10 | 2026-02-12 | 遗漏变量偏倚的敏感性分析（R² 框架） |
| **MRBEE** | [noahlorinczcomi/MRBEE](https://github.com/noahlorinczcomi/MRBEE) | 9 | 2026-05-17 | 偏差校正估计方程，支持相关多效性与样本重叠 |

> 投稿常规组合拳：`TwoSampleMR`（主分析）+ `MR-PRESSO`（多效性）+ `RadialMR` 或 `mr.raps`（稳健性）+ `MRlap`（样本重叠）+ `mRnd`（功效）。

## 三、多变量 MR 与中介分析

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **MVMR** | [WSpiller/MVMR](https://github.com/WSpiller/MVMR) | 57 | 2026-10-19 | 多变量 MR 标准实现，含条件 F 统计量与工具变量强度诊断 |
| **FLOW-MR** | [ZixuanWu1/FLOW-MR](https://github.com/ZixuanWu1/FLOW-MR) | 18 | 2026-04-08 | 中介场景下的 MR，分解直接/间接效应 |
| **RMVMR** | [WSpiller/RMVMR](https://github.com/WSpiller/RMVMR) | 13 | 2026-10-07 | 径向多变量 MR，MVMR 的异质性可视化版本 |

## 四、共定位与精细定位

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **susieR** | [stephenslab/susieR](https://github.com/stephenslab/susieR) | 273 | 2026-11-10 | SuSiE 精细定位，`coloc` 的 `coloc.susie` 方法依赖它；也用于构建可信集 |
| **coloc** | [chr1swallace/coloc](https://github.com/chr1swallace/coloc) | 214 | 2026-10-30 | 共定位分析（ABF 法），判断两个性状是否共享同一因果变异。**MR 前的同一位点验证必做** |
| **hyprcoloc** | [jrs95/hyprcoloc](https://github.com/jrs95/hyprcoloc) | 60 | 2024-04-08 | 多性状共定位聚类，一次回答"这些性状里哪几个共享因果变异" |
| **colocboost** | [StatFunGen/colocboost](https://github.com/StatFunGen/colocboost) | 17 | 2026-11-10 | 多上下文共定位，适合多组学（eQTL+pQTL+GWAS）联合 |

## 五、TWAS / PWAS

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **MetaXcan** | [hakyimlab/MetaXcan](https://github.com/hakyimlab/MetaXcan) | 204 | 2026-09-09 | S-PrediXcan 等，用 eQTL 权重做 TWAS，MR 的常见补充证据 |
| **FUSION** | [gusevlab/fusion_twas](https://github.com/gusevlab/fusion_twas) | 114 | 2026-03-17 | TWAS 主流实现（含多个权重模型），可做 TWAS-MR 联合 |
| **pecotmr** | [StatFunGen/pecotmr](https://github.com/StatFunGen/pecotmr) | 39 | 2026-11-10 | 一体化流程：PWAS / TWAS / 共定位 / MR，适合蛋白组学 QTL 研究 |

## 六、其他主流方法

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **CAUSE** | [jean997/cause](https://github.com/jean997/cause) | 59 | 2023-12-29 | 区分因果效应与**相关多效性**，贝叶斯模型比较（elpd）。**对 mixsqp/ashr 版本敏感** |
| **GSMR** | [JianYang-Lab/gsmr2](https://github.com/JianYang-Lab/gsmr2) | 24 | 2024-04-26 | GSMR + HEIDI 过滤，剔除多效性工具变量。需配合 GCTA |
| **MR2** | [lb664/MR2](https://github.com/lb664/MR2) | 21 | 2026-11-09 | 贝叶斯多响应 MR，同时分析一个暴露对多个结局 |
| **SMR** | [XudongHan-bio/SMR](https://github.com/XudongHan-bio/SMR) | 11 | 2020-12-27 | 汇总数据 MR，常用于 eQTL/pQTL 中介分析。⚠️ 官方主推 [SMR 官网版](https://yanglab.westlake.edu.cn/software/smr/) |
| **MR-CUE** | [QingCheng0218/MR.CUE](https://github.com/QingCheng0218/MR.CUE) | 5 | 2023-11-27 | 允许工具变量间存在相关（LD），无需 clumping |

## 七、功效计算与研究设计

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **mRnd** | [kn3in/mRnd](https://github.com/kn3in/mRnd) | 23 | 2017-09-27 | **MR 功效/样本量计算的标准工具**（在线版 [cnsgenomics.com/shiny/mRnd](https://cnsgenomics.com/shiny/mRnd/)）。⚠️ 代码年久未更新，但方法仍是通用标准 |

> 写方案或投稿时审稿人常问"这个样本量够不够检测到效应"，`mRnd` 是标准答复工具。

## 八、数据获取与工具变量

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **bigsnpr** | [privefl/bigsnpr](https://github.com/privefl/bigsnpr) | 226 | 2026-07-10 | 大规模基因型数据（bed/bgen）读写与质控，做 one-sample MR 或本地 LD 计算时用 |
| **PHESANT** | [MRCIEU/PHESANT](https://github.com/MRCIEU/PHESANT) | 168 | 2025-10-22 | UK Biobank 表型全扫描（pheWAS），常与 MR 配对做"暴露→多结局"筛查 |
| **PheWAS** | [PheWAS/PheWAS](https://github.com/PheWAS/PheWAS) | 161 | — | 经典 pheWAS 实现，EHR 编码映射，做 MR-PheWAS 时用 |
| **gwasglue** | [MRCIEU/gwasglue](https://github.com/MRCIEU/gwasglue) | 160 | 2022-05-20 | 上一代版本。⚠️ 已停更，新项目请用 gwasglue2 |
| **ieugwasr** | [MRCIEU/ieugwasr](https://github.com/MRCIEU/ieugwasr) | 113 | 2026-11-10 | OpenGWAS 数据库 API 客户端，按 ID 拉取 GWAS 汇总统计与 LD 信息 |
| **gwasvcf** | [MRCIEU/gwasvcf](https://github.com/MRCIEU/gwasvcf) | 111 | 2026-07-22 | 把 GWAS 汇总统计存成 VCF，供 SMR、coloc、LD 计算等下游工具复用 |
| **gwasrapidd** | [ramiromagno/gwasrapidd](https://github.com/ramiromagno/gwasrapidd) | 103 | — | GWAS Catalog 的 R 客户端：检索研究、关联、SNP、性状 |
| **MRInstruments** | [MRCIEU/MRInstruments](https://github.com/MRCIEU/MRInstruments) | 49 | 2026-08-11 | 现成工具变量集合（BMI、吸烟、饮酒等常用暴露） |
| **gwasglue2** | [MRCIEU/gwasglue2](https://github.com/MRCIEU/gwasglue2) | 24 | 2024-03-25 | 汇总统计 → LD 矩阵 / VCF 格式转换 |

## 九、可视化与出图

| 包 | GitHub | Star | 最后提交 | 说明 |
|---|---|---|---|---|
| **CMplot** | [YinLiLin/CMplot](https://github.com/YinLiLin/CMplot) | 647 | 2026-05-08 | 曼哈顿图 / QQ 图事实标准，支持环形曼哈顿，快且好看 |
| **locuszoomr** | [myles-lewis/locuszoomr](https://github.com/myles-lewis/locuszoomr) | 65 | 2026-11-10 | 纯 R 实现的 locuszoom，画位点区域关联图 + LD 着色 |
| **forestploter** | [cran/forestploter](https://github.com/cran/forestploter) | 14 | 2026-09-30 | 可编辑表格式森林图，比 `forestplot` 更灵活，适合 MR 多结局汇总图 |

> `TwoSampleMR` 自带 `mr_scatter_plot` / `mr_forest_plot` / `mr_funnel_plot`，简单出图够用；多结局合并或要投稿级排版时再上这三个。

## 十、外部依赖工具（非 R 包）

| 工具 | 地址 | 用途 |
|---|---|---|
| **LDSC** | [bulik/ldsc](https://github.com/bulik/ldsc)（807★，Python） | LD Score 回归：估计遗传力与遗传相关，常作为 MR 的前置探索 |
| **PLINK** | [www.cog-genomics.org/plink](https://www.cog-genomics.org/plink/) | LD clumping、数据格式转换（`TwoSampleMR` 本地 clumping 依赖它） |
| **GCTA** | [yanglab.westlake.edu.cn/software/gcta](https://yanglab.westlake.edu.cn/software/gcta/) | GSMR 必需；也用于 LD 参考与遗传力估计 |

---

## 典型分析链条

一个完整的 MR 研究通常按这个顺序用包：

```
1. 选题与数据准备
   ieugwasr / gwasrapidd / MRInstruments  → 拉取暴露与结局汇总统计
   gwasvcf / gwasglue2                    → 格式转换

2. 选工具变量（IV）
   TwoSampleMR::clump_data（经 OpenGWAS）或本地 PLINK
   PHESANT / PheWAS                       → 若做 MR-PheWAS 筛查

3. 主分析
   TwoSampleMR                            → IVW / MR-Egger / 加权中位数 / 加权模式
   MendelianRandomization                 → 换方法做交叉验证
   OneSampleMR                            → 若有个体数据

4. 稳健性与敏感性（缺一不可）
   MR-PRESSO        → 水平多效性 + 离群值
   RadialMR         → 异质性可视化
   mr.raps / MRMix  → 无效工具情形
   MRlap            → 样本重叠 + winner's curse
   mrsensemakr      → 遗漏变量偏倚
   mRnd             → 功效说明

5. 因果性佐证
   coloc / hyprcoloc / colocboost → 是否共享因果变异
   susieR                         → 精细定位可信集
   FUSION / MetaXcan / pecotmr    → TWAS/PWAS 方向一致性
   CAUSE                          → 区分因果 vs 相关多效性

6. 多变量与中介
   MVMR / RMVMR / FLOW-MR

7. 出图
   TwoSampleMR 内置图 + forestploter / CMplot / locuszoomr
```

---

## 已知安装坑

这些是实际踩过的，`install.R` 里已经处理，但手动装时要注意：

| 问题 | 现象 | 处理 |
|---|---|---|
| `TwoSampleMR` 不在 CRAN | `install.packages` 找不到 | 必须 `remotes::install_github("MRCIEU/TwoSampleMR")`，且依赖 `ieugwasr` 需先装 |
| `MR-PRESSO` 依赖 Java | `rJava` 加载失败 / `JAVA_HOME` 报错 | 装 JDK 8+，`R CMD javareconf`；Windows 还需 `Sys.setenv(JAVA_HOME=...)` |
| `CAUSE` 版本互斥 | 新版 `mixsqp`/`ashr` 与旧版 CAUSE 冲突 | 用 v1.2.0+：`remotes::install_github("jean997/cause@v1.2.0")` |
| `gwasglue` 已停更 | 装最新版报依赖错 | 换 `gwasglue2` |
| `GSMR` 需外部软件 | 函数调用报找不到 gcta | 下载 [GCTA](https://yanglab.westlake.edu.cn/software/gcta/) 并加入 PATH |
| `coloc` 与 `susieR` 冲突 | 同时加载时 `coloc.abf` 结果异常 | 分批加载，或锁定 `susieR` 版本 |
| `MRlap` 需 LD 参考面板 | 报错缺 LD score | 需先准备 LD score 文件（可用 `bigsnpr` 或 LDSC 生成） |
| `mRnd` 代码老旧 | 直接装可能报错 | 主要用在线版，或把公式抄进自己的脚本 |
| GitHub 拉取超时（国内） | `install_github` 卡住 / 502 | 配置代理，或用 `GITHUB_PAT` + 镜像 |

## 数据源

MR 分析的数据一般从这些地方取，配合 `ieugwasr` / `gwasrapidd` 使用：

- **OpenGWAS / IEU** —— https://gwas.mrcieu.ac.uk/ （`ieugwasr` 直接对接，最方便）
- **GWAS Catalog** —— https://www.ebi.ac.uk/gwas/ （`gwasrapidd` 直接对接）
- **FinnGen** —— https://www.finngen.fi/en/access_results
- **UK Biobank** —— https://www.ukbiobank.ac.uk/ （需申请；表型处理用 PHESANT）
- **eQTLGen / GTEx** —— eQTL 中介、TWAS 权重
- **deCODE / UKB-PPP** —— pQTL 分析

---

## 说明

- star 数与最后提交时间仅为**活跃度参考**，不代表方法优劣；老旧但经典的包（如 `MRMix`、`mRnd`）仍有使用价值
- 本项目只做索引与安装编排，各包版权归原作者，使用请引用对应方法学论文
- 欢迎提 Issue 补充遗漏的包

## License

本仓库的清单与脚本以 MIT 发布；所列第三方包遵循各自许可证。
