import { OPENAI_MODELS } from '../types/openai';
import { OpenAIClient } from '../lib/openai';

const client = new OpenAIClient(process.env.OPENAI_API_KEY!);

// Example usage
const response = await client.createChatCompletion(
  'gpt-4-turbo-preview',
  messages,
  {
    temperature: 0.7,
    max_tokens: 1000
  }
); 