#!/bin/bash

## this will retrieve all of the .go files that have been 
## changed since the last commit
STAGED_GO_FILES=$(git diff --cached --name-only -- '*.go')

if [ ! -z "$STAGED_GO_FILES" ]
then

  # Get the go module name
  GO_MOD_HEADER=$(head -n 2 go.mod)
  GO_MODULE_TOKENS=($GO_MOD_HEADER)
  GO_MODULE_NAME=${GO_MODULE_TOKENS[1]}

  # Start analysis
  PASS=true
  for FILE in $STAGED_GO_FILES
  do
    if [ ! -f $FILE ]
    then
      continue
    fi
    # Run golint on the staged file and check the exit status
    golint "-set_exit_status" $FILE
    if [ $? == 1 ]
    then
      PASS=false
    fi
  done
  PACKAGES=()
  for FILE in $STAGED_GO_FILES
  do
    if [ -f $FILE ]
    then
      PACKAGES+=("${GO_MODULE_NAME}/$(dirname $FILE)")
    fi
  done
  UNIQUE_PACKAGES=$(printf "%s\n" "${PACKAGES[@]}" | sort -u)

  for PACKAGE in ${UNIQUE_PACKAGES[@]}
  do
    go vet $PACKAGE
    if [ $? != 0 ]
    then
      PASS=false
    fi
  done

  if ! $PASS; then
    # Format all files if the commit has passed
    for FILE in $STAGED_GO_FILES
    do
      gofmt $FILE
      git add $FILE
    done

    printf "\033[0;30m\033[41mCOMMIT FAILED\033[0m\n"
    exit 1
  fi
fi
