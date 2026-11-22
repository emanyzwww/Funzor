import { Channel, invoke } from "@tauri-apps/api/core";

// 更新服务 (对应 UpdateService.cs). 清单格式与 GitHub Release 的 latest.json 保持一致.
export interface UpdateInfo {
  version: string;
  url: string;
  sha256: string;
  notes: string;
}

export function getCurrentVersion(): Promise<string> {
  return invoke<string>("get_current_version");
}

export function getUpdateInfo(): Promise<UpdateInfo> {
  return invoke<UpdateInfo>("get_update_info");
}

export function downloadAndRunInstaller(
  info: UpdateInfo,
  onProgress: (fraction: number) => void,
): Promise<void> {
  const channel = new Channel<number>();
  channel.onmessage = onProgress;
  return invoke("download_and_run_installer", { info, onProgress: channel });
}

// 三段式版本号比较: 返回正数表示 a 比 b 新.
export function compareVersions(a: string, b: string): number {
  const pa = a.split(".").map((n) => Number.parseInt(n, 10) || 0);
  const pb = b.split(".").map((n) => Number.parseInt(n, 10) || 0);
  const len = Math.max(pa.length, pb.length);
  for (let i = 0; i < len; i++) {
    const d = (pa[i] ?? 0) - (pb[i] ?? 0);
    if (d !== 0) return d;
  }
  return 0;
}
