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

TODO exponentiation does nothing

## Polynomials

Since multiplying a number by itself does nothing, then shouldn't something like:

$$x^4 + x^2 + x + \one$$

collapse down to $x + x + x + \one = x + \one$?
If so, doesn't that make polynomials effectively pointless?

If $x$ is a duck-number, then yes, there's no reason to write out a whole polynomial.
But what if we say that $x$ could be *anything*?
(Well, anything that can be plugged into the polynomial and can interact with our duck-numbers.)
What if each $x^k$ is its own unique entity, with no particular meaning?

It turns out that once again, this checks out mathematically!

TODO finish this section too
