#!/bin/sh

lava_tc()
{
	local id="$1"
	local result="$2"
        local measure="$3"
        local unit="$4"

        if [ -z "$measure" ]; then
                echo "<LAVA_SIGNAL_TESTCASE TEST_CASE_ID=$id RESULT=$result>"
        else
		echo "<LAVA_SIGNAL_TESTCASE TEST_CASE_ID=$id RESULT=$result MEASUREMENT=$3 UNITS=$4>"
        fi
}

lava_tc_pass()
{
	id="$1"
	shift
	lava_tc "$id" "pass" "$@"
}

lava_tc_fail()
{
        id="$1"
        shift
        lava_tc "$id" "fail" "$@"
}

lava_tc_time()
{
	id="$1"
	shift
	/usr/bin/time -f %e -o timings "$@" > /dev/null
	result="$?"
	elapsed="$(tail -1 timings)"
	if [ "$result" -ne 0 ]; then
		lava_tc_fail "$id" "$elapsed" "seconds"
	else
		lava_tc_pass "$id" "$elapsed" "seconds"
	fi
}

lava_tc_time wget-google wget -O - google.com
lava_tc_time wget-rubbish wget -O - asdasd.asd
