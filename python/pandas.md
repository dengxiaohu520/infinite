
## pandas






#### 疑难杂症

1. pandas 读取csv Error tokenizing data. C error: EOF inside string starting
解决方法：
csv文件默认的是以逗号为分隔符，但是中文中逗号的使用率很高，爬取中文数据时就容易造成混淆，所以使用pandas写入csv时可以设置参数 sep=’\t’ ，即以tab为分隔符写入。毕竟tab在中文习惯里用的很少嘛。
那这样在后面读取csv进行数据处理时，一定记得加上一个参数delimiter

df = pd.read_csv(csvfile, header = None, delimiter="\t", quoting=csv.QUOTE_NONE, encoding='utf-8');
df = pd.read_csv('path',delimiter="\t")


