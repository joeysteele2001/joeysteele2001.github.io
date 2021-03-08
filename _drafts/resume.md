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
