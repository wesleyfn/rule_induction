class InductionTree
	def initialize(initial_table, header_class)
		# Inicializa as variáveis de instância
		@i_table, @header_class = [initial_table, header_class]
		@arr_rules = []
		@tree = build_decision_tree(initial_table, header_class)
	end

	def get_tree()
		# Percorre a árvore de decisão para gerar as regras
		traverse_tree(@tree, "")
		@arr_rules.join("\n")
	end

	private

	def build_decision_tree(table, header_class)
		# Verifica se a tabela está vazia ou se todas as instâncias têm a mesma classe
		if table.empty? || same_class?(table, header_class)
			return { class: table[0][header_class] }
		end

		# Calcula o atributo com maior ganho de informação
		best_attribute = select_best_attribute(table, header_class)

		# Cria um nó para o atributo selecionado
		node = { attribute: best_attribute, children: {} }

		# Agrupa as instâncias por valor do atributo selecionado
		grouped_instances = group_instances(table, best_attribute)

		# Recursivamente constrói a árvore para cada valor do atributo selecionado
		grouped_instances.each do |value, instances|
			node[:children][value] = build_decision_tree(instances, header_class)
		end

		node
	end

	def traverse_tree(node, rule)
		if node[:class]
			# Se o nó é uma folha, adiciona a regra ao array de regras
			@arr_rules << rule + "[ #{node[:class]} ]"
		else
			# Se o nó é um atributo, percorre os filhos
			node[:children].each do |value, child|
				traverse_tree(child, rule + "[ #{node[:attribute]} ]--#{value}-->")
			end
		end
	end

	def same_class?(table, header_class)
		# Verifica se todas as instâncias têm a mesma classe
		table.map { |row| row[header_class] }.uniq.length == 1
	end

	def select_best_attribute(table, header_class)
		# Calcula o ganho de informação para cada atributo e seleciona o atributo com maior ganho
		attributes = table.first.headers - [header_class]
		gains = attributes.map { |attribute| [attribute, information_gain(table, attribute, header_class)] }
		gains.max_by { |_, gain| gain }[0]
	end

	def information_gain(table, attribute, header_class)
		# Calcula o ganho de informação para um atributo
		entropy_s = entropy(table, header_class)
		total_instances = table.length

		grouped_instances = group_instances(table, attribute)
		attribute_entropy = grouped_instances.sum do |_, instances|
			instances.length.to_f / total_instances * entropy(instances, header_class)
		end

		entropy_s - attribute_entropy
	end

	def entropy(table, header_class)
		# Calcula a entropia de uma tabela
		class_counts = table.group_by { |row| row[header_class] }.transform_values(&:length)
		total_instances = table.length

		class_counts.sum do |_, count|
			probability = count.to_f / total_instances
			-probability * Math.log2(probability)
		end
	end

	def group_instances(table, attribute)
		# Agrupa as instâncias por valor do atributo
		table.group_by { |row| row[attribute] }
	end
end
# Compare this snippet from src/run.rb:
