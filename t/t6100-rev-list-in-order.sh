#!/bin/sh

test_description='miscellaneous rev-list tests'

. ./test-lib.sh


test_expect_success 'setup' '
	for x in one two three four
	do
		echo $x >$x &&
		git add $x &&
		git commit -m "add file $x"
	done &&
	for x in four three
	do
		git rm $x
		git commit -m "remove $x"
	done &&
	git rev-list --in-commit-order --objects HEAD >actual.raw &&
	cut -c 1-40 > actual < actual.raw &&

	>expect &&
	git rev-parse HEAD^{commit}       >>expect &&
	git rev-parse HEAD^{tree}         >>expect &&
	git rev-parse HEAD^{tree}:one     >>expect &&
	git rev-parse HEAD^{tree}:two     >>expect &&
	git rev-parse HEAD~1^{commit}     >>expect &&
	git rev-parse HEAD~1^{tree}       >>expect &&
	git rev-parse HEAD~1^{tree}:three >>expect &&
	git rev-parse HEAD~2^{commit}     >>expect &&
	git rev-parse HEAD~2^{tree}       >>expect &&
	git rev-parse HEAD~2^{tree}:four  >>expect &&
	git rev-parse HEAD~3^{commit}     >>expect &&
	# skip HEAD~3^{tree}
	git rev-parse HEAD~4^{commit}     >>expect &&
	# skip HEAD~4^{tree}
	git rev-parse HEAD~5^{commit}     >>expect &&
	git rev-parse HEAD~5^{tree}       >>expect &&

	test_cmp expect actual
'

test_done
