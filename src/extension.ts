import * as vscode from 'vscode';
import * as path from 'path';
import * as os from 'os';
import * as fs from 'fs';

let callbacks: string[] = [];


export function activate(context: vscode.ExtensionContext) {
    console.log('Congratulations, your extension "Python Installer" is now active!');

    let disposable = vscode.commands.registerCommand('pythoninstaller.installPython', async () => {
        // Get the absolute path to the extension directory
        const extensionPath = context.extensionPath;

        // Determine the platform
        const platform = os.platform();

        if (platform === 'darwin') {
            // macOS
            const scriptPath = path.join(extensionPath, 'commands', 'install_python.sh');
            fs.chmodSync(scriptPath, '755');

            const terminal = vscode.window.createTerminal('Python Installation');
            terminal.show();
            terminal.sendText(`cd ${extensionPath}`);
            terminal.sendText(`sh ${scriptPath} 3.11 ${extensionPath}/.env`);
        
        } else if (platform === 'win32') {
            // Windows
            const scriptPath = path.join(extensionPath, 'commands', 'maybe_windows.bat');

        
            const terminal = vscode.window.createTerminal('Python Installation');
            terminal.sendText(`cd ${extensionPath}`);
            terminal.sendText(`${scriptPath} ${extensionPath}\\.env`);
    
        } else {
            vscode.window.showInformationMessage('This command is currently supported only on macOS and Windows.');
        }
        callbacks.forEach(element => {
            vscode.commands.executeCommand(element);
        });
    });
    let addCallbackCommand = vscode.commands.registerCommand('pythoninstaller.addCallback', (callback: string) => {
        addCallback(callback);
    });

    context.subscriptions.push(addCallbackCommand);
    context.subscriptions.push(disposable);

    // need to add a command that lets you push more callbacks from other extensions
}

function addCallback(callback: string) {
    callbacks.push(callback);
}
// This method is called when your extension is deactivated

export function deactivate() {}