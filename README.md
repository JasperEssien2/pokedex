# Pokedex

Welcome to the **Pokedex** assignment!

In this assignment, you will be implementing a Flutter application that allows interacting with Pokemons. We hope you like it!

## Assignment Instructions

### Designs

- You can access to the designs of the application from this [link](https://www.figma.com/file/vP3TT058xIqpOv5zv7cUg9/Pokedex-Assessment?node-id=32%3A83).
  - You need to have a Figma account to see the all details. So, please create one if you don't have.
- You can click the **Present** button from top right, to see different flows.
- You can use the static assets in the designs, if required.
- Please follow the designs as much as possible except these cases:
   - For the background colors of Pokemons there are no strict rules, you can specify your own logic to determine them.
   - For **Base stats** section on the **Pokemon details page**, feel free to specify your own logic to determine the colors, which basically indicate the magnitude of each field Hp, Attack, etc.

### Implementation Details

#### General Rules

- You should use latest stable Flutter version.
- You can use any library or any method you like, to implement the application.
- Make sure that you unit test your methods or functions when necessary.
- You can use Android devices/emulators while implementing the application, we will be testing with them.
- Make sure UI looks good for various screen sizes as well.
- Do not forget error handling, there may be scenarios you want to handle.

#### Pages

- Splash Screen
   - It needs to be shown while application is starting.
- All Pokemons
   - You need to fetch the Pokemons from this API: https://pokeapi.co
   - You need to use pagination since there are lots of Pokemons to be listed coming from API.
   - For Pokemon
      - #001 -> **id**
      - **Bulbasaur** -> **name**
      - **Grass, Poison** -> from **types** field
   - For the image of a Pokemon you can use, **sprites** > **other** > **official-artwork** > **front_default**.
   - All Pokemons will be listed on this tab.
   - We would like to see a progress indicator (style it however you want) while Pokemons are being fetched.
- Favourites
   - When a Pokemon is marked as favourite by clicking **Mark as favourite** button on the **Pokemon details page**, it should be shown on this tab.
   - The number of Pokemons marked as favourite, should be shown near the tab text as shown on designs.
   - Pokemons that are marked as favourite should be persistent and the data can be stored on disk. So, after a Pokemon is marked as favourite, it should still be shown under **Favourites** tab even after application is closed and started again.
     - Please note that, we always want to see the most up-to-date information (what API returns) of the Pokemons marked as favourite. Plan your persistence strategy accordingly.
- Pokemon details page
   - Although it is not apparent from the designs, we want you to use **SliverAppBar** while implementing the app bar of this page.
   - In order to calculate BMI use this formula: **weight / (height^2)** without caring any units.
   - In order to calculate **Avg. Power** under **Base stats**, use this formula: **(Hp + Attack + Defense + Special Attack + Special Defense + Speed) / 6**
   - **Remove from favourites** button removes the related Pokemon from the list shown on **Favourites** tab.

## Submission
- You have 7 days to complete this task.
- Please open a Pull/Merge request to this repository with everything you have prepared.
- Prepare necessary instructions to run your application in DOC.md file. Also include references for used libraries, frameworks, code snippets.
- If you have any questions, please send us an email, we'll get back to you as soon as possible.
- Also, when you open the Pull/Merge request, please let us know via an email.

## Evaluation Criterias
Not in order of priority:
   - Code Readability
   - Reusable widget usage
   - Unit Testing
   - State Management
   - UI similar to the designs
   - UI for various screen sizes
   - Error handling
