# Web testing

Web applications are ubiquitous nowadays: whether you check your e-mail, file your tax return or play a simple online game, chances are high that you are using a web application.
They are all client-server applications, where the server is located somewhere on the Internet, and the client runs in your web browser. 
Testing such web applications is called *web testing*.

<!-- FM: the examples above may not work very well for today's students. They are all used to smartphone apps. Should we have a separate chapter on app testing? ... -->

A simplified architecture diagram of a web application may look as follows:

![Client-server communication in a web application](img/web-testing/webapp.svg)

What makes web testing different from what we have seen so far? 
How can you apply the principles you have learned so far to testing web applications? 
In this chapter, we will answer these questions using concrete examples.

## Characteristics of web applications
We will now take a look at some characteristics of web applications and how they influence our testing process. These consequences for testing are then discussed in more detail after this section.

### The front end is usually written in JavaScript
JavaScript is still the de facto programming language for applications that run in a browser.
(This may change in the future now that WebAssembly is supported by all major browsers, but WebAssembly has not gained much traction yet.)
This means that you either need to write the front end in JavaScript, or use a different language like TypeScript and "transpile" it into JavaScript before having your code executed by a browser.
(In fact, even JavaScript code is often transpiled from a newer language version to an older one, so that you can use JavaScript features that are not yet supported in all browsers.)
Even though you will be able to apply many of the testing principles you have probably applied in a Java context, you will now also have to get acquainted with **JavaScript unit testing frameworks**.

The **programming paradigms** may be different, so principles like "inversion of control" may be implemented differently in a JavaScript context.

Also, you will have to pay special attention to the structure of your code.
It is very easy to mix JavaScript with HTML in such a way that you end up with something that is difficult to test.
Make sure you **design for testability** and apply some kind of modular design, creating small, independent components that are easily tested.
When starting a new project from scratch, is helpful to use a JavaScript library or framework (like Vue.js, React or Angular) in order to achieve such a structure.
If you are dealing with existing code for which there are no unit tests, you will probably have to do a significant amount of refactoring to make the code testable. 

### The application follows the client-server model
Having to separate your application into a client side (front end) and a server side (back end) which communicate with each other over HTTP may be beneficial, because it forces you to think of some kind of interface and can help to reduce coupling.
Also, the fact that the server side can be written in any programming language you like, means that you can stick to your familiar testing ecosystem there.
At the same time, it poses challenges, like possibly having **different programming languages** and corresponding ecosystems on the client and server side.
(Of course, you could write the server side in Node.js if you wanted to use JavaScript on both sides.)
You also have to realise that just testing the front and back end separately will probably not cut it.
You will want to reflect how a user uses the application by performing **system tests**, which in turn means that you have to have a web server running while executing such a test.
That server needs to be in the right state (especially if it uses a database), and the versions of front and back end need to be compatible.

### Everyone can access your application
Web applications are usually available to everyone who is connected to the Internet.
First of all, this means that your audience will probably be very diverse: the users will have very different backgrounds. This makes **usability testing** and **accessibility testing** testing a priority.
Secondly, the number of users of your application may become very high at any given point in time, so **load testing** is a wise thing to do.
Finally, some of those users may have malicious intent.
Therefore **security testing** is of utmost importance (and is discussed in the separate Security Testing chapter).

### The front end runs in a browser
Different users use different versions of different browsers.
**Cross-browser testing** helps to ensure that your application will work in the browsers you support.

In addition, browsers show web pages differently based on the window size.
Web designers use something called **responsive web design** to make sure the application will look good in browsers with different sizes, running on different devices.
This is of course also something you should test.

Another factor to consider is the fact that HTML is used as the markup language for web pages.
Even your HTML should be **designed for testability**, so that you can select elements easily (for instance by adding IDs or classes to elements), and so that you can test different parts of the user interface (UI) independently. 
Speaking of user interfaces: **UI component testing** can be considered  a special case of unit testing: here your "unit" is one part of the Document Object Model (DOM), which you feed with certain inputs, possibly triggering some events (like "click"), after which you check whether the new DOM state is equal to what you expected. 
Even more specifically, **snapshot testing** can help you to make sure your UI does not change unexpectedly.

Finally, when you want to perform **system tests** automatically, you will have to somehow control the browser and make it simulate user interaction. 
Two well-known tools for this are Selenium WebDriver and Cypress.

### Many web applications are asynchronous
Especially in a single-page application (SPA), most of the requests to the server are done in an **asynchronous** manner: while the browser is waiting for results from the server, the user can continue to use the application (i.e., they do not have to wait for the results). 
When writing unit tests, you have to account for this by "awaiting" the results from the (mocked) server call before you can check whether the output of your unit matches what you expected. 
When performing system tests, you may have to wait for a certain element to appear on the screen, or even to wait for a certain amount of time (like 1 second) before checking the output. 
This can easily lead to *flaky tests* (as discussed in the chapter on Test Code Quality). 
You either have to write custom code to make your tests more robust, or use a tool like Cypress, which has retry-and-timeout logic built-in.

### TODO
* Something about state (of client and server)? Relate to model-based testing?
* More info about testing the server side? Maybe testing the server by calling it directly with HTTP? (Which may not add much if you use some framework on the server side which translates HTTP requests into classes that are easily tested using traditional techniques.)
* Something about performance testing?

## JavaScript unit testing

### Design for testability
Let us look at an example of a very simple web application (without a back end) that looks like this: 

![Date incrementing application screenshot](img/web-testing/dateIncrementer.png)

