class RuleInduction
  def initialize(initial_table, header_class)
    # Inicializa as variáveis de instância
    @i_table, @header_class = [initial_table, header_class]
    @arr_rules = []
  end

  def get_rules()
    # Cria uma cópia profunda da tabela inicial
    b_table = Marshal.load(Marshal.dump(@i_table))
    sorted_class = sort_classes(b_table)

    # Loop sobre as classes ordenadas
    sorted_class.each do |c|
      @i_table = Marshal.load(Marshal.dump(b_table))
      @indicated_class, qtd_class = c

      # Loop até não haver mais instâncias da classe indicada
      while qtd_class > 0
        @arr_rules << best_complex(@i_table)
        qtd_class -= @removed_rows_qtt
      end
    end

    @arr_rules
  end

  private

  def best_complex(b_table)
    # Cria uma cópia profunda da tabela base

    t_table = Marshal.load(Marshal.dump(b_table))
    s_table = nil
    @rule = 'if '

    # Loop até a tabela de treinamento estar vazia
    while !t_table.empty?
      values = positive_confidence(t_table)

      unless need_specialize?(values[0])
        # Atualiza a tabela inicial e retorna a regra
        @i_table = update_table(t_table, s_table, @i_table, values)
        return @rule + " then class=#{@indicated_class}\n"

      else
        # Especializa a tabela de treinamento
        s_table = specialize(t_table, values)
        values = positive_confidence(s_table)
      end
    end
  end

  def positive_confidence(table)
    # Calcula a confiança positiva
    max_total = 0.0
    max_value, max_attr, max_column = [0.0, '', '']

    data_count = count_attributes(table)
    data_count.delete(@header_class)

    data_count.each do |header, attributes|
      attributes.each do |attr, counts|
        total = counts.values.sum
        conf = (counts[@indicated_class] / total.to_f).round(2)

        # Atualiza os valores máximos
        if max_value < conf || (max_value == conf && max_total < total)
          max_value, max_attr, max_column = [conf, attr, header]
          max_total = total
        end
      end
    end

    [max_value, max_attr, max_column]
  end

  def count_attributes(table)
    # Conta a ocorrência de atributos em cada coluna
    count = {}
    table.headers.each do |header|
      count[header] = {}
      table[header].uniq.each do |value|
        count[header][value] = (header != @header_class) ? Hash.new(0) : 0
      end
    end

    table.each do |row|
      table.headers.each do |header|
        if header != @header_class
          count[header][row[header]][row[@header_class]] += 1
        else
          count[header][row[header]] += 1
        end
      end
    end

    count
  end

  def specialize(t_table, values)
    # Especializa a tabela
    @rule += "#{values[2]}=#{values[1]} and "
    t_table.delete_if { |row| row[values[2]] != values[1] }

    s_table = Marshal.load(Marshal.dump(t_table))
    s_table.delete(values[2])

    s_table
  end

  def update_table(t_table, s_table, b_table, values)
    # Atualiza a tabela
    @rule += "#{values[2]}=#{values[1]}"

    if s_table != nil
      t_table.delete_if { |row| row[values[2]] != values[1] || row[@header_class] != @indicated_class }
      up_table = b_table.delete_if { |row| t_table.include?(row) }
      @removed_rows_qtt = t_table.length
    else
      up_table = t_table.delete_if { |row| row[values[2]] == values[1] && row[@header_class] == @indicated_class }
      @removed_rows_qtt = b_table.length - t_table.length
    end

    up_table
  end

  def sort_classes(table)
    # Ordena as classes pela ocorrência
    counts = count_attributes(table)
    sorted_class = counts[@header_class].sort_by { |key, column| column }.reverse

    sorted_class
  end

  def need_specialize?(values)
    # Verifica se a especialização é necessária
    values != 1.0
  end
end
