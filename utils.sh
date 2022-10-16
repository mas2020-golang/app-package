# -- COLORS
export STOP_COLOR="\e[0m"
# color for a main activity
export ACTIVITY="\e[1;33m"
# color for a sub activity
export SUB_ACT="\e[1;34m>\e[0m"
export DONE="\e[1;32m│ Done\e[0m"
export OK="\e[1;32mOK\e[0m"
export ERROR="\e[1;31m│ Error:\e[0m"
export WARNING="\e[0;33m│ Warning:\e[0m"
export GREEN="\e[1;32m"
export RED="\e[1;31m"
export YELLOW="\e[1;33m"
export RESET="\e[0m"

function checkError() {
    if [[ $? != 0 ]]; then
        printf "$ERROR exit from the application due as an error\n"
        exit 1
    fi
}

# Test func to test the colors
function testColors() {
    printf "$ACTIVITY%s\n" "Activity starting..."
    printf "$SUB_ACT Sub activity starting...\n"
    printf "$ERROR exit from the application due as an error\n"
    printf "$WARNING warning message\n"
    printf "$DONE: activity done\n"
    printf "$OK\n"
    rm treter
    checkError
}

# uncomment for testing
#testColors