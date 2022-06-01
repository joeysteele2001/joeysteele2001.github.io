---
author: Joey Steele
title: Bézier Graphs, Part 2
subtitle: Working out the Math
series-id: banner
series-index: 3
date: June 1, 2022
math: true
---

## The Setup

Our goal is to find the Bézier curve that exactly matches a given cubic polynomial for $$0 \le x \le 1$$.
More specifically:

* we are given the coefficients $$c_0, c_1, c_2, c_3$$ that uniquely describe the polynomial $$y(x) = c_3 x^3 + c_2 x^2 + c_1 x + c_0$$,
* we can write $$y(x)$$ in vector form as $$\vec{Y}(t) = [t, y(t)]$$,
* we would like to find the cubic Bézier curve $$\vec{P}(t)$$ such that $$\vec{P}(t) = \vec{Y}(t)$$ for $$t \in [0, 1]$$.

This probably feels pretty restrictive---especially since we're trying to match small segments from all over the graph.
I'll show later that restricting $$x$$ to between 0 and 1 is without loss of generality.
This is because we can shift and scale the x-axis to fit where we want (and then scale and shift back).

## Matching with a Bezier Curve

First, we know that a cubic Bézier curve has the vector equation:

$$\vec{P}(t) = (1-t)^3 \vec{P}_0 + 3 (1-t)^2 t \vec{P}_1 + 3 (1-t) t^2 \vec{P}_2 + t^3 \vec{P}_3$$

where $$\vec{P}_0, \vec{P}_1, \vec{P}_2, \vec{P}_3$$ are called the *control points*.
We also have a vector equation for our polynomial:

$$\vec{Y}(t) = \begin{bmatrix}t \\ c_3 t^3 + c_2 t^2 + c_1 t + c_0\end{bmatrix} =
t^3 \begin{bmatrix}0 \\ c_3\end{bmatrix} +
t^2 \begin{bmatrix}0 \\ c_2\end{bmatrix} +
t \begin{bmatrix}1 \\ c_1\end{bmatrix} +
\begin{bmatrix}0 \\ c_0\end{bmatrix}$$

Let's factor out each of the vector coefficients so that:

$$\vec{Y}(t) = t^3 \vec{C}_3 + t^2 \vec{C}_2 + t \vec{C}_1 + \vec{C}_0$$

Now this looks very similar to $$\vec{P}(t)$$.
To put them in a similar form, we need to expand out the powers of $$(1-t)$$ and combine the powers of $$t$$:

$$\begin{aligned}
\vec{P}(t) = \, & (1 - 3t + 3t^2 - t^3) & \cdot\, \vec{P}_0 \\
+ \, & 3t (1 - 2t + t^2) & \cdot\, \vec{P}_1 \\
+ \, & 3t^2 (1 - t) & \cdot\, \vec{P}_2 \\
+ \, & t^3 & \cdot\, \vec{P_3}
\end{aligned}$$

$$\begin{aligned}
= \, & t^3 (-\vec{P}_0 + 3\vec{P}_1 - 3\vec{P}_2 + \vec{P}_3) \\
+ \, & t^2 (3\vec{P}_0 - 6\vec{P}_1 + 3\vec{P}_2) \\
+ \, & t (-3\vec{P}_0 + 3\vec{P}_1) \\
+ \, & \vec{P}_0
\end{aligned}$$

Both $$\vec{Y}(t)$$ and $$\vec{P}(t)$$ now have the same structure.
Since $$\vec{Y}(t) = \vec{P}(t)$$, their coefficients are also equal:

$$\begin{aligned}
& \vec{C}_0 = \vec{P}_0 \\
& \vec{C}_1 = -3\vec{P}_0 + 3\vec{P}_1 \\
& \vec{C}_2 = 3\vec{P}_0 - 6\vec{P}_1 + 3\vec{P}_2 \\
& \vec{C}_3 = -\vec{P}_0 + 3\vec{P}_1 - 3\vec{P}_2 + \vec{P}_3
\end{aligned}$$

This is now a system of four linear equations where the unknowns---$$\vec{P}_0, \vec{P}_1, \vec{P}_2, \vec{P}_3$$---are vectors.
We can easily solve this system by substitution to get:

$$\begin{aligned}
& \vec{P}_0 = \vec{C}_0 \\
& \vec{P}_1 = \vec{C}_0 + \frac{1}{3}\vec{C}_1 \\
& \vec{P}_2 = \vec{C}_0 + \frac{2}{3}\vec{C}_1 + \frac{1}{3}\vec{C}_2 \\
& \vec{P}_3 = \vec{C}_0 + \vec{C}_1 + \vec{C}_2 + \vec{C}_3
\end{aligned}$$

Now we'll put this back in terms of $$c_0, c_1, c_2, c_3$$ to get:

$$\begin{aligned}
& \vec{P}_0 = \begin{bmatrix} 0 \\ c_0 \end{bmatrix} \\
& \vec{P}_1 = \begin{bmatrix} 1/3 \\ c_0 + 1/3 \ c_1 \end{bmatrix} \\
& \vec{P}_2 = \begin{bmatrix} 2/3 \\ c_0 + 2/3 \ c_1 + 1/3 \ c_2 \end{bmatrix} \\
& \vec{P}_3 = \begin{bmatrix} 1 \\ c_0 + c_1 + c_2 + c_3 \end{bmatrix}
\end{aligned}$$

{% include todo.html content="make connection to sample rate when discussing segment size" %}
