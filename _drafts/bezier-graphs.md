---
author: Joey Steele
title: Bezier Graphs
series-id: banner
series-index: 2
date: May 19, 2022
math: true
code: true
---

In these next few posts, I work out how to draw the graph of a sum of sinusoids as a sequence of Bézier curves.
There's a good bit of math involved, but the final answer is pretty simple!

## Intro

One graphic I really want in my SVG social media banner is one that shows additive synthesis.
Starting out with one sinusoid, slowly a more complex wave shape is built up by adding higher frequency sinusoids.

Sort of like the waves on the right of this image, but with all the intermediate steps overlaid on each other.

![Synthesis of a bandlimited sawtooth wave, starting from the fundamental frequency, adding up to 20 harmonics.](https://www.sfu.ca/sonic-studio-webdav/handbook/Graphics/Law_of_Superposition.gif)

That should be pretty straightforward then!
All I should have to do to generate these graphs in an SVG is:

* look up the [Fourier series](https://en.wikipedia.org/wiki/Fourier_series) coefficients for a sawtooth wave
* write some code to generate values of the wave for a given number of harmonics
* get $$N$$ evenly spaced sample values, for some sufficiently large value of $$N$$
* connect these samples with straight lines

It might take a couple hours, but it should be pretty simple.
**But!**
A little voice inside me is nagging.
"You're making a vector-based graphic.
Zoom in close enough, and you'll see---[*shudders*]---it's not a smooth curve!"

...I couldn't help myself.
Those straight lines would've been so easy.
But you can have real curves in vector graphics!
You can zoom in as far as you want.
Finding the values for the curves is more interesting than straight lines.
And in the end, there'll be smooth curves all the way down.

{% include details.html
    summary="If you're just looking for the final answer, here it is!"
    content="
Call the original curve $$f(x)$$.
It will be fit between $$x_0 \le x \le x_1$$.
Define the variables $$y_0 = f(x_0)$$, $$y_1 = f(x_1)$$, $$y'_0 = f'(x_0)$$, and $$y'_1 = f'(x_1)$$, where $$f'(x)$$ is the derivative of $$f(x)$$.
Then, the control points $$\vec{P}_0$$, $$\vec{P}_1$$, $$\vec{P}_2$$, $$\vec{P}_3$$ for the Bézier curve that approximates the curve between $$x_0 \le x \le x_1$$ are as follows:

$$\begin{aligned}
\vec{P_0} &= \begin{bmatrix}x_0 \\ y_0\end{bmatrix} \\
\vec{P_1} &= \begin{bmatrix}2/3\ x_0 + 1/3\ x_1 \\ y_0 + 1/3 (x_1 - x_0) y'_0\end{bmatrix} \\
\vec{P_2} &= \begin{bmatrix}1/3\ x_0 + 2/3\ x_1 \\ y_1 - 1/3 (x_1 - x_0) y'_1\end{bmatrix} \\
\vec{P_3} &= \begin{bmatrix}x_1 \\ y_1\end{bmatrix}
\end{aligned}$$
    "
 %}

## Splitting up The Problem

{% include todo.html content="describe the three parts of the problem" %}

In an ideal world, vector graphics formats would let me say, "please put a sine wave *here*," and that would be that.
Unfortunately, SVG, like most formats, only gives a few *primitives* to work with.
Everything has to be built up from there.

In the case of SVG, the only real curved line primitives are ellipse arcs and Bézier curves.
Arcs are pretty limited in how they can be used, and they wouldn't handle sinusoids well.
So that leaves Bézier curves as our only choice.

### What is a Bézier Curve?

![A Bézier curve and its control points.](https://upload.wikimedia.org/wikipedia/commons/d/d0/Bezier_curve.svg){: style="background-color:white" }

{% include todo.html content="describe bezier curves" %}

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