The application does the following:
* When the page is loaded, the current date is shown.
* Every time you click the button, the date is incremented and the new date is logged to the console.

We start with the following (low-quality) implementation (`dateIncrementer1.html`):

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <title>Date incrementer - version 1</title>
</head>

<body>
    <p>Date will appear here.</p>
    <button onclick="incrementDate(this)">+1</button>

    <script>
        function incrementDate(sender) {
            var p = sender.parentNode.children[0];
            var date = new Date(p.innerText);
            date.setDate(date.getDate() + 1);
            p.innerText = date.toISOString().slice(0, 10);
            console.log('The new date is ' + date);
        }

        window.onload = function () {
            var p = document.getElementsByTagName("p")[0];
            p.innerText = new Date().toISOString().slice(0, 10);
        }
    </script>
</body>

</html>
```

Take a minute to think of reasons why it is difficult or impossible to write unit tests for this piece of code.

First of all, the fact that the JavaScript code is inline with the rest of the page means that it is virtually impossible to write unit tests for it. You cannot run the code without also running the rest of the page, so you cannot test the functions separately, as a unit. This is a major issue and should be solved by moving the JavaScript code to one or more separate files.

The `incrementDate()` function is a mix of date logic and user interface (UI) code. 
These parts cannot be tested separately. 
This is exacerbated by the fact that keeping track of the currently shown date is done by updating and reading from the DOM. 
We have even become dependent on the implementation of the date conversion functions (which leads to problems if we decide to use a different date format, for instance). 
The conversion from string that is done should not even be necessary. 
We should solve these problems by splitting up the `incrementDate()` function into different functions and storing the currently shown date in a variable. 
We should also consider the `console.log()` call, which is a side effect that should not interfere with unit testing the date logic.

Another problem is that the initial date value is hard-coded: the code always uses the current date (by calling `new Date()`), so you cannot test what happens with cases like "February 29th, 2020".

No ID or class has been defined for the `<p>` element. 
Therefore we had to jump through hoops to find the element, and thereby unnecessarily imposed restrictions on the HTML structure (the `<p>` element must now be on the same level as the button, and it must be the first element). 
In addition, this makes us need workarounds for finding the element in our UI tests too. 
To avoid that, we simply need to add an `id` to the element.

The aforementioned issues are solved by refactoring the code and splitting it up into three files.
The first one (`dateUtils.js`) contains the utility functions for working with dates, which can now nicely be tested as separate units:

```js
function incrementDate(date) {
    date.setDate(date.getDate() + 1);
}

function dateToString(date) {
    return date.toISOString().slice(0, 10);
}
```

The second one (`dateIncrementer.js`) contains the code for keeping track of the currently shown date and the UI interaction:

```js
function DateIncrementer(initialDate, dateElement) {
    this.date = new Date(initialDate.getTime());
    this.dateElement = dateElement;
}

DateIncrementer.prototype.increment = function () {
    incrementDate(this.date);
    this.updateView();
    console.log('The new date is ' + this.date);
};

DateIncrementer.prototype.updateView = function () {
    this.dateElement.innerText = dateToString(this.date);
};
```

The third one is the refactored HTML file (`dateIncrementer2.html`) that uses our newly created JavaScript files:

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <title>Date incrementer - version 2</title>
</head>

<body>
    <p id="pDate">Date will appear here.</p>
    <button id="btnIncrement">+1</button>

    <script src="dateUtils.js"></script>
    <script src="dateIncrementer.js"></script>
    <script>
        window.onload = function () {
            var incrementer = new DateIncrementer(
                new Date(), document.getElementById("pDate"));

            var btn = document.getElementById("btnIncrement");
            btn.onclick = function () { incrementer.increment(); };

            incrementer.updateView();
        }
    </script>
</body>

</html>
```

The date handling logic can now be tested separately, as well as the UI code. The initial date can now be supplied as an argument. 
The `<p>` element can now be found by its ID.

{% hint style='tip' %}
Some side notes about the code:
* Even though the code has improved, part of it is still not unit-testable (namely the `onload` handler). This can be solved by factoring out that part to a separate file as well.
* You may want to structure the code even better, for instance by writing a proper MVC (Model-View-Controller) implementation. Especially for larger-scale projects with lots of JavaScript, it makes sense to use a library or framework that provides such a structure for you.
* We have not used any modern JavaScript features (like the `class` syntax) in order to maintain compatibility with older browsers. TODO: an example of a 'modern' implementation will probably follow. Mention transpiling again?
* As with the other examples in the book, the code can be found in the [code examples](https://github.com/sttp-book/code-examples/) repository.

{% endhint %}

We should now be ready to write some tests!

### Writing the tests
You could write some tests without using any framework still, by creating a new page and logging stuff to the console.
Example.
The second test fails, because the implementation of dateToString returns the date in UTC, whereas the date was created in the local time zone of the user with time 0:00:00. Fixing the dateToString method is left as an exercise for the reader.

### Choosing a unit testing framework
Now pick a testing framework. Abundance of choice.
Mention testing frameworks: Jasmine, Jest, Mocha, QUnit?

You can also use a testing framework that runs in a browser.
You can also use a testing framework that runs outside of a browser (in Node.js). The test code can then use all modern JavaScript features.


### Example implementation with React and Jest


### UI component testing
TODO

## System/E2E testing
TODO

## Other types of tests
TODO. Discuss in less detail.

## TODO
* Overlap between the different testing types (unit, component/UI, integration, system). How to choose what to test?
* The role of manual testing.
