---
author: Joey Steele
title: Bézier Graphs, Part 2
subtitle: Working out the Math
series-id: banner
series-index: 3
date: June 2, 2022
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

{% include todo.html content="WE DON'T NEED TO SOLVE FOR $$u$$ EVER BECAUSE WE PLUG IN THE ORIGINAL STUFF SO FIX THIS" %}

We can continue on finding a Bézier curve to approximate $$g(u)$$, and we'll eventually end up with four control points: $$\vec{Q}_0$$, $$\vec{Q}_1$$, $$\vec{Q}_2$$, and $$\vec{Q}_3$$.
But they're going to be scaled and shifted horizontally, because we did that at the beginning.
To undo this, we'll define a new Bézier curve $$\vec{P}(t)$$ with control points $$\vec{P}_0$$, $$\vec{P}_1$$, $$\vec{P}_2$$, and $$\vec{P}_3$$.

First, notice that the $$y$$-coordinates of $$\vec{P}$$ will all be the same as $$\vec{Q}$$, because we don't touch the $$y$$-coordinates when we make our transformation at the beginning.
For the horizontal coordinates, we can note that when we defined $$g(u)$$ we essentially substituted $$x = x_0 + u (x_1 - x_0)$$.
So we can solve for $$u$$ in terms of $$x$$ to find the $$x$$-coordinates of $$\vec{P}$$:

$$u = \frac{x - x_0}{x_1 - x_0}$$

In other words, the $$x$$-values of the control points $$P_k$$ are:

$$P_{k,x} = \frac{Q_{k,u} - x_0}{x_1 - x_0}$$

where

$$P_k = \begin{bmatrix}P_{k,x} \\ P_{k,y}\end{bmatrix}; \quad Q_k = \begin{bmatrix}Q_{k,u} \\ Q_{k,y}\end{bmatrix}$$

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

Let's summarize the steps we have so far.
We start out being given a function $$f(x)$$, together with the beginning and end of the segment we want to fit: $$x_0$$ and $$x_1$$.
From here, we define $$g(u) = f(x_0 + u(x_1 - x_0))$$.
Next, we find the values $$c_0$$, $$c_1$$, $$c_2$$, and $$c_3$$ that solve:

$$\begin{gathered}
c_0                     &=& g(0) \\
c_1                     &=& g'(0) \\
c_0 + c_1 + c_2 + c_3   &=& g(1) \\
c_1 + 2 c_2 + 3 c_3     &=& g'(1)
\end{gathered}$$

Then we find the vectors $$\vec{Q}_0$$, $$\vec{Q}_1$$, $$\vec{Q}_2$$, and $$\vec{Q}_3$$ that solve:

$$\begin{aligned}
\vec{Q}_0 = \begin{bmatrix} 0 \\ c_0 \end{bmatrix} \\
-3 \vec{Q}_0 + 3 \vec{Q}_1 = \begin{bmatrix} 1 \\ c_1 \end{bmatrix} \\
3 \vec{Q}_0 - 6 \vec{Q}_1 + 3 \vec{Q}_2 = \begin{bmatrix} 0 \\ c_2 \end{bmatrix} \\
-\vec{Q}_0 + 3 \vec{Q}_1 - 3 \vec{Q}_2 + \vec{Q}_3 = \begin{bmatrix} 0 \\ c_3 \end{bmatrix}
\end{aligned}$$

Finally, we define the vectors $$\vec{P}_0$$, $$\vec{P}_1$$, $$\vec{P}_2$$, and $$\vec{P}_3$$ as:

$$\vec{P}_k = \begin{bmatrix} (Q_{k,u} - x_0) / (x_1 - x_0) \\ Q_{k,y} \end{bmatrix}$$

where $$\vec{Q}_k = \begin{bmatrix} Q_{k,u} \\ Q_{k,y} \end{bmatrix}$$.

