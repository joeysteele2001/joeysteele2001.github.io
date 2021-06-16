---
title: Algebra with Ducks
author: Joey Steele
date: June 14, 2021
math: true
tags: math spam ducks
extra_css: cayley
---

Let's continue developing our new duck numbers!
Algebra, but with a twist!

## Recap from Part 1

$$\gdef\zero{\text{🥚}} \gdef\one{\text{🦆}} \gdef\idk{?} \gdef\inv#1{#1^{\tiny -1}}$$

Last time, we made a new number system (specifically, a *field*).
But the only numbers were $\zero$ and $\one$.
Zero and one.

The numbers have addition and multiplication defined as well.
Here are the addition and multiplication tables:

{% capture tables %}
| $+$     | $\zero$ | $\one$  |
|---------|---------|---------|
| $\zero$ | $\zero$ | $\one$  |
| $\one$  | $\one$  | $\zero$ |
{:.cayley-table}

| $\times$ | $\zero$ | $\one$  |
|----------|---------|---------|
| $\zero$  | $\zero$ | $\zero$ |
| $\one$   | $\zero$ | $\one$  |
{:.cayley-table}
{% endcapture %}
{% assign tables = tables | markdownify %}

{% include side-by-side.html content=tables %}

We had a few more operations and interesting properties:

* **Negation**: $-a = a$
* **Reciprocal**: $\inv{\one} = \one$ ($\zero$ has no inverse)
* **Subtraction**: $a - b = a + (-b)$
* **Division**: $a / b = a \times \inv{b}; \quad b \ne \zero$
* Addition and subtraction are identical! $a - b = a + (-b) = a + b$
* A number plus itself is always zero: $a + a = a + (-a) = \zero$
* A number times itself is always itself: $a \times a = a$

It seems crazy, but everything checks out mathematically.
Our ducks and eggs form a field, so we can do a lot of normal math with them!
Such as...

## Algebra

It can be easy to take algebra for granted.
But let's take a step back and realize: we can solve an equation for an unknown *identically* to the way we do with "real numbers"!

Let's say you wanted to know

TODO finish this section

### Exponents

Let's look at another equation: $x \times x = x$.
Simple enough.
Let's try and solve it, multiplying both sides by $\inv{x}$:

$$x \times x \times \inv{x} = x \times \inv{x}$$

We now have two possible cases: either $x$ has an inverse, or it doesn't.
Let's consider each one.

If $x$ has an inverse, the equation simplifies to: $x \times \one = \one$, or $x = \one$.
If $x$ has no inverse, then $x = \zero$, since that is the only number that has no inverse.
Either way, we find that $x \times x = x$ is true for *all* duck-numbers $x$.
Further, this means that we can simplify any chain of $x \times x \times x \times \cdots$ into $x$.

Now let's quickly talk about notation.
We know that repeated multiplication is usually written like $x^3$, using integer exponents.
But, at the beginning of this whole adventure, we said that integers no longer exist.
So we're going to make a compromise.
It's *possible* to write $x \times x \times x$ all over the place, *but* we'll allow integer exponents for convenience.
This doesn't change our new numbers at all; we could just as easily write $x^\gamma$ or $x^\nearrow$ instead of $x^3$.
In this case, the integers are merely symbols.

So, our short tangent aside, let's return to our last finding: $x \times x \times x \times \cdots = x$.
We can instead write this as $x^k = x$ for all integers $k > 0$.
That's all to say, multiplying a number to itself does absolutely nothing!

## Polynomials

Since multiplying a number to itself does nothing, then shouldn't something like:

$$x^4 + x^2 + x + \one$$

collapse down to $x + x + x + \one = x + \one$?
If so, doesn't that make polynomials effectively pointless?

If $x$ is a duck-number, then yes, there's no reason to write out a whole polynomial.
But what if we say that $x$ could be *anything*?
What if each $x^k$ is its own unique entity, with no particular meaning?

It turns out that once again, this checks out mathematically!
Polynomials don't *have* to be evaluated.
They are mathematical objects in their own right.
And quite interesting ones, as we'll see!

Our duck polynomials follow the same rules as normal polynomials.
The only difference is that the coefficients can only be either $\one$ or $\zero$.
So, for example, we can add $x^2 + x$ with $x + \one$ and get:

$$(x^2 + x) + (x + \one) = x^2 + (x + x) + \one = x^2 + \one$$

As you can see, the $x$ terms cancel each other.

Multiplication also works the same way as normal.
For example:

$$\begin{aligned}
&(x^2 + x) (x + \one) \\
&= x^2 \cdot x + x^2 \cdot \one + x \cdot x + \one \cdot \one \\
&= x^3 + \one x^2 + \zero x + \zero \\
&= x^3 + x^2
\end{aligned}$$

### Duck-Polynomial Notation

Let's simplify our notation a bit.
Condider this general polynomial: $a_3 x^3 + a_2 x^2 + a_1 x + a_0$, where $a_k$ are each duck-numbers.
We could fully represent this as a list of numbers: $[a_3, a_2, a_1, a_0]$.
The powers of $x$ are implied.

Now let's consider a specific duck-polynomial: $\one x^3 + \zero x^2 + \one x + \zero$.
Again, we could write it like: $[\one, \zero, \one, \zero]$.
But we don't even need the commas or braces!
We can unambiguously write that polynomial as $\one\zero\one\zero$.
So in general, a duck-polynomial can be written down by appending each of the duck-coefficients in order.
As a reverse example, $\one\one\zero\one\zero\one = x^5 + x^4 + x^2 + \one$.

### Teaser for Part 3

For fun, try taking a duck-polynomial and replacing all $\zero$ with $0$ and $\one$ with $1$.
Then, plug in $2$ for $x$.
Is it possible to reach every positive integer with the right combination of enough ducks and eggs?
Does this remind you of another widely-used number system?

Stay tuned for more, with our surprising real-world application!
