
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
    'bufferfields',
    'break',
    'concatrestemplate',
    'continue',
    'frombcd',
    'tobcd',
    'breakpoint',
    'calls',
    'comparison',
    'computational_data',
    'duplicate_node',
    'event',
    'implicit_semantics',
    'implicit_conversion',
    'index',
    'hello',
    'match',
    'mid',
    'mutex',
    'negatebitwise',
    'package',
    'varpackage',
    'power_res',
    'processor',
    'references',
    'revision',
    'scopes',
    'timer',
    'field',
    'indexfield',
    'bankfield',
    'tobuffer',
    'todecimalstring',
    'tohexstring',
    'tointeger',
    'findsetbit',
    'tostring',
    'undefined_object',
    'uninitialized_local',
    'unresolved_scope_node',
    'objecttype',
    'opregion'
]

aml_regression_cases = [
    'itay_buffer_resolution',
    'qookie_deref_index',
    'qookie_store_index',
    'thomtl_ifblock',
    'thomtl_resolution',
]

foreach f : aml_test_cases
    test('aml-aml_tests/' + f + '.asl', run_py,
        args: [laiexec, files('aml_tests/' + f + '.asl')])
endforeach

test('aml-aml_tests/' + 'fatal.asl', run_py,
        args: [laiexec, files('aml_tests/' + 'fatal.asl')], should_fail: true)

test('aml-aml_tests/' + 'external.asl', laiexec,
        args: [files('aml_tests/' + 'external.aml')])

foreach f : aml_regression_cases
    test('aml-aml_regressions/' + f + '.asl', run_py,
        args: [laiexec, files('aml_regressions/' + f + '.asl')])
endforeach

