require 'logger'
require 'yaml'
require "./lib/quiz.rb"

logger = Logger.new(STDOUT)
VERSION = '1.0';
logger.info 'Quiz version : '+VERSION

cfg_file = 'sample.yaml'
if ARGV.length == 1
    cfg_file = ARGV[0]+'.yaml'
end

config = YAML::load_file(File.join(File.dirname(__FILE__), "./../data/", cfg_file))
q =  Quiz.new(:config => config);
q.render();