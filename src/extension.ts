import * as vscode from 'vscode';
import * as path from 'path';
import * as os from 'os';
import * as fs from 'fs';

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

            // Display an informational message to non-technical users in a centered modal
            const infoMessage =
                'This extension will install Homebrew and Python on your Mac. ' +
                'You may need to enter your password.';

            const selection = await vscode.window.showInformationMessage(infoMessage, { modal: true }, 'OK', 'Cancel');

            if (selection === 'OK') {
                const terminal = vscode.window.createTerminal('Python Installation');
                terminal.show();
                terminal.sendText(`cd ${extensionPath}`);
                terminal.sendText(`sh ${scriptPath} 3.11 ${extensionPath}/.env`);
            }
        } else if (platform === 'win32') {
            // Windows
            const scriptPath = path.join(extensionPath, 'commands', 'maybe_windows.bat');

            // Display an informational message to non-technical users in a centered modal
            const infoMessage =
                'This extension will download and install Python on your Windows machine. ' +
                'You may need to provide administrative privileges.';

            const selection = await vscode.window.showInformationMessage(infoMessage, { modal: true }, 'OK', 'Cancel');

            if (selection === 'OK') {
                const terminal = vscode.window.createTerminal('Python Installation');
                terminal.show();
                terminal.sendText(`cd ${extensionPath}`);
                terminal.sendText(`${scriptPath} 3.11 ${extensionPath}\\.env`);
            }
        } else {
            vscode.window.showInformationMessage('This command is currently supported only on macOS and Windows.');
        }
    });

    context.subscriptions.push(disposable);
}

// This method is called when your extension is deactivated
export function deactivate() {}