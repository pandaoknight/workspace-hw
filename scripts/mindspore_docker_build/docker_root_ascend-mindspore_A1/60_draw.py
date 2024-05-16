import plotext as plt
import os

def find_latest_file(directory):
    """Find the latest file in the specified directory based on lexicographical order."""
    files = [f for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f))]
    if not files:
        return None
    return max(files, key=lambda x: os.path.join(directory, x))

def extract_ai_core_data(filepath):
    """Extract AI Core(%) data from the file."""
    ai_core_data = []
    with open(filepath, 'r') as file:
        next(file)  # Skip the header line
        for line in file:
            parts = line.split()
            if len(parts) > 4:  # Check if the line has enough parts
                ai_core_data.append(float(parts[4]))  # AI Core(%) is expected to be the 5th column
    return ai_core_data

def plot_data(data):
    """Plot the data using plotext and save it to a file."""
    plt.plot(data)
    plt.title("AI Core Usage Over Time")
    plt.xlabel("Time (arbitrary units)")
    plt.ylabel("AI Core(%)")
    plt.grid(True)
    plt.show()
    plt.savefig("ai_core_usage_plot.png")
    plt.clf()

def main():
    output_dir = "output"
    latest_file_name = find_latest_file(output_dir)
    if latest_file_name:
        file_path = os.path.join(output_dir, latest_file_name)
        print(f"Processing file: {file_path}")
        data = extract_ai_core_data(file_path)
        plot_data(data)
    else:
        print("No files found in the output directory.")

if __name__ == "__main__":
    main()

