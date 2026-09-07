import './style.css';
import { levels } from './levels.js';

const app = document.querySelector('#app');
// Match the original Cocos2d flips: cannon art faces left by default, while
// ship art faces right by default.
const icons = { TreasureBox: 'treasure', CannonLeft: 'cannon', CannonRight: 'cannon flip', ShipLeft: 'ship flip', ShipRight: 'ship', MapOne: 'map', MapTwo: 'map', Skull: 'skull', Fog: 'fog' };
const labels = { Empty: '', TreasureBox: 'treasure', CannonLeft: 'cannon', CannonRight: 'cannon', ShipLeft: 'ship', ShipRight: 'ship', MapOne: 'map', MapTwo: 'map', Skull: 'skull', Fog: 'mystery' };
let selected = Number(localStorage.getItem('pirate-lines-level') || 1);
// Temporary QA setting: expose the complete campaign while validating the
// browser port against the original iOS maps.
let unlocked = 96;
let game;
let tutorialTimer;
const tutorialPages = { 1: 1, 2: 2, 3: 3, 5: 4, 8: 5, 12: 6, 17: 7, 19: 8 };
// Original board geometry: X_MARGIN 27.5 on a 320pt canvas and 53pt edges.
const GRID_INSET = 8.59375;
const GRID_STEP = 16.5625;
const CANNON_FRAME = { texture: [394, 367, 93, 73], color: [144, 43] };
const CANNON_SHOT_FRAMES = [
  { texture: [253, 84, 23, 25], color: [138, 46] },
  { texture: [253, 144, 23, 23], color: [116, 44] },
  { texture: [253, 114, 23, 25], color: [95, 53] },
  { texture: [253, 172, 23, 23], color: [84, 73] },
  { texture: [328, 318, 61, 53], color: [64, 56] },
  { texture: [5, 777, 81, 71], color: [56, 51] },
  { texture: [131, 84, 117, 99], color: [42, 30] },
  { texture: [125, 188, 113, 99], color: [38, 28] },
  { texture: [401, 164, 101, 85], color: [46, 40] },
];

function edgeId(kind, a, b) { return `${kind}:${a}:${b}`; }
function boxEdges(x, y) { return [edgeId('h', x, y), edgeId('h', x, y + 1), edgeId('v', y, x), edgeId('v', y, x + 1)]; }
function edgeDots(key) {
  const [kind, aValue, bValue] = key.split(':');
  const a = Number(aValue); const b = Number(bValue);
  if (kind === 'h') {
    const row = 5 - b;
    return [`${a}:${row}`, `${a + 1}:${row}`];
  }
  const row = 4 - a;
  return [`${b}:${row}`, `${b}:${row + 1}`];
}
function ownerName(owner) { return owner === 'player' ? 'You' : 'CPU'; }
function powerGraphic(type) { return icons[type] ? `<i class="power-icon ${icons[type]}" aria-hidden="true"></i>` : `<span>${type === 'Fog' ? '?' : ''}</span>`; }

function boot() {
  app.innerHTML = `
    <section class="game-shell">
      <header><button class="brand" id="levels" aria-label="Choose a level"><img src="/assets/pirate-lines-logo.png" alt="Pirate Lines"></button><div class="header-actions"><button id="reset" aria-label="Restart level">↻</button><button id="help" aria-label="How to play">?</button></div></header>
      <section class="statusbar"><div><small>VOYAGE</small><strong id="level-label">LEVEL ${selected}</strong></div><div id="turn" class="turn player">YOUR TURN</div><div class="objective"><small>CHART</small><strong id="objective">0 / 0</strong></div></section>
      <section class="board-wrap"><div id="board" class="board" aria-label="Pirate Lines game board"></div></section>
      <section class="scoreboard"><div class="score player-score"><i class="turn-arrow" aria-hidden="true"></i><div class="score-box"><strong id="player-score">0</strong></div><span>YOU</span></div><div class="score cpu-score"><i class="turn-arrow" aria-hidden="true"></i><div class="score-box"><strong id="cpu-score">0</strong></div><span>CPU</span></div></section>
      <p id="message" class="message">Claim a route to begin your voyage.</p>
    </section>
    <dialog id="panel"></dialog>`;
  document.querySelector('#reset').onclick = () => start(selected);
  document.querySelector('#levels').onclick = showLevels;
  document.querySelector('#help').onclick = showHelp;
  start(selected);
}

