title: 机器学习算法—降维算法—PCA
date: 2019-08-27 14:31:37
tags:
- 降维算法
categories: 机器学习
mathjax: true
---

> 现实应用中属性维数经常成千上万。而许多学习方法都涉及距离计算，而高维空间会给距离计算带来很大的麻烦，例如当维数很高时甚至连计算内积都不再容易。

>   事实上，在高维情形下出现的数据样本稀疏、距离计算困难等问题，是所有机器学习方法共同面临的严重障碍，被称为 **"维数灾难(curse of simensionality)"**。缓解维数灾难的一个重要途径是 **降维(dimension reduction)** , 亦称 ”维数约简“, 即通过某种数学变换将原始高维属性空间转变为一个低维 ”子空间“(subspace)， 在这个子空间中样本密度大幅提高，距离计算也变得更为容易。

> 为什么可以降维呢？ 因为很多时候，人们观测或者收集到的数据样本虽然是高维的，但与学习任务密切相关的也许仅是某个低维分布，即高维空间的一个低维 ”嵌入“。例如：数据属性中存在噪声属性、相似属性或冗余属性等，**对高维数据进行降维能在一定程度上达到提炼低维优质属性或降噪的效果。**

> 在很多算法中，降维算法成为了数据预处理的一部分，如 `PCA`

### 降维算法简介

目前已经存在大量的数据降维算法，可以从另个不同的维度对它们进行分类。按照是否有使用样本的标签值，可以将降维算法分为 **有监督降维** 和 **无监督降维** ；按照降维算法使用的映射函数，可以将算法分为 **线性降维** 与 **非线性降维** 。  

- **无监督降维算法** 不使用样本标签值，因此是一种无监督学习算法，其典型代表是 `PCA` 。**有监督的降维算法** 则使用了样本标签值，是一种有监督学习算法，其典型代表是 `LDA`
- **线性降维算法** 根据样本集构造出线性函数完成向低维空间的映射。一般通过对向量 $x$ 进行线性变换即左乘一个投影矩阵 $W$ 而得到结果向量 $y$ ： $y = Wx$ ， `PCA` 和 `LDA` 都是 **线性降维算法** ; 非线性降维算法则构造一个非线性映射完成数据的降维。很多时候数据是非线性的，因此需要使用 **非线性降维算法** 以取得更好的效果，`LLE` 就是一种 **非线性降维算法**

对于 **线性降维**，我们主要使用 **投影** 的方法。对于 **非线性降维**， 我们主要使用 **流形学习**。**流形学习（manifold learning）** 是一种借助拓扑流形概念的降维方法，流形是指在局部与欧式空间同胚的空间，即在局部与欧式空间具有相同的性质，能用欧氏距离计算样本之间的距离。这样即使高维空间的分布十分复杂，但是在局部上依然满足欧式空间的性质，基于流形学习的降维正是这种 **“邻域保持”** 的思想。可以简单的将流形理解成二维空间的曲线，三维空间的曲面，等几何体在更高维空间的推广。

有时候， **投影** 并不是降维的最佳方法。在很多情况下，子空间可能会扭曲和转动，比如图所示的著名的瑞士卷数据集：
![swiss_roll_data](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/swiss_roll_data.jpeg)
简单地将数据集投射到一个平面上会将瑞士卷的不同层叠在一起，如图左侧所示。但是，你真正想要的是展开瑞士卷所获取到的类似图右侧的 2D 数据集。这时候就需要使用 **流形学习**。
![swill_roll_reduce](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/swill_roll_reduce.jpeg)

所以采用哪种方式降维，这一切都取决于数据集。

大概介绍一下几个比较出名的降维算法： `PCA` 、 `LDA` 、 `LLE`

<!-- more -->

- `PCA` ，Principle Component Analysis，即主成分分析法，是特征降维的最常用手段，是最基础的 **无监督降维算法** 。顾名思义， `PCA` 能从冗余特征中提取主要成分，在不太损失模型质量的情况下，提升了模型训练速度。

    它的目标是通过某种线性投影，将高维的数据映射到低维的空间中表示，并期望在所投影的维度上数据的方差最大，以此使用较少的数据维度，同时保留住较多的原数据点的特性。

    通俗的理解，如果把所有的点都映射到一起，那么几乎所有的信息（如点和点之间的距离关系）都丢失了，而如果映射后方差尽可能的大，那么数据点则会分散开来，以此来保留更多的信息。可以证明，PCA是丢失原始数据信息最少的一种线性降维方式。如图：
    ![pca_compare](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/pca_compare.jpeg)
    正如我们所看到的，投影到实线上保留了 **最大方差**。选择保持 **最大方差** 的轴看起来是合理的，因为它很可能比其他投影损失更少的信息。证明这种选择的另一种方法是，选择这个轴使得将原始数据集投影到该轴上的均方距离最小。这两种做法对应了 `PCA` 的两种性质，而且得到了相同的结果。
