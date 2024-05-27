import * as vscode from 'vscode';
import * as path from 'path';
import * as os from 'os';
import * as fs from 'fs';

let callbacks: string[] = [];

export function activate(context: vscode.ExtensionContext) {
    let disposable = vscode.commands.registerCommand('pythoninstaller.installPython', async () => {
        // Get the absolute path to the extension directory
        const extensionPath = context.extensionPath;

        // Determine the platform
        const platform = os.platform();

        // Get a list of all terminals
        let terminals = vscode.window.terminals;

        // Iterate over the terminals
        for (let existingTerminal of terminals) {
            // Check if the terminal name is 'Python Installation'
            if (existingTerminal.name === 'Python Installation') {
                // Dispose the terminal
                existingTerminal.dispose();
            }
        }

        // Now, you can create a new terminal with the name 'Python Installation'
        let terminal: vscode.Terminal | undefined;

        if (platform === 'darwin') {
            // macOS
            const scriptPath = path.join(extensionPath, 'commands', 'install_python.sh');
            fs.chmodSync(scriptPath, '755');

            terminal = vscode.window.createTerminal('Python Installation');
            terminal.show();
            terminal.sendText(`cd ${extensionPath}`);
            terminal.sendText(`sh ${scriptPath} 3.11 ${extensionPath}/.env`);

        } else if (platform === 'win32') {
            // Windows
            const scriptPath = path.join(extensionPath, 'commands', 'maybe_windows.bat');

            terminal = vscode.window.createTerminal('Python Installation');
            terminal.sendText(`cd ${extensionPath}`);
            terminal.sendText(`${scriptPath} ${extensionPath}\\.env`);

        } else if (platform === 'linux') {
            // Linux (Ubuntu)
            const scriptPath = path.join(extensionPath, 'commands', 'install_python_linux.sh');
            fs.chmodSync(scriptPath, '755');

            const terminal = vscode.window.createTerminal('Python Installation');
            terminal.show();
            terminal.sendText(`cd ${extensionPath}`);
            terminal.sendText(`sh ${scriptPath} 3.11 ${extensionPath}/.env`);

        } else {
            vscode.window.showInformationMessage('This command is currently supported only on macOS, Windows, and Linux (Ubuntu).');
        }
        callbacks.forEach(element => {
            vscode.commands.executeCommand(element);
        });

        // Toggle the bottom panel after a delay to ensure the commands are executed
        if (terminal) {
            setTimeout(() => {
                vscode.commands.executeCommand('workbench.action.togglePanel');
            }, 6000); // Hide the terminal after 6 seconds
            // Note that I don't call terminal.dispose() because that could interrupt the script. We could probably just check if it's finished running, but I didn't have success with that.
        }
    });

    let addCallbackCommand = vscode.commands.registerCommand('pythoninstaller.addCallback', (callback: string) => {
        addCallback(callback);
    });

    context.subscriptions.push(addCallbackCommand);
    context.subscriptions.push(disposable);
}

function addCallback(callback: string) {
    callbacks.push(callback);
}

export function deactivate() { }