function dismissTutorial() {
  window.clearTimeout(tutorialTimer);
  document.querySelector('.tutorial-overlay')?.remove();
}

function showLevelTutorial(page) {
  if (game.over) return;
  const overlay = document.createElement('section');
  overlay.className = 'tutorial-overlay';
  overlay.setAttribute('role', 'dialog');
  overlay.setAttribute('aria-modal', 'true');
  overlay.setAttribute('aria-label', `Tutorial page ${page}`);
  overlay.innerHTML = `<div class="tutorial-card"><img class="tutorial-page" src="/assets/tutorial-${page}.png" alt="Pirate Lines tutorial"><button class="tutorial-close" aria-label="Close tutorial"><img src="/assets/tutorial-close.png" alt=""></button></div>`;
  overlay.querySelector('.tutorial-close').onclick = dismissTutorial;
  document.body.append(overlay);
}

function scheduleTutorial(levelNumber) {
  dismissTutorial();
  const page = tutorialPages[levelNumber];
  if (page) tutorialTimer = window.setTimeout(() => showLevelTutorial(page), 1500);
}

function start(number) {
  selected = number;
  localStorage.setItem('pirate-lines-level', selected);
  const level = levels[number - 1];
  game = { level, available: new Set(level.free), claimed: new Map(), boxes: new Map(level.contents.map(item => [`${item.x}:${item.y}`, { ...item, owner: null }])), justClaimed: new Set(), lastCpuEdge: null, turn: 'player', busy: false, over: false, score: { player: 0, cpu: 0 } };
  if (number === 1 || number === 2) {
    game.turn = 'cpu';
    game.busy = true;
    setMessage('The CPU opens the first voyage…');
  }
  render();
  if (number === 1 || number === 2) window.setTimeout(cpuMove, 650);
  scheduleTutorial(number);
}

function render() {
  const board = document.querySelector('#board');
  board.innerHTML = '';
  game.boxes.forEach((box, key) => {
    const [x, y] = key.split(':').map(Number);
    const tile = document.createElement('div');
    tile.className = `tile ${box.owner || ''} ${box.type === 'Fog' && !box.owner ? 'fog' : ''}`;
    tile.style.left = `${GRID_INSET + x * GRID_STEP}%`; tile.style.top = `${GRID_INSET + (4 - y) * GRID_STEP}%`;
    tile.style.width = `${GRID_STEP}%`; tile.style.height = `${GRID_STEP}%`;
    const type = box.owner && box.type === 'Fog' ? box.revealedType : box.type;
    const pattern = !box.owner ? '<i class="bone-pattern" aria-hidden="true"></i>' : '';
    const visual = box.type === 'Empty' && !box.owner ? '' : powerGraphic(type);
    const claimedBox = box.owner ? `<i class="claimed-box ${box.owner}${box.broken ? ' broken' : ''}${game.justClaimed.has(key) ? ' newly-claimed' : ''}" aria-label="${box.broken ? 'broken ' : ''}${box.owner} box"></i>` : '';
    tile.innerHTML = `${claimedBox || `${pattern}${visual}${box.type !== 'Empty' ? `<em>${labels[type]}</em>` : ''}`}`;
    board.append(tile);
  });
  game.available.forEach(key => {
    const [kind, a, b] = key.split(':'); const line = document.createElement('button');
    line.className = `route ${kind} ${game.claimed.get(key) || ''}`;
    line.dataset.edge = key; line.setAttribute('aria-label', `Claim route ${key}`);
    if (kind === 'h') {
      line.style.left = `${GRID_INSET + Number(a) * GRID_STEP}%`;
      line.style.top = `${GRID_INSET + (5 - Number(b)) * GRID_STEP}%`;
      line.style.width = `${GRID_STEP}%`;
    } else {
      line.style.left = `${GRID_INSET + Number(b) * GRID_STEP}%`;
      line.style.top = `${GRID_INSET + (4 - Number(a)) * GRID_STEP}%`;
      line.style.height = `${GRID_STEP}%`;
    }
    line.disabled = game.busy || game.over || game.turn !== 'player' || game.claimed.has(key);
    line.onclick = () => play(key, 'player'); board.append(line);
  });
  const playableDots = new Set();
  game.available.forEach(key => edgeDots(key).forEach(dot => playableDots.add(dot)));
  const lastCpuDots = new Set(game.lastCpuEdge ? edgeDots(game.lastCpuEdge) : []);
  playableDots.forEach(key => {
    const [x, y] = key.split(':').map(Number);
    const dot = document.createElement('b');
    dot.className = `dot${lastCpuDots.has(key) && game.turn === 'player' && !game.over ? ' last-opponent' : ''}`;
    dot.style.left = `${GRID_INSET + x * GRID_STEP}%`;
    dot.style.top = `${GRID_INSET + y * GRID_STEP}%`;
    board.append(dot);
  });
  // A full render replaces the DOM, so consume this one-frame visual state.
  // Previously every claimed box received the animation again on each render.
  game.justClaimed.clear();
  updateHud();
}

