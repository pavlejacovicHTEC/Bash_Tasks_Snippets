
## Task

*Task was to use different techniques in order to manipulate text in txt file that is not very
easy to look at. The example was done on random log file. The goal was to present data in an
organized way through a markdown format* 

## Solution

Variables can be passed on input based on their position, but in this case the flags were used

The easiest way to order logs that are in example_input_file.txt:
1. Remove all double qutes >>> echo $line | tr -d '"'
2. Divide everything by whitespace ' ' delimiter and take variables based on position >>> cut -d " " -f{number}
   2. **NOTE: Some strings have to be concatenated**



The task was done on different ways for practice purposes and each section is commented out
