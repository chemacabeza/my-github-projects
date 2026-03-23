### Section 7: Spring MVC CRUD

**Project Set Up**
* We will extend our existing Employee project and add DB integration
* Add "`EmployeeService`", "`EmployeeRepository`" and "`Employee`" entity
    * Available in our previous projects
* Allows us to focus on creating "`EmployeeController`" and Thymeleaf templates

**Development Process**
1. Controller getting all the employees from the DB

```java
package com.luv2code.springboot.thymeleafdemo.controller;

import com.luv2code.springboot.thymeleafdemo.entity.Employee;
import com.luv2code.springboot.thymeleafdemo.service.EmployeeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/employees")
public class EmployeeController {

    private EmployeeService employeeService;

    public EmployeeController(EmployeeService theEmployeeService) {
        employeeService = theEmployeeService;
    }

    // add mapping for "/list"

    @GetMapping("/list")
    public String listEmployees(Model theModel) {

        // get the employees from db
        List<Employee> theEmployees = employeeService.findAll();

        // add to the spring model
        theModel.addAttribute("employees", theEmployees);

        return "list-employees";
    }
}
```

2. Create the "`list-employees.html`" file

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Employee Directory</title>

    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
</head>
<body>

<div class="container">

    <h3>Employee Directory</h3>
    <hr>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
            </tr>
        </thead>

        <tbody>
            <tr th:each="tempEmployee : ${employees}">

                <td th:text="${tempEmployee.firstName}" />
                <td th:text="${tempEmployee.lastName}" />
                <td th:text="${tempEmployee.email}" />

            </tr>
        </tbody>
    </table>

</div>

</body>
</html>
```

3. Beautify the Thymeleaf template
    * You need to go to <a href="https://getbootstrap.com/">this webpage</a>
    * From that page you need to copy the next 3 lines

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <!-- FROM HERE -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- UNTIL HERE -->
    </head>
  <body>
    <h1>Hello, world!</h1>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  </body>
</html>
```
* And you need to paste those 3 lines into the "`list-employees.html`" file as we saw previously. Also you can delete the line with "`<title>Bootstrap demo</title>`" because we already have a title in our Thymeleaf template.

#### Add new employee to our demo project

**Development Process**

1. New **Add Employee** button for "`list-employees.html`"
    * **Add Employee** button will href link to
        * request mapping "`/employees/showFormForAdd`"

```html
    <a th:href="@{/employees/showFormForAdd}"
        class="btn btn-primary btn-sm mb-3">
       Add Employee
    </a>
```
    * Controller code to show form

```java
package com.luv2code.springboot.thymeleafdemo.controller;

import java.util.ArrayList;
import java.util.List;

import com.luv2code.springboot.thymeleafdemo.service.EmployeeService;
import jakarta.annotation.PostConstruct;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.luv2code.springboot.thymeleafdemo.entity.Employee;

@Controller
@RequestMapping("/employees")
public class EmployeeController {

	private EmployeeService employeeService;

	public EmployeeController(EmployeeService theEmployeeService) {
		employeeService = theEmployeeService;
	}

	// add mapping for "/list"

	@GetMapping("/list")
	public String listEmployees(Model theModel) {

		// get the employees from db
		List<Employee> theEmployees = employeeService.findAll();

		// add to the spring model
		theModel.addAttribute("employees", theEmployees);

		return "employees/list-employees";
	}

	@GetMapping("/showFormForAdd")
	public String showFormForAdd(Model theModel) {

		// create model attribute to bind form data
		Employee theEmployee = new Employee();

		theModel.addAttribute("employee", theEmployee);

		return "employees/employee-form";
	}

	@PostMapping("/save")
	public String saveEmployee(@ModelAttribute("employee") Employee theEmployee) {

		// save the employee
		employeeService.save(theEmployee);

		// use a redirect to prevent duplicate submissions
		return "redirect:/employees/list";
	}
}
```

2. Add **Add Employee** button in List employees page

