import json
import sys

def analyze_tests(filename):
    try:
        with open(filename, 'r', encoding='utf-16le') as f:
            lines = f.readlines()
    except UnicodeDecodeError:
        with open(filename, 'r', encoding='utf-8') as f:
            lines = f.readlines()

    tests = {}
    failures = []

    for line in lines:
        try:
            data = json.loads(line)
            if data['type'] == 'testStart':
                tests[data['test']['id']] = data['test']
            elif data['type'] == 'testDone':
                if data['result'] == 'failure':
                    test_id = data['testId']
                    test_info = tests.get(test_id, {'name': 'Unknown'})
                    failures.append(test_info)
            elif data['type'] == 'error':
                failures.append({'name': 'Global Error', 'error': data['error']})
        except:
            continue

    if not failures:
        print("No failures found in JSON.")
    else:
        print(f"Found {len(failures)} failures:")
        for f in failures:
            print(f"- {f.get('name')} (File: {f.get('url')})")

if __name__ == "__main__":
    analyze_tests('tests.json')
