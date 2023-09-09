## Exponential Backoff for Retries

To improve the reliability and resilience of the message processing system, this project implements exponential backoff for retries in the Lambda function. Exponential backoff gradually increases the time delay between retry attempts, which helps prevent overloading the system with continuous retry requests.

### How Exponential Backoff Works

1. When a message fails processing and needs to be retried, the Lambda function calculates a delay period before the next retry.

2. The delay period is calculated based on the current retry count:
   - For each retry attempt, the delay period is exponentially increased.
   - Random jitter is introduced to add variability to the delay, reducing the likelihood of retry storms.

3. Messages are then sent back to the main SQS queue with the calculated delay.

### Benefits of Exponential Backoff

- **Reduced Load**: Exponential backoff reduces the load on both the Lambda function and the SQS queues. Continuous retries at a fixed interval can overload the system, while exponential backoff spreads retries over a longer time frame.

- **Improved Resilience**: By introducing randomness in the retry delay, the system becomes more resilient to transient issues. If many messages fail simultaneously, they won't retry at the same time.

- **Graceful Handling**: Messages that repeatedly fail and exceed the retry threshold are eventually sent to the Dead Letter Queue (DLQ) or another designated destination. This prevents the system from indefinitely retrying unprocessable messages.

### Configuration

You can customize the behavior of exponential backoff by adjusting parameters like the initial retry delay and the maximum retry count in the Lambda function code. By default, messages are retried up to 3 times before being sent to the DLQ.

Feel free to modify the exponential backoff logic to suit your specific requirements.