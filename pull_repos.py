#!/usr/bin/env python

# name    :	pull_repos.py
# version :	0.0.1
# date    :	20230401
# author  :	Leam Hall
# desc    : Pull basic Git repo information


import os

base_dir    = '/usr/local/src/'
repos       = {'/': {}}


def get_url(file):
    with open(file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('url'):
                line_list = line.split()
                return line_list[-1]

def name_stanza(name):
    result =  "- name: {}\n".format(name)
    result += "  ansible.builtin.git:\n"
    result += "    repo: \"{{ item }}\"\n"
    result += "    dest: \"{{ repodir }}/name"
    if name == 'base':
        result += "\"\n"
    else:
        result += "/{}\"\n".format(name)
    result += "  with_items: \"{{ "
    result += "{}".format(name)
    result += " }}\"\n"
    result += "\n\n"
    return result

def get_repo_dir(url):
    """
    Takes a standard git URL and returns the last section as the directory
    """
    url_parts = url[1].split('/')
    base_dir    = url_parts[-1].replace('.git', '')
    return base_dir

for root, dirs, files in os.walk(base_dir):
    for d in dirs:
        if d == '.git':
            config_file = os.path.join(root, d, 'config')
            url         = get_url(config_file)
            project_dir = root.replace('/usr/local/src/', '')
            proj_list   = os.path.split(project_dir)
            proj_dir    = proj_list[0]
            proj_repo   = proj_list[1]
            if len(proj_dir) and proj_dir not in repos.keys():
                repos[proj_dir] = {}
            if len(proj_dir) == 0:
                repos['/'][proj_repo] = url
            else:
                repos[proj_dir][proj_repo] = url

with open('tmp/workstations.yml', 'w') as ws:
    ws.write("---\n\n")
    ws.write("repos:\n") 
    for k in repos.keys():
        for item in repos[k].items():
            repo_dir = get_repo_dir(item)
            if not k.startswith('/'):
                k = "/{}".format(k)
            ws.write("  - '{} {} {}' \n".format(k, item[1], repo_dir))

"""
with open('tmp/clone_repos.yml', 'w') as clone:
    clone.write("---\n")
    clone.write("- hosts:           workstations\n")
    clone.write("  become:          false\n")
    clone.write("  gather_facts:    false\n")
    clone.write("\n\n")
    clone.write("  tasks:\n")
    clone.write("    - name: make_directories\n")
    clone.write("      ansible.builtin.file:\n")

   
    for k in repos.keys():
         
    clone.write("        repo:  ")

"""
    
