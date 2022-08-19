
FROM python:3.8.3-alpine

RUN pip install --upgrade pip

RUN adduser -D myuser
USER myuser
WORKDIR /home/myuser
ADD app .

COPY --chown=myuser:myuser requirements.txt requirements.txt
RUN pip install --user -r requirements.txt

ENV PATH="/home/myuser/.local/bin:${PATH}"

COPY --chown=myuser:myuser . .

CMD ["python", "produce.py", "runserver", "0.0.0.0:8000"]

