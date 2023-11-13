require 'csv'

def load_table(file_path)
  table = CSV.read(file_path, headers: true)
  header_class = table.headers[-1]
  [table, header_class] # return
end