Let's start with the system of equations solving for $$\vec{Q}_k$$.
Earlier, I mentioned that we can solve separately for the $$u$$ and $$y$$ components of $$\vec{Q}_k$$.
Let's write that out for the $$y$$ components:

$$\begin{aligned}
Q_{0,y}     &               &               &           &= c_0 \\
-3 Q_{0,y}  &+ 3 Q_{1,y}    &               &           &= c_1 \\
3 Q_{0,y}   &- 6 Q_{1,y}    &+ 3 Q_{2,y}    &           &= c_2 \\
-Q_{0,y}    &+ 3 Q_{1,y}    &- 3 Q_{2,y}    &+ Q_{3,y}  &= c_3
\end{aligned}$$

If you're familiar with linear algebra, you'll recognize that we can rewrite this as a matrix equation.
If not, keep going along---it should make some sense what's going on.

$$
\underbrace{
    \begin{bmatrix}
    1 & 0 & 0 & 0 \\
    -3 & 3 & 0 & 0 \\
    3 & -6 & 3 & 0 \\
    -1 & 3 & -3 & 1
    \end{bmatrix}
}_{B}

\underbrace{
    \begin{bmatrix}
    Q_{0,y} \\ Q_{1,y} \\ Q_{2,y} \\ Q_{3,y}
    \end{bmatrix}
}_{\vec{q}_y}

=

\underbrace{
    \begin{bmatrix}
    c_0 \\ c_1 \\ c_2 \\ c_3
    \end{bmatrix}
}_{\vec{c}_y}
$$

Or, more simply, $$B \vec{q}_y = \vec{c}_y$$.
Similarly, $$B \vec{q}_u = \vec{c}_u$$, where

$$
\vec{q}_u = \begin{bmatrix} Q_{0,u} \\ Q_{1,u} \\ Q_{2,u} \\ Q_{3,u} \end{bmatrix};\quad
\vec{c}_u = \begin{bmatrix} 0 \\ 1 \\ 0 \\ 0 \end{bmatrix}
$$

To solve both these equations at once, we can package $$\vec{q}_u$$ and $$\vec{q}_y$$ into a matrix, and similar with $$\vec{c}_u$$ and $$\vec{c}_y$$:

$$
\underbrace{
    \begin{bmatrix}
    1 & 0 & 0 & 0 \\
    -3 & 3 & 0 & 0 \\
    3 & -6 & 3 & 0 \\
    -1 & 3 & -3 & 1
    \end{bmatrix}
}_{B}

\underbrace{
    \begin{bmatrix}
    Q_{0,u} & Q_{0,y} \\
    Q_{1,u} & Q_{1,y} \\
    Q_{2,u} & Q_{2,y} \\
    Q_{3,u} & Q_{3,y}
    \end{bmatrix}
}_{\mathbf{Q}}

=

\underbrace{
    \begin{bmatrix}
    0 & c_0 \\
    1 & c_1 \\
    0 & c_2 \\
    0 & c_3
    \end{bmatrix}
}_{\mathbf{C}}
$$

So, we can solve for all the $$\vec{Q}$$ control points by solving $$B \mathbf{Q} = \mathbf{C}$$.
Since $$B$$ is square and invertible, it's as simple as:

$$\mathbf{Q} = B^{-1} \mathbf{C}$$

We can extend similar reasoning to solve for $$\vec{c}_y$$.
Writing the equation solving for $$c_0$$ through $$c_3$$ in matrix form:

$$
\underbrace{
    \begin{bmatrix}
    1 & 0 & 0 & 0 \\
    0 & 1 & 0 & 0 \\
    1 & 1 & 1 & 1 \\
    0 & 1 & 2 & 3
    \end{bmatrix}
}_{A}

\underbrace{
    \begin{bmatrix}
    c_0 \\ c_1 \\ c_2 \\ c_3
    \end{bmatrix}
}_{\vec{c}_y}

=

