
project('lai_tools', 'c')

lai = subproject('lai')

laiexec = executable('laiexec',
        'laiexec/main.c',
        'common/laihost.c',
    dependencies: lai.get_variable('dependency'))

aml_test_cases = [
    'arithmetic',
    'event',
    'hello',
    'mutex',
    'power_res'
]

run_py = find_program('aml_tests/run.py')

foreach f : aml_test_cases
    test('aml-aml_tests/' + f + '.asl', run_py,
        args: [laiexec, files('aml_tests/' + f + '.asl')])
endforeach

