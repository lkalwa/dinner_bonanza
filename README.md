# Dinner Bonanza

A Rails application that helps you find recipes based on ingredients you have at hand.

## Features

- Search recipes by ingredients
- View recipe details including preparation and cooking time
- Responsive design with Bootstrap
- Real-time ingredient filtering
- Pagination for recipe lists

## Prerequisites

- Ruby 3.2.0 or higher
- PostgreSQL
- Node.js and Yarn
- Chrome/Chromium (for system tests)

## Installation

### First Time Setup

For the first time setup, run:

```bash
git clone git@github.com:lkalwa/dinner_bonanza.git
cd dinner_bonanza
bin/setup
```

This will:
- Install all Ruby and JavaScript dependencies
- Create and setup the database
- Seed the database with initial recipe data
- Start the development server

### Regular Development

For regular development, after the first setup:

1. Start the server:
```bash
bin/dev
```

2. If you need to update the database schema:
```bash
rails db:migrate
```

3. If you need to reset the database with fresh data:
```bash
rails db:seed
```

Visit `http://localhost:3000` to see the application.

## Usage

### Adding Ingredients
1. Type an ingredient name in the search field
2. Click "+ Add Ingredient" button
3. The ingredient will appear as a chip below the search field

### Removing Ingredients
1. Click the "X" button on any ingredient chip
2. The ingredient will be removed from the search

### Browsing Recipes
1. The main page shows all recipes sorted by rating
2. Use the pagination controls at the bottom to navigate through pages
3. Each recipe card shows:
   - Recipe image
   - Title
   - Preparation time
   - Cooking time

### Viewing Recipe Details
1. Click "Let's cook!" on any recipe card
2. The details page shows:
   - Large recipe image
   - Full title
   - Preparation and cooking times
   - Complete list of ingredients
   - Back link to return to the recipe list

### Filtering Recipes
1. Add one or more ingredients using the search field
2. The recipe list will automatically update to show only recipes containing those ingredients
3. Remove ingredients to see more recipes

## Development

### Running the Server

To start the development server, use:

```bash
bin/dev
```

This command starts both the Rails server and the CSS watcher process for handling stylesheets.

### Running Tests

```bash
bundle exec rspec
```

### Code Style

```bash
bundle exec rubocop
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.