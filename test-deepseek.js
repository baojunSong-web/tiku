const fetch = require('node-fetch');

// 测试DeepSeek API调用
async function testDeepSeekAPI() {
  try {
    const apiKey = 'sk-e3ee9621ac434ec695ce269c6fa7535f'; // 从.env文件获取的API密钥
    const apiUrl = 'https://api.deepseek.com/v1/chat/completions';
    
    const testQuestion = {
      content: '1+1=?',
      answer: '2',
      explanation: '简单的加法运算'
    };
    
    const response = await fetch(apiUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: 'deepseek-chat',
        messages: [
          {
            role: 'system',
            content: `你是一位专业的教育助手，擅长根据原题生成相关的练习题。请根据用户提供的题目生成3道难度为2的相关练习题，包含题目、答案和解析。` +
                     '难度级别：1-简单，2-中等，3-较难，4-困难，5-非常困难。' +
                     '返回格式：每个题目包含"题目"、"答案"和"解析"三个字段，用\n分隔，不同题目用---分隔。'
          },
          {
            role: 'user',
            content: `请根据以下题目生成3道难度为2的相关练习题：\n${testQuestion.content}`
          }
        ]
      })
    });
    
    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.message || `API请求失败: ${response.status}`);
    }
    
    const data = await response.json();
    
    console.log('DeepSeek API调用成功！');
    console.log('生成的题目内容：');
    console.log(data.choices[0].message.content);
    
    // 解析生成的题目
    const generatedContent = data.choices[0].message.content;
    const questionBlocks = generatedContent.split('---');
    const questions = [];
    
    questionBlocks.forEach((block, index) => {
      const lines = block.trim().split('\n');
      const question = {
        id: `generated-${Date.now()}-${index}`,
        content: '',
        answer: '',
        explanation: '',
        difficulty: 2
      };
      
      let currentSection = '';
      lines.forEach(line => {
        line = line.trim();
        if (line.startsWith('题目')) {
          currentSection = 'content';
          question.content = line.replace(/^题目[：:]\s*/, '');
        } else if (line.startsWith('答案')) {
          currentSection = 'answer';
          question.answer = line.replace(/^答案[：:]\s*/, '');
        } else if (line.startsWith('解析')) {
          currentSection = 'explanation';
          question.explanation = line.replace(/^解析[：:]\s*/, '');
        } else if (currentSection) {
          question[currentSection] += '\n' + line;
        }
      });
      
      if (question.content.trim()) {
        questions.push(question);
      }
    });
    
    console.log('\n解析后的题目列表：');
    console.log(JSON.stringify(questions, null, 2));
    
    return true;
  } catch (error) {
    console.error('DeepSeek API调用失败：', error);
    return false;
  }
}

// 执行测试
testDeepSeekAPI();
