# 1.2 Principles of software testing

In this chapter, we first define some terminology. Using the right
terms helps us understand each other better. We then discuss the differences
between *verification* and *validation*. Finally, we discuss some testing principles
that will guide us (or, more specifically, force us to perform trade-offs whenever
we choose a testing technique) throughout the book.

## Failure, Fault and Error

It is common to hear different terms to indicate that a software system
is not behaving as expected.
Just to name a few: _error_, _mistake_, _defect_, _bug_, _fault_, and _failure_.
To describe the events that led to a software crash more precisely, 
we need to agree on a certain vocabulary.
For now, this comes down to three terms: **failure**, **fault**, and **error**.

A **failure** is a component of the (software) system that is not behaving as expected.
Failures are often visible to the end user.
An example of a failure is a mobile app that stops working, or a 
news website that starts to show yesterday's news on its front page. 
The software system did something it was not supposed to do.

Failures are generally caused by _faults_.
**Faults** are also called _defects_ or _bugs_.
A fault is the flaw in the component of the system that caused the 
system to behave incorrectly. A fault is technical and, in our world, usually refers to 
source code, such as a comparison in an `if` statement that uses a "less than" operator (`<`) instead of a "greater than" operator (`>`). 
A broken connection is an example of a hardware fault.

> Note that the existence of a fault in the source code does not necessarily lead to a failure.
> If the code containing the fault is never executed, it will never cause a failure.
> Failures only occur when the system is being used, and someone notices it not behaving as expected.

Finally, we have an **error**, also called *mistake*.
An error is the human action that caused the system to run not as expected.
For example, a developer didn't cover an obscure condition because they misunderstood
the requirement. Plugging a cable into the wrong socket is an example of a hardware mistake. 

In other words: a *mistake* by a developer can lead to a *fault* in the source code that will
eventually result in a *failure*.

In the _Min-Max_ code example of the previous chapter: the *failure* was the program returning
a large number, the *fault* was a bad `if/else if` condition, and the *mistake* was me not dealing 
properly with that case.

{% set video_id = "zAty8Rpg92I" %}
{% include "/includes/youtube.md" %}



## Verification and Validation

**Verification** and **validation** are both about 
assessing the quality of a system. However, they do have a subtle difference,
which can be quickly described by a single question:

* **Validation: Are we building the right software?**
Validation concerns the features that our software system offers, and the customer (i.e., for whom the system is made): 
  * is the system under development what the users really want and/or need?
  * is the system actually useful? 

  Validation techniques, thus, focus on understanding
whether the software system is delivering the business value it should deliver. In this book, we only briefly cover validation techniques (see chapters on Continuous Experimentation and on Behaviour-Driven Development).


* **Verification: Are we building the system right?** 
Verification, on the other hand, is about the system behaving as it 
is supposed to, according to the specification. 

  In simple words, this mostly means that the system behaves without any bugs.
  Note that this does not guarantee that the system is useful: a system might work 
  beautifully, bug-free, but  not deliver the features that customers really need.

Note how both _validation_ and _verification_ are fundamental for ensuring
the delivery of high-quality software systems.

{% set video_id = "LZ3Fb2Jq7yw" %}
{% include "/includes/youtube.md" %}


## Principles of software testing (or why software testing is so hard)

A simplistic view on software testing is that,
if we want our systems to be well-tested, all we need to do is to keep adding more tests until it is enough. We wish it were that simple.

Indeed, a very important part of any software testing process is 
to know _when to stop testing_.
After all, resources (e.g., money, developers, infrastructure) are limited. Therefore,
the goal should always be to maximise the number of bugs found while minimising the 
amount of resources we had to spend on finding those bugs.
Creating too few tests might leave us with a software system that does not behave as intended (i.e., _full of bugs_).
On the other hand, creating tests after tests, without proper consideration, might lead to ineffective tests (besides costing too much time and money).


Given resource constraints, we highlight an important principle in 
software testing: **exhaustive testing is impossible**. It might be impossible
even if we had unlimited resources. Imagine a software system that has "just" 300 different
flags (or configuration settings). Those flags can be set to either true or false (Booleans) and
they can be set independently from the others. The software system behaves differently
according to the configured combination of flags. This implies that we need to test all the possible combinations. A simple calculation shows us that 2 possible values for each of the 300 different flags gives $$2^{300}$$ combinations that need to be tested. As a matter
of comparison, this number is higher than the estimated number of atoms in the universe.
In other words, this software system has more possible combinations to be tested than the universe has atoms.

