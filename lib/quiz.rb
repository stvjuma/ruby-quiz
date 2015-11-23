
=begin
Main entry point into the application. Responsible for serving the questions
and marking them as correct / incorrect. Answers to questions can be provided
as a comma separated delimiter or a space separated list of values. The order
of questions is random and determined on instansiation
=end
class Quiz 
    attr_accessor :name,:summary
    attr_reader :questions
    def initialize(params = {})
        @questions = []
        @name = params.fetch("name", "")
        @summary = params.fetch("summary", "")
        config = params.fetch(:config, nil)
        if config != nil
            @name = config.fetch("name", @name)
            @summary = config.fetch("summary", @summary)
            @questions = []
            config["questions"].shuffle.each_with_index do |question,index|
                q = question.keys[0]
                @questions.push Question.new(index+1, q, question[q].fetch("options", []),
                    question[q].fetch("answers", []))
            end
        end
        
        questions = params.fetch(:questions, nil)
        if questions != nil
            @questions = [];
            questions.shuffle.each_with_index do |question,index|
                question.index = (index + 1)
                @questions.push question
            end
        end
        
    end
        
    
    def render
        puts "\r\n#{@name}\r\n#{@summary}"
        @questions.each do |question|
            puts question.print
            answer = []
            
            # keep asking the user for an answer until we get the correct response
            while answer.length != question.answers.length do 
                answer = []
                response = STDIN.gets.chomp
                # split the response by whitespace and commas,
                # so responses can be a b c d or a,b,c,d
                response.split(/[\s,\,]/).each do |res|
                    # be lenient with user input, strip out unwanted characters
                    res = res.downcase.gsub(/[^a-z]+/, '').to_s.strip
                    if res.length > 0 # ignore any white space
                        if question.is_valid_answer res 
                            answer.push(res)
                        else
                            puts "[ERROR] Invalid response '#{res}'. Available options are ["+question.available_answers.join(', ')+"]"
                        end
                    end
                end
                    
                # check if the user entered the correct number of answers
                if answer.length != question.answers.length 
                    puts "[ERROR] You need to enter "+question.answers.length.to_s+" answer(s)."
                end
            end
            
            question.response = answer
           
            
        end  
        
        percent = (score().to_f/questions.length.to_f)*100.0
        puts "\r\n\r\nYou got #{score} out of #{@questions.length}. Your score is #{percent}%."
    end 
    
    def score
        score = 0
        @questions.each do |question|
            if question.validate_answers(question.response)
                score += 1;
            end 
        end
        
        return score
    end
end

=begin
Responsible for serving the questions and their responding multiple
choice options. The order of the multiple choice option is random
and determined on instansiation. Options for question limited to 
the alphabet (a - z) [26]. Any questions with more than this number 
of options wont be rendered.
=end
class Question
    attr_accessor :answers,:response,:options,:index,:question
    # keep an index to convert integers to letters for multiple choice
    ALPHABET = ("a".."z").to_a
    
    def initialize(index, question, options, answers)
        @index = index
        @question = question
        @answers = answers
        @options = {}
        @response = []
        options.shuffle.each_with_index do |option,index|
            @options[ALPHABET[index]] = option;
        end
        
        @options[ALPHABET[@options.length]] = 'None of the above';
        
        # If no answers provided, the assumption is that none of answers apply, so we default 
        # to 'None of the above'
        if @answers.length == 0
            @answers.push 'None of the above'
        end
        
    end
    
    def is_valid_answer(response)
        return @options.has_key?(response)
    end
    
    def available_answers
        # return sorted keys
        return @options.keys.sort
    end
    
    def validate_answers(response)   
        # if the number or responses doesn't match assume the answer is wrong
        if response.length != @answers.length
            return false
        end
        # loop through each response and make sure the value is in the answers array
        response.each do |res|
            # if answer not valid, or not in answers array assume solution is wrong
            if (!is_valid_answer(res) or !@answers.include? @options[res])
                return false
            end
        end
        # if we get here, solution is valid
        return true
    end
    
    def print
        q = "#{@index}. #{@question}\r\n"
        @options.sort.each do |label, option|
            q +="\t"+label+"). #{option}\r\n";
        end
        
        q += "\r\n"
        return q
    end
end