function updateHud() {
  const finished = [...game.boxes.values()].filter(box => box.owner).length;
  document.querySelector('#level-label').textContent = `LEVEL ${selected}`;
  document.querySelector('#objective').textContent = `${finished} / ${game.boxes.size}`;
  document.querySelector('#player-score').textContent = game.score.player;
  document.querySelector('#cpu-score').textContent = game.score.cpu;
  document.querySelector('.player-score').classList.toggle('active', !game.over && game.turn === 'player');
  document.querySelector('.cpu-score').classList.toggle('active', !game.over && game.turn === 'cpu');
  const turn = document.querySelector('#turn'); turn.textContent = game.over ? 'VOYAGE COMPLETE' : game.turn === 'player' ? 'YOUR TURN' : 'CPU THINKING'; turn.className = `turn ${game.turn}`;
}

// Resolve from board state rather than from the most recently clicked route.
// This mirrors the original GameLayer's square checks, while also ensuring a
// completed square can never be skipped because of an edge-coordinate lookup.
function completedBy() { return [...game.boxes.entries()].filter(([key, box]) => !box.owner && boxEdges(...key.split(':').map(Number)).every(id => game.claimed.has(id))); }
function reward(type) { return type === 'TreasureBox' ? 2 : type.startsWith('Map') ? 1 : type === 'Skull' ? -2 : 1; }
function actualType(box) {
  if (box.type !== 'Fog') return box.type;
  const roll = Math.random() * 100;
  box.revealedType = roll < 20 ? 'TreasureBox' : roll < 60 ? 'Skull' : roll < 80 ? 'CannonRight' : 'ShipRight';
  return box.revealedType;
}
function adjust(owner, amount) { game.score[owner] += amount; }
function applyPower(box, owner) {
  const type = actualType(box);
  adjust(owner, reward(type));
  const opponent = owner === 'player' ? 'cpu' : 'player';
  if (type.startsWith('Cannon')) {
    const targetX = box.x + (type === 'CannonRight' ? 1 : -1);
    const target = game.boxes.get(`${targetX}:${box.y}`);
    if (target?.owner === opponent) { target.broken = true; adjust(opponent, -1); }
  }
  if (type.startsWith('Ship')) {
    const direction = type === 'ShipRight' ? 1 : -1;
    for (let x = box.x + direction; x >= 0 && x < 5; x += direction) {
      const target = game.boxes.get(`${x}:${box.y}`);
      if (target?.owner === opponent) { target.owner = owner; target.broken = false; adjust(opponent, -1); adjust(owner, 1); }
    }
  }
  if (type.startsWith('Map')) {
    const maps = [...game.boxes.values()].filter(candidate => candidate.owner === owner && candidate.type.startsWith('Map'));
    if (maps.length >= 2 && !game[`${owner}MapBonus`]) { game[`${owner}MapBonus`] = true; adjust(owner, 5); }
  }
  return type;
}

