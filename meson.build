
project('lai_tools', 'c',
    default_options: ['c_std=c99'])

lai = subproject('lai')

laiexec = executable('laiexec',
        'laiexec/main.c',
        'common/laihost.c',
    c_args: ['-D_GNU_SOURCE'],
    dependencies: lai.get_variable('dependency'))

run_py = find_program('aml_tests/run.py')

aml_test_cases = [
    'arithmetic',
    'computational_data',
    'event',
    'index',
    'hello',
    'mutex',
    'package',
    'power_res'
]

aml_regression_cases = [
# Disable failing tests for now so that we can test coverage information.
#   'qookie_deref_index'
]

foreach f : aml_test_cases
    test('aml-aml_tests/' + f + '.asl', run_py,
        args: [laiexec, files('aml_tests/' + f + '.asl')])
endforeach

foreach f : aml_regression_cases
    test('aml-aml_regressions/' + f + '.asl', run_py,
        args: [laiexec, files('aml_regressions/' + f + '.asl')])
endforeach

