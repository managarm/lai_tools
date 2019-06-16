
project('lai_tools', 'c')

lai = subproject('lai')

laiexec = executable('laiexec',
        'laiexec/main.c',
        'common/laihost.c',
    dependencies: lai.get_variable('dependency'))

run_py = find_program('aml_tests/run.py')

aml_test_cases = [
    'arithmetic',
    'event',
    'index',
    'hello',
    'mutex',
    'power_res'
]

aml_regression_cases = [
	'qookie_deref_index'
]

foreach f : aml_test_cases
    test('aml-aml_tests/' + f + '.asl', run_py,
        args: [laiexec, files('aml_tests/' + f + '.asl')])
endforeach

foreach f : aml_regression_cases
    test('aml-aml_regressions/' + f + '.asl', run_py,
        args: [laiexec, files('aml_regressions/' + f + '.asl')])
endforeach

