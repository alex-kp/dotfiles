
import os
import subprocess

DOTFILES_GIT_DIR = os.getenv('DOTFILES_GIT_DIR')
HOMEDIR = os.path.expanduser("~")
GITCMD = ['/usr/bin/git', f'--git-dir={DOTFILES_GIT_DIR}',
          f'--work-tree={HOMEDIR}']

def remove_vim_submodules():
    if not os.path.isfile('.gitmodules'):
        print('.gitmodules file not found.')
        return

    # Read .gitmodules file
    with open('.gitmodules', 'r', encoding='utf-8') as file:
        lines = file.readlines()

    submodules_to_remove = []
    current_submodule = {}

    for line in lines:
        line = line.strip()

        if line.startswith('[submodule'):
            if current_submodule:
                if current_submodule.get('path', '').startswith('.vim'):
                    submodules_to_remove.append(current_submodule)
                current_submodule = {}

        if '=' in line:
            key, value = line.split('=', 1)
            key = key.strip()
            value = value.strip()
            current_submodule[key] = value

    # Handle the last submodule in the file
    if current_submodule and current_submodule.get('path', '').startswith('.vim'):
        submodules_to_remove.append(current_submodule)

    print(submodules_to_remove)
    subprocess.run([*GITCMD, 'status'], check=True)

    for submodule in submodules_to_remove:
        path = submodule.get('path')
        if path:
            try:
                # Remove the submodule
                subprocess.run([*GITCMD, 'submodule', 'deinit', '-f', path], check=True)
                subprocess.run([*GITCMD, 'rm', '-f', path], check=True)
                subprocess.run(['rm', '-rf', os.path.join('.git', 'modules', path)], check=True)
                print(f'Successfully removed submodule at path: {path}')
            except subprocess.CalledProcessError as e:
                print(f'Error removing submodule at path: {path}, {str(e)}')

    for submodule in submodules_to_remove:
        path = submodule.get('path')
        url = submodule.get('url')
        if path:
            try:
                # Remove the submodule
                subprocess.run([*GITCMD, 'submodule', 'add', url, path], check=True)
                print(f'Successfully added submodule {url} at path: {path}')
            except subprocess.CalledProcessError as e:
                print(f'Error cloning submodule at path: {path}, {str(e)}')


if __name__ == '__main__':
    print(f'{DOTFILES_GIT_DIR=}, {HOMEDIR=}, {GITCMD=}')

    remove_vim_submodules()
