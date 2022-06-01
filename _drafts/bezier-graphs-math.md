---
author: Joey Steele
title: Bézier Graphs, Part 2
subtitle: Working out the Math
series-id: banner
series-index: 3
date: June 1, 2022
math: true
---

## Transforming To and From A Simpler Case

Conceptually, what we want to do is move the graph left or right so the left edge of the segment is at $$0$$.
Then we stretch or squish the graph so the right edge ends up at $$1$$.

To do this, I'll introduce a new variable $$u$$ to avoid confusion with $$x$$.
Our original segment is defined by $$f(x)$$, for $$x_0 \le x \le x_1$$.
We'll call the new shifted-and-scaled segment $$g(u)$$, where $$0 \le u \le 1$$.
So our goal is to find $$g(u)$$ so that $$g(0) = f(x_0)$$ and $$g(1) = f(x_1)$$.

Shifting left or right by $$x_0$$ is as simple as adding to $$u$$: $$g(u) = f(x_0 + u)$$.
As a sanity check, we can see that $$g(0) = f(x_0)$$, which is the first bit of what we want!
But $$g(1) = f(x_0 + 1)$$, which isn't quite right.

The distance between $$x_0$$ and $$x_1$$ is just $$x_1 - x_0$$.
We want to scale $$g$$ so that this distance gets squished or stretched to $$1$$.
To do this, we just multiply $$u$$ by the original distance $$x_1 - x_0$$:

$$g(u) = f(x_0 + u (x_1 - x_0))$$

Now we can double-check our work to see that, sure enough, $$g(0) = f(x_0)$$ and $$g(1) = f(x_0 + x_1 - x_0) = f(x_1)$$.

### Undoing this Simplification

We can continue on finding a Bézier curve to approximate $$g(u)$$, and we'll eventually end up with four control points: $$\vec{Q}_0$$, $$\vec{Q}_1$$, $$\vec{Q}_2$$, and $$\vec{Q}_3$$.
But they're going to be scaled and shifted horizontally, because we did that at the beginning.
To undo this, we'll define a new Bézier curve $$\vec{P}(t)$$ with control points $$\vec{P}_0$$, $$\vec{P}_1$$, $$\vec{P}_2$$, and $$\vec{P}_3$$.

First, notice that the $$y$$-coordinates of $$\vec{P}$$ will all be the same as $$\vec{Q}$$, because we don't touch the $$y$$-coordinates when we make our transformation at the beginning.
For the horizontal coordinates, we can note that when we defined $$g(u)$$ we essentially substituted $$x = x_0 + u (x_1 - x_0)$$.
So we can solve for $$u$$ in terms of $$x$$ to find the $$x$$-coordinates of $$\vec{P}$$:

$$u = \frac{x - x_0}{x_1 - x_0}$$

In other words, the $$x$$-values of the control points $$P_k$$ are:

$$P_{k,x} = \frac{Q_{k,x} - x_0}{x_1 - x_0}$$

where

$$P_k = \begin{bmatrix}P_{k,x} \\ P_{k,y}\end{bmatrix}; \quad Q_k = \begin{bmatrix}Q_{k,x} \\ Q_{k,y}\end{bmatrix}$$

So that's it!
We can simplify the problem, going from $$f(x)$$ to $$g(u)$$, and then undo that, going from $$\vec{Q}(t)$$ to $$\vec{P}(t)$$.
Next up, how do we get from $$g(u)$$ to $$\vec{Q}(t)$$?

## Approximating the Segment with a Cubic Polynomial

## Matching the Cubic Polynomial with a Bézier Curve

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
