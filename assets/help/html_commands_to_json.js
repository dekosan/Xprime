const fs = require('fs');
const path = require('path');

const html = fs.readFileSync('commands.html', 'utf8');

// Ensure output folder exists
const outputDir = path.join(__dirname, 'commands');
if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir);
}
// ““
// Regex to match each command section
const sectionRegex = /<a name="([^"]+)"><\/a>\s*<div class="command"[^>]*>([\s\S]*?<\/div>)\s*<\/div>/gi;

function toFileName(name) {
    return name
    .replace(/&gt;/g, '>')            // >
    .replace(/&lt;/g, '<');           // <
}

let match;

let commands = new Array();

while ((match = sectionRegex.exec(html)) !== null) {
    const name = toFileName(match[1]);
    
    commands.push(`${name}`);
}

commands.push("AFiles","AFilesB","DelAFiles");

commands.sort((a, b) =>
  a.localeCompare(b, undefined, { sensitivity: "base" }) ||
  a.localeCompare(b, undefined, { sensitivity: "case" })
);

let pattern = `(?mi)(?<![a-z%\\\\u0080-\\\\uFFFF])(?:` + commands.join("|") + `)\\\\b`;

const filePath = path.join(outputDir, `commands.json`);
fs.writeFileSync(filePath, pattern, 'utf8');
console.log(`Created ${filePath}`);

console.log('All sections extracted.');
