#!/usr/bin/env python3
"""Embed measured Flutter evidence in README; fail if any capture is missing."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
files = ['counter', 'history', 'empty-history', 'non-negative-guard']
for name in files:
    image = root / 'docs' / 'screenshots' / f'{name}.png'
    if not image.is_file() or image.stat().st_size == 0:
        raise SystemExit(f'Missing screenshot: {image}')
log = (root / 'docs' / 'rebuilds.log').read_text(encoding='utf-8')
if 'build: CounterValue' not in log or 'build: HistoryBadge' not in log:
    raise SystemExit('Rebuild log is incomplete')
readme = root / 'README.md'
content = readme.read_text(encoding='utf-8')
start, end = '<!-- EVIDENCE:START -->', '<!-- EVIDENCE:END -->'
block = '''
Журнал нижче записано під час виконання `test/evidence_test.dart`.
Скриншоти є рендерами справжніх Flutter-віджетів у тестовому середовищі.
Час записів фіксований для відтворюваності знімків.

```text
''' + log.rstrip() + '\n```\n\n'
for name, label in zip(files, ['Лічильник', 'Історія', 'Порожня історія', 'Захист від від’ємного значення']):
    block += f'### {label}\n\n![{label}](docs/screenshots/{name}.png)\n\n'
readme.write_text(content[:content.index(start) + len(start)] + '\n' + block +
                  content[content.index(end):], encoding='utf-8')
print('README now contains captured screenshots and measured rebuild logs.')
