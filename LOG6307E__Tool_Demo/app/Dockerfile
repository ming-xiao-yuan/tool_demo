FROM python:3.12

WORKDIR /server_app
COPY . .

RUN pip install -r requirements.txt

RUN python -m venv venv
RUN . venv/bin/activate

EXPOSE 5000

CMD ["python", "server.py"]