```html
<!DOCTYPE HTML>
<html lang="en" xmlns:th="http://www.thymeleaf.org">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">

	<title>Employee Directory</title>
</head>

<body>

<div class="container">

	<h3>Employee Directory</h3>
	<hr>

	<!-- Add a button -->
	<a th:href="@{/employees/showFormForAdd}"
		class="btn btn-primary btn-sm mb-3">
		Add Employee
	</a>

	<table class="table table-bordered table-striped">
		<thead class="table-dark">
			<tr>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Email</th>
			</tr>
		</thead>

		<tbody>
			<tr th:each="tempEmployee : ${employees}">

				<td th:text="${tempEmployee.firstName}" />
				<td th:text="${tempEmployee.lastName}" />
				<td th:text="${tempEmployee.email}" />

			</tr>
		</tbody>
	</table>

</div>

</body>
</html>
```

3. Create HTML form for new employee

```html
<!DOCTYPE HTML>
<html lang="en" xmlns:th="http://www.thymeleaf.org">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">

    <title>Save Employee</title>
</head>

<body>

    <div class="container">

        <h3>Employee Directory</h3>
        <hr>

        <p class="h4 mb-4">Save Employee</p>

        <form action="#" th:action="@{/employees/save}"
                         th:object="${employee}" method="POST">

            <input type="text" th:field="*{firstName}"
                   class="form-control mb-4 w-25" placeholder="First name">

            <input type="text" th:field="*{lastName}"
                   class="form-control mb-4 w-25" placeholder="Last name">

            <input type="text" th:field="*{email}"
                   class="form-control mb-4 w-25" placeholder="Email">

            <button type="submit" class="btn btn-info col-2">Save</button>

        </form>

        <hr>
        <a th:href="@{/employees/list}">Back to Employees List</a>

    </div>


</body>

</html>
```

4. Process form data to save employee

**Thymeleaf Expressions**

| Expression | Description |
| :---- | :---- |
| `th:action` | Location to send form data |
| `th:object` | Reference to model attribute |
| `th:field` | Bind input field to a property in model attribute |

More information right <a href="https://www.thymeleaf.org/doc/tutorials/3.0/thymeleafspring.html#creating-a-form">here</a>.

5. Add method to "`EmployeeRepository`" to retrieve employees order by last name ascending

```java
package com.luv2code.springboot.thymeleafdemo.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import com.luv2code.springboot.thymeleafdemo.entity.Employee;

import java.util.List;

public interface EmployeeRepository extends JpaRepository<Employee, Integer> {

	// that's it ... no need to write any code LOL!

    // add a method to sort by last name
    public List<Employee> findAllByOrderByLastNameAsc();

}
```

This is something related to Spring Data JPA Magic. You can learn more about it in the following <a href="https://docs.spring.io/spring-data/jpa/reference/jpa/query-methods.html">webpage</a>.


#### Update an existing employee to our demo project

**Development Process**

1. Add the **Update** button in the list employees page

```html
<!DOCTYPE HTML>
<html lang="en" xmlns:th="http://www.thymeleaf.org">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">

	<title>Employee Directory</title>
</head>

<body>

<div class="container">

	<h3>Employee Directory</h3>
	<hr>

	<!-- Add a button -->
	<a th:href="@{/employees/showFormForAdd}"
		class="btn btn-primary btn-sm mb-3">
		Add Employee
	</a>

	<table class="table table-bordered table-striped">
		<thead class="table-dark">
			<tr>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Email</th>
				<th>Action</th>
			</tr>
		</thead>

		<tbody>
			<tr th:each="tempEmployee : ${employees}">

				<td th:text="${tempEmployee.firstName}" />
				<td th:text="${tempEmployee.lastName}" />
				<td th:text="${tempEmployee.email}" />

				<!-- Add update button/link -->
				<td>
					<a th:href="@{/employees/showFormForUpdate(employeeId=${tempEmployee.id})}"
					   class="btn btn-info btn-sm">
						Update
					</a>
				</td>

			</tr>
		</tbody>
	</table>

</div>

</body>
</html>
```

2. Pre-populate Form

