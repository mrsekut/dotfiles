use std::io::Write;
use std::process::{Command, Stdio};

fn main() {
    let max_log_count = std::env::var("MAX_LOG_COUNT").unwrap_or_else(|_| "30".to_string());
    let filter_command = std::env::var("FILTER").unwrap_or_else(|_| "fzf".to_string());

    if let Err(e) = run(&max_log_count, &filter_command) {
        eprintln!("Error: {}", e);
        std::process::exit(1);
    }
}

fn run(max_log_count: &str, filter_command: &str) -> Result<(), String> {
    if !has_staged_changes()? {
        return Err("No staged changes. Use 'git add -p' to add them.".to_string());
    }

    let commits = get_commit_history(max_log_count)?;
    let selected_line = run_filter_command(filter_command, &commits)?;
    let target_commit_hash = extract_commit_hash(&selected_line)?;

    create_fixup_commit(&target_commit_hash)?;
    run_rebase(&target_commit_hash)?;

    println!("Fixup commit and rebase completed successfully.");
    Ok(())
}

fn has_staged_changes() -> Result<bool, String> {
    let status = Command::new("git")
        .arg("diff")
        .arg("--cached")
        .arg("--quiet")
        .status()
        .map_err(|e| format!("Failed to run git diff: {}", e))?;
    Ok(!status.success())
}

fn get_commit_history(max_log_count: &str) -> Result<String, String> {
    let output = Command::new("git")
        .arg("log")
        .arg("--oneline")
        .arg("-n")
        .arg(max_log_count)
        .output()
        .map_err(|e| format!("Failed to run git log: {}", e))?;

    if output.status.success() {
        Ok(String::from_utf8_lossy(&output.stdout).to_string())
    } else {
        Err("git log command failed".to_string())
    }
}

fn run_filter_command(filter_command: &str, input: &str) -> Result<String, String> {
    let mut child = Command::new(filter_command)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .map_err(|e| format!("Failed to start filter command: {}", e))?;

    if let Some(stdin) = child.stdin.as_mut() {
        stdin
            .write_all(input.as_bytes())
            .map_err(|e| format!("Failed to write to stdin: {}", e))?;
    }

    let output = child
        .wait_with_output()
        .map_err(|e| format!("Failed to read output: {}", e))?;

    if output.status.success() {
        Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
    } else {
        Err("Filter command failed".to_string())
    }
}

fn extract_commit_hash(line: &str) -> Result<String, String> {
    line.split_whitespace()
        .next()
        .map(|s| s.to_string())
        .ok_or_else(|| "Failed to parse selected commit hash".to_string())
}

fn create_fixup_commit(commit_hash: &str) -> Result<(), String> {
    let status = Command::new("git")
        .arg("commit")
        .arg("--fixup")
        .arg(commit_hash)
        .status()
        .map_err(|e| format!("Failed to run git commit --fixup: {}", e))?;

    if status.success() {
        Ok(())
    } else {
        Err("git commit --fixup command failed".to_string())
    }
}

fn run_rebase(commit_hash: &str) -> Result<(), String> {
    let rebase_target = format!("{}~1", commit_hash);
    let status = Command::new("git")
        .arg("rebase")
        .arg("-i")
        .arg("--autosquash")
        .arg(&rebase_target)
        .status()
        .map_err(|e| format!("Failed to run git rebase: {}", e))?;

    if status.success() {
        Ok(())
    } else {
        Err("git rebase command failed".to_string())
    }
}
