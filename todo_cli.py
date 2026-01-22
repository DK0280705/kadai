#!/usr/bin/env python3
import argparse
import json
from pathlib import Path

DATA_FILE = Path(__file__).with_name("tasks.json")


def load_tasks():
    if DATA_FILE.exists():
        with DATA_FILE.open("r", encoding="utf-8") as f:
            return json.load(f)
    return []


def save_tasks(tasks):
    with DATA_FILE.open("w", encoding="utf-8") as f:
        json.dump(tasks, f, ensure_ascii=True, indent=2)


def list_tasks(tasks):
    if not tasks:
        print("No tasks yet.")
        return
    for idx, task in enumerate(tasks, start=1):
        status = "[x]" if task.get("done") else "[ ]"
        print(f"{idx}. {status} {task.get('text', '')}")


def add_task(tasks, text):
    tasks.append({"text": text, "done": False})
    save_tasks(tasks)
    print("Added.")


def mark_done(tasks, index):
    try:
        tasks[index]["done"] = True
        save_tasks(tasks)
        print("Marked done.")
    except IndexError:
        print("No such task.")


def delete_task(tasks, index):
    try:
        removed = tasks.pop(index)
        save_tasks(tasks)
        print(f"Deleted: {removed.get('text', '')}")
    except IndexError:
        print("No such task.")


def parse_args():
    parser = argparse.ArgumentParser(description="Tiny TODO CLI")
    sub = parser.add_subparsers(dest="command")

    sub.add_parser("list", help="List tasks")

    add = sub.add_parser("add", help="Add a task")
    add.add_argument("text", nargs="+", help="Task description")

    done = sub.add_parser("done", help="Mark task as done")
    done.add_argument("index", type=int, help="Task number from 'list'")

    delete = sub.add_parser("delete", help="Delete a task")
    delete.add_argument("index", type=int, help="Task number from 'list'")

    return parser.parse_args()


def main():
    args = parse_args()
    tasks = load_tasks()

    if args.command == "add":
        add_task(tasks, " ".join(args.text))
    elif args.command == "done":
        mark_done(tasks, args.index - 1)
    elif args.command == "delete":
        delete_task(tasks, args.index - 1)
    else:
        list_tasks(tasks)


if __name__ == "__main__":
    main()
