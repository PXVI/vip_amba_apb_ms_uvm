# *******************************************************
# Date Created   : 16 November, 2019
# Author         : :P
# *******************************************************

# Regression Test Running Script
# ------------------------------
# 0
testSummary(){

    if [ $# -eq 2 ]
    then
        if [ -f $1 ]
        then
            fail_res=`grep "UVM_ERROR :\s*[1-9]\+\|UVM_FATAL :\s*[1-9]\+" $1`;
            warn_res=`grep "UVM_WARNING :\s*[1-9]\+" $1`;

            if [ "$fail_res" = "" -a "$warn_res" = "" ]
            then
                echo "# " >> $1;
                echo "# +TestCase -> $2" >> $1;
                echo "# " >> $1;
                echo "# =====================================================" >> $1;
                echo "#  TEST RESULT : PASSED                                " >> $1;
                echo "# =====================================================" >> $1;

                echo "# ";
                echo "# +TestCase -> $2";
                echo "# ";
                echo "# =====================================================";
                echo "#  TEST RESULT : PASSED                                ";
                echo "# =====================================================";
            else
                if [ "$fail_res" != "" ]
                then
                    echo "# " >> $1;
                    echo "# +TestCase -> $2" >> $1;
                    echo "# " >> $1;
                    echo "# =====================================================" >> $1;
                    echo "#  TEST RESULT : FAILED                                " >> $1;
                    echo "# =====================================================" >> $1;
                    
                    echo "# ";
                    echo "# +TestCase -> $2";
                    echo "# ";
                    echo "# =====================================================";
                    echo "#  TEST RESULT : FAILED                                ";
                    echo "# =====================================================";
                elif [ "$warn_res" != "" ]
                then
                    echo "# " >> $1;
                    echo "# +TestCase -> $2" >> $1;
                    echo "# " >> $1;
                    echo "# =====================================================" >> $1;
                    echo "#  TEST RESULT : PASSED ( With Warnings! )             " >> $1;
                    echo "# =====================================================" >> $1;

                    echo "# ";
                    echo "# +TestCase -> $2";
                    echo "# ";
                    echo "# =====================================================";
                    echo "#  TEST RESULT : PASSED ( With Warnings! )             ";
                    echo "# =====================================================";
                else
                    echo "Unknown Error Scenario has occured! [F] Summary Script Failed!"
                fi
            fi

        else
            echo "Test Log Does Not Exist! [F] Summary Script Failed!"
        fi
    else
        echo "Please pass only one file as an argument! [F] Summary Script Failed!"
    fi

}

if [ $# -eq 2 -a -f $1 ]
then
    testSummary $@;   
else
  echo "Invalid Summary Script Call! [F] Summary Script Failed!";
fi