```java
package com.luv2code.springboot.thymeleafdemo.controller;

import java.util.List;

import com.luv2code.springboot.thymeleafdemo.service.EmployeeService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.luv2code.springboot.thymeleafdemo.entity.Employee;

@Controller
@RequestMapping("/employees")
public class EmployeeController {

	private EmployeeService employeeService;

	public EmployeeController(EmployeeService theEmployeeService) {
		employeeService = theEmployeeService;
	}

	// add mapping for "/list"

	@GetMapping("/list")
	public String listEmployees(Model theModel) {

		// get the employees from db
		List<Employee> theEmployees = employeeService.findAll();

		// add to the spring model
		theModel.addAttribute("employees", theEmployees);

		return "employees/list-employees";
	}

	@GetMapping("/showFormForAdd")
	public String showFormForAdd(Model theModel) {

		// create model attribute to bind form data
		Employee theEmployee = new Employee();

		theModel.addAttribute("employee", theEmployee);

		return "employees/employee-form";
	}

	@GetMapping("/showFormForUpdate")
	public String showFormForUpdate(@RequestParam("employeeId") int theId,
									Model theModel) {

		// get the employee from the service
		Employee theEmployee = employeeService.findById(theId);

		// set employee as a model attribute to pre-populate the form
		theModel.addAttribute("employee", theEmployee);

		// send over to our form
		return "employees/employee-form";
	}

	@PostMapping("/save")
	public String saveEmployee(@ModelAttribute("employee") Employee theEmployee) {

		// save the employee
		employeeService.save(theEmployee);

		// use a redirect to prevent duplicate submissions
		return "redirect:/employees/list";
	}
}
```


#### Delete an existing employee to our demo project


1. Add the **Delete** button in the list employees page

```html
<!DOCTYPE HTML>
<html lang="en" xmlns:th="http://www.thymeleaf.org">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">

	<title>Employee Directory</title>
</head>

<body>

<div class="container">

	<h3>Employee Directory</h3>
	<hr>

	<!-- Add a button -->
	<a th:href="@{/employees/showFormForAdd}"
		class="btn btn-primary btn-sm mb-3">
		Add Employee
	</a>

	<table class="table table-bordered table-striped">
		<thead class="table-dark">
			<tr>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Email</th>
				<th>Action</th>
			</tr>
		</thead>

		<tbody>
			<tr th:each="tempEmployee : ${employees}">

				<td th:text="${tempEmployee.firstName}" />
				<td th:text="${tempEmployee.lastName}" />
				<td th:text="${tempEmployee.email}" />

				<!-- Add update button/link -->
				<td>
					<a th:href="@{/employees/showFormForUpdate(employeeId=${tempEmployee.id})}"
					   class="btn btn-info btn-sm">
						Update
					</a>

					<!-- Add "delete" button/link -->
					<a th:href="@{/employees/delete(employeeId=${tempEmployee.id})}"
					   class="btn btn-danger btn-sm"
					   onclick="if (!(confirm('Are you sure you want to delete this employee?'))) return false">
						Delete
					</a>
				</td>

			</tr>
		</tbody>
	</table>

</div>

</body>
</html>
```

2. Add controller code for "`Delete`"

```java
package com.luv2code.springboot.thymeleafdemo.controller;

import java.util.List;

import com.luv2code.springboot.thymeleafdemo.service.EmployeeService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.luv2code.springboot.thymeleafdemo.entity.Employee;

@Controller
@RequestMapping("/employees")
public class EmployeeController {

	private EmployeeService employeeService;

	public EmployeeController(EmployeeService theEmployeeService) {
		employeeService = theEmployeeService;
	}

	// add mapping for "/list"

	@GetMapping("/list")
	public String listEmployees(Model theModel) {

		// get the employees from db
		List<Employee> theEmployees = employeeService.findAll();

		// add to the spring model
		theModel.addAttribute("employees", theEmployees);

		return "employees/list-employees";
	}

	@GetMapping("/showFormForAdd")
	public String showFormForAdd(Model theModel) {

		// create model attribute to bind form data
		Employee theEmployee = new Employee();

		theModel.addAttribute("employee", theEmployee);

		return "employees/employee-form";
	}

	@GetMapping("/showFormForUpdate")
	public String showFormForUpdate(@RequestParam("employeeId") int theId,
									Model theModel) {

		// get the employee from the service
		Employee theEmployee = employeeService.findById(theId);

		// set employee as a model attribute to pre-populate the form
		theModel.addAttribute("employee", theEmployee);

		// send over to our form
		return "employees/employee-form";
	}

	@PostMapping("/save")
	public String saveEmployee(@ModelAttribute("employee") Employee theEmployee) {

		// save the employee
		employeeService.save(theEmployee);

		// use a redirect to prevent duplicate submissions
		return "redirect:/employees/list";
	}

	@GetMapping("/delete")
	public String delete(@RequestParam("employeeId") int theId) {

		// delete the employee
		employeeService.deleteById(theId);

		// redirect to /employees/list
		return "redirect:/employees/list";

	}
}
```
