require_relative 'rule_induction.rb'
require_relative 'csv_util.rb'

def run()
  table, header_class = load_table('../data/tenis.csv')

  induction = RuleInduction.new(table, header_class)
  puts induction.get_rules()
end

run()
