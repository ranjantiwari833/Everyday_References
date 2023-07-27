#!/usr/bin/python3

import argparse
from pathlib import Path
import yaml

parser=argparse.ArgumentParser(
    prog="test_python_script.py",
    description="Yaml parser mock function",
)

parser.add_argument("-i", "--input", required=True, help="Name of yaml file")
parser.add_argument("-t", "--ticket", required=True, help="Ticket ID")
args=parser.parse_args()

target_file = Path(args.input)

if not target_file.exists():
    print("Target file doesnt exist")
    raise SystemExit(1)


if __name__ == "__main__":
    ticket_number=args.ticket

    with open(args.input, "r") as yaml_file:
        yaml_data = yaml.safe_load(yaml_file)
        yaml_data["ticket id"] = ticket_number

    with open('new.yaml', "w") as write_file:
        yaml.safe_dump(yaml_data, write_file)