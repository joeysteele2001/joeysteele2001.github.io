---
author: Joey Steele
title: Experiments with Writing a Resume with Jekyll
---

Reflections on my *unusual* experiment translating my resume from Word into a single-page static website.

## Background

Recently, I had set about updating my resume.
With COVID and all the associated craziness this past year, it was long overdue.
Turns out, between my first and fifth semester in college, a lot has changed!

My original (out-of-date) copy was written out in a Word `.docx` document.
I already liked the formatting of the document, and I had even used the "styles" feature in an attempt to keep everything uniform.
Even so, I noticed it was quite difficult to change my document.
Bullet points would sometimes be misaligned by default.
Inline styles were difficult to apply.
*Whoopsies, that comma isn't supposed to be italicized!*

Now at this point, it's becoming clear that many word processor features annoy me.
But don't take this as a "Microsoft Word is *bad*" rant.
Word processors are great at handling long, more-uniform text documents.
They're even better at quickly drafting things.
Your spelling and grammar will be checked.
Perhaps best of all, nearly anyone can use word processing software with minimal technical knowledge.

But a resume is a different beast than an essay or a letter or a high school lab report.
With your typical prose writing, almost all the text looks the same: size, color, indentation, spacing, etc.
But a resume?
You'll probably see *at most* 5 consecutive lines formatted the same.
And this is for good reason!
A resume has a lot of dense information packed into one page, and each piece of information might serve very different functions.
For example, the name of a previous employer and the dates you worked for them are very different, yet they'll likely sit close together.

With a word processor, I was finding that adding new items required a lot of thought about how they'll be formatted, rather than being able to just get information written down.
The content of a document and its formatting details are two very different things, and it was very difficult to think about one without having to deal with the other.
As someone who's dealt with a fair amount of code, I know that the two concerns should be separated as much as possible.
I should be able to specify a document's formatting once, and have the content automatically conform to it.

## Documents as Code

Like a codebase, a document is a living, breathing thing.
It organically evolves as new things are added, old things are improved, and mistakes are fixed.
Eventually, the document is ready to be released to its audience, so it is transformed from its original source format into one that can be easily consumed.

That's right.
A document is very much like a piece of software.
So many principles that apply to the creation software can *also* apply to the creation of a document!

* Don't Repeat Yourself
* Separation of concerns (modularity)
* Abstraction
* Version control

I think you get the point.
So, how can we go about treating our documents as code?

Why not write them in a specialized language?
It may not be a typical imperative programming style, but we are still ultimately giving a computer pre-planned instructions on what to do.
Well, there are many of these specialized languages.

TeX, LaTeX, and their offspring are hugely popular in academia, especially fields that use math a lot.
These languages are known for beautifully typesetting text, including equations, into a printed format.
HTML and CSS are, of course, languages designed for document content (plus structure) and formatting, specifically for the web.
Markdown has become an increasingly popular choice due to its ease of use and minimal syntax.
Though intended to be compiled into HTML, people have been able to transform Markdown into LaTeX, PDFs, Word documents, rich text documents, and many other formats.

## Why a Webpage?

So, I mentioned (La)TeX is good at printed media, which is exactly what a resume is.
Why didn't I go down that route?
After all, there are many people that do exactly that!

Well...
I'm not great a LaTeX.
I'm even worse at customizing its formatting.
And frankly, despite its positive results, the language and toolchain feels quite archaic to me.
I'm sure there are ways to make it less painful, but it's just not as easy as making a website.
And, after all, this is just an experiment!
My handy `.docx` file still sits, waiting to be loved again.

## The Process

Let's talk through how I initially converted my resume from a Word document into an HTML file and CSS file!
In short, I hand-wrote the entire HTML file, splitting everything into appropriate and logical sections.
Then, I added CSS styling, which included adding some `id` and `class` attributes to some of the HTML tags.

### The Content: HTML

My HTML file was structured pretty normally.
Inside of the `body`, the structure essentially looked like this:

```html
<body>
    <article>
        <header> [...] </header>
        <main> [...] </main>
    </article>
</body>
```

I tried to be a *decent* user of HTML5 and put the actual main content into an `article`. Then I split the resume into two parts: the `header` and the `main` content.
Inside the `header` is the frontmatter of the resume: my name and contact information.

The rest of my resume lives in `main`, with this general structure:

```html
<main>
    <section class="edu"> [...] </section>
    <section class="skills"> [...] </section>
    <section class="projects"> [...] </section>
    [...]
</main>
```

Each section of my resume is (fittingly) in a `section` tag.
The section heading and content live within.

Now, there were two types of sections in my resume: "dated" and "listed".

#### Dated sections

The "dated" items are the typical things that have a title, date, and additional information in bullets.
Projects, degrees, and prior work are good examples of these items.

The structure of a dated section looks like this:

```html
<section class="projects">
    <h2>Projects</h2>
    <section class="resitem-dated">
        <div class="resitem-info">
            <div class=resitem-title>Cool Project Name</div>
            <div class=resitem-location>Null Island</div>
            <div class=resitem-date>January 1970</div>
        </div>

        <ul>
            <li>Information about this cool project.</li>
            <li>Another bit of information.</li>
            [...]
        </ul>
    </section>

    [...]
</section>
```

The heading comes first.
It's an `h2` tag so that the `h1` tag can hold the title of the page (in this case, my name).
Then come one or more `section` tags to hold each dated item.
Within the `section` is a `div` with the item's information (title, location, and date), then an unordered list with the details about the item.

At this point, you might be wondering about all the layers of hierarchy at play here.
I decided that, if an element belongs together with its neighbors, they should be enclosed inside a container.
Though perhaps not completely visible or obvious, a resume definitely has many levels of organization at play.
The topmatter really is separate from the rest of the content.
Each section is truly separate from the next.
Each item is separate from the others within a section.
Et cetera, et cetera.
And this has true benefits: CSS styling works a lot better when I can target specific groups of elements easily.
I can add a flexbox to a group of items without having to go back and add `div`s.
Another benefit is that the page structure can be parsed more easily, which greatly aids in accessibility.

#### Listed sections

"Listed" sections just have lists of things, such as specific skills.
Every list has a category, such as "software skills" or "engineering courses".
The structure of these sections looks like so:

```html
<section class="skills">
    <h2>Skills</h2>

    <section class="resitem-list">
        <table>
            <tr>
                <td class="resitem-title">Programming</td>
                <td>Python, HTML, Haskell, VBA Macros, Scratch, Brainfsk</td>
            </tr>

            <tr>
                [more amazing skills]
            </tr>

            [...]
        </table>
    </section>
</section>
```

The list is represented as a table, where each row is a skill category.
The categories are formatted as a `resitem-title` for uniformity, meaning that the categories are formatted identically to the dated item titles.
