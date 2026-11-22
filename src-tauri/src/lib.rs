use serde::Deserialize;
use sha2::{Digest, Sha256};
use tauri::{ipc::Channel, AppHandle};

const MANIFEST_URL: &str = "https://github.com/emanyzwww/Funzor/releases/latest/download/latest.json";

/// 对应原 UpdateInfo: GitHub Release 分发清单里的安装包信息.
/// 清单字段兼容 camelCase 与 PascalCase 两种写法.
#[derive(Debug, Clone, serde::Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct UpdateInfo {
    #[serde(alias = "Version")]
    pub version: String,
    #[serde(alias = "Url")]
    pub url: String,
    #[serde(alias = "Sha256")]
    pub sha256: String,
    #[serde(alias = "Notes")]
    pub notes: String,
}

/// 当前程序版本 (对应原 UpdateService.CurrentVersion, 来自程序集版本).
#[tauri::command]
fn get_current_version(app: AppHandle) -> String {
    app.package_info().version.to_string()
}

/// 拉取分发清单. 网络或解析失败返回 Err, 由前端展示更新失败 (对应原 GetLatestAsync).
#[tauri::command]
async fn get_update_info() -> Result<UpdateInfo, String> {
    let response = reqwest::get(MANIFEST_URL)
        .await
        .map_err(|e| e.to_string())?
        .error_for_status()
        .map_err(|e| e.to_string())?;
    let text = response.text().await.map_err(|e| e.to_string())?;
    serde_json::from_str(&text).map_err(|e| e.to_string())
}

/// 下载安装包, 校验 SHA256, 静默启动安装程序后退出应用 (对应原 DownloadAndRunInstallerAsync).
#[tauri::command]
async fn download_and_run_installer(
    app: AppHandle,
    info: UpdateInfo,
    on_progress: Channel<f64>,
) -> Result<(), String> {
    use futures_util::StreamExt;
    use std::io::Write;

    let response = reqwest::get(&info.url)
        .await
        .map_err(|e| e.to_string())?
        .error_for_status()
        .map_err(|e| e.to_string())?;
    let total = response.content_length();

    let directory = std::env::temp_dir().join("FunzorUpdate");
    std::fs::create_dir_all(&directory).map_err(|e| e.to_string())?;
    let installer_path = directory.join("FunzorSetup-x64.exe");

    let mut file = std::fs::File::create(&installer_path).map_err(|e| e.to_string())?;
    let mut received: u64 = 0;
    let mut stream = response.bytes_stream();
    while let Some(chunk) = stream.next().await {
        let chunk = chunk.map_err(|e| e.to_string())?;
        file.write_all(&chunk).map_err(|e| e.to_string())?;
        received += chunk.len() as u64;
        if let Some(total) = total {
            if total > 0 {
                let _ = on_progress.send(received as f64 / total as f64);
            }
        }
    }
    drop(file);

    let bytes = std::fs::read(&installer_path).map_err(|e| e.to_string())?;
    let digest = Sha256::digest(&bytes);
    let hex: String = digest.iter().map(|b| format!("{b:02x}")).collect();
    if !hex.eq_ignore_ascii_case(&info.sha256) {
        let _ = std::fs::remove_file(&installer_path);
        return Err("更新包校验失败, 已取消安装.".to_string());
    }

    // 主程序不要求管理员权限, 安装程序自行请求提权 (见 docs/refactor-plan.md 第 9 节).
    std::process::Command::new(&installer_path)
        .args(["/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART", "/CLOSEAPPLICATIONS"])
        .spawn()
        .map_err(|e| e.to_string())?;

    // 安装程序已在运行, 退出以释放文件占用 (对应原 Application.Current.Exit()).
    app.exit(0);
    Ok(())
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            get_current_version,
            get_update_info,
            download_and_run_installer
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
