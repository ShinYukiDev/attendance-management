using AB001.WinForm.Forms;
using Microsoft.Extensions.Configuration;
using Serilog;

namespace AB001.WinForm;

internal static class Program
{
    /// <summary>
    ///  アプリケーションのメインのエントリポイント。
    /// </summary>
    [STAThread]
    private static void Main()
    {
        ConfigureLogger();
        Application.ThreadException += OnThreadException;
        AppDomain.CurrentDomain.UnhandledException += OnUnhandledException;

        try
        {
            Log.Information("アプリケーションを起動します。");

            // To customize application configuration such as set high DPI settings or default font,
            // see https://aka.ms/applicationconfiguration.
            ApplicationConfiguration.Initialize();
            Application.Run(new DemoForm());
        }
        catch (Exception ex)
        {
            Log.Fatal(ex, "アプリケーションで未処理例外が発生しました。");
            throw;
        }
        finally
        {
            Log.Information("アプリケーションを終了します。");
            Log.CloseAndFlush();
        }
    }

    /// <summary>
    /// Serilog のロガーを構成します。
    /// </summary>
    private static void ConfigureLogger()
    {
        Directory.CreateDirectory(Path.Combine(AppContext.BaseDirectory, "Logs"));

        var configuration = new ConfigurationBuilder()
            .SetBasePath(AppContext.BaseDirectory)
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
            .Build();

        Log.Logger = new LoggerConfiguration()
            .ReadFrom.Configuration(configuration)
            .CreateLogger();
    }

    /// <summary>
    /// UI スレッド上の未処理例外をログ出力します。
    /// </summary>
    /// <param name="sender">イベント送信元。</param>
    /// <param name="e">例外イベント データ。</param>
    private static void OnThreadException(object sender, ThreadExceptionEventArgs e)
    {
        Log.Error(e.Exception, "UI スレッドで未処理例外が発生しました。");
        MessageBox.Show($"UI スレッドで未処理例外が発生しました。\n\n{e.Exception.Message}", "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
    }

    /// <summary>
    /// アプリケーション ドメインの未処理例外をログ出力します。
    /// </summary>
    /// <param name="sender">イベント送信元。</param>
    /// <param name="e">例外イベント データ。</param>
    private static void OnUnhandledException(object sender, UnhandledExceptionEventArgs e)
    {
        if (e.ExceptionObject is Exception exception)
        {
            Log.Fatal(exception, "アプリケーション ドメインで未処理例外が発生しました。");
            MessageBox.Show($"アプリケーション ドメインで未処理例外が発生しました。\n\n{exception.Message}", "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return;
        }

        Log.Fatal("アプリケーション ドメインで未処理例外が発生しました。例外詳細は取得できませんでした。");
        MessageBox.Show("アプリケーション ドメインで未処理例外が発生しました。例外詳細は取得できませんでした。", "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
    }
}
