require_relative 'rule_induction.rb'
require_relative 'csv_util.rb'
require_relative 'tree_induction.rb'

def run()
  table, header_class = load_table('../data/tenis.csv')

  rule_induction = RuleInduction.new(table, header_class)
  tree_induction = InductionTree.new(table, header_class)

  puts "Regras de Indução"
  puts rule_induction.get_rules()
  puts "\n"
  puts "Árvore de Indução"
  puts tree_induction.get_tree()
end

run()
