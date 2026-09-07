import { readFile, writeFile, mkdir } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { inflateSync } from 'node:zlib';

const root = new URL('../../Grid/Art/', import.meta.url);
const out = new URL('../src/levels.js', import.meta.url);

function decode(encoded) {
  const bytes = inflateSync(Buffer.from(encoded.replace(/\s/g, ''), 'base64'));
  return Array.from({ length: bytes.length / 4 }, (_, i) => bytes.readUInt32LE(i * 4));
}

function getLayer(xml, name) {
  const match = xml.match(new RegExp(`<layer name="${name}"[\\s\\S]*?<data[^>]*>([\\s\\S]*?)<\\/data>`));
  return match ? decode(match[1]) : Array(36).fill(0);
}

function tileItems(xml) {
  // Read one tile block at a time. Looking for an Item property across the
  // whole tileset incorrectly attaches the following tile's Item to a
  // preceding LineFilled / RowFilled tile.
  return Object.fromEntries([...xml.matchAll(/<tile id="(\d+)">([\s\S]*?)<\/tile>/g)]
    .map(([, id, block]) => [Number(id) + 1, block.match(/<property name="Item" value="([^"]+)"\/>/)?.[1]])
    .filter(([, item]) => item));
}

const levels = [];
for (let number = 1; number <= 96; number++) {
  // The original iPhone build loads the Retina variant through cocos2d's
  // suffix resolver. These maps are not just higher-resolution art: their
  // layout data differs from the legacy base files.
  const xml = await readFile(new URL(`DAL_Level${number}-hd.tmx`, root), 'utf8');
  const right = getLayer(xml, 'Right');
  const down = getLayer(xml, 'Down');
  const itemTypes = tileItems(xml);
  const items = getLayer(xml, 'Items');
  const free = [];
  const contents = [];
  for (let y = 0; y < 6; y++) for (let x = 0; x < 6; x++) {
    const index = y * 6 + x;
    // TMX y is top-down; original game reverses it into its bottom-up grid model.
    if (right[index] && x < 5) free.push(`h:${x}:${5 - y}`);
    if (down[index] && y < 5) free.push(`v:${4 - y}:${x}`);
    const type = itemTypes[items[index]];
    if (type && x < 5 && y < 5) contents.push({ x, y: 4 - y, type });
  }
  levels.push({ number, free, contents });
}
await mkdir(dirname(out.pathname), { recursive: true });
await writeFile(out, `// Generated from Grid/Art/DAL_Level*.tmx. Do not hand-edit.\nexport const levels = ${JSON.stringify(levels)};\n`);
console.log(`Extracted ${levels.length} original TMX layouts.`);
