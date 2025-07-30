FROM python:3.11-slim

WORKDIR /server

COPY app.py .

RUN pip install flask requests

CMD ["python", "app.py"]