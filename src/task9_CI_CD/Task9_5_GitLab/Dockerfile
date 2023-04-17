FROM centos:7

RUN yum install python3 python-pip -y
COPY  requrements  requrements
RUN pip3 install -r requrements
COPY  python_api/python-api.py  python-api.py
CMD ["python3", "python-api.py"]
