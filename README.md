This is a sample ruby program that simulates a quiz and takes input from
the command line. This program was developed on a Mac OSX with the ruby
version reported as 
    * RUBY VERSION 
        - 'ruby 2.0.0p645 (2015-04-13 revision 50299) [universal.x86_64-darwin15]'

To answer the questions:
    The quiz will keep asking until you have entered the
    correct amount of responses. 
        * For each question enter the label (a, b, c , d ...) next to the question
          as your answer.
          
        * You can separate multiple answers by entering
          the values as a comma separated list e.g. a, b, c, d 
          
        * Alternatively you can also enter a space separated list e.g. a b c d.
        
A sample YAML file is provided in the data/sample.yaml location. You can execute
the program by changing directory to the main 'quiz' folder and executing the 
command : 
    * ruby lib/main.rb
        - This will execute the default configured quiz which is data/sample.yaml
        
If you wish to provide your own quiz, you can add it to the data folder and execute
the quiz with the command : 
    * ruby lib/main.rb 'myquiz'
        - This will execute the quize at data/myquiz.yaml
        
The test for the program are available in 'tests/test_quiz.rb', you can execute the 
tests by executing
    * rake test
        - This is assuming that you have rake installed and configured on your system