FROM python:3-alpine

RUN apk add --no-cache gcc linux-headers musl-dev postgresql-dev \
	&& pip install --upgrade pip

ADD app/ /ie/app/
ADD app.py /ie/app.py
ADD config.py /ie/config.py
ADD requirements.txt /ie/requirements.txt

WORKDIR /ie

RUN pip3 install -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["python", "app.py"]
