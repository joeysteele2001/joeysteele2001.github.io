---
title: A Field of Ducks
series-id: field-of-ducks
series-index: 1
author: Joey Steele
date: June 11, 2021
math: true
tags: math spam ducks
extra_css: cayley
published: true
description: We make a new mathematical field (number system) using only emoji characters.
---

Oh no!
We've lost all of our numbers!
Math is forever broken.
Let's make our own simple system, *with ducks*.

## Meet the Cast

$$\gdef\zero{\text{🥚}} \gdef\one{\text{🦆}} \gdef\idk{?} \gdef\inv#1{#1^{\tiny -1}}$$

Our first character is zero.
Nothing.
A goose egg.
Literally!

$$\Huge{\zero}$$

Zero doesn't seem like a big deal.
But as with geese, it makes sure to come out and show you how important it is.

Our second persona is a duck.
Ducks are better than zero.
They are *number one*!

$$\Huge{\one}$$

Our duck makes our numbers interesting.
Now we have more than just "nothing".

But that's it!
We'll only have two numbers.
We don't need any more.
Just $$\zero$$ and $$\one$$ along for this journey.

## Operations

Numbers aren't very fun on their own!
We need to do some math with them.
Let's start from the beginning with *addition*.

(Quick note: for the rest of this article, $$a$$, $$b$$, and $$c$$ will refer to any arbitrary number, $$\zero$$ or $$\one$$.)

### Addition

We won't get *too* exotic here.
We'll use the plus sign ($$+$$) for adding numbers.
We could define addition however we want, but let's force our number system to follow similar properties we already know.
That way, our number system will follow our intuition as much as possible.
We'll fill in this addition table as we go:

| $$+$$     | $$\zero$$ | $$\one$$ |
|-----------|-----------|----------|
| $$\zero$$ | $$\idk$$  | $$\idk$$ |
| $$\one$$  | $$\idk$$  | $$\idk$$ |
{:.cayley-table}

Early on in school, we learned that addition is *commutative*.
This means $$a + b = b + a$$.
Great!
That...
Doesn't tell us much.

Oooh!
We also learned that adding zero to something does nothing.
So addition has an *identity* element.
Our "zero" should be a goose egg: $$\zero$$.
So now we know that $$a + \zero = a$$.

This unlocks three of our four addition table entries!

$$\begin{gathered}
\zero + \zero = \zero & \text{(definition of identity)} \\
\one + \zero = \one & \text{(definition of identity)} \\
\zero + \one = \one & \text{(commutativity)} \\
\end{gathered}$$

| $$+$$     | $$\zero$$     | $$\one$$     |
|-----------|---------------|--------------|
| $$\zero$$ | **$$\zero$$** | **$$\one$$** |
| $$\one$$  | **$$\one$$**  | $$\idk$$     |
{:.cayley-table}

We still need one more property to fill in the last entry.
This last one is a bit less intuitive.
Remember that a number ($$x$$) plus its negative ($$-x$$) always gives you zero?
Let's make our numbers have this same property!
Instead of "negative", we'll call it the *additive inverse*.
Every number $$a$$ has an additive inverse $$-a$$, and $$a + (-a) = \zero$$.

So, what is $$\one + \one$$?
Let's assume, for the sake of argument, that $$\one + \one = \one$$.
If that were true, then $$\one$$ would have no additive inverse!
So $$\one + \one$$ must equal $$\zero$$.
Let's fill that into our table:

$$\one + \one = \zero$$

| $$+$$     | $$\zero$$ | $$\one$$      |
|-----------|-----------|---------------|
| $$\zero$$ | $$\zero$$ | $$\one$$      |
| $$\one$$  | $$\one$$  | **$$\zero$$** |
{:.cayley-table}

Interestingly, both $$\zero$$ and $$\one$$ are their own inverses!
In general, this means that $$-a = a$$, or $$a + a = a - a = 0$$.

One last interesting property that our addition follows is *associativity*.
This one seems pretty obvious, but in general, notice that:

$$(a + b) + c = a + (b + c)$$

That's it for addition!
Let's advance forward.

### Multiplication

Once again, we won't get too exotic with multiplication.
We'll use a "times sign" ($$\times$$) for it.

Our multiplication can follow many similar properties as addition.
We'll say it is:

* commutative: $$a \times b = b \times a$$,
* and associative: $$(a \times b) \times c = a \times (b \times c)$$.

Let's also make $$\one$$ our multiplicative *identity* so that $$a \times \one = a$$.

Once again, we've unlocked three entries in our table!

$$\begin{gathered}
\zero \times \one = \zero & \text{(definition of identity)} \\
\one \times \zero = \zero & \text{(commutativity)} \\
\one \times \one = \one & \text{(definition of identity)} \\
\end{gathered}$$

| $$\times$$ | $$\zero$$     | $$\one$$      |
|------------|---------------|---------------|
| $$\zero$$  | $$\idk$$      | **$$\zero$$** |
| $$\one$$   | **$$\zero$$** | **$$\one$$**  |
{:.cayley-table}

We can also define a multiplicative *inverse*: $$\frac{1}{a}$$, or $$a^{\tiny -1}$$.
Remember that zero doesn't have an inverse, since division by zero is undefined.
So, every non-$$\zero$$ number $$a$$ has a multiplicative inverse $$a^{\tiny -1}$$, and $$a \times a^{\tiny -1} = \one$$.
In other words, $$\one \times e^{\tiny -1} = \one$$.

What is $$e^{\tiny -1}$$?
Reading off our table, only $$\one \times \one = \one$$.
So $$\one$$ is its own inverse: $$e^{\tiny -1} = \one$$.

