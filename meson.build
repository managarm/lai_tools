
project('lai_tools', 'c')

lai = subproject('lai')

laiexec = executable('laiexec',
        'laiexec/main.c',
        'common/laihost.c',
    dependencies: lai.get_variable('dependency'))

foreach f : ['hello', 'arithmetic']
	test('aml-aml_tests/' + f + '.asl', files('aml_tests/run.py'),
		args: [laiexec, files('aml_tests/' + f + '.asl')])
endforeach

