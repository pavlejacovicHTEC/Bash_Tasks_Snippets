# Explanation

Variables can be passed on input based on their position, but in this case the flags were used

The easiest way to order logs that are in example_input_files:
1. Remove all double qutes >>> echo $line | tr -d '"'
2. Divide everything by whitespace ' ' delimiter and take variables based on position >>> cut -d " " -f{number}

The task was done on different ways for practice purposes and each section is commented out
