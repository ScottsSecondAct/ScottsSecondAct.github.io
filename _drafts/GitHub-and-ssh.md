---
title: GitHub and SSH
categories:
  - Notes
tags:
  - Computer Science
  - Source Code Control
  - Security
---
## GitHub and SSH

### Creating a named key

```bash
ssh-keygen -t ed25519 -C "scott@ScottsSecondAct" -f ~/.ssh/ScottsSecondAct
```

### Starting the SSH Agent

```bash
eval "$(ssh-agent -s)"
```

### Adding the Key to the Agent

```bash
ssh-add ~/.ssh/ScottsSecondAct
```

### Testing the Key
