import java.util.List;
import java.util.Map;

public class App {
    public static void main(String[] args) throws Exception 
    {
        Map<String, List<String>> exemplos = FileUtils.readFileCSV("data/file.csv");

        for (String rule : exemplos.keySet()) {
            System.out.println(rule + "\n" + exemplos.get(rule) + "\n");
        }
    }
}