\underbrace{
    \begin{bmatrix}
    g(0) \\ g'(0) \\ g(1) \\ g'(1)
    \end{bmatrix}
}_{\vec{g}_y}
$$

Also, let's define

$$\vec{g}_u = A \vec{c}_u = \begin{bmatrix} 0 \\ 1 \\ 1 \\ 1 \end{bmatrix} \to
\mathbf{G} = \begin{bmatrix} 0 & g(0) \\ 1 & g'(0) \\ 1 & g(1) \\ 1 & g'(1) \end{bmatrix}$$

Now, we can succintly write that $$A \mathbf{C} = \mathbf{G}$$.
Solving for $$\mathbf{C}$$, we get $$\mathbf{C} = A^{-1} \mathbf{G}$$.
Combining our matrix equations, we have:

$$\mathbf{Q} = B^{-1} A^{-1} \mathbf{G}$$

Finally, let's write $$\mathbf{G}$$ in terms of $$f(x)$$.
We said that $$g(u) = f(x_0 + u(x_1 - x_0))$$.
Its derivative is then:

$$g'(u) = (x_1 - x_0) f'(x_0 + u(x_1 - x_0))$$

There's a scale factor out front due to the chain rule.
Plugging into $$\mathbf{G}$$, we get:

$$\mathbf{G} = \begin{bmatrix}
0 & f(x_0) \\
1 & (x_1 - x_0) f'(x_0) \\
1 & f(x_1) \\
1 & (x_1 - x_0) f'(x_1) \\
\end{bmatrix}$$

We're so close!
Let's rush over to [Wolfram Alpha][wolfram] to compute $$B^{-1} A^{-1}$$:

$$
B^{-1} A^{-1} = \begin{bmatrix}
1 & 0 & 0 & 0 \\
1 & 1/3 & 0 & 0 \\
0 & 0 & 1 & -1/3 \\
0 & 0 & 1 & 0
\end{bmatrix}
$$

Now we can compute $$\mathbf{Q}$$:

$$
\mathbf{Q} = B^{-1} A^{-1} \mathbf{G} = \begin{bmatrix}
0 & f(x_0) \\[6pt]
\frac{1}{3} & f(x_0) + \frac{x_1 - x_0}{3} f'(x_0) \\[6pt]
\frac{2}{3} & f(x_1) - \frac{x_1 - x_0}{3} f'(x_1) \\[6pt]
1 & f(x_1)
\end{bmatrix}
$$

And to wrap things up, we can read off the $$\vec{Q}_k$$ entries and compute the final control points $$\vec{P}_k$$.

$$
\begin{aligned}
\vec{P}_0 &= \left< { x_0, f(x_0) }\right> \\
\vec{P}_1 &= \left< { \tfrac{2}{3} x_0 + \tfrac{1}{3} x_1, f(x_0) + \tfrac{x_1 - x_0}{3} f'(x_0) } \right> \\
\vec{P}_2 &= \left< { \tfrac{1}{3} x_0 + \tfrac{2}{3} x_1, f(x_1) - \tfrac{x_1 - x_0}{3} f'(x_1) } \right> \\
\vec{P}_3 &= \left< { x_1, f(x_1) } \right> \\
\end{aligned}
$$

### Interpreting the Control Points

[wolfram]: https://www.wolframalpha.com/input?i2d=true&i=invert%5C%2840%29%7B%7B1%2C0%2C0%2C0%7D%2C%7B-3%2C3%2C0%2C0%7D%2C%7B3%2C-6%2C3%2C0%7D%2C%7B-1%2C3%2C-3%2C1%7D%7D%5C%2841%29*invert%5C%2840%29%7B%7B1%2C0%2C0%2C0%7D%2C%7B0%2C1%2C0%2C0%7D%2C%7B1%2C1%2C1%2C1%7D%2C%7B0%2C1%2C2%2C3%7D%7D%5C%2841%29

{% include todo.html content="make connection to sample rate when discussing segment size" %}
