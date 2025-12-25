# 访问 https://phoebe.bbspink.com/test/read.cgi/mobpink/1766390070/l50 ，抓取最新50条回复，保存到本地文件 replies.json 中

import json
import requests
from bs4 import BeautifulSoup

URL = "https://phoebe.bbspink.com/test/read.cgi/mobpink/1766390070/l50"

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
}

resp = requests.get(URL, headers=headers)
resp.raise_for_status()

soup = BeautifulSoup(resp.text, "html.parser")

# 所有回复都在 <article class="clear post">
articles = soup.select("article.clear.post")

results = []

for art in articles[:100]:
    # 楼号
    post_id = art.get("data-id", "").strip()

    # header 里包含时间和 UID
    header = art.select_one("details.post-header")
    if not header:
        continue

    date_span = header.select_one("span.date")
    uid_span = header.select_one("span.uid")

    date_text = date_span.get_text(strip=True) if date_span else ""
    uid_text = uid_span.get_text(strip=True) if uid_span else ""

    # 正文内容
    content = art.select_one("section.post-content")
    body_text = content.get_text(separator="\n", strip=True) if content else ""

    results.append({"post_id":post_id, "date_text":date_text, "uid_text":uid_text, "body_text":body_text})

with open("replies.json", "w", encoding="utf-8") as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

print(f"完成，共保存 {len(results)} 条")
