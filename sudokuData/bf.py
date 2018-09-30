import  requests
from bs4 import BeautifulSoup
import threadpool

f = open('data1', 'w')
num = 1;

for sudokuNum in range(214921, 214981):
    print(str(num)+'--'+str(sudokuNum))
    if(num>1000):
        break;
    # f.write("This is " + str(sudokuNum-16421) + " sudoku.")
    urlsudoku = 'https://oubk.com/sudoku/'+str(sudokuNum)+'.html'
    r = requests.get(urlsudoku)
    html_doc = r.text
    soup = BeautifulSoup(html_doc, 'html.parser')
    if(soup.find(id='k1s1')):
        idStr = ''
        game = matrix = [[0 for i in range(10)] for i in range(10)]
        for i in range(1,10):
            tempStr = ''
            for j in range(1,10):
                idStr = 'k'+str(j)+'s'+str(i)
                # print(idStr)
                tempObj = str(soup.find(id=idStr))
                tempObj1 = tempObj.split('value="')[1].split('"')[0]
                if(tempObj1 == ""):
                    game[i-1][j-1] = 0
                else:
                    game[i - 1][j - 1] = int(tempObj1)
                tempStr += str(game[i-1][j-1]) + " "
            f.write(tempStr + '\n')
        f.write('\n')
        num+=1
    else:
        continue;




f.close()