Given that exhaustive testing is impossible,
software testers have to then prioritise the tests they will perform.

When prioritising the test cases, we note that **bugs are not uniformly distributed**.
Empirically, we observe that some components in some software systems present more
bugs than other components.

Another crucial consequence of the fact that exhaustive testing is impossible is that, 
as Dijkstra used to say, **program testing can be used to show the presence of bugs, but never to show their absence**.
In other words, while we might find more bugs by simply testing more, our test suites,
however large they might be,
will never ensure that the software system is 100% bug-free. They will only ensure
that the cases we test for behave as expected.

To test our software, we need a lot of variation in our tests.
For example, we want variety in the inputs when testing a method, 
like we saw in the examples above.
To test the software well, however, we also need variation in 
the testing strategies that we apply.

Indeed, an interesting empirical finding is that if testers apply the same testing techniques over and over, they will at some point lose their efficacy. 
This is described by what is known as the **pesticide paradox** (which nicely refers to "bugs" as an equivalent term for software faults):
_"Every method you use to prevent or find bugs leaves a residue of 
subtler bugs against which those methods are ineffectual."_
In practice, this means that no single testing strategy 
can guarantee that the software under test is bug-free.
A concrete example might be a team that solely relies on unit testing techniques.
At some point, maybe all the bugs that can be captured at unit test level will be found
by the team; however, the team might miss bugs that only occur at integration level.
From the pesticide paradox, we thus conclude that testers have to use 
different testing strategies to minimise the number of bugs left in the software.
When studying the various testing strategies that we present in this book, 
keep in mind that combining them all might be a wise decision.

The context also plays an important role in how one devises test cases.
For example, devising test cases for a mobile app is very different 
from devising test cases for a web application, or for software used in a rocket.
In other words: **testing is context-dependent**.

Again, while this book mostly focuses on verification techniques, 
let us not forget that having a low number of bugs is not enough for good software.
As we have said before, a program that works flawlessly, but is of no use for its users, 
is still not a good program.
That is a common fallacy (also known as the **absence-of-errors fallacy**) that software testers face when they decide to focus solely
on verification and not so much on validation.

{% set video_id = "dkbvb_wTN-M" %}
{% include "/includes/youtube.md" %}


## Exercises

**Exercise 1.**
Having certain terminology helps testers to explain the problems they have with a program or in their software.

Below is a small conversation.
Fill in the blanks with one of the following terms: failure, fault, or error.

* **Mark**: Hey, Jane, I just observed a (1) _ _ _ _ _ _ in our software: if the user has multiple surnames, our software doesn't allow them to sign in. 
* **Jane**: Oh, that's awful. Let me debug the code so that I can find the (2) _ _ _ _ _ _.
* **Jane** *(a few minutes later):* Mark, I found it! It was my (3) _ _ _ _ _ _. I programmed that part, but never thought of this case.
* **Mark**: No worries, Jane! Thanks for fixing it!


**Exercise 2.**
Kelly, a very experienced software tester, visits *Books!*, a social network focused on matching people based on books they read.
Users do not report bugs so often, as *Books!* developers have strong testing practices in place.
However, users do say that the software is not really delivering what it promises.

What testing principle applies to this problem?

**Exercise 3.**
Suzanne, a junior software tester, has just joined a very large online payment company in the Netherlands. As a first task, Suzanne analysed their past two years of bug reports.
Suzanne observes that more than 50% of bugs have been happening in the *International payments* module. 

Suzanne then promises her manager that she will design test cases that will completely cover the *International payments* module, and thus, find 
all the bugs.

Which of the following testing principles might explain why this is **not** possible?

1. Pesticide paradox. 
2. Exhaustive testing.
3. Test early.
4. Defect clustering.

**Exercise 4.**
John strongly believes in unit testing. In fact, this is the only type of testing he actually
does at any project he's in. All the testing principles below but one might help convince John that he should also focus on different types of testing. 

Which of the following **is the least related** when we want to convince John to move away from his 'only unit testing' approach?

1. Pesticide paradox. 
2. Tests are context-dependent.
3. Absence-of-errors fallacy.
4. Test early.



## References

* Graham, D., Van Veenendaal, E., & Evans, I. (2008). Foundations of software testing: ISTQB certification. Cengage Learning EMEA. Chapters 1, 2, 3.
