#!/usr/bin/env python3
import json
import base64

# Read the JSON file
with open('document_response.json', 'r') as f:
    data = json.load(f)

# Decode the base64 content
content_base64 = data['content']
pdf_bytes = base64.b64decode(content_base64)

# Save the decoded PDF
with open('decoded_document.pdf', 'wb') as f:
    f.write(pdf_bytes)
print("Saved decoded PDF to decoded_document.pdf")

# Try to extract text (requires PyPDF2 or pdfplumber)
try:
    import pdfplumber
    from io import BytesIO
    with pdfplumber.open(BytesIO(pdf_bytes)) as pdf:
        text = ""
        for page in pdf.pages:
            text += page.extract_text() + "\n"
except ImportError:
    try:
        import PyPDF2
        from io import BytesIO
        pdf_file = BytesIO(pdf_bytes)
        reader = PyPDF2.PdfReader(pdf_file)
        text = ""
        for page in reader.pages:
            text += page.extract_text() + "\n"
    except ImportError:
        print("Install PyPDF2 or pdfplumber: pip install PyPDF2")
        text = ""

if text:
    with open('decoded_document.txt', 'w', encoding='utf-8') as f:
        f.write(text)
    print("Text extracted and saved to decoded_document.txt")
