@echo off
rem 文字コードをUTF-8に変更（日本語文字化け対策）
chcp 65001 > nul

rem ★バッチファイルが存在するフォルダの「1つ上の階層（ルート）」にカレントディレクトリを移動
cd /d "%~dp0.."

rem ==================================================
rem 設定エリア（プロジェクト名やフレームワークの定義）
rem ==================================================
set TARGET_FRAMEWORK=net8.0

echo ==================================================
echo  .NET 8 WinForms 複数ソリューション構成プロジェクト作成を開始します
echo  (Serilog設定外出し対応 ＆ Oracle対応 ＆ xUnit全面配置版)
echo ==================================================

rem 1. フォルダの作成 (src, tests, db)
echo 📁 フォルダを作成しています...
if not exist src mkdir src
if not exist tests mkdir tests
if not exist db\migrations mkdir db\migrations

rem ==================================================
rem 2. 製品プロジェクトの作成 (src フォルダ内)
rem ==================================================
echo 🛠️ 製品プロジェクトを作成しています...

rem 共通プロジェクト (クラスライブラリ)
dotnet new classlib -n ABCommon.Business -f %TARGET_FRAMEWORK% -o src\ABCommon.Business
dotnet new classlib -n ABCommon.DataAccess -f %TARGET_FRAMEWORK% -o src\ABCommon.DataAccess

rem 画面アプリケーション (WinForms)
dotnet new winforms -n AB001.WinForm -f %TARGET_FRAMEWORK% -o src\AB001.WinForm
dotnet new winforms -n AB002.WinForm -f %TARGET_FRAMEWORK% -o src\AB002.WinForm
dotnet new winforms -n AB003.WinForm -f %TARGET_FRAMEWORK% -o src\AB003.WinForm


rem ==================================================
rem 3. テストプロジェクトの作成 (tests フォルダ内) ※xUnit
rem ==================================================
echo 🧪 テストプロジェクトを作成しています (xUnit)...

dotnet new xunit -n ABCommon.Business.Tests -f %TARGET_FRAMEWORK% -o tests\ABCommon.Business.Tests
dotnet new xunit -n ABCommon.DataAccess.Tests -f %TARGET_FRAMEWORK% -o tests\ABCommon.DataAccess.Tests


rem ==================================================
rem 4. プロジェクト参照（依存関係）の設定
rem ==================================================
echo 🔗 プロジェクト間の参照を設定しています...

rem 共通ビジネスロジック -> 共通データアクセス への参照
dotnet add src\ABCommon.Business\ABCommon.Business.csproj reference src\ABCommon.DataAccess\ABCommon.DataAccess.csproj

rem 各画面アプリケーション -> 共通ビジネスロジック への参照
dotnet add src\AB001.WinForm\AB001.WinForm.csproj reference src\ABCommon.Business\ABCommon.Business.csproj
dotnet add src\AB002.WinForm\AB002.WinForm.csproj reference src\ABCommon.Business\ABCommon.Business.csproj
dotnet add src\AB003.WinForm\AB003.WinForm.csproj reference src\ABCommon.Business\ABCommon.Business.csproj

rem テストプロジェクト -> 製品プロジェクト への参照
dotnet add tests\ABCommon.Business.Tests\ABCommon.Business.Tests.csproj reference src\ABCommon.Business\ABCommon.Business.csproj
dotnet add tests\ABCommon.DataAccess.Tests\ABCommon.DataAccess.Tests.csproj reference src\ABCommon.DataAccess\ABCommon.DataAccess.csproj


rem ==================================================
rem 5. 外部パッケージの追加 (Serilog ＆ Oracle ＆ Json設定)
rem ==================================================
echo 📦 外部パッケージを追加しています...

rem 各WinForm（UI層）にはSerilogコア＋出力先＋★JSON構成読込パッケージを追加
dotnet add src\AB001.WinForm\AB001.WinForm.csproj package Serilog
dotnet add src\AB001.WinForm\AB001.WinForm.csproj package Serilog.Sinks.Console
dotnet add src\AB001.WinForm\AB001.WinForm.csproj package Serilog.Sinks.File
dotnet add src\AB001.WinForm\AB001.WinForm.csproj package Microsoft.Extensions.Configuration.Json
dotnet add src\AB001.WinForm\AB001.WinForm.csproj package Serilog.Settings.Configuration

