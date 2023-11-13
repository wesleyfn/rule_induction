require 'byebug'

=begin
  i_table= initial_table
  b_table= base_table
  t_table= training_table
  s_table= specialized_table
=end

class RuleInduction
  def initialize(initial_table, header_class)
    @i_table, @header_class = [initial_table, header_class]
    @sorted_class = []
    @indicated_class = nil

    @rule = ''
    @arr_rules = []
    @removed_rows_qtt = 0
  end

  def get_rules()
    b_table = Marshal.load(Marshal.dump(@i_table))
    @sorted_class = sort_classes(b_table)

    @sorted_class.each do |c|
      @i_table = Marshal.load(Marshal.dump(b_table))
      @indicated_class, qtd_class = c
      while c[1] > 0
        @arr_rules << best_complex(@i_table)
        # show_table(@i_table)
        c[1] -= @removed_rows_qtt
      end
    end
    @arr_rules
  end

  private

  def best_complex(b_table)
    t_table = Marshal.load(Marshal.dump(b_table))
    s_table = nil
    @rule = 'if '

    values = positive_confidence(t_table)
    while !t_table.empty?
      unless need_specialize?(values[0])
        @i_table = update_table(t_table, s_table, @i_table, values)
        return @rule + " then class=#{@indicated_class}\n"
      else
        s_table = specialize(t_table, values)
      end
      values = positive_confidence(s_table)
    end
  end

  def positive_confidence(table)
    complex = {}
    max_total = 0.0
    max_value, max_attr, max_column = [0.0, '', '']

    data_count = count_attributes(table)
    data_count.delete(@header_class)

    data_count.each do |header, attributes|
      attributes.each do |attr, counts|
        total = 0.0

        counts.each { |_, value| total += value }
        conf = (counts[@indicated_class] / total.to_f).round(2)

        if max_value < conf
          max_total = total
          max_value, max_attr, max_column = [conf, attr, header]
        elsif max_value == conf and max_total < total
          max_value, max_attr, max_column = [conf, attr, header]
          max_total = total
        end
      end
    end
    [max_value, max_attr, max_column]
  end

  def count_attributes(table)
    count = {}
    # Inicialize a contagem com valores padrão
    table.headers.each do |header|
      count[header] = {}
      table[header].uniq.each do |value|
        count[header][value] = (header != @header_class) ? Hash.new(0) : 0
      end
    end

    # Preencha a contagem
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
    @rule += "#{values[2]}=#{values[1]} and "
    s_table = Marshal.load(Marshal.dump(t_table))

    s_table.delete_if { |row| row[values[2]] != values[1] }
    t_table.delete_if { |row| row[values[2]] != values[1] }

    s_table.delete(values[2])
    s_table
  end

  def update_table(t_table, s_table, b_table, values)
    @rule += "#{values[2]}=#{values[1]}"

    if s_table != nil
      t_table.delete_if { |row| !(row[values[2]] == values[1] && row[@header_class] == @indicated_class) }
      up_table = b_table.delete_if { |row| t_table.include?(row) }
      @removed_rows_qtt = t_table.length
    else
      up_table = t_table.delete_if { |row| row[values[2]] == values[1] && row[@header_class] == @indicated_class }
      @removed_rows_qtt = b_table.length - t_table.length
    end

    up_table
  end

  def sort_classes(table)
    counts = count_attributes(table)
    sorted_class = (
      counts[@header_class].sort_by { |key, column| column }
    ).reverse

    sorted_class
  end

  def need_specialize?(values)
    (values == 1.0) ? false : true
  end

=begin   def show_table(table)
    i = 1
    table.each do |row|
      puts "Linha #{i}: #{row}"
      i += 1
    end
  end
=end
end
