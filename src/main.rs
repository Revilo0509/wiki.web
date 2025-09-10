use gurtlib::prelude::*;
use pulldown_cmark::{html, Options, Parser};
use serde_json::json;
use std::collections::HashMap;
use std::fs::File;
use std::io::Read;
use std::path::{Path, PathBuf};
use std::sync::Arc;
use tokio::fs::{self, read_dir};
use tokio::sync::RwLock;

const DEV_MODE: bool = true;
const PORT: &str = "4878";
const DOMAIN: &str = "0.0.0.0";

type ComponentCache = Arc<RwLock<HashMap<&'static str, String>>>;

fn guess_content_type(path: &Path) -> &'static str {
    match path.extension().and_then(|e| e.to_str()) {
        Some("html") | Some("htm") => "text/html; charset=utf-8",
        Some("md") => "text/html; charset=utf-8",
        Some("css") => "text/css; charset=utf-8",
        Some("js") => "application/javascript; charset=utf-8",
        Some("json") => "application/json; charset=utf-8",
        Some("png") => "image/png",
        Some("jpg") | Some("jpeg") => "image/jpeg",
        Some("gif") => "image/gif",
        Some("svg") => "image/svg+xml",
        Some("webp") => "image/webp",
        Some("txt") => "text/plain; charset=utf-8",
        Some("pdf") => "application/pdf",
        Some("zip") => "application/zip",
        _ => "application/octet-stream",
    }
}

fn load_file(path: &Path) -> Option<String> {
    println!("Loading file: {:?}", path);
    let mut content = String::new();
    File::open(path).ok()?.read_to_string(&mut content).ok()?;
    Some(content)
}

fn load_binary(path: &Path) -> Option<Vec<u8>> {
    println!("Loading binary file: {:?}", path);
    let mut buf = Vec::new();
    File::open(path).ok()?.read_to_end(&mut buf).ok()?;
    Some(buf)
}

fn sanitize_path(path: &str) -> Option<PathBuf> {
    let trimmed = path.trim();
    if trimmed.is_empty() || Path::new(trimmed).is_absolute() {
        eprintln!("Invalid or absolute path attempt: {}", path);
        return None;
    }

    let path_buf = PathBuf::from(trimmed);
    if path_buf
        .components()
        .any(|c| c == std::path::Component::ParentDir)
    {
        eprintln!("Unsafe path traversal attempt: {}", path);
        return None;
    }

    Some(path_buf)
}

