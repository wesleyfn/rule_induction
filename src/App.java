import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class App {
    public static void main(String[] args) throws Exception 
    {
        String file_path = "data/file.csv";
        Map<String, List<String>> dataMap = FileUtils.readFileCSV(file_path);

        String classe;
        try (Scanner scanner = new Scanner(System.in)) {
            System.out.print("Digite a coluna classe: ");
            classe = scanner.nextLine();
        }

        List<String> classes = dataMap.get(classe);

        System.out.println(classes);
    }
}
