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

This is the last step to solve!
Remember that we're looking for $$\vec{Q}(t)$$ a cubic Bézier curve that has the same path as the polynomial $$c(u)$$.
This might seem a bit tricky, because $$c(u)$$ is a regular function while $$\vec{Q}(t)$$ is a vector-valued function.
Fortunately, we can make a vector-valued version of $$c$$ by *parameterizing* it.

We'll refer to this new version of the polynomial as $$\vec{C}(t)$$.
To parameterize it, define $$u(t) = t$$ and $$y(t) = c(u(t)) = c_0 + c_1 t + c_2 t^2 + c_3 t^3$$.
Now, the vector version of $$c$$ is:

$$\vec{C}(t) =
\begin{bmatrix} u(t) \\ y(t) \end{bmatrix} =
\begin{bmatrix} t \\ c_0 + c_1 t + c_2 t^2 + c_3 t^3 \end{bmatrix}$$

At this point, to make $$\vec{Q}(t)$$ match $$\vec{C}(t)$$, we just set them equal.
We can then solve for the control points $$\vec{Q}_0$$, $$\vec{Q}_1$$, $$\vec{Q}_2$$, and $$\vec{Q}_3$$.
Remember that $$\vec{Q}(t)$$ is a cubic Bézier curve, so its equation is:

$$\vec{Q}(t) = (1-t)^3 \vec{Q}_0 + 3 t (1-t)^2 \vec{Q}_1 + 3 t^2 (1-t) \vec{Q}_2 + t^3 \vec{Q}_3$$

We'll need to rearrange $$\vec{C}$$ and $$\vec{Q}$$ to solve for the control points.
We'll put both equations in the form $$\vec{V}_0 + t \vec{V}_1 + t^2 \vec{V}_2 + t^3 \vec{V}_3$$.
First, for $$\vec{C}(t)$$:

$$\vec{C}(t) =
\begin{bmatrix} 0 \\ c_0 \end{bmatrix} +
t \begin{bmatrix} 1 \\ c_1 \end{bmatrix} +
t^2 \begin{bmatrix} 0 \\ c_2 \end{bmatrix} +
t^3 \begin{bmatrix} 0 \\ c_3 \end{bmatrix}$$

It should be easy to multiply and add to verify this is right.
Next, $$\vec{Q}(t)$$ is more involved because of the $$(1-t)$$ bits.
First we expand out all the $$t$$ stuff:

$$\begin{aligned}
\vec{Q}(t) &=
(1 - 3t + 3t^2 - t^3) \vec{Q}_0 \\
&+ (3t - 6t^2 + 3t^3) \vec{Q}_1 \\
&+ (3t^2 - 3t^3) \vec{Q}_2 \\
&+ (t^3) \vec{Q}_3
\end{aligned}$$

And then we recombine the common powers of $$t$$:

$$\begin{aligned}
\vec{Q}(t) &=
\vec{Q}_0 \\
&+ t (-3 \vec{Q}_0 + 3 \vec{Q}_1) \\
&+ t^2 (3 \vec{Q}_0 - 6 \vec{Q}_1 + 3 \vec{Q}_2) \\
&+ t^3 (-\vec{Q}_0 + 3 \vec{Q}_1 - 3 \vec{Q}_2 + \vec{Q}_3)
\end{aligned}$$

Now we can set $$\vec{Q}(t) = \vec{C}(t)$$ by equating the coefficients of $$t$$:

$$\begin{aligned}
\vec{Q}_0 = \begin{bmatrix} 0 \\ c_0 \end{bmatrix} \\
-3 \vec{Q}_0 + 3 \vec{Q}_1 = \begin{bmatrix} 1 \\ c_1 \end{bmatrix} \\
3 \vec{Q}_0 - 6 \vec{Q}_1 + 3 \vec{Q}_2 = \begin{bmatrix} 0 \\ c_2 \end{bmatrix} \\
-\vec{Q}_0 + 3 \vec{Q}_1 - 3 \vec{Q}_2 + \vec{Q}_3 = \begin{bmatrix} 0 \\ c_3 \end{bmatrix}
\end{aligned}$$

These are four equations in four unknowns again!
This time, the unknowns are vectors, but we can just solve it two separate times---once for the top components, once bottom components.
As before, we know this can be solved easily with a computer.
So, we've solved all the sub-problems!
It's time to string them together into a single solution.
Bear with me here, because the solution is going to be pretty simple!

## Putting Together the Solution

{% include todo.html content="make connection to sample rate when discussing segment size" %}
