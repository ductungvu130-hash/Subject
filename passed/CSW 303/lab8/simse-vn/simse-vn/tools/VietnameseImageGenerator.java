import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.geom.Rectangle2D;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

/**
 * Generates Vietnamese UI GIF labels for SimSE simulations (cross-platform).
 */
public final class VietnameseImageGenerator {

  private static final Pattern UNICODE = Pattern.compile("\\\\u([0-9A-Fa-f]{4})");

  private VietnameseImageGenerator() {}

  public static void main(String[] args) throws Exception {
    if (args.length != 1) {
      System.err.println("Usage: VietnameseImageGenerator <generatedRoot>");
      System.exit(1);
    }
    Path generatedRoot = Path.of(args[0]);
    if (!Files.isDirectory(generatedRoot)) {
      throw new IllegalArgumentException("Not a directory: " + generatedRoot);
    }
    Files.list(generatedRoot)
        .filter(Files::isDirectory)
        .forEach(dir -> {
          try {
            processModel(dir);
          } catch (Exception e) {
            throw new RuntimeException(e);
          }
        });
  }

  private static void processModel(Path modelDir) throws Exception {
    Path imagesDir = modelDir.resolve("simse/gui/images");
    Path layoutDir = imagesDir.resolve("layout");
    if (Files.isDirectory(imagesDir)) {
      saveTextGif(
          imagesDir.resolve("all.GIF").toFile(),
          unescape("T\\u1EA4T C\\u1EA2"),
          35,
          35,
          8,
          new Color(246, 246, 246),
          Color.BLACK);
    }
    if (!Files.isDirectory(layoutDir)) {
      return;
    }
    Color tabBack = new Color(216, 226, 238);
    Color tabClicked = new Color(186, 207, 230);
    Color buttonBack = new Color(228, 238, 238);
    Color buttonText = new Color(18, 45, 90);

    saveTextGif(layoutDir.resolve("btnArtifact.gif").toFile(), unescape("S\\u1EA2N PH\\u1EA8M"), 120, 16, 9, tabBack, buttonText);
    saveTextGif(layoutDir.resolve("btnArtifactClicked.gif").toFile(), unescape("S\\u1EA2N PH\\u1EA8M"), 120, 16, 9, tabClicked, buttonText);
    saveTextGif(layoutDir.resolve("btnCustomer.gif").toFile(), unescape("KH\\u00C1CH H\\u00C0NG"), 120, 16, 9, tabBack, buttonText);
    saveTextGif(layoutDir.resolve("btnCustomerClicked.gif").toFile(), unescape("KH\\u00C1CH H\\u00C0NG"), 120, 16, 9, tabClicked, buttonText);
    saveTextGif(layoutDir.resolve("btnEmployee.gif").toFile(), unescape("NH\\u00C2N VI\\u00CAN"), 120, 16, 9, tabBack, buttonText);
    saveTextGif(layoutDir.resolve("btnEmployeeClicked.gif").toFile(), unescape("NH\\u00C2N VI\\u00CAN"), 120, 16, 9, tabClicked, buttonText);
    saveTextGif(layoutDir.resolve("btnProject.gif").toFile(), unescape("D\\u1EF0 \\u00C1N"), 120, 16, 9, tabBack, buttonText);
    saveTextGif(layoutDir.resolve("btnProjectClicked.gif").toFile(), unescape("D\\u1EF0 \\u00C1N"), 120, 16, 9, tabClicked, buttonText);
    saveTextGif(layoutDir.resolve("btnTool.gif").toFile(), unescape("C\\u00D4NG C\\u1EE4"), 120, 16, 9, tabBack, buttonText);
    saveTextGif(layoutDir.resolve("btnToolClicked.gif").toFile(), unescape("C\\u00D4NG C\\u1EE4"), 120, 16, 9, tabClicked, buttonText);
    saveTextGif(layoutDir.resolve("btnNextEvent.gif").toFile(), unescape("S\\u1EF0 KI\\u1EC6N TI\\u1EBEP"), 88, 17, 7, buttonBack, buttonText);
    saveTextGif(layoutDir.resolve("btnAdvClock.gif").toFile(), unescape("CH\\u1EA0Y \\u0110\\u1ED2NG H\\u1ED2"), 88, 17, 7, buttonBack, buttonText);
    saveTextGif(layoutDir.resolve("btnStopClock.gif").toFile(), unescape("D\\u1EEANG"), 88, 17, 9, buttonBack, buttonText);
    saveClockGif(layoutDir.resolve("clock.gif").toFile());
  }

