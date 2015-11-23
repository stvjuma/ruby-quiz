require "./lib/quiz.rb"
require "test/unit"

class TestNAME < Test::Unit::TestCase
    def test_question
        question = Question.new(1, 'What is the capital of France?', 
         ['Berlin', 'London', 'Paris'], ['Paris']);
        assert_equal(1, question.answers.length, 'Unable to validate answers length')
        assert_equal(4, question.options.length, 'Unable to verify multiple choices length')
    end
    
    def test_question_response
        question = Question.new(1, 'What is the capital of France?', 
         ['Berlin', 'London', 'Paris'], ['Paris']);
        response = "";
        question.options.each do |key,value|
            if value == "Paris"
                response = key
                break
            end
        end
        
        assert(question.validate_answers([response]), 'Unable to mark answer as correct')
        assert_equal(false, question.validate_answers(['a','b','c','d']), 'Unable to trap multiple answers as false')
    end
    
    def test_question_multi_response
        question = Question.new(1, 'What is Paris located?', 
            ['Europe', 'France', 'Belgium', 'United Kingdom'], ['France', 'Europe']);
        response = "";
        answers = []
        question.options.each do |k,v|
            if question.answers.include? v
                answers.push(k)
            end
        end
        
        assert_equal(question.answers.length, answers.length, "Number of valid responses doesn't match")
        assert(question.validate_answers(answers), 'Unable to mark multiple answers as correct')
        assert_equal(false, question.validate_answers([answers[0]]), 'Single answers in multi answer question should fail')
    end
    
    def test_question_valid_answer
        question = Question.new(1, 'What is the capital of France?', 
         ['Berlin', 'London', 'Paris'], ['Paris']);
        assert_equal('None of the above', question.options['d'], "Last option not 'None of the above'")
        assert(question.is_valid_answer('a'), 'Unable to verify valid answer')
        assert_equal(false, question.is_valid_answer('e'), 'Unable to verify invalid answer')
    end
    
    def test_question_none_of_the_above
        question = Question.new(1, 'Which came first, the chicken or the egg?', 
            ['Chicken', 'Egg', 'Both'], []);
        assert_equal('None of the above', question.options['d'], "Last option not 'None of the above'")
        assert(question.is_valid_answer('d'), 'Unable to verify valid answer')
        assert_equal(true, question.validate_answers(['d']), "When no answers available, 'None of the above' should be the correct answer")
    end
    
    def test_question_random_options
        question = Question.new(1, 'What is the capital of France?', 
         ['Berlin', 'London', 'Paris'], ['Paris']);
        options = question.options
        3.times do
            q = Question.new(1, 'What is the capital of France?', 
            ['Berlin', 'London', 'Paris'], ['Paris']);
            q.options.each do |k,v|
                if options[k] != v # we have a random order so assertion passes
                    return
                end
            end
        end
        
        assert(false, 'Question options are not in random order')
    end
    
    def test_quiz
        questions = [
            Question.new(1, 'What is the capital of France?', 
            ['Berlin', 'London', 'Paris'], ['Paris']),
            Question.new(1, 'What is 1 + 1?', 
            ['3', '2', '4'], ['2']),
            Question.new(1, 'How many fingers does the average human have?', 
            ['10', '5', '2'], ['10']),
        ]
        
        quiz = Quiz.new(:questions => questions)
        assert_equal(quiz.questions.length, 3, "Number of questions doesn't match")
    end
    
    def test_quiz_random_questions
        questions = [
            Question.new(1, 'What is the capital of France?', 
            ['Berlin', 'London', 'Paris'], ['Paris']),
            Question.new(1, 'What is 1 + 1?', 
            ['3', '2', '4'], ['2']),
            Question.new(1, 'How many fingers does the average human have?', 
            ['10', '5', '2'], ['10']),
        ]
        
       
        3.times do 
            quiz = Quiz.new(:questions => questions)
            quiz.questions.each_with_index do |q,index|
                if q.question != questions[index].question
                    return #questions are in random order so move on
                end
            end
        end
        
        assert(false, 'Quiz questions are not in random order')
    end
    
    def test_quiz_score
        questions = [
            Question.new(1, 'What is the capital of France?', 
            ['Berlin', 'London', 'Paris'], ['Paris']),
            Question.new(1, 'What is 1 + 1?', 
            ['3', '2', '4'], ['2']),
            Question.new(1, 'How many fingers does the average human have?', 
            ['10', '5', '2'], ['10']),
        ]
        
        quiz = Quiz.new(:questions => questions)
        assert_equal(0, quiz.score, "No questions answered, quiz score should be '0'")
        
        questions.each do |question|
            answers = []
            question.options.each do |k,v|
                if question.answers.include? v
                    answers.push(k)
                end
            end
            question.response = answers
        end
        
        assert_equal(3, quiz.score, 'Final score not marked correctly')
        
    end
    
end
