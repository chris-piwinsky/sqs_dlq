import json
import logging
import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    try:
        # Your Lambda function logic here

        # Simulate an error
        raise Exception("This Lambda function intentionally raised an error")
    except Exception as e:
        # Log the entire event payload as JSON along with the timestamp
        current_timestamp = datetime.datetime.now().isoformat()
        logger.error(f"Received event at {current_timestamp}: {json.dumps(event)}")
        
        # Append the timestamp to the error message
        error_message = f"{str(e)} (Occurred at {current_timestamp})"
        raise Exception(error_message)