function showShipEffects(effects) {
  const board = document.querySelector('#board');
  effects.forEach(({ box, type }) => {
    const direction = type === 'ShipRight' ? 'right' : 'left';
    const effect = document.createElement('i');
    effect.className = `ship-effect ${direction}`;
    effect.style.left = `${GRID_INSET + (box.x + 0.5) * GRID_STEP}%`;
    effect.style.top = `${GRID_INSET + (4.5 - box.y) * GRID_STEP}%`;
    effect.innerHTML = `<i class="power-icon ship${direction === 'left' ? ' flip' : ''}" aria-hidden="true"></i>`;
    effect.addEventListener('animationend', () => effect.remove(), { once: true });
    board.append(effect);
  });
}

function setAtlasFrame(element, frame, scale) {
  const [textureX, textureY, width, height] = frame.texture;
  const [canvasX, canvasY] = frame.color;
  Object.assign(element.style, {
    left: `${canvasX * scale}px`,
    top: `${canvasY * scale}px`,
    width: `${width * scale}px`,
    height: `${height * scale}px`,
    backgroundSize: `${512 * scale}px ${1024 * scale}px`,
    backgroundPosition: `${-textureX * scale}px ${-textureY * scale}px`,
  });
}

function showCannonEffects(effects) {
  const board = document.querySelector('#board');
  const edgeLength = board.clientWidth * GRID_STEP / 100;
  const scale = edgeLength / 106;
  effects.forEach(({ box, type }) => {
    const direction = type === 'CannonRight' ? 'right' : 'left';
    const facing = direction === 'right' ? 1 : -1;
    const effect = document.createElement('i');
    effect.className = `cannon-effect ${direction}`;
    effect.style.left = `${GRID_INSET + (box.x + 0.5) * GRID_STEP + facing * 0.53 * GRID_STEP}%`;
    effect.style.top = `${GRID_INSET + (4.4 - box.y) * GRID_STEP}%`;
    effect.style.width = `${265 * scale}px`;
    effect.style.height = `${133 * scale}px`;
    effect.innerHTML = '<i class="atlas-frame cannon-body"></i><i class="atlas-frame cannon-shot"></i>';
    const cannon = effect.querySelector('.cannon-body');
    const shot = effect.querySelector('.cannon-shot');
    setAtlasFrame(cannon, CANNON_FRAME, scale);
    setAtlasFrame(shot, CANNON_SHOT_FRAMES[0], scale);
    board.append(effect);
    CANNON_SHOT_FRAMES.slice(1).forEach((frame, index) => {
      window.setTimeout(() => {
        if (shot.isConnected) setAtlasFrame(shot, frame, scale);
      }, (index + 1) * 56);
    });
    window.setTimeout(() => effect.classList.add('fade'), 500);
    window.setTimeout(() => effect.remove(), 1000);
  });
}

function play(edge, owner) {
  if (game.claimed.has(edge) || game.over) return;
  if (owner === 'cpu') game.lastCpuEdge = edge;
  else game.lastCpuEdge = null;
  game.claimed.set(edge, owner);
  const captured = completedBy();
  const cargo = [];
  const shipEffects = [];
  const cannonEffects = [];
  game.justClaimed = new Set(captured.map(([key]) => key));
  captured.forEach(([key, box]) => {
    box.owner = owner;
    const type = applyPower(box, owner);
    if (type.startsWith('Ship')) shipEffects.push({ box, type });
    if (type.startsWith('Cannon')) cannonEffects.push({ box, type });
    if (type !== 'Empty') cargo.push(labels[type]);
  });
  const effectDuration = cannonEffects.length ? 1000 : shipEffects.length ? 900 : 0;
  if (captured.length) setMessage(`${ownerName(owner)} ${owner === 'player' ? 'claimed' : 'claims'} ${captured.length} square${captured.length > 1 ? 's' : ''}${cargo.length ? ` — ${cargo.join(', ')} activated!` : '!'}`);
  else { game.turn = owner === 'player' ? 'cpu' : 'player'; setMessage(owner === 'player' ? 'The CPU is plotting a course…' : 'Your turn — seize the advantage.'); }
  if ([...game.boxes.values()].every(box => box.owner)) {
    finish(effectDuration);
    showShipEffects(shipEffects);
    showCannonEffects(cannonEffects);
    return;
  }
  if (game.turn === 'cpu') {
    game.busy = true;
    render();
    showShipEffects(shipEffects);
    showCannonEffects(cannonEffects);
    window.setTimeout(cpuMove, Math.max(550, effectDuration));
  } else {
    game.busy = effectDuration > 0;
    render();
    showShipEffects(shipEffects);
    showCannonEffects(cannonEffects);
    if (effectDuration) window.setTimeout(() => { game.busy = false; render(); }, effectDuration);
  }
}

