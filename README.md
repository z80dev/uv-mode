# UV Mode for Emacs

[![MELPA](https://melpa.org/packages/uv-mode-badge.svg)](https://melpa.org/#/uv-mode)

UV Mode provides seamless integration between [uv](https://github.com/astral-sh/uv) (the Python package installer) and Emacs python-mode. Unlike pyenv-mode which manages multiple Python versions, UV Mode focuses on managing project-specific virtual environments created by uv.

## Features

UV Mode automatically detects and activates virtual environments created by uv in your Python projects. When you open a Python file, UV Mode checks for a `.venv` directory in the project root and activates it if found. This enables seamless switching between different Python projects, each with its own isolated environment.

Key features include:
- Automatic virtual environment detection and activation
- Mode line indicator showing the current project/environment
- Integration with pythonic.el for enhanced Python development
- Simple keybindings for manual control when needed

## Installation

### Prerequisites

- Emacs 25.1 or later
- [uv](https://github.com/astral-sh/uv) installed and available in your PATH
- pythonic.el package

### Via MELPA

```elisp
(use-package uv-mode
  :hook (python-mode . uv-mode-auto-activate-hook))
```

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/z80dev/uv-mode.git
   ```

2. Add the following to your Emacs configuration:
   ```elisp
   (add-to-list 'load-path "/path/to/uv-mode")
   (require 'uv-mode)
   (add-hook 'python-mode-hook #'uv-mode-auto-activate-hook)
   ```

## Usage

UV Mode works automatically once installed. Simply open a Python file in a project that has a `.venv` directory, and UV Mode will activate the appropriate virtual environment.

### Manual Controls

While automatic activation is the primary way to use UV Mode, you can also control it manually:

- `C-c C-s`: Manually activate the virtual environment for the current project
- `C-c C-u`: Deactivate the current virtual environment

### Mode Line Indicator

When active, UV Mode displays the current project name in the mode line with the prefix "UV:". This helps you quickly identify which virtual environment is active.

## Project Structure

UV Mode expects your Python projects to follow this structure:
```
project-root/
├── .venv/           # UV-created virtual environment
├── src/
│   └── your_code.py
└── other_files
```

The `.venv` directory should be created using uv. UV Mode will automatically detect this directory and use it as the project's virtual environment.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details.

## Credits

UV Mode was inspired by [pyenv-mode](https://github.com/proofit404/pyenv-mode) and adapted to work with uv's project-local virtual environments approach.
