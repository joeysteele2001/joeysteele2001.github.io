---
title: Orbital Dynamics
subtitle: Numerically Modelling the Orbit of Comet 67P
author: Joseph Steele
date: July 19, 2020
math: true
---

## Introduction

This project models the trajectory of the orbit of Comet 67P around the sun using differential equations.
The model is derived from Newton's universal law of gravitation and his second law of motion.
The resultant differential equation is a nonlinear, second-order vector equation.
The solutions produced by four numerical techniques are then compared.
Each numerical solution is checked against the principle of angular momentum in order to assess the quantitative accuracy of each method.

## Model

The model is based on Newton's second law: $\vec{F} = m \vec{a}$, which states that the vector force on an object is proportional to its vector acceleration.
Denoting $\vec{v}$ as velocity and $\vec{r}$ as position, by definition, $\vec{a} = \frac{d}{dt} \vec{v} = \frac{d^2}{dt^2}  \vec{r}$, so $\vec{F} = m \vec{r}''$.
The force of gravity $\vec{F}_g$ on Object 1 by Object 2 is observed to be $\vec{F}_g = -G m_1 m_2 \frac{\vec{r}}{|\vec{r}|^3}$.
Here, $\vec{r}$ is the position of one object relative to the other, $m_i$ are the masses of the two objects, and $G$ is a universal constant ($G = 6.67 \times 10^{-11} \, \mathrm{m^3 \, kg^{-1} \, s^{-2}}$) [@nist-g].
The notation $|\vec{r}|$ refers to the magnitude of $\vec{r}$.

To create the model, we start with a few assumptions:

* The sun is fixed at the origin, $\vec{r} = \vec{0}$.
* The force of the comet on the sun is negligible compared to the sun's mass (such that the sun does not move).
* The sun and the comet are the only two objects in the universe.
* Gravity is the only force acting on the sun and comet.

Now we can find an equation describing the comet's motion.
Equating $\vec{F_g} = m \vec{a}$, $m \vec{r}'' = -GMm \frac{\vec{r}}{|\vec{r}|^3}$ (here $M$ is the mass of the sun and $m$ is the mass of the comet).
Therefore:
$$ \vec{r}'' = -GM \frac{\vec{r}}{|\vec{r}|^3} $$
This is a second-order nonlinear ordinary differential equation in $\vec{r}$.
It is also autonomous because the right-hand side does not depend on $t$.

### Converting to first-order

While this model is elegant, it poses a couple of problems for the numerical methods we will use.
First, the equation is second-order, but the numerical methods expect a first-order equation of the form $\vec{y}' = \vec{f}(t, \vec{y})$.
Second, the model is written in terms of vectors, so the usual method of converting a second-order equation to a first-order system would produce "vectors of vectors".
To fix these problems, we rewrite the model as a system of second-order equations in terms of the components of $\vec{r}$.
Since there are only two physical objects interacting, we can constrain the comet's motion to the xy-plane.

Let us write $\vec{r}$ as $<r_x, r_y>$ and $\vec{v} = \vec{r}'$ as $<v_x, v_y>$.
Then, $|\vec{r}| = ( r_x^2 + r_y^2 )^{1/2}$.
Now, the model is the system:

$$
\begin{aligned}
r_x'' = -GM \frac{r_x}{( r_x^2 + r_y^2 )^{3/2}} \\
r_y'' = -GM \frac{r_y}{( r_x^2 + r_y^2 )^{3/2}}
\end{aligned}
$$

Next, we define $\vec{s}$, the comet's "state vector":

$$
\vec{s} =
\begin{bmatrix}
    s_{1x} \\ s_{1y} \\ s_{2x} \\ s_{2y}
\end{bmatrix}
=
\begin{bmatrix}
    r_x \\ r_y \\ r_x' \\ r_y'
\end{bmatrix}
\implies
\vec{s}' =
\begin{bmatrix}
    s_{1x}' \\ s_{1y}' \\ s_{2x}' \\ s_{2y}'
\end{bmatrix}
=
\begin{bmatrix}
    s_{2x} \\ s_{2y} \\
    -G M s_{1x} ( s_{1x}^2 + s_{1y}^2 )^{-3/2} \\
    -G M s_{1y} ( s_{1y}^2 + s_{1y}^2 )^{-3/2}
\end{bmatrix}
= \vec{f}(\vec{s})
$$