- `LDA` ， 线性判别分析, 一种 **有监督的线性降维算法** 。其基本思想是：将训练样本投影到一条直线上，使得同类的样例尽可能近，不同类的样例尽可能远。如图所示：
    ![lda](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/lda.png)
    对新的样本进行分类时，只需将该样本点投影到这条直线上，根据与各个类别的中心值进行比较，从而判定出新样本与哪个类别距离最近。
- `LLE` , manifold learning , 即局部线性嵌入。是一种经典的 **流形学习** 算法。它的目标是 保持邻域内样本之间的线性关系。


降维除了可以加快训练速度外，在数据可视化方面也十分有用。降低特征维度到 2（或者 3）维从而可以在图中画出一个高维度的训练集，让我们可以通过视觉直观的发现一些非常重要的信息，比如 **聚类**。

### PCA算法原理
`主成分分析（PCA）` 直接通过一个线性变换，将原始空间中的样本投影到新的低维空间中。简单来理解这一过程便是： `PCA` 采用一组新的基来表示样本点，其中每一个基向量都是原来基向量的线性组合，通过使用尽可能少的新基向量来表出样本，从而达到降维的目的。

根据 `PCA` 的目标，它有这两个重要的性质：

- 最近重构性：样本点到超平面的距离足够近，即尽可能在超平面附近；
- 最大可分性：样本点在超平面上的投影尽可能地分散开来，即投影后的坐标具有区分性。满足上面所说的 **最大方差理论** 。

举个例子：假设我们要将特征从  n  维度降到  k  维：PCA 首先找寻  k  个  n  维向量，然后将特征投影到这些向量构成的  k 维空间，并保证投影误差足够小。下图中中，为了将特征维度从三维降低到二位，PCA 就会先找寻两个三维向量  $u^{(1)}$ , $u^{(2)}$ ，二者构成了一个二维平面，然后将原来的三维特征投影到该二维平面上：
![pca3d22d](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/PCA3D22D.png)

#### PCA算法步骤

**最近重构性与最大可分性虽然从不同的出发点来定义优化问题中的目标函数，但最终这两种特性得到了完全相同的优化问题。** 所以可以得到以下推导：
![pca_derivation](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/pca_derivation.png)
接着使用拉格朗日乘子法求解上面的优化问题，得到：
![pca_xiefangcha](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/pca_fangcha.png)
因此只需对协方差矩阵进行特征值分解即可求解出投影矩阵 $W$ ，`PCA` 算法的整个流程如下图所示：
![pca-progress](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/pca-progress.png)
所以我们的新样本是：
$$Z = XW$$

> **直观点的例子：**
> 1. 原始数据集矩阵 X：
    $$\left[ \begin{array}{cc} 1 & 1 & 2 & 4 & 2 \\\ 1 & 3 & 3 & 4 & 4 \end{array} \right]$$
> 2. 中心化后：
    $$\left[ \begin{array}{cc} -1 & -1 & 0 & 2 & 0 \\\ -2 & 0 & 0 & 1 & 1 \end{array} \right]$$
> 3. 再求协方差矩阵：
    $$C = \frac15\left[ \begin{array}{cc} -1 & -1 & 0 & 2 & 0 \\\ -2 & 0 & 0 & 1 & 1 \end{array} \right]\left[ \begin{array}{cc} -1 & -2 \\\ -1 & 0 \\\ 0 & 0 \\\ 2 & 1 \\\ 0 & 1 \end{array} \right] = \left[ \begin{array}{cc} \frac65 & \frac45 \\\ \frac45 & \frac65 \end{array} \right]$$
> 4. 特征值：
    $$λ_1 = 2, λ_2 = \frac25 $$
> 5. 对应的特征向量:
    $$c1 = \left[ \begin{array}{cc} \frac{1}{\sqrt2} \\\ \frac{1}{\sqrt2} \end{array} \right], c2 = \left[ \begin{array}{cc} -\frac{1}{\sqrt2} \\\ \frac{1}{\sqrt2} \end{array} \right]$$
> 6. 标准化：
    $$P = \left[ \begin{array}{cc} \frac{1}{\sqrt2} & \frac{1}{\sqrt2} \\\ -\frac{1}{\sqrt2} & \frac{1}{\sqrt2} \end{array} \right]$$
