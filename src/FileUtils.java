import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class FileUtils {
    /**
     * Lê um arquivo CSV e retorna uma lista de listas de strings.
     *
     * @param file_path O caminho para o arquivo CSV a ser lido.
     * @return Uma lista de listas, onde cada lista representa uma 
     *         linha/regra do arquivo CSV.
     */
    public static List<List<String>> readFileCSV(String file_path) {
        List<List<String>> rulesList = new ArrayList<>();

        // Tenta abrir e ler o arquivo CSV especificado
        try (BufferedReader reader = new BufferedReader(new FileReader(file_path))) {
            String line;
            // Lê cada linha do arquivo
            while ((line = reader.readLine()) != null) {
                // Divide a linha em campos usando a vírgula como delimitador
                String[] rule = line.split(",");
                // Adiciona uma regra à lista de regras
                rulesList.add(Arrays.asList(rule));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return rulesList;
    }
}