# 访问 https://find.5ch.net/search?q=%E3%81%A6%E3%81%83%E3%82%93%E3%81%8F%E3%82%8B 获取多个话题标题与网址，保存到本地文件 titles.json 中

import requests
from bs4 import BeautifulSoup
import json

URL = "https://find.5ch.net/search?q=%E3%81%A6%E3%81%83%E3%82%93%E3%81%8F%E3%82%8B"

headers = {
    "User-Agent": "Mozilla/5.0"
}

resp = requests.get(URL, headers=headers, timeout=15)
resp.encoding = "utf-8"

soup = BeautifulSoup(resp.text, "html.parser")

results = []

for item in soup.select("div.list > div.list_line"):
    link = item.select_one("a.list_line_link")
    info = item.select("div.list_line_info_container")

    if not link or len(info) < 3:
        continue

    title = link.select_one(".list_line_link_title").text.strip()
    url = link["href"]

    time = info[1].text.strip()
    replies = info[2].text.strip()

    results.append({
        "title": title,
        "url": url,
        "time": time,
        "replies": replies
    })

with open("titles.json", "w", encoding="utf-8") as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

print(f"完成，共保存 {len(results)} 条")
