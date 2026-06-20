using System.Diagnostics;
using System.Drawing;
using System.Windows.Forms;
using Serilog;

namespace AB001.WinForm.Forms
{
    /// <summary>
    /// アプリケーション全体で利用する共通の画面基底クラスです。
    /// </summary>
    public partial class AbstractForm : Form
    {
        /// <summary>
        /// 画面タイトルに付与するアプリケーション名です。
        /// </summary>
        private const string ApplicationTitle = "勤怠管理";

        /// <summary>
        /// Esc キーで画面を閉じる機能を有効化するかどうかを取得します。
        /// </summary>
        protected virtual bool EnableEscapeToClose => true;

        /// <summary>
        /// <see cref="AbstractForm"/> クラスの新しいインスタンスを初期化します。
        /// </summary>
        protected AbstractForm()
        {
            InitializeComponent();
            ConfigureBaseAppearance();
        }

        /// <summary>
        /// フォーム読み込み時に共通のタイトル設定を適用します。
        /// </summary>
        /// <param name="e">イベント データ。</param>
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            ApplyWindowTitle();
            Log.Information("画面を表示しました。Form={FormName}, Title={Title}", GetType().Name, Text);
        }

        /// <summary>
        /// 画面の共通外観を設定します。
        /// </summary>
        protected virtual void ConfigureBaseAppearance()
        {
            KeyPreview = true;
            StartPosition = FormStartPosition.CenterScreen;
            MinimumSize = new Size(960, 540);
            Font = SystemFonts.MessageBoxFont;
        }

        /// <summary>
        /// 画面タイトルにアプリケーション名を付与します。
        /// </summary>
        protected virtual void ApplyWindowTitle()
        {
            if (string.IsNullOrWhiteSpace(Text))
            {
                Text = ApplicationTitle;
                return;
            }

            if (!Text.EndsWith($" - {ApplicationTitle}", StringComparison.Ordinal))
            {
                Text = $"{Text} - {ApplicationTitle}";
            }
        }

        /// <summary>
        /// 情報メッセージを表示します。
        /// </summary>
        /// <param name="message">表示するメッセージ。</param>
        protected void ShowInfo(string message)
        {
            Log.Information("情報メッセージを表示します。Form={FormName}, Title={Title}, Message={Message}", GetType().Name, Text, message);
            MessageBox.Show(this, message, "情報", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        /// <summary>
        /// 警告メッセージを表示します。
        /// </summary>
        /// <param name="message">表示するメッセージ。</param>
        protected void ShowWarning(string message)
        {
            Log.Warning("警告メッセージを表示します。Form={FormName}, Title={Title}, Message={Message}", GetType().Name, Text, message);
            MessageBox.Show(this, message, "警告", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }

        /// <summary>
        /// 例外情報をログ出力し、エラーメッセージを表示します。
        /// </summary>
        /// <param name="message">表示するメッセージ。</param>
        /// <param name="exception">発生した例外。</param>
        protected void ShowError(string message, Exception exception)
        {
            Debug.WriteLine(exception);
            Log.Error(exception, "エラーメッセージを表示します。Form={FormName}, Title={Title}, Message={Message}", GetType().Name, Text, message);
            MessageBox.Show(this, message, "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        /// <summary>
        /// 確認ダイアログを表示し、ユーザーの選択結果を返します。
        /// </summary>
        /// <param name="message">表示するメッセージ。</param>
        /// <returns>ユーザーが「はい」を選択した場合は <see langword="true"/>。</returns>
        protected bool Confirm(string message)
        {
            var result = MessageBox.Show(this, message, "確認", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes;
            Log.Information("確認ダイアログの結果を受け取りました。Form={FormName}, Title={Title}, Message={Message}, Result={Result}", GetType().Name, Text, message, result);
            return result;
        }

        /// <summary>
        /// 指定処理を例外ハンドリング付きで実行します。
        /// </summary>
        /// <param name="action">実行する処理。</param>
        /// <param name="errorMessage">例外発生時に表示するメッセージ。</param>
        /// <returns>処理が成功した場合は <see langword="true"/>、失敗した場合は <see langword="false"/>。</returns>
        protected bool ExecuteSafely(Action action, string errorMessage)
        {
            try
            {
                action();
                Log.Information("共通例外ハンドリング対象の処理が成功しました。Form={FormName}, Title={Title}", GetType().Name, Text);
                return true;
            }
            catch (Exception ex)
            {
                ShowError(errorMessage, ex);
                return false;
            }
        }
    }
}
