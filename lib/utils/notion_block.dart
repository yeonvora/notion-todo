/// Checkbox
dynamic checkboxBlock(String name, bool checked) {
  return {
    "object": "block",
    "type": "to_do",
    "to_do": {
      "checked": checked,
      "rich_text": [
        {
          "type": "text",
          "text": {
            "content": name,
          }
        }
      ],
    }
  };
}

/// Divider
dynamic dividerBlock() {
  return {
    "object": "block",
    "type": "divider",
    "divider": {},
  };
}
