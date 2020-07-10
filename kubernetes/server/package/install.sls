# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set formula = d.formula %}

    {%- if grains.os_family|lower in ('redhat', 'debian') %}
        {%- if d.server.pkg.use_upstream_repo %}
            {%- set sls_repo_install = tplroot ~ '.package.repo.install' %}
include:
  - {{ sls_repo_install }}
        {%- endif %}

{{ formula }}-server-package-install-deps:
  pkg.installed:
    - names: {{ d.pkg.deps|json }}

{{ formula }}-server-package-install-pkgs:
  pkg.installed:
    - names: {{ d.server.pkg.commands|json }}
    - runas: {{ d.identity.rootuser }}
    - reload_modules: true
        {%- if d.server.pkg.use_upstream_repo %}
    - require:
      - pkgrepo: {{ formula }}-package-repo-managed
        {%- endif %}

    {%- else %}

{{ formula }}-server-package-install-other:
  test.show_notification:
    - text: |
        The server package is unavailable for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}