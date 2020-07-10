# -*- coding: utf-8 -*-
# vim: ft=sls

{%- if grains.os_family == 'MacOS' %}
    {%- set tplroot = tpldir.split('/')[0] %}
    {%- from tplroot ~ "/map.jinja" import data as d with context %}
    {%- set formula = d.formula %}

{{ formula }}-skaffold-package-install-brew:
  cmd.run:
    - names:
      - /usr/local/bin/brew install skaffold

{%- endif %}

