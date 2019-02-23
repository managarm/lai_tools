
project('lai_tools', 'c')

lai = subproject('lai')

executable('laiexec',
        'laiexec/main.c',
        'common/laihost.c',
    dependencies: lai.get_variable('dependency'))

