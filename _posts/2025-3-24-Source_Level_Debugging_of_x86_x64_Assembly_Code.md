---
title: Source Level Debugging Using gdb and Visual Studio Code
categories:
  - Blog
tags:
  - Computer Engineering
  - Assembly Language
  - x86_x64 Microprocessor
---

## Overview

Source-level debugging is a superpower, especially when you're working in assembly.
When you integrate GDB with Visual Studio Code, it becomes a visual experience where:

- You're no longer guessing addresses or scrolling disassembly.

- You can read and debug your own source files, not just opcodes.

- You get a register view, memory view, and call stack in real-time

This post describes the steps to get up and running with gdb and Visual Studio Code.

## Setup

### Step 1: Install Windows Terminal

1. Open Microsoft Store (Start Menu → type “Microsoft Store”).

2. Search for Windows Terminal.

3. Click Install.

### Step 2: Enable WSL2

#### Open PowerShell as Administrator and run

  {% highlight powershell %} wsl --install {% endhighlight %}

  This installs:

- Windows Subsystem for Linux
- WSL2 as the default
- Ubuntu as the default distro

⚠️ If you’ve used WSL before, you might need to update it:

  {% highlight powershell %} wsl --update {% endhighlight %}

#### Reboot your computer when prompted

### Step 3: Install Ubuntu

If Ubuntu wasn’t auto-installed:

1. Open Microsoft Store

2. Search for Ubuntu

3. Choose a version (e.g., Ubuntu 22.04 LTS) and click Install.

### Step 4: Open Ubuntu in Windows Terminal

1. Open Windows Terminal

2. If Ubuntu is installed, it should already appear as a tab option or in the dropdown menu.

3. If not:

- Click the dropdown arrow (next to the tab bar)

- Select Settings

- Under Profiles → Add a new profile → WSL, select Ubuntu

Now, from the dropdown, click Ubuntu to open it.

### Step 5: Install the Full Build Essentials in Ubuntu

{% highlight bash %}
sudo app update
sudo apt install build-essential gdb -y
{% endhighlight %}

### Step 6: Verify Installation

{% highlight bash %}
gcc --version
g++ --version
make --version
as --version
ld --version
gdb --version
{% endhighlight %}
