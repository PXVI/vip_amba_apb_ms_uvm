# *******************************************************
# Date Created   : 16 November, 2019
# Author         : :P
# *******************************************************

# Regression Test Running Script
# ------------------------------
# 0
runTests(){

    if [ $# -eq 5 ]
    then
        if [ -f $1 ]
        then
            i=1;
            pass_num=0;
            fail_num=0;
            reg_list_num=`grep -i ".*_test" $1 | wc -l`;
            mc_count=$5;
            regress_start_time=`date "+%s"`;
            echo "=====================================================";
            echo -n " TOTAL NUMBER OF TESTS IN REGRESSION LIST: ";
            echo "$reg_list_num";
            echo "=====================================================";
            echo -n " RANDOMIZATION MODE : ";
            if [ $3 -eq "0" ]
            then
                echo "Common Seed"
            else
                echo "Random Seed"
            fi
            echo "=====================================================";

            # Getting the Process ID
            echo " Process ID: $$";

            if [ $reg_list_num -ne 0 ]
            then
                echo "-----------------------------------------------------";
                if [ $mc_count -le 1 ]
                then
                    echo " CORES : DEFAULT ( 1 )                           ";
                else
                    echo " CORES : $mc_count                               ";
                fi
                echo "-----------------------------------------------------";
                echo " REGRESSION STATUS :-                                ";
                echo "-----------------------------------------------------";

                if [ $mc_count -le 1 ]
                then
                    while [ $i -le $reg_list_num ]
                    do
                        testName=`head -$i $1 | tail -1`;
                        echo -n "$testName running..."
                        sleep 1;

                        if [ $3 -ne "0" ]
                        then
                            rand_seed=`date "+%N"`;
                            make sim TESTNAME=$testName REGRESS_DUMP_DEBUG=0 SEED=$rand_seed F_COVER=$4 >> regression.log;
                        else
                            make sim TESTNAME=$testName REGRESS_DUMP_DEBUG=0 SEED=$2 F_COVER=$4 >> regression.log;
                        fi

                        testRes=`grep "TEST RESULT : " $testName.log | grep "PASSED\|FAILED"`;

                        echo " $testRes";

                        temp_res=`grep "TEST RESULT : PASSED" $testName.log`;
                        if [ "$temp_res" != "" ]
                        then
                            pass_num=`expr $pass_num + 1`;
                        fi
                        
                        temp_res=`grep "TEST RESULT : FAILED" $testName.log`;
                        if [ "$temp_res" != "" ]
                        then
                            fail_num=`expr $fail_num + 1`;
                        fi

                        i=`expr $i + 1`;
                    done
                    total_pass_fail_sum=`expr $pass_num + $fail_num`;

                    echo ""
                    echo "-----------------------------------------------------";
                    echo -n " TOTAL   TESTS : ";
                    echo "$total_pass_fail_sum";
                    echo -n " PASSING TESTS : ";
                    echo "$pass_num";
                    echo -n " FAILING TESTS : ";
                    echo "$fail_num";
                    echo "-----------------------------------------------------";

                    regress_end_time=`date "+%s"`;
                    time_eval_sec=`expr $regress_end_time - $regress_start_time`;
                    if [ $time_eval_sec -ge 60 ]
                    then
                        time_eval_min=`expr $time_eval_sec / 60`;
                        if [ $time_eval_min -ge 60 ]
                        then
                            time_eval_hr=`expr $time_eval_min / 60`;
                            temp_val=`expr $time_eval_hr "*" 60`;
                            time_eval_min=`expr $time_eval_min - $temp_val_1`;
                            temp_val_2=`expr $time_eval_min "*" 60`;
                            time_eval_sec=`expr $time_eval_sec - $temp_val_2`;
                            echo " Run Time : ${time_eval_hr}h ${time_eval_min}m ${time_eval_sec}s"
                        else
                            temp_val=`expr $time_eval_min "*" 60`;
                            time_eval_sec=`expr $time_eval_sec - $temp_val`;
                            echo " Run Time : ${time_eval_min}m ${time_eval_sec}s"
                        fi
                    else
                        echo " Run Time : ${time_eval_sec}s"
                    fi

                    echo "-----------------------------------------------------";
                    echo "REGRESSION Complete! [S]"
                else
                    
                    # This will keep track of the number of test cases that are running in parallel
                    running_test_count=0;

                    while [ $i -le $reg_list_num ]
                    do
                        testName=`head -$i $1 | tail -1`;

                        # Firing the Simulations on Different Cores
                        if [ $3 -ne "0" ]
                        then
                            rand_seed=`date "+%N"`;
                            make sim TESTNAME=$testName REGRESS_DUMP_DEBUG=0 SEED=$rand_seed F_COVER=$4 > /dev/null &
                            echo " $testName fired..."
                        else
                            make sim TESTNAME=$testName REGRESS_DUMP_DEBUG=0 SEED=$2 F_COVER=$4 > /dev/null &
                            echo " $testName fired..."
                        fi

                        sleep 0.5;
                        running_test_count=`ps --ppid $$ | grep -c 'make'`;
                        running_test_count=`expr $running_test_count`;

                        while [ $running_test_count -ge $mc_count ]
                        do
                            sleep 0.5;
                            running_test_count=`ps --ppid $$ | grep -c 'make'`;
                            running_test_count=`expr $running_test_count`;
                        done
                        
                        i=`expr $i + 1`;
                    done

                    sleep 0.5;
                    running_test_count=`ps --ppid $$ | grep -c 'make'`;
                    running_test_count=`expr $running_test_count`;

                    while [ $running_test_count -ne 0 ]
                    do
                        sleep 0.5;
                        running_test_count=`ps --ppid $$ | grep -c 'make'`;
                        running_test_count=`expr $running_test_count`;
                    done

                    pass_num=`grep 'TEST RESULT : PASSED' ./*_test.log | grep -c 'PASSED'`;
                    fail_num=`grep 'TEST RESULT : FAILED' ./*_test.log | grep -c 'FAILED'`;

                    total_pass_fail_sum=`expr $pass_num + $fail_num`;

                    echo ""
                    echo "-----------------------------------------------------";
                    echo -n " TOTAL   TESTS : ";
                    echo "$total_pass_fail_sum";
                    echo -n " PASSING TESTS : ";
                    echo "$pass_num";
                    echo -n " FAILING TESTS : ";
                    echo "$fail_num";
                    echo "-----------------------------------------------------";

                    regress_end_time=`date "+%s"`;
                    time_eval_sec=`expr $regress_end_time - $regress_start_time`;
                    if [ $time_eval_sec -ge 60 ]
                    then
                        time_eval_min=`expr $time_eval_sec / 60`;
                        if [ $time_eval_min -ge 60 ]
                        then
                            time_eval_hr=`expr $time_eval_min / 60`;
                            temp_val=`expr $time_eval_hr "*" 60`;
                            time_eval_min=`expr $time_eval_min - $temp_val_1`;
                            temp_val_2=`expr $time_eval_min "*" 60`;
                            time_eval_sec=`expr $time_eval_sec - $temp_val_2`;
                            echo " Run Time : ${time_eval_hr}h ${time_eval_min}m ${time_eval_sec}s"
                        else
                            temp_val=`expr $time_eval_min "*" 60`;
                            time_eval_sec=`expr $time_eval_sec - $temp_val`;
                            echo " Run Time : ${time_eval_min}m ${time_eval_sec}s"
                        fi
                    else
                        echo " Run Time : ${time_eval_sec}s"
                    fi

                    echo "-----------------------------------------------------";
                    echo "REGRESSION Complete! [S]"
                fi
            else
                echo "No Tests Provided in the Regression List! [S] Regression Script Completed!"
            fi

        else
            echo "Not a valid file! [F] Regress Script Failed!"
        fi
    else
        echo "Please pass only one file as an argument! [F] Regress Script Failed!"
    fi

}

if [ $# -eq 5 -a -f $1 ]
then
    runTests $@;   
else
  echo "Invalid Regression Command Execution! [F] Regress Script Failed!";
fi
