import java.util.List;

public class App {
    public static void main(String[] args) throws Exception {
        for (List<String> rule : FileUtils.readFileCSV("data/file.csv")) {
            System.out.println(rule.get(2));
        }
    }
}
