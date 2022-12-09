## Task

Task is two create a script that:
1. Can work with any location/directory that is passed as input
2. Goes through everything in that directory and checks if the directories inside are git type
3. If the directories are git type, do some git operation
4. Skip optional directories that are provided inside the file whose location should be passed to a script

Additional:
1. Do the task on a depth level larger than 1
2. Take into account special characters in folder names and special namefolders (DONE/PARTIALLY)
3. Create option for different commands (DONE)

## Solution

### task2_way1.sh

1. Reads excluded folders from ignore file
2. Loads them into array
3. Iterates through wanted location and skips all elements of that array
4. Runs git pull

### task2_way2.sh

1. Iterates through folders on wanted location
2. Checks with grep if they are excluded
3. Runs wanted git command (pull/branch) based on passed argument
4. Checks if folder has whitespaces and escape them so it can iterate through

### task2_way3.sh

## TO DO
1. Add depth level as argument