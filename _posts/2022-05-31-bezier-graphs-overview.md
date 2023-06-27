---
author: Joey Steele
title: Bézier Graphs, Part 1
subtitle: Overview
series-id: banner
series-index: 2
date: May 31, 2022
math: true
published: false
---

In these next couple posts, I work out how to draw the graph of a sum of sinusoids as a sequence of Bézier curves.
This post gives an overview of the problem, and I work out the math in the next post.

## Intro

One graphic I really want in my SVG social media banner is a visual for additive synthesis.
Starting out with one sinusoid, slowly a more complex wave shape is built up by adding higher frequency sinusoids.

Sort of like the waves on the right of this image, but with all the intermediate steps overlaid on each other.

![Synthesis of a bandlimited sawtooth wave, starting from the fundamental frequency, adding up to 20 harmonics.](https://www.sfu.ca/sonic-studio-webdav/handbook/Graphics/Law_of_Superposition.gif)

That should be pretty straightforward then!
All I should have to do to generate these graphs in an SVG is:

* look up the [Fourier series](https://en.wikipedia.org/wiki/Fourier_series) coefficients for a sawtooth wave
* write some code to generate values of the wave for a given number of harmonics
* get $$N$$ evenly-spaced sample values, for some sufficiently large value of $$N$$
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

{% capture final_answer_content %}
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
{% endcapture %}

{% include details.html
    summary="If you're just looking for the final answer, here it is!"
    content=final_answer_content %}

## Splitting up The Problem

In an ideal world, vector graphics formats would let me say, "please put a sine wave *here*," and that would be that.
Unfortunately, SVG, like most formats, only gives a few *primitives* to work with.
Everything has to be built up from there.

In the case of SVG, the only real curved line primitives are ellipse arcs and Bézier curves.
Arcs are pretty limited in how they can be used, and they wouldn't handle sinusoids well.
So that leaves Bézier curves as our only choice.
We'll represent the graph as a sequence of cubic Bézier curves strung together.
Instead of each piece of the graph being a little line, it'll be a little Bézier curve!

### What is a Bézier Curve?

[Video: The Beauty of Bézier Curves by Freya Holmér](https://youtu.be/aVwxzDHniEw){: #bezier-video}

Bézier curves are ubiquitous in graphics.
They're fairly simple computationally.
They're also pretty easy for humans to understand, and they can make almost any curved shape!
Most graphics formats support *cubic* Bézier curves, which are defined by four points: the two endpoints, and two other *control points* that determine the shape of the curve.
In the picture below, $$P_0$$ and $$P_3$$ are the endpoints, and $$P_1$$ and $$P_2$$ are the control points.
(Technically, all four points are considered control points.)

![A Bézier curve and its control points.](https://upload.wikimedia.org/wikipedia/commons/d/d0/Bezier_curve.svg){: style="background-color:white" }

Bézier curves are defined mathematically using a vector equation.
If the control points are the vectors $$\vec{P}_0$$, $$\vec{P}_1$$, $$\vec{P}_2$$, and $$\vec{P}_3$$, then the equation for a Bézier curve is:

$$\vec{P}(t) = (1-t)^3 \vec{P}_0 + 3 t (1-t)^2 \vec{P}_1 + 3 t^2 (1-t) \vec{P}_2 + t^3 \vec{P}_3$$

When $$t = 0$$, the graph is at the starting point $$\vec{P}_0$$.
It hits the end of the curve $$\vec{P}_3$$ when $$t = 1$$.
In between, it smoothly passes near the other control points.
I encourage you to watch some of the animations from [the video linked above](#bezier-video) to get a better visual intuition for what's going on.
(In fact, the whole video is a great intro for the math behind Bézier curves!)

### The Parts of the Problem

In order to represent a mathematical graph as a sequence of Bézier curves, we need to refine the problem first.
To start, we're only going to consider one small segment of the graph at a time.
Stringing together many curves will be pretty straightforward.

Let's be more specific now.
First of all, let's give a name to the function we're going to plot: $$f(x)$$.
It turns out, none of the math relies on the curve having any properties in particular, so we'll allow any (differentiable) function here.
Next, we'll call the "start" and "end" points of the segment $$x_0$$ and $$x_1$$.
Finally, $$P(t)$$ will be the Bézier curve that approximates $$f(x)$$ between $$x_0$$ and $$x_1$$.
The control points of $$\vec{P}$$ are $$\vec{P}_0$$, $$\vec{P}_1$$, $$\vec{P}_2$$, and $$\vec{P}_3$$.

So our problem boils down to finding the values for the control points, given $$f(x)$$, $$x_0$$, and $$x_1$$.
I'll work out the math in the next post, but here's an overview for how I solve it:

* First, we transform the segment to run between $$x = 0$$ and $$x = 1$$.
* Next, we find a cubic polynomial (one step up from a quadratic) that approximates the segment.
* Then, we compute the control points of the Bézier curve which precisely matches this cubic.
* Finally, we transform those control points back to the position of the original segment.

The reason I don't just directly solve the problem is that the math gets very messy and too complicated to work out by hand.
With the setup above, the numbers stay pretty simple, and we can rely on computers to do some of the work by using matrices.
If matrices and linear algebra scare you, don't worry: they don't take center stage, and I'm just using them as a tool to lighten the mathematical load on myself.

With that being said, I hope you stick around for the next post, where I'll solve the problem as I listed above!
