# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.kernel|lower == 'linux' and grains.os_family not in ('Arch',) %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set formula = d.formula %}

        {%- if d.client.pkg.use_upstream_archive and d.linux.altpriority|int > 0 %}

include:
  - {{ sls_archive_clean }}

            {%- for cmd in d.client.pkg.commands %}

{{ formula }}-client-archive-alternatives-remove-{{ cmd }}:
  alternatives.remove:
    - name: link-k8s-client-{{ cmd }}
    - path: {{ d.client.pkg.archive.name }}/{{ cmd }}
    - onlyif: update-alternatives --get-selections |grep ^link-k8s-client-{{ cmd }}
    - require:
      - sls: {{ sls_archive_clean }}

            {%- endfor %}
        {%- endif %}
    {%- endif %}
