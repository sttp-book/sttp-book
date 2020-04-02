# Testing techniques

In a simplified view of a software testing process, 
developers perform two distinct tasks: **designing
test cases**, and **executing test cases**.

The first task, as we just mentioned, 
is about analysing and designing test cases. In simple words, the goal of this stage
is to systematically devise different test cases that together will give us a certain level
of confidence as to whether the software is ready to be shipped or not.
Devising test cases is an activity that is often done by humans (although we will explore the state-of-the-art in software testing research, where machines also try to 
devise test cases for us). After all, it requires good knowledge of the requirements.
In the _Roman Numeral_ example of a previous chapter, we devised three test cases during
the test case design phase.

The second task is about executing the test cases we have devised. 
We often do it by running the software system, feeding it with the inputs we crafted, 
and checking whether the system responded in the way we expected.
Although this phase can also be done by humans, this is an activity that we can easily automate.
As we discussed before, we can (and should) write a program that runs our software and executes the test cases. 

{% hint style='info' %}
As a side note, in industry, the term "automated software testing" is often related to the automatic *execution* of test cases (that were manually devised). In academia, whenever a research paper says "automated software testing", it means automatically *creating* test cases (by means of artificial intelligence techniques, for instance).
{% endhint %}


{% set video_id = "pPv37kPqvAE" %}
{% include "/includes/youtube.md" %}


When it comes to devising test cases, while our experience indeed helps us deeply in finding bugs, it might not be enough: 

* Experience-based testing is highly prone to mistakes. The developer might forget to test a corner case.
* It varies from person to person. Our goal is to define techniques such that any developer in the world is able to test any software.
* Without clear criteria, it is difficult to know when to stop testing. Our gut feelings might not be precise enough.

The following chapters aim at exploring different techniques to effectively,
rigorously, and systematically test a 
software system, and how to automate as many steps on the way as possible.
These techniques will rely on the different artefacts that are present during the 
software development process. 

More specifically, we discuss:

* **Specification-based testing**: We will discuss techniques to derive tests from textual requirements. We will discuss the _category/partition method_ and what _equivalence partitioning_ means.

* **Boundary testing**: We will discuss how to derive tests that exercise the boundaries of our requirement.

* **Structural-based testing**: We will derive test cases based on the structure of the source code.

* **Model-based testing**: We will leverage more formal documentation such as state machines and decision tables to derive tests. 

* **Design-by-contracts**: We will devise explicit contracts to methods and classes to ensure that they behave correctly when these contracts are (and are not) met.

* **Property-based testing**: We will learn how to derive properties of the system (similar to contracts) and use them to automatically generate test cases.



{% set video_id = "xyV5fZsUH9s" %}
{% include "/includes/youtube.md" %}



## References


* Yu, C. S., Treude, C., & Aniche, M. (2019, July). Comprehending Test Code: An Empirical Study. In 2019 IEEE International Conference on Software Maintenance and Evolution (ICSME) (pp. 501-512). IEEE. Chicago	

