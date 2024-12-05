import OpenAI from 'openai';

export class OpenAIClient {
  private client: OpenAI;

  constructor(apiKey: string) {
    this.client = new OpenAI({ apiKey });
  }

  async createChatCompletion(
    model: string,
    messages: any[],
    options: any = {}
  ) {
    return await this.client.chat.completions.create({
      model,
      messages,
      ...options
    });
  }

  // Add other methods for different model types
  async createImage(prompt: string, options: any = {}) {
    return await this.client.images.generate({
      prompt,
      ...options
    });
  }

  async createEmbedding(input: string | string[], options: any = {}) {
    return await this.client.embeddings.create({
      input,
      model: 'text-embedding-3-small', // or text-embedding-3-large
      ...options
    });
  }
} 