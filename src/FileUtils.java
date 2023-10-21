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

    public static String encontreMelhorComplexo(Map<String, List<String>> Exemplos, String classe) {
        String melhorComplexo = "";
    
        // Inicialize um valor mínimo para a confiabilidade positiva
        double melhorConfiabilidadePositiva = 0.0;
    
        for (String feature : Exemplos.keySet()) {
            // Calcule a confiabilidade positiva para a feature atual
            double confiabilidadePositiva = calcularConfiabilidadePositiva(feature, Exemplos, classe);
    
            // Se a confiabilidade positiva atual for maior que a anterior, atualize o melhorComplexo
            if (confiabilidadePositiva > melhorConfiabilidadePositiva) {
                melhorComplexo = feature;
                melhorConfiabilidadePositiva = confiabilidadePositiva;
            }
        }
    
        return melhorComplexo;
    }
    
    public static double calcularConfiabilidadePositiva(String feature, Map<String, List<String>> Exemplos, String classe) {
        int totalPositivos = 0; // Total de exemplos positivos da classe
        int positivosComFeature = 0; // Total de exemplos positivos com a feature
    
        for (int i = 0; i < Exemplos.get("classe").size(); i++) {
            String classeAtual = Exemplos.get("classe").get(i);
            if (classeAtual.equals(classe)) {
                totalPositivos++;
                if (Exemplos.get(feature).get(i).equals("1")) {
                    positivosComFeature++;
                }
            }
        }
    
        if (totalPositivos == 0) {
            return 0.0; // Evitar divisão por zero
        }
    
        return (double) positivosComFeature / totalPositivos;
    }
}
