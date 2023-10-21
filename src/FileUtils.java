import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FileUtils 
{
    public static Map<String, List<String>> readFileCSV(String file_path) {
        Map<String, List<String>> dataMap = new HashMap<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(file_path))) {
            // Lê a primeira linha do arquivo para obter os nomes das colunas (cabeçalho)
            String header = reader.readLine();
            if (header != null) 
            {
                String line;
                String[] columnNames = header.split(",");

                // Atribui a cada coluna uma instancia de lista
                for (String columnName : columnNames) {
                    dataMap.put(columnName, new ArrayList<>());
                }

                // Adiciona a cada instancia de lista uma lista de strings
                while ((line = reader.readLine()) != null) {
                    String[] values = line.split(",");
                    for (int i = 0; i < columnNames.length && i < values.length; i++) {
                        dataMap.get(columnNames[i]).add(values[i]);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return dataMap;
    }
}
