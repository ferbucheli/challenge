# Library Challenge

This project digitizes the management of a university library, transitioning from paper-based book loan management to a digital system. It aims to streamline the process, improving efficiency for both students and the library administrator.

![Contributors](https://img.shields.io/github/contributors/ferbucheli/places_tracker?style=flat-square&color=blue)
![Issues](https://img.shields.io/github/issues/ferbucheli/places_tracker?style=flat-square&color=blue)

## Tech Stack

<table>  
		<tr>  
			<td><b>Frontend</b></td>  
			<td>Flutter</td>  
		</tr> 
    <tr>  
			<td><b>Backend</b></td>  
			<td>Django</td>  
		</tr>  
</table>

## Features

### For Administrators

- **Add New Books**: Administrators can input new book details (code, title, author, quantity).
- **Book Management**: Option to search for books using their code (optional feature).

### For Students

- **View Available Books**: Students can browse the catalog for books (displaying code, title, author, quantity).
- **Manage Loans**: View details of borrowed books, including issue and return dates.

## Workflow

### Login

- The system simulates a login process, determining the user's role (administrator or student).

### Adding Books

- When a new book is added, required details include code, title, author, and quantity.
- If the book already exists (based on code), the available quantity is updated.

### Borrowing Process

1. **Selection**: Students view and select books from the catalog. The selected books are temporarily reserved.
2. **Confirmation or Cancellation**: The student can confirm the loan or cancel it. Cancelling releases the reserved books back to the inventory.

### Borrowing Rules

- The return date is set to 30 days post loan.
- Students cannot borrow multiple copies of the same title simultaneously.

## System Requirements

- **Development**: Can be a console program or a web application.
- **Programming Languages**: Python, Java, JavaScript.
- **Repository**: Project to be uploaded on GitHub.

Note: The project focuses on process optimization rather than interface design.
