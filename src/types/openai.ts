export type OpenAIModel = {
  id: string;
  name: string;
  maxTokens: number;
  type: 'chat' | 'completion' | 'image' | 'embedding';
}

export const OPENAI_MODELS: OpenAIModel[] = [
  {
    id: 'gpt-4-0125-preview',
    name: 'GPT-4 Turbo Preview',
    maxTokens: 128000,
    type: 'chat'
  },
  {
    id: 'gpt-4-turbo-preview',
    name: 'GPT-4 Turbo Preview',
    maxTokens: 128000,
    type: 'chat'
  },
  {
    id: 'gpt-4',
    name: 'GPT-4',
    maxTokens: 8192,
    type: 'chat'
  },
  {
    id: 'gpt-3.5-turbo-0125',
    name: 'GPT-3.5 Turbo',
    maxTokens: 16385,
    type: 'chat'
  },
  // Add other models as needed
]; 