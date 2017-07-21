# golang Development

###### Mikel Nelson (6/2017)
Example golang project set up

Table of Contents

* [Documentation](#documentation)
* [Tests](#tests)
    * [Testing Style](#testing-style)
    * [Designing for Testing](#designing-for-testing)
    * [Assertion Style Tests](#assertion-style-tests)
* [Dependencies](#dependencies)
* [Development Helpers](#development-helpers)

## Documentation
### Rules
* Every file should have the License and Copyright at the top.
* Every pkg should have a `doc.go` file that has the `copyright - blank line - package description - then package <blah>` only. Then every other file in the package will not have the package description.
* All func, type, interfaces, etc should have a comment.
* `LICENSE` file at top level (essetially the same as the license and copyright in each go file).
* `go vet, golint, gosimple` should be run on all code and the results should be "clean".
* ***Viable, usable godoc is the goal***.

## Tests
### Rules
* Every `X.go` should have a corresponding `X_test.go` file (if applicable)
* `X_test.go` should provide full code coverage if possible.
* Do NOT create a `X_test.go` just to silent the `[no test file]` warnings.  Only create `X_test.go` with actual tests internal and a `not implemented` failure or skip.

### Testing Style

Golang's [testing][1] package provides foundational, native testing capabilities.
This will be sufficient for many use-cases, so where possible, relying on it 
exclusively is preferred. 

[The official Golang guide][2] advises the use of [table-driven tests][3]. These 
offer significant benefits for code that accepts wide-ranging inputs and 
verifiable outputs, so where possible, their use is recommended.

The CNCT guideline is generally to follow the conventions of the Kubernetes
project. Kubernetes leverages multiple styles of tests, sometimes in [the same file][7]:

- Fairly complex [table tests][6], probably better for unit testing
- Simpler [error checking tests][5] (method `TestForwardPortsReturnsErrorWhenAllBindsFailed`), probably better for integration tests


#### Designing for Testing

Golang advises a design convention, _accept interfaces, return pointers_.
[Interfaces][8] offer significant advantages for overall application development and modularity,
but also simplifies testing.

The use of interfaces can also [simplify implementation of test mocks][9].

A good practice, following TDD, will be to approach development of a module in phases:

1. Define interfaces
2. Define a few tests for the interface, using a test package `<package>_test`.
3. Define your struct(s) and their methods to fulfill the interface
4. Define a mock struct that fulfills the same interface, in a separate Go file, in the test package.
5. When necessary to isolate the system under tests, provide the mock to _consumers_ of the struct, who should rely on the interface from #1.

#### Assertion Style tests

Ideally you'd adopt the conventions advised by [Go's own style guide][2], under 
most conditions, and alternate testing styles wouldn't be necessary. For 
developers who find Go's style of testing foreign, it's advisable to read 
[the experience of other developers learning Go][4] as well. 

Generally there's little practical advantage to assertion style tests over
table tests, beyond the idiomatic representation. The same validation logic
of an assertion test can be expressed in the iteration over the test table.

If for some reason you _absolutely_ need to think in assertion style,
embedding the assertion methods within the Test function is advisable, or at
least in the same file, to reduce "cognitive load" and provide all available 
context for the next developer who will read your code.

The following test cases perform identically with both styles, for comparison.


```golang

package main

import (
    "strings"
    "testing"
)

func TestMyCode(t *testing.T) {


    dosomething := func(text string) string {
        return strings.ToUpper(text)
    }

    cases := map[string]struct {
        input    string
        expected string
        result   string
    }{
        "First":  {"a", "A", dosomething("a")},
        "Second": {"b", "B", dosomething("b")},
        "Third":  {"c", "C", dosomething("c")},
    }

    for key, pair := range cases {
        if pair.expected != pair.result {
            t.Errorf("Test failed: %s; (%v != %v)", key, pair.expected, pair.result)
        }
    }
}

func TestMyCode_Assert(t *testing.T) {

    assertEqual := func(a, b interface{}, message string) {
        if a != b {
            t.Errorf("Test failed: %s; (%v != %v)", message, a, b)
        }
    }

    dosomething := func(text string) string {
        return strings.ToUpper(text)
    }

    assertEqual("A", dosomething("a"), "First")
    assertEqual("B", dosomething("b"), "Second")
    assertEqual("C", dosomething("c"), "Third")

}

```


## Dependencies
### Rules
* Dependency Management tools for golang are in flux.  Hopeful future is `go dep`.  
* For now, create and check in `./vendor` sub-ddirectory.
* Create the ./vendor dir via whatever means you like.  For exmple:
** Dependencies are managed with [Glide](https://github.com/Masterminds/glide).
** Add new golang package dependencies to `glide.yaml`.  Add package version information to `glide.lock`.
** NOTE: `glide.lock` has a timestamp that is updated whenever the dependencies are checked.  This should not cause a `git` checkin, however, editing the file should be checked in.  This is not automated.
** You should only have to rum `make dep` or `make dep-update`, and only if missing packages or they are out of date.  This is not automated.


## Development Helpers
### cobra
[cobra](https://github.com/spf13/cobra) pkg is used for the `main/cmd` packages.  New `cmd` files may be added by hand, or easier, with the `cobra add` command template add.
 


[1]: https://golang.org/pkg/testing/
[2]: https://github.com/golang/go/wiki/TableDrivenTests
[3]: https://golang.org/doc/code.html#Testing
[4]: https://medium.com/@benbjohnson/structuring-tests-in-go-46ddee7a25c
[5]: https://github.com/kubernetes/kubernetes/blob/master/pkg/client/tests/portfoward_test.go
[6]: https://github.com/kubernetes/kubernetes/blob/master/pkg/kubectl/deployment_test.go
[7]: https://github.com/kubernetes/kubernetes/blob/master/pkg/kubectl/stop_test.go
[8]: https://gobyexample.com/interfaces
[9]: https://nathanleclaire.com/blog/2015/10/10/interfaces-and-composition-for-effective-unit-testing-in-golang/

