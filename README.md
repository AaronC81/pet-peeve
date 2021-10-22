# Pet Peeve

This is my entry to the [Inaugural Gosu Game Jam](https://itch.io/jam/gosu-game-jam).

Please see the [Itch page](https://orangeflash81.itch.io/pet-peeve) for a more
flashy description!

The code is a bit messy - it's quick-and-dirty game jam code rather than
something really polished and extensible. Some of the important components:

- `engine` contains a variety of classes to build Gosu up into a higher-level
  engine:
  - The `Entity` class can be instantiated (or extended) for something which
    has a position on the screen, and an `Animation` to draw in that position.
    (Some `Animation`s actually have only one frame to act as a static sprite.)
  - `GravityEntity` is a subclass of `Entity` which will fall if it is not on
    a floor.
  - `Transition` allows the screen to fade to and from black. At runtime one
    instance of this is created, as the `$transition` global.
- `entities` contains `Entity` subclasses to implement game items:
  - `Cat` handles movement, jumping, and swiping. This is quite long mainly due
    to the complexity of the cat's animations and swipe cooldowns.
  - `DestructableObject`s can be swiped by the cat.
  - `Scenery` acts as a floor which the cat can jump on.
  - `CatFlap` is "activated" when the level is cleared, allowing the cat to
    move to the next level.
  - `Wall` is simply placed behind the level as a background.
- Ruby files not in a folder tend to control higher-level systems:
  - `main.rb` is the game entry point, which instantiates lots of globals,
    calls tick/draw events, and sends input to `$world.cat`.
  - `GameState` keeps track of score and draws the in-game UI.
  - `Menus` draws the splash screen, main menu, and game over menu.
  - `World` stores references to all entities and ties most systems together.
    It also handles generating new levels once the current one is cleared. 

## Running

```
bundle install
bundle exec ruby ./src/main.rb
```

This has been tested on Ruby 2.7.1 and Ruby 3.0.0, both on Arch Linux.

## Building an EXE

```
gem install ocra
build.bat
```
