const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// 连接数据库
const dbPath = path.join(__dirname, 'database/tiku.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('数据库连接失败:', err.message);
    process.exit(1);
  }
  console.log('成功连接到SQLite数据库');
});

// 查询科目数据
db.all('SELECT * FROM subjects', [], (err, rows) => {
  if (err) {
    console.error('查询科目数据失败:', err.message);
    process.exit(1);
  }
  
  console.log('数据库中的科目数据:');
  if (rows.length === 0) {
    console.log('暂无科目数据');
    // 直接插入科目数据
    const defaultSubjects = ['语文', '数学', '英语'];
    defaultSubjects.forEach((subject, index) => {
      db.run(
        'INSERT INTO subjects (name, created_at, updated_at) VALUES (?, datetime(\'now\'), datetime(\'now\'))',
        [subject],
        (err) => {
          if (err) {
            console.error(`插入科目 ${subject} 失败:`, err.message);
          } else {
            console.log(`成功插入科目: ${subject}`);
          }
          
          // 所有科目处理完成后关闭数据库
          if (index === defaultSubjects.length - 1) {
            db.close();
          }
        }
      );
    });
  } else {
    rows.forEach((row, index) => {
      console.log(`${index + 1}. ID: ${row.id}, 名称: ${row.name}, 创建时间: ${row.created_at}`);
    });
    db.close();
  }
});