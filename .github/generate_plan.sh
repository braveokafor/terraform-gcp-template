#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <plan-file> <pr-number> <commit-sha> <repo-name>"
    exit 1
fi


plan_file=$1
pr_number=$2
commit_sha=$3
repo_name=$4

pr_url=https://github.com/$repo_name/pull/pr_number
commit_url="https://github.com/$repo_name/commit/$commit_sha"
repo_url="https://github.com/$repo_name"


planOutput=$(terraform show $plan_file | jq -Rs)
graphJson=$(terraform graph -plan=$plan_file | dot -Tdot_json | jq '.objects | walk(if type == "object" then del(.shape) else . end)')
graphSVG=$(terraform graph -plan=$plan_file | dot -Tsvg | tr -d "\n")

# Create or overwrite plan.html
cat > plan.html <<EOL
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/terminal.css@0.7.2/dist/terminal.min.css" />
    <title>Terraform Report for PR #$repo_name ($pr_number)</title>
    <style>
        :root {
            --global-font-size: 15px;
            --global-line-height: 1.4em;
            --font-stack: -apple-system, BlinkMacSystemFont, Segoe UI, Helvetica,
                Arial, sans-serif, Apple Color Emoji, Segoe UI Emoji, Segoe UI Symbol;
            --background-color: #222225;
            --page-width: 60em;
            --font-color: #e8e9ed;
            --code-bg-color: #3f3f44;
            --input-style: solid;
            --display-h1-decoration: none;
        }

        .terraform {
            white-space: pre-wrap;
            padding: 1em;
        }

        .ansi-bold {
            font-weight: bold;
        }

        .ansi-green {
            color: limegreen;
        }

        .ansi-red {
            color: red;
        }

        .ansi-yellow {
            color: yellow;
        }

        .ansi-blue {
            color: blue;
        }

        .ansi-cyan {
            color: cyan;
        }

        .ansi-white {
            color: white;
        }

        .renderjson a {
            text-decoration: none;
        }

        .renderjson .disclosure {
            color: crimson;
            font-size: 150%;
        }

        .renderjson .syntax {
            color: grey;
        }

        .renderjson .string {
            color: red;
        }

        .renderjson .number {
            color: cyan;
        }

        .renderjson .boolean {
            color: plum;
        }

        .renderjson .key {
            color: lightblue;
        }

        .renderjson .keyword {
            color: lightgoldenrodyellow;
        }

        .renderjson .object.syntax {
            color: lightseagreen;
        }

        .renderjson .array.syntax {
            color: lightsalmon;
        }
    </style>
</head>

<body>
    <section>
        <div class="terminal-card">
            <header class="terminal-logo">Pull Request Information</header>
            <div id="pr-info" class="terminal-card">
                <h4 class="terminal-prompt">repo</h4>
                <p>
                    <a href="$repo_url" class="no-style">$repo_name</a>
                </p>

                <h4 class="terminal-prompt">pr</h4>
                <p>
                    <a href="$pr_url" class="no-style">$pr_number</a>
                </p>

                <h4 class="terminal-prompt">commit</h4>
                <p>
                    <a href="$commit_url" class="no-style">$commit_sha</a>
                </p>
            </div>
        </div>
        <br />

        <div class="terminal-card">
            <header>Plan Terminal Output</header>
            <div id="terraform-plan" class="terminal-card terraform"></div>
        </div>
        <br />

        <div class="terminal-card">
            <header>Plan Graph SVG</header>
            <div id="terraform-graph-svg" class="terminal-card terraform">$graphSVG</div>
        </div>
        <br />

        <div class="terminal-card">
            <header>Plan Graph JSON</header>
            <div id="terraform-graph-json" class="terminal-card terraform"></div>
        </div>
    </section>

    <script>
        function ansiToHtml(ansiText) {
            const mappings = [
                { regex: /\x1b\[0m/g, replace: '</span>' }, // Reset
                { regex: /\x1b\[1m/g, replace: '<span class="ansi-bold">' }, // Bold
                { regex: /\x1b\[32m/g, replace: '<span class="ansi-green">' }, // Green
                { regex: /\x1b\[31m/g, replace: '<span class="ansi-red">' }, // Red
                { regex: /\x1b\[33m/g, replace: '<span class="ansi-yellow">' }, // Yellow
                { regex: /\x1b\[34m/g, replace: '<span class="ansi-blue">' }, // Blue
                { regex: /\x1b\[36m/g, replace: '<span class="ansi-cyan">' }, // Cyan
                { regex: /\x1b\[37m/g, replace: '<span class="ansi-white">' } // White
            ];

            mappings.forEach(mapping => {
                ansiText = ansiText.replace(mapping.regex, mapping.replace);
            });

            return ansiText;
        }

        const planCMD = '<h4 class="terminal-prompt">terraform show $plan_file</h4>';
        const planOutput = $planOutput;
        var planDiv = document.getElementById('terraform-plan')

        planDiv.innerHTML = planCMD + ansiToHtml(planOutput);
    </script>

    <script src="https://cdn.rawgit.com/caldwell/renderjson/master/renderjson.js"></script>

    <script>
        var graphJson = $graphJson;
        var graphDiv = document.getElementById('terraform-graph-json')

        graphDiv.appendChild(renderjson.set_icons('+', '-').set_show_to_level(2)(graphJson))
    </script>

</body>

</html>
EOL

echo "plan.html has been generated successfully."
