#!/usr/bin/env python

# name    :	pull_repos.py
# version :	0.0.1
# date    :	20230401
# author  :	Leam Hall
# desc    : Pull basic Git repo information


import os

base_dir    = '/usr/local/src'
repos       = {'base': {}}


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
                repos['base'][proj_repo] = url
            else:
                repos[proj_dir][proj_repo] = url

with open('git_repos.yml', 'w') as clone:
    clone.write("---\n\n")
    with open('clone_repos.yml', 'w') as names: 
        names.write("---\n\n")
        for k in repos.keys():
            names.write(name_stanza(k))
            clone.write("{}:\n".format(k))
            for item in repos[k].items():
                clone.write("  - '{}'\n".format(item[1]))



        
