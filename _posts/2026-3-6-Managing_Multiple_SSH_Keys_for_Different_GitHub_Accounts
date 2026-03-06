---
title: Managing Multiple SSH Keys for Different GitHub Accounts
header:
  teaser: /assets/images/ssh-keys-teaser.svg
categories:
  - Blog
tags:
  - GitHub
  - SSH
---

# Managing Multiple SSH Keys for Different GitHub Accounts

If you're like many developers, you've got more than one GitHub account — maybe a personal one for side projects and open-source contributions, and a work account tied to your organization. The moment you try to push or pull from both, you run headfirst into an annoying reality: GitHub doesn't allow the same SSH key on multiple accounts.

So how do you juggle them cleanly? The answer is a well-configured SSH config file and a bit of discipline around your Git setup. Let's walk through it step by step — with instructions for **Windows**, **macOS**, and **Linux**.

## Why You Need Separate Keys

GitHub identifies you by your SSH key, not by your username. When you push to a repo, GitHub looks at the key presented during the SSH handshake and maps it to an account. If you try to add the same public key to two different accounts, GitHub will reject it. One key, one account — that's the rule.

This means each GitHub account needs its own SSH key pair.

---

## Step 1: Generate Your Keys

You need to create a separate key pair for each GitHub account. The trick is giving each key a distinct filename so they don't overwrite each other.

### macOS & Linux

Open a terminal and run:

```bash
# Key for your personal GitHub account
ssh-keygen -t ed25519 -C "you@personal-email.com" -f ~/.ssh/id_ed25519_personal

# Key for your work GitHub account
ssh-keygen -t ed25519 -C "you@work-email.com" -f ~/.ssh/id_ed25519_work
```

After running both commands, you'll have four files in `~/.ssh/`:

```
id_ed25519_personal
id_ed25519_personal.pub
id_ed25519_work
id_ed25519_work.pub
```

### Windows

You have two good options: **Git Bash** (installed with Git for Windows) or **PowerShell** (Windows 10/11 ships with OpenSSH built in).

**Using Git Bash:**

The commands are identical to macOS and Linux:

```bash
ssh-keygen -t ed25519 -C "you@personal-email.com" -f ~/.ssh/id_ed25519_personal
ssh-keygen -t ed25519 -C "you@work-email.com" -f ~/.ssh/id_ed25519_work
```

Git Bash translates `~` to your Windows home directory (typically `C:\Users\YourName`).

**Using PowerShell:**

```powershell
ssh-keygen -t ed25519 -C "you@personal-email.com" -f "$env:USERPROFILE\.ssh\id_ed25519_personal"
ssh-keygen -t ed25519 -C "you@work-email.com" -f "$env:USERPROFILE\.ssh\id_ed25519_work"
```

Your keys will be stored in `C:\Users\YourName\.ssh\`.

> **Note:** Use `ed25519` — it's the modern default, faster and more secure than RSA. The `-f` flag is critical; it lets you name each key file explicitly instead of overwriting the default `id_ed25519`.

---

## Step 2: Add the Public Keys to GitHub

For each account, copy the public key and add it to the corresponding GitHub account under **Settings → SSH and GPG keys → New SSH key**.

### macOS

```bash
pbcopy < ~/.ssh/id_ed25519_personal.pub
```

This copies the key directly to your clipboard. Paste it into GitHub. Repeat for the work key on the work account.

### Linux

```bash
# Using xclip
xclip -selection clipboard < ~/.ssh/id_ed25519_personal.pub

# Using xsel
xsel --clipboard < ~/.ssh/id_ed25519_personal.pub

# Or just print and manually copy
cat ~/.ssh/id_ed25519_personal.pub
```

### Windows

**Git Bash:**

```bash
clip < ~/.ssh/id_ed25519_personal.pub
```

**PowerShell:**

```powershell
Get-Content "$env:USERPROFILE\.ssh\id_ed25519_personal.pub" | Set-Clipboard
```

**Or use:**

```powershell
type C:\Users\YourName\.ssh\id_ed25519_personal.pub | clip
```

---

## Step 3: Configure the SSH Config File

This is where the magic happens. You'll create host aliases that tell SSH which key to use for each account.

### macOS & Linux

Open (or create) `~/.ssh/config` in your editor of choice:

```bash
nano ~/.ssh/config
```

Add the following:

```
# Personal GitHub account
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes

