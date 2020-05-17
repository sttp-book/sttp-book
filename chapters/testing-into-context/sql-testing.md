# SQL Testing

As we discussed in the _Testing Pyramid_ chapter, parts of our system only make sense to be tested by means of integration testing. A common case for integration testing are classes that talk to databases. Business applications are often composed of many [Data Access Objects](https://en.wikipedia.org/wiki/Data_access_object) (DAOs) that perform complex SQL queries. A lot of business knowledge are encapsulated in these queries, requiring testers to spend some energy in making sure that produce the expected outcomes.

In this chapter, we discuss:

* What to test in a SQL query?
* How to write automated test cases for such queries
* Challenges and best practices

This chapter expects the reader to have some basic knowledge on SQL queries.

## What to test in a SQL query?

SQL is a robust language and contains a large number of different functions that developers can make use of. Let us simplify and see queries as a composition of predicates. See the following examples:

* `SELECT * FROM INVOICE WHERE VALUE < 50`
* `SELECT * FROM INVOICE I JOIN CUSTOMER C ON I.CUSTOMER_ID = C.ID WHERE C.COUNTRY = 'NL'`
* `SELECT * FROM INVOICE WHERE VALUE > 50 AND VALUE < 200`

In these examples, `value < 50`, `i.customer_id = c.id`, `c.country = 'NL'`, and `value > 50 and value < 200` are the predicates that compose the different queries. As a tester, a possible criteria is to exercise the different predicates and check whether the SQL query returns the expected results when predicates are evaluated to different results. 

Virtually all the testing techniques we have discussed in the _Testing Techniques_ part of this book can be applied here:

* Specification-based testing: These SQL queries emerge out of a requirement. A tester can analyse the requirements and derive equivalent partitions that need to be tested.
* Boundary analysis: Such programs have boundaries. Given that we can also expect boundaries to be places with a high bug probability, exercise them is therefore also important.
* Structural testing: Structurally-speaking, SQL queries contain predicates, and a tester might use the SQL's structure to derive test cases.

Let us focus on structural testing. If we look close to the third example, and try to make an analogy with what we discussed in structural testing, we see that the SQL query contains a single branch (`value > 50 and value < 200`), composed of two predicates (`value > 50` and `value < 200`). This means that there are four possible combinations of results in these two predicates: (TT), (TF), (FT), (FF). A tester might aim at: 

- Branch coverage: in this case, two tests, one that makes the overall decision to be evaluated to true, and one that makes the overall decision to be evaluated to false would be enough to achieve 100% branch coverage.
- Condition+Branch coverage: in this case, three tests would be enough to achieve 100% condition+branch coverage, e.g., T1=150, T2=40, T3=250.

In [A practical guide to SQL white-box testing](https://dl.acm.org/doi/pdf/10.1145/1147214.1147221), Tuya and colleague suggests five guidelines for designing SQL tests: 

1. **Adopting MC/DC for SQL conditions.** Decisions happen at three places in a SQL query: _join_, _where_ and _having_ conditions. Testers can make use of a criteria such as MC/DC to fully exercise its predicates.

1. **Adapting MC/DC for tackling with nulls**. Given that databases have a special way of handling/returning NULLs, any (coverage) criteria should be adapted to a three-valued logic (i.e., true, false, null). In other words, consider the possibility of values being null in your query.

1. **Category partitioning selected data**. SQL can be considered a sort of declarative specification, of which we can define partitions to be tested. Directly from their text:
	1. Rows that are retrieved: We include a test state to force the query to not select any row.
	1. Rows that are merged: The presence of unwanted duplicate rows in the output is a common failure in some queries. We include a test state in which identical rows are selected.
	1. Rows that are grouped: For each of the group-by columns, we design test states to obtain at least two different groups at the output, such that the value used for the grouping is the same, and all the other are different.
	1. Rows that are selected in a subquery: For each subquery, we include test states that return zero and more rows, with at least one null and two different values in the selected column. 
	1. Values that participate in aggregate functions: For each aggregate function (excluding count), we include at least one test state in which the function computes two equal values and another one that is different. 
	1. Other expressions: We also design test states for expressions involving the like predicate, date management, string management, data type conversions or other functions using category partitioning and boundary checking.

1. **Checking the outputs.** We should check not only the input domain, but also the output domain. SQL queries might return NULL in specific columns or empty sets, for example, which might make the rest of the program to break. 

1. **Checking the database constraints**. Databases have constraints. Testers should make sure these constraints are indeed enforced by the database.

As you can see, many things can go wrong in a SQL query. And it is part of a tester's job to make sure it does not happen.

{% hint style='tip' %}
For interested readers, in the [Full predicate coverage for testing SQL database queries](https://onlinelibrary.wiley.com/doi/abs/10.1002/stvr.424) paper, Tuya et al. propose a MC/DC criteria for SQL queries.
{% endhint %}

## How to write automated test cases for SQL queries

We can make use of JUnit to write SQL tests. After all, all we need is to (1) establish a connection with the database, (2) make sure the database is in the right initial state, (3) fire a SQL query, (4) check the output.

Imagine: 
* We have an `Invoice` table that is composed of a `name` (varchar, length 100) and a `value` (double).
* We have an `InvoiceDao` class that makes use of any API to communicate with the database. The precise API does not matter.
* This DAO performs three actions: `save()` that persists an invoice in a database, `all()` which returns all invoices in the database, and `allWithAtLeast` that returns all invoices with at least an specified value.
	* `all()` runs the following SQL query: `select * from invoice`
	* `allWithAtLeast()` runs: `select * from invoice where value >= ?`
	* `save()` runs `insert into invoice (name, value) values (?,?)`.
	* You may see a JDBC implementation of this `InvoiceDao` in our [code examples](https://github.com/sttp-book/code-examples/blob/master/src/main/java/tudelft/mocks/invoice/InvoiceDao.java) repository.

Take a look at this rather long JUnit test snippet (which you can also see in our [code examples](https://github.com/sttp-book/code-examples/blob/master/src/test/java/tudelft/mocks/invoice/InvoiceDaoIntegrationTest.java) repository:

```java
public class InvoiceDaoIntegrationTest {

    private final DatabaseConnection connection = new DatabaseConnection();
    private final InvoiceDao dao = new InvoiceDao(connection);

    @BeforeEach
    void cleanup() throws SQLException {
        /**
         * Let's clean up the table before the test runs.
         * That will avoid possible flaky tests.
         *
         * Note that doing a single 'truncate' here seems simple and enough for this exercise.
         * In large systems, you will probably want to encapsulate the 'reset database' logic
         * somewhere else. Or even make use of specific frameworks for that.
         */
        connection.getConnection().prepareStatement("truncate table invoice").execute();

        /**
         * Maybe you also want to double check if the cleaning operation
         * worked!
         */
        List<Invoice> invoices = dao.all();
        assertThat(invoices).isEmpty();
    }

    @AfterEach
    void close() {
        /**
         * Closing up the connection might also be something you do
         * at the end of each test.
         * Or maybe only at the end of the entire test suite, just to optimize.
         * (In practice, you should also use some connection pool, like C3P0,
         * to handle connections)
         */
        connection.close();
    }

    @Test
    void save() {
        final var inv1 = new InvoiceBuilder().build();
        final var inv2 = new InvoiceBuilder().build();

        dao.save(inv1);

        List<Invoice> afterSaving = dao.all();
        assertThat(afterSaving).containsExactlyInAnyOrder(inv1);

        dao.save(inv2);
        List<Invoice> afterSavingAgain = dao.all();
        assertThat(afterSavingAgain).containsExactlyInAnyOrder(inv1, inv2);
    }

    @Test
    void atLeast() {
        int value = 50;

        /**
         * Explore the boundary: value >= x
         * On point = x
         * Off point = x-1
         * In point = x + 1 (not really necessary, but it's cheap, and makes the
         *   test strategy easier to comprehend)
         */
        final var inv1 = new InvoiceBuilder().withValue(value - 1).build();
        final var inv2 = new InvoiceBuilder().withValue(value).build();
        final var inv3 = new InvoiceBuilder().withValue(value + 1).build();

        dao.save(inv1);
        dao.save(inv2);
        dao.save(inv3);

        List<Invoice> afterSaving = dao.allWithAtLeast(value);
        assertThat(afterSaving).containsExactlyInAnyOrder(inv2, inv3);
    }
}
```

Let us understand it:

* Before each test, a clean up operation happens. We clean the entire database to make sure our tests will not be flaky. It is easy to imagine that, if a database has unkwnown data, a SQL query will return unexpected results. Note that, in here, we are doing a simple `truncate table`. In more complex systems, you might want to extract this "reset database" logic to an specialized class (or even to make use of framework).
* After each class, we close the connection, to avoid connection leaks. In this example, a simple `Connection#close` suffices. In real life, you might want to use some professional connection pool (not only for your test code, but also for your production code!)
* The `save()` test method exercises both `save()` and `all()` methods. It inserts values to the database and ensures they are persisted correctly afterwards.
* The `atLeast` exercises the `allWithAtLeast` method. Note how it also exercises the boundaries of the `value>?` condition. 
* Observe how test data builders (in this case, exemplified by the `InvoiceBuilder` class) helps us in quickly building test data.

This test suite might be considered good enough for the current `InvoiceDao` class. Note that, by basically applying all the ideas we have seen before, we were able to write good SQL testing without much costs.

## Challenges and best practices

The example above was quite simple. Challenges might emerge once your SQL queries are highly complex. Some tips:

* **Make use of test data builders.** They will help you to quickly build the data structures you need.
* **Make use of good assertions APIs.** Asserting was easy in the example above as AssertJ makes our life easier. 
* **Minimize the required data**. Make sure the input data is minimized. You do not want to have to load hundreds of thousands of elements to exercise your SQL query (maybe you will want to do this to exercise other features of your database, like speed, but that is not the case here).
* **Build good test infrastructure**. In our example, it was simple to open a connection, to reset the database state, and etc, but that might become more complicated (or lenghty) once your database schema gets complicated. Invest on a test infrastructure to facilitate your SQL testing.
* **Take into consideration the schema evolution**. In real life, database schemas evolve quite fast. Make sure your test suite is resilient towards these changes (i.e., if an evolution should not break the test suite, it does not; if an evolution should break the test suite, it does break the test suite).

## References

* Tuya, Javier, M. José Suárez-Cabal, and Claudio De La Riva. "A practical guide to SQL white-box testing." ACM SIGPLAN Notices 41, no. 4 (2006): 36-41.
