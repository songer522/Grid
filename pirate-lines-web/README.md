# Pirate Lines — web edition

A standalone, single-player browser version of Pirate Lines. It keeps the original 96 TMX level layouts and item placements, while using a lightweight responsive HTML/CSS/JS interface.

## Run it

```sh
npm install
npm run dev
```

Build a deployable static site with:

```sh
npm run build
```

## Level data

`src/levels.js` is generated from the original `Grid/Art/DAL_Level*.tmx` maps. If a source map changes, regenerate it from this directory:

```sh
npm run levels
```

The game is intentionally single player: all multiplayer, Game Center, StoreKit, and native iOS dependencies are absent. Progress and unlocked charts are saved locally in the browser.
