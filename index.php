<?php
$scriptUrl = "https://raw.githubusercontent.com/undoLogic/LINUX-Personal-Server/main/download-LINUX-Personal-Server.sh";
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>download-LINUX-Personal-Server.sh</title>
    <style>
        body {
            font-family: monospace;
            background: #f4f4f4;
            padding: 2rem;
        }
        .container {
            background: white;
            padding: 1rem;
            border: 1px solid #ccc;
            max-width: 800px;
            margin: auto;
            border-radius: 5px;
        }
        code {
            display: block;
            background: #eee;
            padding: 0.5rem;
            margin: 1rem 0;
            font-size: 1rem;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>🚀 Install Your Dev Environment</h1>
    <p>Run this one-liner in iSH, Alpine, or any Linux terminal:</p>
    <code>curl -sO <?= htmlspecialchars($scriptUrl); ?> &amp;&amp; chmod +x download-LINUX-Personal-Server.sh &amp;&amp; ./download-LINUX-Personal-Server.sh</code>

    <p>Or to run it without saving the file:</p>
    <code>sh -c "$(curl -fsSL <?= htmlspecialchars($scriptUrl); ?>)"</code>

    <p>📦 Repository: <a href="https://github.com/undoLogic/LINUX-Personal-Server" target="_blank">undoLogic/LINUX-Personal-Server</a></p>
</div>
</body>
</html>