dotnet add src\AB002.WinForm\AB002.WinForm.csproj package Serilog
dotnet add src\AB002.WinForm\AB002.WinForm.csproj package Serilog.Sinks.Console
dotnet add src\AB002.WinForm\AB002.WinForm.csproj package Serilog.Sinks.File
dotnet add src\AB002.WinForm\AB002.WinForm.csproj package Microsoft.Extensions.Configuration.Json
dotnet add src\AB002.WinForm\AB002.WinForm.csproj package Serilog.Settings.Configuration

dotnet add src\AB003.WinForm\AB003.WinForm.csproj package Serilog
dotnet add src\AB003.WinForm\AB003.WinForm.csproj package Serilog.Sinks.Console
dotnet add src\AB003.WinForm\AB003.WinForm.csproj package Serilog.Sinks.File
dotnet add src\AB003.WinForm\AB003.WinForm.csproj package Microsoft.Extensions.Configuration.Json
dotnet add src\AB003.WinForm\AB003.WinForm.csproj package Serilog.Settings.Configuration

rem 共通ビジネスロジック層にはSerilogコアのみ追加
dotnet add src\ABCommon.Business\ABCommon.Business.csproj package Serilog

rem 共通データアクセス層にSerilogコアとOracle接続パッケージを追加
dotnet add src\ABCommon.DataAccess\ABCommon.DataAccess.csproj package Serilog
dotnet add src\ABCommon.DataAccess\ABCommon.DataAccess.csproj package Oracle.ManagedDataAccess.Core


rem ==================================================
rem 6. 各ソリューションファイルの作成とプロジェクトの追加
rem ==================================================
echo 📄 ソリューションファイルを作成し、プロジェクトを追加しています...

rem --- AB001 ソリューション ---
dotnet new sln -n AB001 -f sln
dotnet sln AB001.sln add src\AB001.WinForm\AB001.WinForm.csproj
dotnet sln AB001.sln add src\ABCommon.Business\ABCommon.Business.csproj
dotnet sln AB001.sln add src\ABCommon.DataAccess\ABCommon.DataAccess.csproj
dotnet sln AB001.sln add tests\ABCommon.Business.Tests\ABCommon.Business.Tests.csproj
dotnet sln AB001.sln add tests\ABCommon.DataAccess.Tests\ABCommon.DataAccess.Tests.csproj

rem --- AB002 ソリューション ---
dotnet new sln -n AB002 -f sln
dotnet sln AB002.sln add src\AB002.WinForm\AB002.WinForm.csproj
dotnet sln AB002.sln add src\ABCommon.Business\ABCommon.Business.csproj
dotnet sln AB002.sln add src\ABCommon.DataAccess\ABCommon.DataAccess.csproj
dotnet sln AB002.sln add tests\ABCommon.Business.Tests\ABCommon.Business.Tests.csproj
dotnet sln AB002.sln add tests\ABCommon.DataAccess.Tests\ABCommon.DataAccess.Tests.csproj

rem --- AB003 ソリューション ---
dotnet new sln -n AB003 -f sln
dotnet sln AB003.sln add src\AB003.WinForm\AB003.WinForm.csproj
dotnet sln AB003.sln add src\ABCommon.Business\ABCommon.Business.csproj
dotnet sln AB003.sln add src\ABCommon.DataAccess\ABCommon.DataAccess.csproj
dotnet sln AB003.sln add tests\ABCommon.Business.Tests\ABCommon.Business.Tests.csproj
dotnet sln AB003.sln add tests\ABCommon.DataAccess.Tests\ABCommon.DataAccess.Tests.csproj


rem ==================================================
rem 7. ビルド確認
rem ==================================================
echo 🔨 ビルド確認を行っています...
dotnet build AB001.sln
dotnet build AB002.sln
dotnet build AB003.sln

echo ==================================================
echo  🎉 すべての設定が完了しました！
echo ==================================================
pause