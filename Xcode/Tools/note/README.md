## NOTE for HP Prime
**Command Line Tool**

A command-line tool that converts .md and .ntf files into the HP Prime .hpnote format, preserving formatting such as bold and italic text, font sizes, and foreground and background colors.

`Usage: note <input-file> [-o <output-file>]`

<table>
  <thead>
    <tr align="left">
      <th>Options</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>-o <output-file></td><td>Specify the filename for generated note</td>
    </tr>
    <tr>
      <td>-c or --compress</td><td>Specify if the CC note should be included</td>
    </tr>
    <tr>
      <td>-v or --verbose</td><td>Display detailed processing information</td>
    </tr>
    <tr>
      <td colspan="2"><b>Additional Commands</b></td>
    </tr>
    <tr>
      <td>--version</td><td>Displays the version information</td>
    </tr>
    <tr>
      <td>--build</td><td>Displays the build information</td>
    </tr>
    <tr>
      <td>--help</td><td>Show this help message</td>
    </tr>
  </tbody>
</table>

Download links: <a href="http://insoft.uk/action/?method=downlink&path=macos&file=note.zip">macOS</a> | <a href="http://insoft.uk/action/?method=downlink&path=pc&file=note.exe.zip">Windows

>[!NOTE]
>This <a href="http://insoft.uk/action/?method=downlink&path=macos&file=note.pkg">package installer</a> upgrades the command-line tool for Xprime version 26.1 and later.

### Supported File Types
|Type|Description|Format|
|:-|:-|:-|
|.note|HP Prime note plain text|UTF16le|
|.note|NoteText Format|UTF8|
|.ntf|NoteText Format|UTF8|
|.md|Markdown Language|UTF8|
|.hpnote|HP Prime note (Plain Text without BOM)|UTF16le|
|.hpappnote|HP Prime note (Plain Text without BOM)|UTF16le|

#### Bold Text
```
\b0 No Bold
\b1 Bold
\b Toggle Bold On/Off
```

#### Italic Text
```
\i0 No Italic
\i1 Italic
\i Toggle Italic On/Off
```

#### Underlined Text
```
\u0 No Underline
\u1 Underline
\u Toggle Underline On/Off
```

#### Strikethrough Text
```
\s0 No Strikethrough Text
\s1 Strikethrough Text
\s Toggle Strikethrough On/Off
```

#### Text Alignment
```
\a0 Left Aligned Text (Default)
\a1 Center Aligned Text
\a2 Right Aligned Text
```

#### Font Size
```
\fs7 FontSize 22
\fs Default FontSize 14
```

#### Foreground Color
```
\fg#7C00 Red Text
\fg#FFFF Default
\fg Default
```

#### Background Color
```
\bg#7C00 Red Background
\bg#FFFF Default
\bg Default
```

#### Bullets
```
\l0 None
\l1 ●
\l2   ○
\l3     ▶
\l None, ●, ○ or ▶
```
>[!NOTE]
>Markdown supports embedded NoteText Format commands to handle features it lacks, such as text alignment.