  private static String unescape(String value) {
    Matcher matcher = UNICODE.matcher(value);
    StringBuffer sb = new StringBuffer();
    while (matcher.find()) {
      int code = Integer.parseInt(matcher.group(1), 16);
      matcher.appendReplacement(sb, Matcher.quoteReplacement(String.valueOf((char) code)));
    }
    matcher.appendTail(sb);
    return sb.toString();
  }

  private static void saveTextGif(
      File path, String text, int width, int height, int fontSize, Color back, Color fore)
      throws Exception {
    Files.createDirectories(path.toPath().getParent());
    BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
    Graphics2D g = image.createGraphics();
    try {
      enableQuality(g);
      g.setColor(back);
      g.fillRect(0, 0, width, height);
      g.setColor(new Color(40, 80, 110));
      g.setStroke(new BasicStroke(1f));
      g.drawRect(0, 0, width - 1, height - 1);
      g.setColor(fore);
      g.setFont(new Font("SansSerif", Font.BOLD, fontSize));
      drawCentered(g, text, width, height);
    } finally {
      g.dispose();
    }
    ImageIO.write(image, "gif", path);
  }

  private static void saveClockGif(File path) throws Exception {
    int width = 242;
    int height = 96;
    Files.createDirectories(path.toPath().getParent());
    BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
    Graphics2D g = image.createGraphics();
    try {
      enableQuality(g);
      Color back = new Color(226, 236, 236);
      Color panel = new Color(210, 230, 234);
      Color textColor = new Color(20, 55, 90);
      Color border = new Color(0, 74, 145);
      g.setColor(back);
      g.fillRect(0, 0, width, height);
      g.setColor(border);
      g.setStroke(new BasicStroke(2f));
      g.drawRect(2, 2, width - 5, height - 5);
      g.setColor(panel);
      g.fillRect(15, 34, 92, 25);
      g.setColor(border);
      g.drawRect(15, 34, 92, 25);
      Font fontTitle = new Font("SansSerif", Font.BOLD, 10);
      Font fontSmall = new Font("SansSerif", Font.BOLD, 9);
      g.setColor(textColor);
      g.setFont(fontTitle);
      drawInRect(g, unescape("TH\\u1EDCI GIAN"), 22, 6, 110, 16);
      drawInRect(g, unescape("\\u0110\\u00C3 QUA"), 30, 19, 110, 14);
      g.setFont(fontSmall);
      drawInRect(g, unescape("NH\\u1ECAP"), 24, 63, 75, 14);
    } finally {
      g.dispose();
    }
    ImageIO.write(image, "gif", path);
  }

  private static void enableQuality(Graphics2D g) {
    g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
  }

  private static void drawCentered(Graphics2D g, String text, int width, int height) {
    Rectangle2D bounds = g.getFontMetrics().getStringBounds(text, g);
    float x = (float) ((width - bounds.getWidth()) / 2d - bounds.getX());
    float y = (float) ((height - bounds.getHeight()) / 2d - bounds.getY());
    g.drawString(text, x, y);
  }

  private static void drawInRect(Graphics2D g, String text, float rx, float ry, float rw, float rh) {
    Rectangle2D bounds = g.getFontMetrics().getStringBounds(text, g);
    float x = rx + (float) ((rw - bounds.getWidth()) / 2d - bounds.getX());
    float y = ry + (float) ((rh - bounds.getHeight()) / 2d - bounds.getY());
    g.drawString(text, x, y);
  }
}
