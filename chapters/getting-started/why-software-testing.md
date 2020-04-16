# Why software testing?


Why should we actually care about software testing?
**The main reason is that bugs are everywhere**. 

As a person who is probably highly dependent on software technology, you should have encountered a few software bugs in your life. Some of them probably did not affect you that much. For example, maybe your Alarm app on your mobile phone crashed, and you did not wake up in time for a meeting. However, some other bugs might have (negatively) affected your life. Societies all over the world have faced critical issues due to software bugs, from medical devices that do not work properly and harm patients, to electric power plants that completely shut down.

And, while these software systems we gave as examples might seem far out from most developers' daily jobs, it is impressively easy to make mistakes even in less critical/complex software systems.

To illustrate how hard it is to spot bugs, let's start with a requirement:

> **Requirement: Min-max**
>
> Implement a program that, given a list of numbers (integers), returns 
> the smallest and the largest numbers in this list.

This looks like a very simple program to implement; maybe even an exercise for an Introduction to Programming course. 

A first implementation in Java could be as follows:

```java
public class NumFinder {
  private int smallest = Integer.MAX_VALUE;
  private int largest = Integer.MIN_VALUE;

  public void find(int[] nums) {
    for(int n : nums) {
      if(n < smallest) smallest = n;
      else if(n > largest) largest = n;
    }
  }

  // getters for smallest and largest
}
```


The idea behind the code is as follows: we go through all the elements of the `nums` list and store the smallest and the largest numbers in two different variables.
If `n` is smaller than the smallest number we have seen so far, we replace the smallest number by `n`. The same idea applies to the largest number: 
if `n` is bigger than the largest number, we just replace it by `n`. 

A common flaw in developers (which we will try as much as possible to convince you  _not to do_) is that they implement the program based on the requirements, and then perform "small checks" to make sure the program works as expected. (Note that these "small checks" are what we will fight against; developers should perform rigorous and systematic testing to make sure their program works!)

For the sake of the argument, let us do a "small check" on the program we just wrote. A simple way of doing it would be to come up with a "main" method that exercises the program a few times. 
Suppose that the developer then tried their implementation with 4, 25, 7, and 9 as inputs. 


```java
public class NumFinderMain {

  public static void main (String[] args) {
    NumFinder nf = new NumFinder();
    nf.find(new int[] {4, 25, 7, 9});

    System.out.println(nf.getLargest());
    System.out.println(nf.getSmallest());
  }
}
```

The output of this program is: `25, 4`. This means the implementation works as expected. In a larger context, this would mean that the developer can ship this new implementation to the final user, and let them use this new feature. **Can we really...?**

No, we can not. The current implementation does not work for all the possible cases. **There's a bug in there!** (Can you find the bug? Look at the implementation above and try to find it!)

The program does not work properly for the following input: an array with values 4, 3, 2, and 1. For this input, the program returns the following output: `-2147483648, 1`.
In a more generalised way, the implementation does not handle "numbers in decreasing order" well enough. 

We have just found a bug. This is maybe the right time for a reflection: if bugs can occur
even in simple programs like the ones above, imagine what happens in large complex
software systems, on which our society relies upon.

Before anything else, let us just fix the bug.
Back to the source code, we see that the bug is 
actually caused by the `else if` instruction.  
The `else if` should actually just be an `if`. 
Take a moment to understand why.

```java
public class NumFinder {
  private int smallest = Integer.MAX_VALUE;
  private int largest = Integer.MIN_VALUE;

  public void find(int[] nums) {
    for(int n : nums) {
      if(n < smallest) smallest = n;

      // BUG was here!!
      if(n > largest) largest = n;
    }
  }

  // getters for smallest and largest
}
```

Again, this is indeed a trivial bug. Once you have found it, it might indeed
look stupid. But these kind of mistakes 
can and do happen all the time. Why? The answer is simple: developers deal 
with highly complex software systems. Software systems that are composed of millions (if not billions) of lines of code. Software that generates tons of data per second. Software that communicates with hundreds (if not thousands) of external systems in an asynchronous and distributed manner. Software that has millions of user requests for hour. 
It is simply impossible to predict, during development time, everything that can happen. 

**This is why we need to test software. Because the world is complex, bugs do happen.**
And they can really have a huge impact in our lives.

What is the solution? To rigorously and systematically test the software systems we develop.

{% set video_id = "xtLgp8LXWp8" %}
{% include "/includes/youtube.md" %}

## Exercises

**Exercise 1.**
Google for "famous software bugs". Learn what caused them as well as the impact they
had.

## References

* Wikipedia. List of software bugs. https://en.wikipedia.org/wiki/List_of_software_bugs
