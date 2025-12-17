const fs = require('fs');
const path = require('path');

const inputFile = path.resolve(__dirname, 'hover-data.js');
const source = fs.readFileSync(inputFile, 'utf8');

function escapeRTF(text) {
    return text
        .replace(/\\/g, '\\\\')
        .replace(/{/g, '\\{')
        .replace(/}/g, '\\}')
        .replace(/Syntax:/g, '\\b\\fs32Syntax\\par\\b0\\fs24')
    .replace(/Example:/g, '\\b\\fs28Example\\b0\\fs24')
    .replace(/Description:/g, '\\b\\fs28Description\\b0\\fs24')
        .replace(/\r?\n/g, '\\par\n');
}

function markdownToPlain(md) {
    return md
        .replace(/```[\s\S]*?```/g, block =>
            block.replace(/```.*?\n/, '').replace(/```/, '')
        )
        .replace(/^###\s*/gm, '')
        .replace(/-+/g, '')
        .replace(/\`{2,}/gm, '')
        .replace(/hpprime/gm, '')
        .replace(/\bSintaxis\b/gm, 'Syntax')
        .replace(/\\n+/gm, '\n')
        .trim();
}

const outDir = path.join(__dirname, 'rtf');
fs.mkdirSync(outDir, { recursive: true });

const blockRegex = /if\s*\(word === '([^']+)'\)\s*{([\s\S]*?)return new vscode\.Hover/g;
const blocks = [...source.matchAll(blockRegex)];

for (const block of blocks) {
    const word = block[1];
    const body = block[2];

    const markdownMatches = [...body.matchAll(/appendMarkdown\((`([^`])*`|'([^']*)')\);/g)];

    let markdown = '';
    for (const m of markdownMatches) {
        markdown += m[2] || m[3] || '';
    }

    let text = `${word}\n\n${markdownToPlain(markdown)}`;
    text = text.replace(/\bSyntax\b/gm, '');
    text = text.replace(word, "Syntax:\n");
    text = text
    .replace('`Example:`', "Example:")
    .replace('`Description:`', "Description:");
    text = text.replace(/\n\s+/gm, "\n\n");
    text = text.replace(/:\n\n/gm, ":\n");

    const rtf = `{\\rtf1\\ansi\\deff0
{\\fonttbl{\\f0\\fnil System;}}
\\f0\\fs24
${escapeRTF(text)}
}`;

    fs.writeFileSync(path.join(outDir, `${word}.rtf`), rtf, 'utf8');
}

console.log(`✔ Generated ${blocks.length} RTF files in ./rtf`);