> 7. 选择较大特征值对应的特征向量：
    $$W = \left[ \begin{array}{cc} \frac{1}{\sqrt2} & \frac{1}{\sqrt2} \end{array} \right]$$
> 8. 执行 `PCA` 变换：$Z=WX$ 得到的 Z 就是 `PCA` 降维后的值 数据集矩阵:
    $$Z = \left[ \begin{array}{cc} \frac{1}{\sqrt2} & \frac{1}{\sqrt2} \end{array} \right]\left[ \begin{array}{cc} -1 & -1 & 0 & 2 & 0 \\\ -2 & 0 & 0 & 1 & 1 \end{array} \right] = \left[ \begin{array}{cc} -\frac{1}{\sqrt2} & -\frac{1}{\sqrt2} & 0 & \frac{3}{\sqrt2} & \frac{1}{\sqrt2} \end{array} \right]$$

#### PCA 降维后的恢复
通过上面的步骤将数据进行了压缩，同样，可以通过逆向流程来恢复数据。由于：
$$Z=XW$$
因此：
$$X_{approx}=ZW^T$$
之所以用 Xapprox，是因为恢复后的数据会有一定的误差。如下图所示，左边为原始数据，右边为恢复后的数据。
![pca-recover](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/pca-recover.svg)

#### PCA 降到多少维才合适？

从 `PCA` 的执行流程中，我们知道，需要为 `PCA` 指定目的维度 $d'$ 。如果降维不多，则性能提升不大；如果目标维度太小，则又丢失了许多信息。

降维后低维空间的维数 $d'$ 通常由用户先指定， 或通过在 $d'$ 值不同的低维空间中对 **$k$ 近邻分类器**（或其他开销较小的学习算法） 进行交叉验证来选取较好的 $d'$ 值。对 `PCA` ，还可以从重构的角度来设置一个重构阈值，例如 $t = 95\% $ ，然后选择使得下式成立的最小的 $d'$ 值：

![d_formula](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/d_formula.png)

#### PCA 的作用和效果

显然，低维空间和原始高维空间必有不同，因为对应于最小的 $d - d'$ 个特征值的特征向量被舍弃了，这是降维导致的结果。但舍弃这一部分信息往往是必要的： 一方面，舍弃这部分信息后使得样本的采样密度增大，这是降维的重要动机；另一方面，当数据收到噪声影响时，最小的特征值所对应的特征向量往往与噪声有关，将他们舍弃能在一定程度上起到去噪的作用。


### PCA算法实例