This new equation is of the form $\vec{s}' = \vec{f}(\vec{s})$, so we directly apply it to the numerical methods used.
The differential equation remains nonlinear, so it is no easier to solve analytically.

## Numerical Solutions

To obtain numerical solutions for this model, we implement the following methods:

* Euler's method
* Improved Euler's method (Heun method)
* Runge-Kutta method
* Euler-Cromer method

The first three methods are described in Chapter 8 of the textbook.
The fourth is described below.

I wrote the code for all the numerical methods from scratch so that I could easily support vector equations.
The relevant code to generate the solutions, plus a link to the full source code, are listed in the [Appendix](#code-listings).

### Initial conditions

For all the solutions, define the x-axis to be the major axis ("long axis") of the orbit.
The y-axis is the minor axis ("short axis") of the orbit.
The initial conditions are $\vec{r}(0) = <r_a, 0>$ and $\vec{v}(0) = <0, v_a>$, where $r_a$ is the *aphelion* (furthest distance from the sun) and $v_a$ is the speed of the comet at the aphelion.
$r_p$ and $v_p$ are the corresponding quantities for the *perihelion* (closest distance to the sun).
I could not find $v_a$ for Comet 67P published directly, so it is calculated from the aphelion and perihelion using $v_a = \sqrt{\frac{2 M G r_p}{r_a (r_a + r_p)}}$.
A derivation for this formula is located in the [Appendix](#derivation-of-aphelion-speed).

In the case of Comet 67P, the values of the initial condition parameters are:

* $r_a = 849.7 \times 10^9 \, \mathrm{m}$ [@esa-67p]
* $v_a = 7.487 \times 10^3 \, \mathrm{m / s}$

### Accuracy

A convenient method to check the accuracy of the numerical solutions uses the principle of angular momentum, which predicts that the angular momentum of the comet should remain constant at all times.

The principle of angular momentum states that the rate of change of angular momentum ($\vec{L}$) equals net torque: $d\vec{L}/dt = \vec{\tau}_\mathrm{net}$.
*Torque* $\vec{\tau}$ on an object due to a force $\vec{F}$ is $\vec{\tau} = \vec{r} \times \vec{F}$ ("$\times$" is the *cross product* operator).
The force of gravity is of the form $F = k \vec{r}$, which is always in the opposite direction to position.
This means that torque due to gravity is $\tau = r m |k| r \sin \pi = 0$, by the definition of the cross product.
By the principle of angular momentum, $d\vec{L}/dt = 0$, meaning that the angular momentum of an object affected by only gravity should be constant.

Because the model estimates position *and* velocity for each point in time, we can compare angular momentum at any point with initial angular momentum using the quotient $L(t)/L(0)$.
To calculate angular momentum at a given point, use $\vec{L} = \vec{r} \times m \vec{v}$.
Since $\vec{r}$ and $\vec{v}$ are always in the xy-plane, the cross product is simply $\vec{r} \times m \vec{v} = m <0, 0, r_x v_y - r_y v_x>$.
When dividing $L(t)$ by $L(0)$, the mass cancels, so $\frac{L(t)}{L(0)} = \frac{\vec{r}(t) \times \vec{v}(t)}{\vec{r}(0) \times \vec{v}(0)}$.
Since the quotient is 1 if there is no error, we use the term *percent error* to mean $\frac{L(t)}{L(0)} - 1$.

### Description of Euler-Cromer method

The Euler-Cromer method is almost identical to Euler's method, but it applies to the specialized case where velocity affects position and vice versa.
More precisely, it uses the *updated* version of velocity to compute the new position, rather than using the old velocity value.
Numerically:

$$\begin{gathered}
v_{n+1} = v_n + f(r_n) \Delta t \\
r_{n+1} = r_n + v_{n+1} \Delta t
\end{gathered}$$

When applicable, the Euler-Cromer method tends to be significantly more accurate and more stable than the regular Euler's method, and requires no additional computations [@cromer-1981].

This method applies to the comet because position is determined by velocity, and acceleration is determined by position.
For this situation, $v$ and $r$ are vectors, and $\vec{f}(\vec{r}_n)$ is acceleration due to gravity, $-GM \vec{r}_n |\vec{r}_n|^{-3/2}$.

### Results

For all numerical methods, we use a step size of 10 steps per day, and run the model for ten orbits, approximately 67 years.
These parameters give very precise models but produced over 200,000 rows of data for each model.
To compensate, we only sample every 100th data point, which produces identical plots, but greatly reduces the computation time required to produce the plots.

The comet orbit trajectories produced by the numerical methods are plotted in [Figure 1](#img-traj).
These represent the x- and y- coordinates of the comet plotted against each other, visualizing the shape of the orbit.
All four trajectories are approximately elliptical as predicted from real orbits.
Qualitatively, Euler's method appears to spiral out in a positive feedback loop, while the other three methods appear to produce relatively stable trajectories.

Though the qualitative properties of the orbits are somewhat helpful, the percent error values are much more revealing.
[Figure 2](#img-err) plots percent error vs. time.
Euler's method systematically produces a relatively large error, reaching over 3% within 10 orbits.
Improved Euler's method has the same shape, but is several orders of magnitude smaller.
Both Euler's and Improved Euler's methods appear to produce the vast majority of their error when the comet is near the sun, travelling at a high velocity.
The accuracy of these methods may be improved if an adaptive time step is used.

Euler-Cromer and Runge-Kutta produce more chaotic error plots, but with a tiny magnitude peaking at about $2.5 \times 10^{-14}$.
These two methods both recover from the errors they produce, rather than creating a positive feedback loop that eventually spirals out of control.
This suggests that these methods would be far more stable in the long-term.
Although they produce similar errors, Euler-Cromer is significantly less computationally expensive, requiring only one evaluation of $dy/dt$ for each iteration, whereas Runge-Kutta requires four.

<!-- ![Comet trajectories produced by four numerical methods.](img/traj.pdf)

![Percent angular momentum error in trajectories from four numerical methods. *Note that the vertical axes of the plots are different from each other.*](img/err.pdf) -->

## Conclusion

From modeling the orbit of Comet 67P using four numerical methods, we have found that Euler's method and Improved Euler's method do not produce stable predictions, whereas Runge-Kutta and Euler-Cromer are stable and produce very small error.
Euler-Cromer requires far fewer computations than Runge-Kutta for a similar level of accuracy in this situation, so Euler-Cromer would be most suited to model the comet's orbit.
It would be interesting to apply these numerical methods to more complex orbit situations, such as modelling the effects of a large planet on the comet's orbit.
It is also noteworthy that all four simulations of 67 years consistently finished in under 2 seconds on a laptop.
This suggests that for most applications, the differences in computational requirements for the numerical methods is insignificant.

## Appendix

### Derivation of aphelion speed

The formula for aphelion speed $v_a$ mentioned in [Numerical Solutions] is derived from the principle of energy conservation and the principle of angular momentum.
Energy conservation states that, with no external work, there is no net energy change.
That is, if $K$ and $U$ are kinetic and potential energy respectively, then $\Delta K + \Delta U = 0$.
Potential energy due to gravity is $\Delta U = -GMm/|\vec{r}|$.
The angular momentum principle states that the rate of change of angular momentum equals net torque: $d\vec{L}/dt = \vec{\tau}_\mathrm{net}$.
We already know from earlier that angular momentum is constant when two objects interact due to gravity.

From energy conservation, we can compare the aphelion and perihelion:
$$ \frac{1}{2} m (v_p^2 - v_a^2) = m M G \left( \frac{1}{r_p} - \frac{1}{r_a} \right)
\implies
v_p^2 - v_a^2 = 2 M G \left( \frac{1}{r_p} - \frac{1}{r_a} \right)
$$
From angular momentum, $\vec{r}_a \times m \vec{v}_a = \vec{r}_p \times m \vec{v}_p$.
Because $\vec{r}$ and $\vec{v}$ are perpendicular at the perihelion and aphelion, the equation simplifies to $r_a v_a = r_p v_p$ (the products of the *magnitudes* of the vectors).
Substituting $v_p = r_a v_a / r_p$ to the energy conservation equation:
$$ \frac{r_a^2 v_a^2}{r_p^2} - v_a^2 =
2 M G \left( \frac{1}{r_p} - \frac{1}{r_a} \right) \implies
v_a^2 = 2 M G \left( \frac{r_p - r_a}{r_p r_a} \right) \left( \frac{r_p^2}{r_a^2 - r_p^2} \right) $$
$$ v_a^2 = 2 M G \frac{r_p}{r_a (r_a + r_p)} \implies
v_a = \sqrt{\frac{2 M G r_p}{r_a (r_a + r_p)}}$$

### Code listings

I wrote all of the code from scratch in the language Rust.
Note that some of the code in these listings may vary slightly from the full source code for easier readability in this paper.
Most of the functionality for my program is inside library files I wrote.
The heart of the numerical methods code is in `num.rs`.
Each numerical method is defined as a function which takes initial conditions, a time step, and a function for $dy/dt$, and returns an `Iterator` structure.
The numerical method functions simply describe how to compute the next `(t, y)` data point given the previous one.
Listed below are the relevant snippets of the bodies of each of the functions (with boilerplate code removed for readability).

```rust
// Euler's method: next (t, y)
return (t + delta_t, y + dydt(t, y) * delta_t);

// Improved Euler: next (t, y)
let dydt_n = dydt(t, y);
return (
    t + delta_t,
    y + (dydt_n + dydt(t + delta_t, y + dydt_n * delta_t))
      * 0.5 * delta_t
);

// Runge-Kutta: next (t, y)
let k1 = dydt(t, y);
let k2 = dydt(t + 0.5 * delta_t, y + k1 * 0.5 * delta_t);
let k3 = dydt(t + 0.5 * delta_t, y + k2 * 0.5 * delta_t);
let k4 = dydt(t + delta_t, y + k3 * delta_t);
return (
    t + delta_t,
    y + (k1 + k2 * 2.0 + k3 * 2.0 + k4)
      * (delta_t / 6.0)
);

// Euler-Cromer: next (t, y)
let rx = y.0;
let ry = y.1;
let vx = y.2;
let vy = y.3;

let y_new = dydt(t, y);
let vx_new = vx + y_new.2 * delta_t;
let vy_new = vy + y_new.3 * delta_t;
let rx_new = rx + vx_new * delta_t;
let ry_new = ry + vy_new * delta_t;

return (t + delta_t, Vec4(rx_new, ry_new, vx_new, vy_new));
```

The `main.rs` file calls the numerical method functions, takes the appropriate number of iterations to reach 10 orbits, and calls functions to write every 100th data point to a file:

```rust
fn main() {
    let y0 = Vec4(R_A, 0.0, 0.0, V_A);
    do_orbits(0.0, y0, SECS_PER_DAY / 10.0, 10.0 * ORBIT_PERIOD);
}

fn do_orbits(t0: f64, y0: Vec4, delta_t: f64, max_t: f64) {
    // Number of steps to reach max_t
    let num_steps = num_steps(delta_t, t0, max_t);
    let l_initial = angular_momentum(y0);

    let euler = euler(t0, y0, delta_t, dydt_comet)
        .take(num_steps)
        .step_by(100);

    let improved = improved_euler(t0, y0, delta_t, dydt_comet)
        .take(num_steps)
        .step_by(100);

    let cromer = euler_cromer(t0, y0, delta_t, dydt_comet)
        .take(num_steps)
        .step_by(100);

    let rk = runge_kutta(t0, y0, delta_t, dydt_comet)
        .take(num_steps)
        .step_by(100);

    write_orbit_to("data/euler.txt", euler, l_initial);
    write_orbit_to("data/improved.txt", improved, l_initial);
    write_orbit_to("data/cromer.txt", cromer, l_initial);
    write_orbit_to("data/rk.txt", rk, l_initial);
}
```

The file `vector.rs` defines a `Vec4` type to represent vectors with 4 components, with vector addition and scalar multiplication operations.
`util.rs` defines the `num_steps` function used in `main.rs` and a couple functions for writing the data collected.
`physics.rs` defines all the physical constants used, computes angular momentum from an $\vec{s}$ comet state vector, and computes percent error.
Most importantly, it defines $dy/dt$ due to gravity, according to my model:

```rust
/// The rate of change of the comet's state vector
/// at position `y`, due to gravity.
pub fn dydt_comet(_t: f64, y: Vec4) -> Vec4 {
    let s1x = y.0;
    let s1y = y.1;
    let s2x = y.2;
    let s2y = y.3;

    let mag_r = s1x * s1x + s1y * s1y;
    let g_m_mag_s = -G * M * mag_r.powf(-1.5);

    Vec4(s2x, s2y, s1x * g_m_mag_s, s1y * g_m_mag_s)
}
```

Finally, `lib.rs` merely ties together all the library files and makes them available to `main.rs`.

The full source code is available on [GitHub](https://github.com/joeysteele2001/comet).