function cpuMove() {
  game.busy = false;
  const choices = [...game.available].filter(edge => !game.claimed.has(edge));
  // Port of the original CPUBrain priority: finish a three-sided box, then
  // choose a route that cannot make a two-sided box, then take a two-sided
  // route only when no safer route exists. This intentionally avoids a
  // score-maximising minimax strategy; the iOS CPU was a tactical, random AI.
  const adjacent = edge => [...game.boxes.entries()].filter(([key, box]) => !box.owner && boxEdges(...key.split(':').map(Number)).includes(edge));
  const count = key => boxEdges(...key.split(':').map(Number)).filter(id => game.claimed.has(id)).length;
  const completing = choices.filter(edge => adjacent(edge).some(([key]) => count(key) === 3));
  const safe = choices.filter(edge => adjacent(edge).every(([key]) => count(key) <= 1));
  const twoSided = choices.filter(edge => adjacent(edge).some(([key]) => count(key) === 2));
  const pool = completing.length ? completing : safe.length ? safe : twoSided.length ? twoSided : choices;
  play(pool[Math.floor(Math.random() * pool.length)], 'cpu');
}

function finish(effectDuration = 0) {
  game.over = true; const won = game.score.player >= game.score.cpu;
  if (won && selected >= unlocked && selected < 96) { unlocked = selected + 1; localStorage.setItem('pirate-lines-unlocked', unlocked); }
  render();
  setMessage(won ? 'Victory! Your flag flies over this chart.' : 'The CPU takes this chart. Try a different route.');
  window.setTimeout(() => showResult(won), Math.max(350, effectDuration));
}

function setMessage(text) { document.querySelector('#message').textContent = text; }
function openPanel(content) { const panel = document.querySelector('#panel'); panel.innerHTML = content; panel.showModal(); panel.querySelectorAll('[data-close]').forEach(el => el.onclick = () => panel.close()); }
function showHelp() { dismissTutorial(); openPanel(`<button class="close" data-close>×</button><h2>How to play</h2><p>Take turns claiming the glowing routes. Complete a square to claim it and take another turn.</p><p>Power-ups follow the original rules: treasure earns 2, skulls cost 2, cannons damage an adjacent enemy square, ships take over a row, and both map pieces earn a 5-point bonus. Fog hides a random power-up.</p><button class="primary" data-close>Set sail</button>`); }
function showResult(won) { openPanel(`<h2>${won ? 'Chart conquered!' : 'Chart lost'}</h2><p>${won ? 'The next chart is now available.' : 'The sea is fickle — give it another voyage.'}</p><div class="result-score"><span>You <b>${game.score.player}</b></span><span>CPU <b>${game.score.cpu}</b></span></div><div class="panel-actions"><button data-close>Charts</button><button class="primary" id="again">${won && selected < 96 ? 'Next level' : 'Try again'}</button></div>`); document.querySelector('#again').onclick = () => { document.querySelector('#panel').close(); start(won && selected < 96 ? selected + 1 : selected); }; }
function showLevels() { dismissTutorial(); const buttons = levels.map(level => `<button class="level ${level.number <= unlocked ? '' : 'locked'} ${level.number === selected ? 'active' : ''}" data-level="${level.number}" ${level.number > unlocked ? 'disabled' : ''}>${level.number <= unlocked ? level.number : '⚓'}</button>`).join(''); openPanel(`<button class="close" data-close>×</button><h2>Choose a chart</h2><p class="muted">96 original voyage layouts · single player</p><div class="level-grid">${buttons}</div>`); document.querySelectorAll('[data-level]').forEach(button => button.onclick = () => { document.querySelector('#panel').close(); start(Number(button.dataset.level)); }); }

boot();