/// Preload all components into a cache at startup
fn preload_components(names: &[&'static str]) -> ComponentCache {
    println!("Preloading components into cache...");
    let mut map = HashMap::new();
    for &name in names {
        let path = PathBuf::from(format!("Frontend/components/{}.html", name));
        let content = load_file(&path).unwrap_or_default();
        map.insert(name, content);
        println!("- Preloaded component: {}", name);
    }
    Arc::new(RwLock::new(map))
}

/// Apply components to a template, with or without caching.
async fn apply_template(template: &str, cache: &ComponentCache) -> String {
    let mut result = template.to_string();

    for comp in ["head", "navbar", "footer"] {
        let html = if DEV_MODE {
            println!("DEV_MODE active: Reloading component '{}' from disk.", comp);
            let path = PathBuf::from(format!("Frontend/components/{}.html", comp));
            load_file(&path)
        } else {
            println!("Production mode: Using cached component '{}'.", comp);
            let cache_read = cache.read().await;
            cache_read.get(comp).cloned()
        };

        if let Some(html_content) = html {
            result = result.replace(&format!("{{{{ {} }}}}", comp), &html_content);
        }
    }

    result
}

async fn render_md(path: &Path, cache: &ComponentCache) -> Option<String> {
    println!("Rendering markdown file: {:?}", path);
    let md_content = load_file(path)?;
    let parser = Parser::new_ext(&md_content, Options::all());
    let mut html_content = String::new();
    html::push_html(&mut html_content, parser);

    let template_path = Path::new("Frontend/static/wikishell.html");
    let template = load_file(template_path)?;
    Some(apply_template(&template.replace("{{ content }}", &html_content), cache).await)
}

async fn serve_path(
    base_dir: &'static str,
    path: &str,
    cache: &ComponentCache,
) -> Result<GurtResponse> {
    println!("Serving path: '{}' from base directory '{}'", path, base_dir);
    let base = Path::new(base_dir);
    let relative_path = if path == "/" || path.is_empty() {
        PathBuf::from("")
    } else if let Some(p) = sanitize_path(path) {
        p
    } else {
        eprintln!("Blocked invalid/unsafe path: '{}'", path);
        return Ok(GurtResponse::forbidden().with_string_body("Invalid or unsafe path"));
    };
    let full_path = base.join(&relative_path);
    println!("Resolved full path: {:?}", full_path);

    if full_path.is_dir() {
        println!("Path is a directory, looking for index file...");
        for index_file in &["index.html", "main.md"] {
            let candidate = full_path.join(index_file);
            if candidate.exists() {
                println!("Found index file: {:?}", candidate);
                let content = if candidate.extension().and_then(|e| e.to_str()) == Some("md") {
                    render_md(&candidate, cache).await
                } else if let Some(c) = load_file(&candidate) {
                    Some(apply_template(&c, cache).await)
                } else {
                    None
                };
                if let Some(content) = content {
                    println!("Successfully served HTML content.");
                    return Ok(GurtResponse::ok()
                        .with_header("Content-Type", "text/html; charset=utf-8")
                        .with_string_body(content));
                }
            }
        }
        println!("No index file found in directory: {:?}", full_path);
        return Ok(GurtResponse::not_found().with_string_body("File not found"));
    }

    let content_type = guess_content_type(&full_path);
    println!("Serving file: {:?}, Content-Type: {}", full_path, content_type);

    if content_type.starts_with("text/")
        || content_type.contains("javascript")
        || content_type.contains("json")
    {
        if let Some(mut content) = load_file(&full_path) {
            if content_type == "text/html; charset=utf-8" {
                content = apply_template(&content, cache).await;
            }
            println!("Successfully served text/HTML content.");
            return Ok(GurtResponse::ok()
                .with_header("Content-Type", content_type)
                .with_string_body(content));
        }
    } else if let Some(bytes) = load_binary(&full_path) {
        println!("Successfully served binary content.");
        return Ok(GurtResponse::ok()
            .with_header("Content-Type", content_type)
            .with_body(bytes));
    }

    eprintln!("File not found or failed to load: {:?}", full_path);
    Ok(GurtResponse::not_found().with_string_body("File not found"))
}

#[tokio::main]
async fn main() -> Result<()> {
    let cache = preload_components(&["head", "navbar", "footer"]);
    let address = format!("{}:{}", DOMAIN, PORT);

    let server = GurtServer::with_tls_certificates("cert.pem", "key.pem")?
        .get("/wiki/*", {
            let cache = cache.clone();
            move |ctx| {
                let path = ctx.path().strip_prefix("/wiki/").unwrap_or("").to_string();
                let cache = cache.clone();
                async move {
                    println!("Handling request for '/wiki/{}'", path);
                    serve_path("Data", &path, &cache).await
                }
            }
        })
        .get("/static/*", {
            let cache = cache.clone();
            move |ctx| {
                let path = ctx
                    .path()
                    .strip_prefix("/static/")
                    .unwrap_or(ctx.path())
                    .trim_start_matches('/')
                    .to_string();
                let cache = cache.clone();
                async move {
                    println!("Handling request for '/static/{}'", path);
                    serve_path("Frontend/static", &path, &cache).await
                }
            }
        })
        .get("/api/count", |_ctx| async {
            println!("Handling API request for '/api/count'");
            let mut folders = Vec::new();
            let mut entries = match read_dir("Data").await {
                Ok(entries) => entries,
                Err(e) => {
                    eprintln!("Error reading 'Data' directory: {}", e);
                    return Ok(GurtResponse::internal_server_error()
                        .with_string_body("Failed to read data directory"));
                }
            };

            while let Some(entry) = entries.next_entry().await.unwrap() {
                let path = entry.path();
                if path.is_dir() {
                    if let Some(folder_name) = path.file_name().and_then(|n| n.to_str()) {
                        folders.push(folder_name.to_string());
                    }
                }
            }

            let response_json = json!({
                "folders": folders,
                "count": folders.len(),
            });
            println!("API response: Found {} folders.", folders.len());

            Ok(GurtResponse::ok().with_json_body(&response_json)?)
        })
        .get("/*", {
            let cache = cache.clone();
            move |ctx| {
                let path = ctx.path().strip_prefix("/").unwrap_or("").to_string();
                let cache = cache.clone();
                async move {
                    println!("Handling generic request for '/{}'", path);
                    serve_path("Frontend/pages", &path, &cache).await
                }
            }
        });

    println!("GURT server starting on gurt://{}", address);
    server.listen(&address).await
}