首先我们利用 **奇异值分解** 实现一个 `pca` 算法，我们也可以直接使用 [Scikit-Learn 的 PCA 类](https://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html#sklearn.decomposition.PCA)，以供后面的实例使用， 代码如下：

``` python
# coding: utf8
# pca/pca.py

import numpy as np

def normalize(X):
    """数据标准化处理

    Args:
        X 样本
    Returns:
        XNorm 标准化后的样本
    """
    XNorm = X.copy()
    m,n = XNorm.shape
    mean = np.mean(XNorm, axis=0)
    std = np.std(XNorm, axis=0)
    XNorm = (XNorm - mean) / std
    return XNorm

def PCA(X, k = 1):
    """PCA

    Args:
        X 样本
        k 目的维度
    Returns:
        XNorm 标准化后的样本
        Z 降维后的新样本
        U U
        UReduce 约减矩阵  Ureduce，即投影矩阵
        S S
        V V
    """
    m, n = X.shape
    # 数据中心化
    XNorm = normalize(X)
    # 计算协方差矩阵
    Coef = XNorm.T * XNorm/m
    # 奇异值分解
    U, S, V = np.linalg.svd(Coef)
    # 取出前 k 个向量
    UReduce = U[:, 0:k]
    Z = XNorm * UReduce
    return XNorm, Z, U, UReduce, S, V

def recover(UReduce, Z):
    """数据恢复

    Args:
        UReduce 约减矩阵  Ureduce，即投影矩阵
        Z 降维后的样本
    """
    return Z * UReduce.T
```

#### PCA for 加速学习
现在，我们手上有一个人脸数据集，每张图片大小为  32×32 ，以像素为特征，则每个特征向量的维度就为  1024  维：

![face_before_pca](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/face_before_pca.png)

使用 `PCA` 进行降低特征维度到  100  维：

``` python
# coding: utf8
# pca/test_pca4visualization.py

import pca
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

def display(images, width, height):
    """展示图片

    Args:
        images 图像样本
        width 图像宽
        height 图像高
    """
    m, n = images.shape
    rows = int(np.floor(np.sqrt(m)))
    cols = int(np.ceil(m / rows))
    # 图像拼接
    dstImage = images.copy()
    dstImage = np.zeros((rows * height, cols * width))
    for i in range(rows):
        for j in range(cols):
            idx = cols * i + j
            image = images[idx].reshape(height, width)
            dstImage[i * height:i * height + height,
                     j * width: j * width + width] = image
    plt.imshow(dstImage.T, cmap='gray')
    plt.axis('off')
    plt.show()

data = loadmat('data/ex7faces.mat')
X = np.mat(data['X'],dtype=np.float32)
m, n = X.shape

# 展示原图
display(X[0:100, :], 32, 32)

XNorm, Z, U, UReduce, S, V = pca.PCA(X, k=100)
XRec = pca.recover(UReduce, Z)

# 显示修复后的图，可以看出，PCA 损失了一部分细节
display(XRec[0:100, :], 32, 32)
```

结果如下, 可以看到，我们的人脸数据变得模糊，但是眼睛，鼻子，嘴唇等特征仍然可辨识：

![face_after_pca](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/face_after_pca.png)

#### PCA for 数据可视化

我们有一张小鸟的图片，这是一个三通道彩色图像：

![bird](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/bird_small.png)

我们将图片的像素按颜色进行聚类，并在三维空间观察聚类成果：

![3d_data](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/3D_data.png)

似乎在三维空间可视化不是那么直观，借助于 `PCA` ，我们将聚类结果降到二维空间进行可视化：

![2d_data](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/2D_data.png)

示例代码：
```python
# coding: utf8
# pca/test_pca4visualization.py

import numpy as np
import kmeans
import pca
from scipy.io import loadmat
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import matplotlib.cm as cmx
import matplotlib.colors as colors

def getCmap(count):
    color_norm  = colors.Normalize(vmin=0, vmax=count-1)
    scalar_map = cmx.ScalarMappable(norm=color_norm, cmap='hsv')
    def map_index_to_rgb_color(index):
        return scalar_map.to_rgba(index)
    return map_index_to_rgb_color

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

data = loadmat('data/bird_small.mat')
A = data['A']

A = A / 255.0;

height, width, channels = A.shape
X = np.mat(A.reshape(height * width, channels))

m, n = X.shape

clusterNum = 16
cmap = getCmap(clusterNum)
centroids, clusterAssment = kmeans.kMeans(X, clusterNum)
# 随机选择 1000 个样本绘制
sampleSize = 1000
sampleIndexs = np.random.choice(m, sampleSize)
clusters = clusterAssment[sampleIndexs]
samples = X[sampleIndexs]

# 三维下观察
for i in range(sampleSize):
    x, y, z = samples[i,:].A[0]
    center = clusters[i, 0]
    color = cmap(center)
    ax.scatter([x], [y], [z], color=color, marker='o')
plt.show()

# 二维下观察
reducedSamples = pca.PCA(samples, k=2)[1]
for i in range(sampleSize):
    x, y = reducedSamples[i,:].A[0]
    center = clusters[i, 0]
    color = cmap(center)
    plt.scatter([x], [y], color=color, marker='o')
plt.show()
```

### PCA 引申
线性降维方法假设聪高维空间到低维空间的函数映射都是线性的，然而，在不少现实任务中，可能需要非线性映射才能找到恰当的低维嵌入。例如：
![pca_k](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/pca_k.png)
如上所示，如果直接使用线性降维方法对三维空间观察到的样本点进行降维，则将丢失原本的低维结构，我们需要的是 "本真二维结构"

在上面我们提到了 **流形学习** ，这儿我们还有另外一种方法，基于核技巧对线性降维方法进行 **”核化“** ，其实即先将样本映射到高维空间，再在高维空间中使用线性降维的方法。

`PCA` 可以通过 **核化** 生成 **核主成分分析（KPCA）** ，它通常能够很好地保留投影后的簇，有时甚至可以展开分布近似于扭曲流形的数据集。

下图 展示了使用线性核， `RBF` 核， `sigmoid` 核 将瑞士卷降到 2 维。
![kpca](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/machine-learn/kpca.jpeg)

选择最佳的 **核方法** 和 **超参数值**  是另外一部分复杂的部分，这儿简单带过，感兴趣的同学自己研究下。



> **参考链接：**
> - [斯坦福机器学习笔记](https://yoyoyohamapi.gitbooks.io/mit-ml/content/%E7%89%B9%E5%BE%81%E9%99%8D%E7%BB%B4/articles/PCA.html)
> - [周志华《机器学习》学习笔记](https://github.com/Vay-keen/Machine-learning-learning-notes)