We still don't know $$\zero \times \zero$$!
For that, let's remember one more property: *distributivity*.

In algebra, distributivity is often quite helpful.
It says that "multiplication distributes over addition", meaning $$a \times (b + c) = (a \times b) + (a \times c)$$.
Let's make our numbers follow this property too!

Now let's assume, for the sake of argument, that $$\zero \times \zero = \one$$.
If that's true, then:

$$\begin{aligned}
\zero \times (\zero + \one) &= (\zero \times \zero) + (\zero \times \one) \\
\zero \times \one &= \one + \zero \\
\zero &= \one \\
\end{aligned}$$

Obviously that's wrong, so $$\zero \times \zero$$ must equal $$\zero$$.
Fill in the final table slot!

$$\zero \times \zero = \zero$$

| $$\times$$ | $$\zero$$     | $$\one$$  |
|------------|---------------|-----------|
| $$\zero$$  | **$$\zero$$** | $$\zero$$ |
| $$\one$$   | $$\zero$$     | $$\one$$  |
{:.cayley-table}

## The Field of Ducks

At this point, you probably think that we've done something completely ridiculous and stupid.
On the one hand, you're right, this is ridiculous.
But we have actually just recreated the simplest mathematical [field][link-field] possible.

But what *is* a field?
I could give a strict mathematical definition, but we've already done most of that.
Instead, think about the numbers that don't exist anymore (like "real numbers").
The "real numbers" have all of the properties that we decided to give our new numbers.
They have commutativity, associativity, inverses and identities over addition and multiplication, as well as distributivity of multiplication over addition.

These "properties" are what make a field a field.
Mathematicians call them *axioms*, which are basically the rules of the game.
In this case, the game is "being a field".

So what do we get out of being a field?
Well, for one, all basic algebra automatically applies to our ducks!
So it's completely valid to solve this equation:

$$\begin{aligned}
(\one \times x) + \one &= \zero \\
x + \one &= \zero & &\text{(identity)} \\
x + \one - \one &= \zero - \one & &\text{(subtract both sides)} \\
x &= \zero + (-\one) & &\text{(subtraction is addition)} \\
x &= \zero + \one & &\text{(inverse is self)} \\
x &= \one & &\text{(identity)} \\
\end{aligned}$$

Things like vectors and matrices apply as well!

$$\begin{bmatrix}
\one & \one \\
\zero & \one \\
\end{bmatrix} \cdot \begin{bmatrix}
\one \\ \one
\end{bmatrix} = \begin{bmatrix}
\zero \\ \one
\end{bmatrix}$$

We can even do matrix row-reduction with ducks!

{% capture detail-content %}
Let's solve the matrix equation $$A \vec{x} = \vec{b}$$, where:

$$\begin{gathered}
A = \begin{bmatrix} \one & \one \\ \zero & \one \end{bmatrix} \\
\vec{b} = \begin{bmatrix} \zero \\ \one \end{bmatrix}
\end{gathered}$$

We'll use row reduction with an augmented matrix to solve this.

$$\begin{bmatrix}
\one & \one & | & \zero \\
\zero & \one & | & \one
\end{bmatrix} \sim \begin{bmatrix}
\one - \zero & \one - \one & | & \zero - \one \\
\zero & \one & | & \one
\end{bmatrix} \sim \begin{bmatrix}
\one & \zero & | & \one \\
\zero & \one & | & \one
\end{bmatrix}$$

Reading off the right side of the augmented matrix, we see that:

$$\vec{x} = \begin{bmatrix} \one \\ \one \end{bmatrix}$$

It's even valid to solve $$A \vec{x} = \vec{b}$$ by taking $$A^{\tiny -1}$$:

$$ \vec{x} = A^{\tiny -1} \vec{b} $$

We can compute the inverse of a $$2 \times 2$$ matrix like so:

$$\begin{gathered}
A = \begin{bmatrix} a & b \\ c & d \end{bmatrix} \\
A^{\tiny -1} = \frac{\one}{ad - bc} \begin{bmatrix} d & -b \\ -c & a \end{bmatrix}
\end{gathered}$$

So, for our equation:

$$\begin{aligned}
\vec{x} &= A^{\tiny -1} \vec{b} \\
&= \frac{\one}{(\one \times \one) - (\one \times \zero)}
    \begin{bmatrix} \one & -\one \\ -\zero & \one \end{bmatrix}
    \begin{bmatrix} \zero \\ \one \end{bmatrix} \\
&= \frac{\one}{\one - \zero}
    \begin{bmatrix} \one & \one \\ \zero & \one \end{bmatrix}
    \begin{bmatrix} \zero \\ \one \end{bmatrix} \\
&= \frac{\one}{\one}
    \begin{bmatrix}
        (\one \times \zero) + (\one \times \one) \\
        (\zero \times \zero) + (\one \times \one)
    \end{bmatrix} \\
&= \one \cdot \begin{bmatrix} \zero + \one \\ \zero + \one \end{bmatrix} \\
&= \begin{bmatrix} \one \\ \one \end{bmatrix}
\end{aligned}$$
{% endcapture %}
{% assign detail-content = detail-content | markdownify %}

{% include details.html content=detail-content %}

[link-field]: https://en.wikipedia.org/wiki/Field_(mathematics) "Field (mathematics) - Wikipedia"

## Stay Tuned

We now know what a field is, and we now have a field of ducks and eggs!
Stay tuned for Part 2, where we'll play with algebra and make bigger numbers with our ducks and eggs.
