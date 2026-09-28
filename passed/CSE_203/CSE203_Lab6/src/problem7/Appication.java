package problem7;

import java.util.ArrayList;
import java.util.List;

class Application {
    
    private List<IPlugin> installedPlugins;

    public Application() {
        this.installedPlugins = new ArrayList<>();
    }

    
    public void loadPlugin(IPlugin plugin) {
        installedPlugins.add(plugin);
    }

    public void runPlugins() {
        System.out.println("--- Starting running PLUGIN ---");
        for (IPlugin plugin : installedPlugins) {
            
            plugin.execute();
        }
        System.out.println("--------------------------------");
    }
}