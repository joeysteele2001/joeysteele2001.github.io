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

We're going to split this sub-problem into two parts.
First, let's take for granted that we can generate a cubic Bézier curve for any cubic polynomial.
(That makes sense to me intuitively, since the equation for a cubic Bézier curve is basically a fancy cubic polynomial to begin with.)
Now, all we need to do is find a cubic polynomial that's a "good fit" for $$g(u)$$.

What is a "good fit" then?
Well, that's a subjective question, despite this being a mathematical venture.
The math will be valid regardless of what we choose.
So let's choose what qualities we want our approximation to have.

Since this is a visual graph, the endpoints should be exactly right.
If we don't have this, then we're no better off than when we connected with straight lines!
Next, there's one more property that should be very useful:
in order to keep the graph from having sharp edges at the ends of each segment, let's make the *slopes* of the approximation match the actual function at the endpoints.
If you've ever worked with Taylor series, we're essentially using the same reasoning here, just approximating about two points instead of one.

And believe it or not, those conditions are enough to find a unique cubic polynomial, so let's go on!

Let's get more mathematical.
Give the label $$c(u)$$ to the cubic polynomial that's approximating $$g(u)$$.
The coefficients of the polynomial are defined as:

$$c(u) = c_0 + c_1 u + c_2 u^2 + c_3 u^3$$

To find a matching cubic polynomial, we just have to find the right values for $$c_0$$, $$c_1$$, $$c_2$$, and $$c_3$$.

We know that we have four conditions (two for the left edge of the segment, and two for the right).
Let's express them mathematically.
For the endpoints to match:

$$c(0) = g(0);\quad c(1) = g(1)$$

For the slopes to match at the endpoints:

$$c'(0) = g'(0);\quad c'(1) = g'(1)$$

where $$c'(u)$$ and $$g'(u)$$ are the derivatives of $$c$$ and $$g$$ with respect to $$u$$.
Also, using calculus, we find that $$c'(u) = c_1 + 2 c_2 u + 3 c_3 u^2$$.
Evaluating all the left terms in the conditions, we get:

$$\begin{gathered}
c(0)    &=& c_0                     &=& g(0) \\
c'(0)   &=& c_1                     &=& g'(0) \\
c(1)    &=& c_0 + c_1 + c_2 + c_3   &=& g(1) \\
c'(1)   &=& c_1 + 2 c_2 + 3 c_3     &=& g'(1)
\end{gathered}$$

These are now four linear equations in four unknowns (since we already know how to evaluate $$g(u)$$ and $$g'(u)$$).
We aren't going to solve it here though.
As we'll see later, computers can easily do that part for us by using some linear algebra.
So for now, let's take for granted that we *can* solve for the values of $$c_0$$, $$c_1$$, $$c_2$$, and $$c_3$$.
In other words, we've found the cubic polynomial $$c(u)$$ that "best" fits $$g(u)$$, and we can continue with the second half of this sub-problem.

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