# Work GitHub account
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes
```

Save and set the correct permissions:

```bash
chmod 600 ~/.ssh/config
```

### Windows

The config file lives at `C:\Users\YourName\.ssh\config` (no file extension).

**Using Git Bash:**

```bash
nano ~/.ssh/config
```

Add the same content as above — Git Bash uses the same path format:

```
# Personal GitHub account
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes

# Work GitHub account
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes
```

**Using PowerShell or Notepad:**

```powershell
notepad "$env:USERPROFILE\.ssh\config"
```

If the file doesn't exist yet, Notepad will offer to create it. Use Windows-style paths in the config:

```
# Personal GitHub account
Host github-personal
    HostName github.com
    User git
    IdentityFile C:\Users\YourName\.ssh\id_ed25519_personal
    IdentitiesOnly yes

# Work GitHub account
Host github-work
    HostName github.com
    User git
    IdentityFile C:\Users\YourName\.ssh\id_ed25519_work
    IdentitiesOnly yes
```

> **Important:** The `Host` value is an alias you choose — it can be anything. `IdentitiesOnly yes` tells SSH to *only* use the specified key for that host, preventing the agent from trying every loaded key and potentially sending the wrong one.

> **Windows tip:** If you're using both Git Bash and native Windows OpenSSH, be aware they may read different config files. Git Bash uses its own SSH, while PowerShell and VS Code typically use Windows OpenSSH. For consistency, you can configure Git to use Windows OpenSSH:
> ```powershell
> git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
> ```

---

## Step 4: Register Keys with the SSH Agent

The SSH agent caches your keys in memory so you aren't prompted for your passphrase on every Git operation.

### macOS

macOS has built-in Keychain integration. Add to your `~/.ssh/config`:

```
Host *
    AddKeysToAgent yes
    UseKeychain yes
```

Then load the keys:

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_personal
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_work
```

The Keychain will remember them across reboots.

### Linux

Start the agent and add your keys:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_personal
ssh-add ~/.ssh/id_ed25519_work
```

To persist across sessions, add the `eval` line to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.). Some desktop environments (GNOME, KDE) start an agent automatically — check with `ssh-add -l` first.

For automatic key loading on login, you can add to `~/.ssh/config`:

```
Host *
    AddKeysToAgent yes
```

### Windows

**Using Git Bash:**

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_personal
ssh-add ~/.ssh/id_ed25519_work
```

To have the agent start automatically, add those lines to your `~/.bashrc` file in your Git Bash home directory.

**Using Windows OpenSSH (PowerShell):**

First, ensure the SSH Agent service is running:

```powershell
# Check the service status
Get-Service ssh-agent

# If it's not running, enable and start it (run as Administrator)
Set-Service -Name ssh-agent -StartupType Automatic
Start-Service ssh-agent
```

Then add your keys:

```powershell
ssh-add "$env:USERPROFILE\.ssh\id_ed25519_personal"
ssh-add "$env:USERPROFILE\.ssh\id_ed25519_work"
```

The Windows SSH Agent service persists across reboots when set to Automatic, so you only need to add the keys once.

---

## Step 5: Test Your Setup

Verify that each alias connects to the correct account.

### All Platforms

```bash
ssh -T github-personal
ssh -T github-work
```

For each, you should see:

```
Hi your-username! You've successfully authenticated, but GitHub does not provide shell access.
```

If both aliases greet the correct username, you're set. If not, use verbose mode to debug:

```bash
ssh -vT github-personal
```

This shows exactly which key is being offered and whether the connection succeeds.

---

## Step 6: Clone Repos Using the Right Host Alias

Instead of the standard clone URL, replace `github.com` with your alias.

### All Platforms

```bash
# Personal repo
git clone git@github-personal:your-personal-username/repo.git

# Work repo
git clone git@github-work:your-work-org/repo.git
```

For existing repos, update the remote URL:

```bash
cd ~/projects/my-personal-project
git remote set-url origin git@github-personal:your-personal-username/repo.git
```

On Windows with PowerShell, substitute `~` with your actual path if needed:

```powershell
cd C:\Users\YourName\projects\my-work-project
git remote set-url origin git@github-work:your-work-org/repo.git
```

---

## Step 7: Set Per-Repo Git Identity

SSH keys handle authentication, but Git also stamps your name and email on every commit. If you don't configure this, your work commits might show your personal email.

### Option A: Set Identity Per Repo (All Platforms)

