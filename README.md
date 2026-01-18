# 孩子的错题库系统

一个用于管理孩子错题的综合性系统，支持手动录入和图片识别添加错题，提供多维度分类管理、筛选、打印和智能题目生成功能。

## 技术栈

### 前端
- React 18
- TypeScript
- Vite
- Tailwind CSS
- React Router
- Tesseract.js (OCR 识别)
- jsPDF + html2canvas (PDF 生成)

### 后端
- Node.js
- Express
- TypeScript
- SQLite
- Sequelize ORM
- Tesseract.js (OCR 识别)

## 功能特点

### 1. 题目录入
- ✅ 手动录入：富文本编辑器支持，可输入题目、答案、解析
- ✅ 图片/截图上传：支持多种图片格式，实时 OCR 识别
- ✅ 自动分类建议：基于题目内容智能推荐科目和知识点

### 2. 题目管理
- ✅ 多维度分类：按科目、知识点、错误类型、时间分类
- ✅ 题目详情：支持添加错误原因、解析、复习笔记
- ✅ 编辑与删除：支持单题和批量操作
- ✅ 收藏功能：标记重点题目

### 3. 题库整理与筛选
- ✅ 高级筛选：支持多条件组合筛选
- ✅ 排序功能：按时间、知识点、错误频率排序
- ✅ 导出功能：支持导出为 JSON、CSV 格式

### 4. 打印功能
- ✅ PDF 生成：美观的打印布局，支持自定义模板
- ✅ 批量打印：选择题目范围和数量
- ✅ 排版优化：自动分页，避免题目跨页
- ✅ 打印预览：实时查看打印效果

### 5. 智能题目生成
- ✅ 基于知识点：分析现有错题的知识点，生成同类型题目
- ✅ 难度适配：支持调整生成题目的难度级别
- ✅ 数量控制：可自定义生成题目数量
- ✅ 答案解析：自动生成答案和解析

### 6. 复习计划
- ✅ 遗忘曲线提醒：基于艾宾浩斯遗忘曲线推荐复习时间
- ✅ 复习记录：记录每次复习情况
- ✅ 掌握程度评估：自动评估题目掌握程度

## 项目结构

```
tiku/
├── frontend/             # 前端代码
│   ├── src/
│   │   ├── components/   # React组件
│   │   ├── pages/        # 页面组件
│   │   ├── hooks/        # 自定义Hooks
│   │   ├── services/     # API服务
│   │   ├── types/        # TypeScript类型定义
│   │   ├── App.tsx       # 应用入口
│   │   ├── main.tsx      # 渲染入口
│   │   └── index.css     # 全局样式
│   ├── package.json      # 前端依赖
│   ├── tsconfig.json     # TypeScript配置
│   ├── vite.config.ts    # Vite配置
│   └── tailwind.config.js # Tailwind CSS配置
├── backend/              # 后端代码
│   ├── src/
│   │   ├── config/       # 配置文件
│   │   ├── controllers/  # 控制器
│   │   ├── models/       # 数据模型
│   │   ├── routes/       # API路由
│   │   ├── services/     # 业务逻辑
│   │   └── utils/        # 工具函数
│   ├── package.json      # 后端依赖
│   └── tsconfig.json     # TypeScript配置
├── database/             # 数据库文件
└── README.md            # 项目说明文档
```

## 安装与运行

### 前置要求
- Node.js 16+ 
- npm 或 yarn

### 1. 克隆项目

```bash
git clone <repository-url>
cd tiku
```

### 2. 安装依赖

#### 前端依赖
```bash
cd frontend
npm install
```

#### 后端依赖
```bash
cd ../backend
npm install
```

### 3. 运行项目

#### 启动后端服务
```bash
cd backend
npm run dev
```
后端服务将运行在 http://localhost:3001

#### 启动前端服务
```bash
cd ../frontend
npm run dev
```
前端服务将运行在 http://localhost:3000

### 4. 访问应用
在浏览器中访问 http://localhost:3000

## API 文档

### 题目相关 API

| 方法 | 路径 | 描述 |
|------|------|------|
| POST | /api/questions | 创建题目 |
| GET | /api/questions | 获取题目列表 |
| GET | /api/questions/:id | 获取单个题目 |
| PUT | /api/questions/:id | 更新题目 |
| DELETE | /api/questions/:id | 删除题目 |
| PATCH | /api/questions/:id/favorite | 切换收藏状态 |

### OCR 相关 API

| 方法 | 路径 | 描述 |
|------|------|------|
| POST | /api/ocr/recognize | 识别图片中的文字 |

## 数据库结构

### subjects 表
| 字段名 | 类型 | 描述 |
|--------|------|------|
| id | INTEGER | 主键，自增 |
| name | TEXT | 科目名称 |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

### questions 表
| 字段名 | 类型 | 描述 |
|--------|------|------|
| id | INTEGER | 主键，自增 |
| subject_id | INTEGER | 外键，关联科目表 |
| content | TEXT | 题目内容 |
| answer | TEXT | 正确答案 |
| user_answer | TEXT | 用户错误答案 |
| error_reason | TEXT | 错误原因 |
| explanation | TEXT | 题目解析 |
| error_type | TEXT | 错误类型 |
| difficulty | INTEGER | 难度等级（1-5） |
| is_favorite | BOOLEAN | 是否收藏 |
| review_count | INTEGER | 复习次数 |
| last_reviewed_at | DATETIME | 最后复习时间 |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

### tags 表
| 字段名 | 类型 | 描述 |
|--------|------|------|
| id | INTEGER | 主键，自增 |
| name | TEXT | 标签名称 |
| type | ENUM | 标签类型（knowledge/error） |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

### question_tags 表
| 字段名 | 类型 | 描述 |
|--------|------|------|
| question_id | INTEGER | 外键，关联题目表 |
| tag_id | INTEGER | 外键，关联标签表 |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

## 开发说明

### 前端开发
- 使用 Vite 作为构建工具
- 使用 TypeScript 进行类型检查
- 使用 Tailwind CSS 进行样式设计
- 使用 React Router 进行路由管理

### 后端开发
- 使用 Express 构建 API 服务
- 使用 Sequelize ORM 操作数据库
- 使用 TypeScript 进行类型检查
- 使用 Tesseract.js 进行 OCR 识别

## 部署说明

### 前端部署
1. 构建前端代码
```bash
cd frontend
npm run build
```
2. 将 dist 目录部署到静态文件服务器（如 Nginx、Apache）

### 后端部署
1. 构建后端代码
```bash
cd backend
npm run build
```
2. 启动后端服务
```bash
npm start
```

## 注意事项

1. 首次运行时，数据库会自动创建并初始化
2. OCR 识别需要一定的时间，取决于图片大小和服务器性能
3. 建议定期备份数据库文件（database/tiku.db）
4. 支持的图片格式：jpeg、jpg、png、gif
5. 单张图片大小限制：5MB

## 许可证

MIT
