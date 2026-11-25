#!/usr/bin/env python3
"""Añade a los 12 archivos app_XX.arb las claves nuevas del selector de tema y
de los mapas de impacto de nodo y red.

Uso, desde la raíz del proyecto Flutter (donde está pubspec.yaml):

    python3 tools/add_l10n_keys.py --dry-run     # solo muestra qué haría
    python3 tools/add_l10n_keys.py               # aplica los cambios
    python3 tools/add_l10n_keys.py --dir lib/l10n

- No reformatea los archivos: añade las claves al final y nada más.
- Es idempotente: las claves que ya existen no se tocan.
- Las traducciones son una propuesta: conviene que las revise alguien que
  hable cada idioma y que el término "nodo" coincida con el que ya usáis
  en impactTabMyNode.
"""
import argparse
import json
import sys
from pathlib import Path

LANGS = ["ca", "es", "eu", "en", "fr", "de", "it", "pt", "ru", "ar", "zh", "ja"]

# Claves que llevan un marcador {count} de tipo entero
WITH_COUNT = {"impactParticipants"}

TR = {
    "settingsTheme": {
        "en": "Theme", "es": "Tema", "ca": "Tema", "eu": "Gaia",
        "fr": "Thème", "de": "Design", "it": "Tema", "pt": "Tema",
        "ru": "Тема", "ar": "المظهر", "zh": "主题", "ja": "テーマ",
    },
    "themeLight": {
        "en": "Day", "es": "Día", "ca": "Dia", "eu": "Eguna",
        "fr": "Jour", "de": "Tag", "it": "Giorno", "pt": "Dia",
        "ru": "День", "ar": "نهار", "zh": "白天", "ja": "昼",
    },
    "themeDark": {
        "en": "Night", "es": "Noche", "ca": "Nit", "eu": "Gaua",
        "fr": "Nuit", "de": "Nacht", "it": "Notte", "pt": "Noite",
        "ru": "Ночь", "ar": "ليل", "zh": "夜晚", "ja": "夜",
    },
    "themeDusk": {
        "en": "Dusk", "es": "Crepúsculo", "ca": "Crepuscle", "eu": "Ilunabarra",
        "fr": "Crépuscule", "de": "Dämmerung", "it": "Crepuscolo", "pt": "Crepúsculo",
        "ru": "Сумерки", "ar": "الغسق", "zh": "黄昏", "ja": "夕暮れ",
    },
    "impactParticipants": {
        "en": "Participants: {count}",
        "es": "Participantes: {count}",
        "ca": "Participants: {count}",
        "eu": "Parte-hartzaileak: {count}",
        "fr": "Participants : {count}",
        "de": "Teilnehmende: {count}",
        "it": "Partecipanti: {count}",
        "pt": "Participantes: {count}",
        "ru": "Участники: {count}",
        "ar": "المشاركون: {count}",
        "zh": "参与者：{count}",
        "ja": "参加者：{count}",
    },
    "impactNoNode": {
        "en": "You don't belong to a node yet. Join one to see its map.",
        "es": "Aún no perteneces a ningún nodo. Únete a uno para ver su mapa.",
        "ca": "Encara no pertanys a cap node. Uneix-te a un per veure'n el mapa.",
        "eu": "Oraindik ez zara inongo nodotakoa. Batu nodo batera bere mapa ikusteko.",
        "fr": "Vous n'appartenez à aucun nœud pour le moment. Rejoignez-en un pour voir sa carte.",
        "de": "Du gehörst noch keinem Knoten an. Tritt einem bei, um seine Karte zu sehen.",
        "it": "Non appartieni ancora a nessun nodo. Unisciti a uno per vederne la mappa.",
        "pt": "Você ainda não pertence a nenhum nó. Entre em um para ver o mapa dele.",
        "ru": "Вы пока не состоите ни в одном узле. Присоединяйтесь к узлу, чтобы увидеть его карту.",
        "ar": "أنت لا تنتمي إلى أي عقدة بعد. انضم إلى عقدة لعرض خريطتها.",
        "zh": "你还没有加入任何节点。加入一个节点即可查看它的地图。",
        "ja": "まだどのノードにも所属していません。ノードに参加すると、そのマップを見られます。",
    },
    "impactScopeError": {
        "en": "Couldn't load the map. Try again.",
        "es": "No se pudo cargar el mapa. Inténtalo de nuevo.",
        "ca": "No s'ha pogut carregar el mapa. Torna-ho a provar.",
        "eu": "Ezin izan da mapa kargatu. Saiatu berriro.",
        "fr": "Impossible de charger la carte. Réessayez.",
        "de": "Die Karte konnte nicht geladen werden. Versuche es erneut.",
        "it": "Impossibile caricare la mappa. Riprova.",
        "pt": "Não foi possível carregar o mapa. Tente novamente.",
        "ru": "Не удалось загрузить карту. Попробуйте снова.",
        "ar": "تعذّر تحميل الخريطة. حاول مرة أخرى.",
        "zh": "无法加载地图，请重试。",
        "ja": "マップを読み込めませんでした。もう一度お試しください。",
    },
    "impactRetry": {
        "en": "Retry", "es": "Reintentar", "ca": "Reintenta", "eu": "Saiatu berriro",
        "fr": "Réessayer", "de": "Erneut versuchen", "it": "Riprova", "pt": "Tentar novamente",
        "ru": "Повторить", "ar": "إعادة المحاولة", "zh": "重试", "ja": "再試行",
    },
}


def entries_for(lang: str, existing: set[str]) -> list[str]:
    """Líneas JSON (con sangría de 2 espacios) de las claves que faltan."""
    out: list[str] = []
    for key, by_lang in TR.items():
        if key in existing:
            continue
        out.append(f"  {json.dumps(key)}: {json.dumps(by_lang[lang], ensure_ascii=False)}")
        if key in WITH_COUNT:
            out.append(
                f'  {json.dumps("@" + key)}: {{\n'
                '    "placeholders": {\n'
                '      "count": { "type": "int" }\n'
                "    }\n"
                "  }"
            )
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir", default="lib/l10n", help="carpeta con los app_XX.arb")
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    folder = Path(args.dir)
    if not folder.is_dir():
        print(f"No existe la carpeta {folder}. Usa --dir con la ruta correcta.")
        return 1

    problems = 0
    for lang in LANGS:
        path = folder / f"app_{lang}.arb"
        if not path.exists():
            print(f"[{lang}] FALTA {path}")
            problems += 1
            continue

        text = path.read_text(encoding="utf-8")
        try:
            existing = set(json.loads(text).keys())
        except json.JSONDecodeError as exc:
            print(f"[{lang}] JSON no válido, no se toca: {exc}")
            problems += 1
            continue

        entries = entries_for(lang, existing)
        if not entries:
            print(f"[{lang}] ya estaba al día")
            continue

        body = text.rstrip()
        if not body.endswith("}"):
            print(f"[{lang}] no termina en }}, no se toca")
            problems += 1
            continue
        new_text = body[:-1].rstrip() + ",\n" + ",\n".join(entries) + "\n}\n"

        try:
            json.loads(new_text)  # comprobar antes de escribir
        except json.JSONDecodeError as exc:
            print(f"[{lang}] el resultado no sería JSON válido, no se toca: {exc}")
            problems += 1
            continue

        added = [e.split(":")[0].strip().strip('"') for e in entries if not e.strip().startswith('"@')]
        if args.dry_run:
            print(f"[{lang}] añadiría: {', '.join(added)}")
        else:
            path.write_text(new_text, encoding="utf-8")
            print(f"[{lang}] añadidas {len(added)} claves")

    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