```bash
cd ~/projects/my-work-project
git config user.name "Your Work Name"
git config user.email "you@work-email.com"
```

### Option B: Directory-Based Conditional Includes

If you organize repos into directories by account, you can automate identity switching.

**macOS & Linux (`~/.gitconfig`):**

```ini
[user]
    name = Your Personal Name
    email = you@personal-email.com

[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
```

Then create `~/.gitconfig-work`:

```ini
[user]
    name = Your Work Name
    email = you@work-email.com
```

Now any repo under `~/work/` automatically uses the work identity.

**Windows (`C:\Users\YourName\.gitconfig`):**

```ini
[user]
    name = Your Personal Name
    email = you@personal-email.com

[includeIf "gitdir:C:/Users/YourName/work/"]
    path = C:/Users/YourName/.gitconfig-work
```

> **Windows gotcha:** Use forward slashes in the `gitdir` path, and include a trailing slash. Git on Windows handles forward slashes correctly in config files.

Then create `C:\Users\YourName\.gitconfig-work`:

```ini
[user]
    name = Your Work Name
    email = you@work-email.com
```

---

## Troubleshooting

### Wrong account is being used

Run `ssh -vT github-personal` to see verbose output. Check which key is being offered. Make sure `IdentitiesOnly yes` is in your config for each host.

### Permission denied (publickey)

Confirm the public key is added to the correct GitHub account. Double-check the `IdentityFile` path in your SSH config — typos are silent failures. On Windows, confirm you're using the right SSH client (Git Bash vs. Windows OpenSSH).

### Windows: Git uses the wrong SSH client

If Git Bash works but VS Code or PowerShell doesn't (or vice versa), they may be using different SSH implementations. Force Git to use a specific SSH:

```powershell
# Use Windows OpenSSH
git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"

# Or use Git's bundled SSH
git config --global core.sshCommand "C:/Program Files/Git/usr/bin/ssh.exe"
```

### Existing repos still use the old remote

Update them manually with `git remote set-url`. Audit all your repos at once:

**macOS & Linux:**

```bash
find ~/projects -name ".git" -type d -exec sh -c \
  'echo "=== $(dirname {}) ===" && git -C $(dirname {}) remote -v' \;
```

**Windows (PowerShell):**

```powershell
Get-ChildItem -Path C:\Users\YourName\projects -Recurse -Directory -Filter ".git" |
  ForEach-Object {
    $repo = $_.Parent.FullName
    Write-Host "=== $repo ==="
    git -C $repo remote -v
  }
```

### Agent forwarding conflicts

If you SSH into remote servers and forward your agent, all loaded keys travel with you. This is usually fine, but be aware of it in security-sensitive environments.

---

## Quick Reference Cheat Sheet

| Step | macOS | Linux | Windows (Git Bash) | Windows (PowerShell) |
|------|-------|-------|--------------------|----------------------|
| Generate key | `ssh-keygen -f ~/.ssh/id_ed25519_personal` | Same | Same | `ssh-keygen -f "$env:USERPROFILE\.ssh\id_ed25519_personal"` |
| Copy pub key | `pbcopy < ~/.ssh/key.pub` | `xclip -sel clip < ~/.ssh/key.pub` | `clip < ~/.ssh/key.pub` | `Get-Content key.pub \| Set-Clipboard` |
| SSH config location | `~/.ssh/config` | `~/.ssh/config` | `~/.ssh/config` | `C:\Users\You\.ssh\config` |
| Start agent | Built-in (Keychain) | `eval "$(ssh-agent -s)"` | `eval "$(ssh-agent -s)"` | `Start-Service ssh-agent` |
| Add key | `ssh-add --apple-use-keychain` | `ssh-add ~/.ssh/key` | `ssh-add ~/.ssh/key` | `ssh-add path\to\key` |
| Git config | `~/.gitconfig` | `~/.gitconfig` | `~/.gitconfig` | `C:\Users\You\.gitconfig` |

---

## Wrapping Up

The setup takes about ten minutes on any platform and saves you from a recurring headache. The core idea is the same everywhere: give each account its own key, map each key to a host alias in your SSH config, and use those aliases in your remote URLs. Layer on conditional Git configs for commit identity, and you've got a clean workflow that keeps your accounts neatly separated.

The platform-specific differences are minor — mostly around file paths, clipboard commands, and SSH agent management. Once it's configured, you'll forget it's even there. And that's exactly how good tooling should work.