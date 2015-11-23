# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
    spec.name          = "quiz"
    spec.version       = '1.0'
    spec.authors       = ["Steve Akuom"]
    spec.email         = ["steve@ju.ma"]
    spec.summary       = %q{Ruby Test}
    spec.description   = %q{Implementation of a Ruby Quiz}
    spec.homepage      = "http://steve.ju.ma"
    spec.license       = "MIT"

    spec.files         = ['lib/quiz.rb']
    spec.executables   = ['bin/quiz']
    spec.test_files    = ['tests/test_quiz.rb']
    spec.require_paths = ["lib"]
end