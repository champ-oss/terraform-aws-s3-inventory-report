FROM public.ecr.aws/lambda/python:3.9

RUN yum -y install awscli curl

COPY inventory_report.py "${LAMBDA_TASK_ROOT}"

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

CMD [ "inventory_report.lambda_handler" ]