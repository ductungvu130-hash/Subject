package simse.tools;

import simse.codegenerator.CodeGenerator;
import simse.modelbuilder.ModelOptions;
import simse.modelbuilder.ModelOptionsFileManipulator;
import simse.modelbuilder.actionbuilder.ActionFileManipulator;
import simse.modelbuilder.actionbuilder.DefinedActionTypes;
import simse.modelbuilder.graphicsbuilder.SopFileManipulator;
import simse.modelbuilder.mapeditor.MapEditorMap;
import simse.modelbuilder.mapeditor.TileData;
import simse.modelbuilder.mapeditor.UserData;
import simse.modelbuilder.objectbuilder.DefinedObjectTypes;
import simse.modelbuilder.objectbuilder.ObjectFileManipulator;
import simse.modelbuilder.rulebuilder.RuleFileManipulator;
import simse.modelbuilder.startstatebuilder.CreatedObjects;
import simse.modelbuilder.startstatebuilder.SimSEObject;
import simse.modelbuilder.startstatebuilder.StartStateFileManipulator;

import java.io.File;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Vector;

public class SimulationBatchGenerator {
  private static final String[][] MODELS = {
      {"waterfall", "waterfall", "Waterfall.mdl"},
      {"incremental", "incremental", "incremental.mdl"},
      {"xp", "xp", "XP.mdl"}
  };

  public static void main(String[] args) throws Exception {
    if (args.length != 2) {
      throw new IllegalArgumentException(
          "Usage: simse.tools.SimulationBatchGenerator <modelsDir> <outputDir>");
    }

    File modelsDir = new File(args[0]).getCanonicalFile();
    File outputDir = new File(args[1]).getCanonicalFile();
    File iconDir = new File(modelsDir, "waterfall/icons").getCanonicalFile();

    if (!modelsDir.isDirectory()) {
      throw new IllegalArgumentException("Models directory not found: " + modelsDir);
    }
    if (!iconDir.isDirectory()) {
      throw new IllegalArgumentException("Icon directory not found: " + iconDir);
    }
    if (!outputDir.exists() && !outputDir.mkdirs()) {
      throw new IllegalStateException("Could not create output directory: " + outputDir);
    }

    for (String[] config : MODELS) {
      generateModel(modelsDir, outputDir, iconDir, config);
    }
  }

  private static void generateModel(File modelsDir, File outputDir, File iconDir,
      String[] config) throws Exception {
    String id = config[0];
    File modelFile = new File(new File(modelsDir, config[1]), config[2])
        .getCanonicalFile();
    File destination = new File(outputDir, id).getCanonicalFile();

    if (!modelFile.isFile()) {
      throw new IllegalArgumentException("Model file not found: " + modelFile);
    }
    resetDirectory(destination);

    ModelOptions options = new ModelOptions();
    new ModelOptionsFileManipulator(options).loadFile(modelFile);
    options.setIconDirectory(iconDir);
    options.setCodeGenerationDestinationDirectory(destination);

    DefinedObjectTypes objectTypes = new DefinedObjectTypes();
    new ObjectFileManipulator(objectTypes).loadFile(modelFile);

    CreatedObjects objects = new CreatedObjects();
    Vector<String> startWarnings =
        new StartStateFileManipulator(objectTypes, objects).loadFile(modelFile);

    DefinedActionTypes actionTypes = new DefinedActionTypes();
    Vector<String> actionWarnings =
        new ActionFileManipulator(objectTypes, actionTypes).loadFile(modelFile);
    Vector<String> ruleWarnings =
        new RuleFileManipulator(objectTypes, actionTypes).loadFile(modelFile);

    Hashtable<SimSEObject, String> startStateImages =
        new Hashtable<SimSEObject, String>();
    Hashtable<SimSEObject, String> ruleImages =
        new Hashtable<SimSEObject, String>();
    Vector<String> graphicsWarnings = new SopFileManipulator(options, objectTypes,
        objects, actionTypes, startStateImages, ruleImages).loadFile(modelFile);

    MapEditorMap mapLoader = new MapEditorMap(null, options, objectTypes, objects,
        actionTypes, startStateImages, ruleImages);
    Vector<String> mapWarnings = mapLoader.loadFile(modelFile);
    ArrayList<UserData> userDatas = mapLoader.getUserDatas();
    TileData[][] map = mapLoader.getMap();

    printWarnings(id, "start state", startWarnings);
    printWarnings(id, "actions", actionWarnings);
    printWarnings(id, "rules", ruleWarnings);
    printWarnings(id, "graphics", graphicsWarnings);
    printWarnings(id, "map", mapWarnings);

    CodeGenerator generator = new CodeGenerator(options, objectTypes, objects,
        actionTypes, startStateImages, ruleImages, map, userDatas);
    generator.generate();
    System.out.println("Generated " + id + " into " + destination);
  }

  private static void printWarnings(String id, String section,
      Vector<String> warnings) {
    if (warnings == null || warnings.isEmpty()) {
      return;
    }
    for (String warning : warnings) {
      System.out.println("Warning [" + id + " " + section + "]: " + warning);
    }
  }

  private static void resetDirectory(File directory) {
    if (directory.exists()) {
      try {
        deleteRecursively(directory);
      } catch (IllegalStateException e) {
        File staleDirectory = new File(directory.getParentFile(),
            directory.getName() + ".stale." + System.currentTimeMillis());
        if (!directory.renameTo(staleDirectory)) {
          throw e;
        }
      }
    }
    if (!directory.mkdirs()) {
      throw new IllegalStateException("Could not create directory: " + directory);
    }
  }

  private static void deleteRecursively(File file) {
    File[] children = file.listFiles();
    if (children != null) {
      for (File child : children) {
        deleteRecursively(child);
      }
    }
    for (int attempt = 1; attempt <= 12; attempt++) {
      if (file.delete() || !file.exists()) {
        return;
      }
      System.gc();
      try {
        Thread.sleep(Math.min(250L * attempt, 2000L));
      } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
        throw new IllegalStateException("Interrupted while deleting: " + file, e);
      }
    }
    if (!file.delete() && file.exists()) {
      throw new IllegalStateException("Could not delete: " + file);
    }
  }
}
