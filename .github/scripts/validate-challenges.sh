#!/bin/bash

challenges=$(find challenges -type f -name "README.md")

required_sections=(
  "## 📝 Descrição"
  "## 🎯 Objetivos"
  "## 📋 Requisitos"
  "## 📈 Critérios de Avaliação"
)

exit_code=0

for challenge in $challenges; do
  echo "Validating $challenge..."
  
  for section in "${required_sections[@]}"; do
    if ! grep -q "$section" "$challenge"; then
      echo "❌ Missing section in $challenge: $section"
      exit_code=1
    fi
  done
done

if [ $exit_code -eq 0 ]; then
  echo "✅ All challenges validated successfully!"
fi

exit $exit_code