required_dirs=(
  "challenges/beginner"
  "challenges/intermediate"
  "challenges/advanced"
  "templates"
)

required_files=(
  "README.md"
  "CONTRIBUTING.md"
  "LICENSE"
  "templates/challenge-template.md"
)

for dir in "${required_dirs[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "❌ Directory not found: $dir"
    exit 1
  fi
done

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "❌ File not found: $file"
    exit 1
  fi
done

echo "✅ Repository structure validated successfully!"
exit 0