# Amador Demo App

## Getting Started

Use a programming language/multiple programming languages of choice.

Feel free to experiment in js framework: svelte

Preferred: Python, R (Shiny: Using Rhino framework)

Set this up however you feel comfortable. As long as the requirements of this app are met, the approach does not matter and we will optimize later.

## Requirements

1.  Create a front end that allows users to upload data in (.csv) format: use iris, mtcars, diamonds as toy datasets.
2.  Link the back end database (Mongo/Arango) to the front end UI.
    -   E.g., once dataset is uploaded, it is stored in the database.
3.  Render the dataset that is uploaded to the UI.
4.  Create multiple buttons for the UI that manipulate data: Examples: “Delete Column”, “Add Column”, “Remove Row”, “Sum Column”.
    -   May need to rely on data manipulation packages here: pandas, dplyr, etc…
5.  Create query streams from these buttons that are compatible with database of choice and that are reactive at the click
    -   E.g., the buttons automatically create a query stream and performs the action in real time on the dataset that is rendered to the UI.
6.  You may have to setup your own MongoDB/ArangoDB instance, or use one and share it. This may require some configuration on your end. If this is taking too long – feel free to use a public test instance:
    ```
    url ="mongodb+srv://readwrite:test@cluster0-84vdt.mongodb.net/test"
    ```
7.  This will take some working through.
8.  Get creative.
9.  Don't worry.
10. Use intuition and be as simple as possible.

## Resources

https://www.mongodb.com/↩︎

https://www.arangodb.com/↩︎

https://dev.to/ashraf_zolkopli/django-svelte-best-dev-experience-dx-1848↩︎

https://github.com/Appsilon/rhino↩︎

https://appsilon.github.io/rhino/articles/tutorial/create-your-first-rhino-app.html↩︎

https://github.com/ranikay/shiny-reticulate-app↩︎

https://jeroen.github.io/mongolite/index.html↩︎

https://github.com/jeroen/mongolite/↩︎