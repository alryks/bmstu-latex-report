import argparse
import csv
import sys
from dataclasses import dataclass
from pathlib import Path
from statistics import mean, median, stdev


@dataclass(frozen=True)
class Measurement:
    trial: int
    time_ms: float


@dataclass(frozen=True)
class Summary:
    count: int
    minimum: float
    maximum: float
    average: float
    median: float
    stddev: float


def read_measurements(path: Path) -> list[Measurement]:
    measurements = []
    seen_trials = set()

    with path.open(encoding="utf-8", newline="") as source:
        reader = csv.DictReader(source)
        required_fields = {"trial", "time_ms"}
        if not required_fields.issubset(reader.fieldnames or []):
            raise ValueError("Expected the trial and time_ms columns.")

        for row in reader:
            try:
                trial = int(row["trial"])
                time_ms = float(row["time_ms"])
            except (TypeError, ValueError) as exc:
                raise ValueError(
                    f"Invalid measurement on CSV line {reader.line_num}."
                ) from exc

            if trial in seen_trials:
                raise ValueError(f"Duplicate trial number: {trial}.")
            if trial < 1 or not 0 <= time_ms < float("inf"):
                raise ValueError(f"Invalid values for trial {trial}.")

            seen_trials.add(trial)
            measurements.append(Measurement(trial, time_ms))

    if not measurements:
        raise ValueError("The CSV contains no measurements.")

    return sorted(measurements, key=lambda item: item.trial)


def summarize(measurements: list[Measurement]) -> Summary:
    times = [item.time_ms for item in measurements]
    return Summary(
        count=len(times),
        minimum=min(times),
        maximum=max(times),
        average=mean(times),
        median=median(times),
        stddev=stdev(times) if len(times) > 1 else 0.0,
    )


def print_report(
    measurements: list[Measurement], summary: Summary, show_trials: bool
) -> None:
    if show_trials:
        print(f"{'Trial':>6} {'Time, ms':>12}")
        for item in measurements:
            print(f"{item.trial:>6} {item.time_ms:>12.2f}")
        print()

    print(f"Measurements: {summary.count}")
    print(f"Minimum:      {summary.minimum:.2f} ms")
    print(f"Maximum:      {summary.maximum:.2f} ms")
    print(f"Mean:         {summary.average:.2f} ms")
    print(f"Median:       {summary.median:.2f} ms")
    print(f"Std. dev.:    {summary.stddev:.2f} ms")


def main() -> int:
    parser = argparse.ArgumentParser(description="Summarize measurements.")
    parser.add_argument("input", type=Path, help="CSV file with measurements")
    parser.add_argument("--show-trials", action="store_true")
    args = parser.parse_args()

    try:
        measurements = read_measurements(args.input)
    except (OSError, ValueError) as exc:
        print(exc, file=sys.stderr)
        return 1

    print_report(measurements, summarize(measurements), args.show_trials)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
