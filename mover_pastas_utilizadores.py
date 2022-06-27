import os
import shutil

with open('C:/Teste_Mudanca_NAS/nomes_utilizadores2.txt') as ficheiro:
    lines = ficheiro.read().splitlines()
    errorMsg = "Ocorreu um erro ao mover as seguintes pastas:"
    error = 0

    # print (lines)
    for pasta in lines:
        source = "C:/Teste_Mudanca_NAS/Partilhados/"+pasta+"/"
        destination = 'C:/Teste_Mudanca_NAS/Partilha/Pessoais/'+pasta
        if(os.path.isdir(source)):
            print ("A copiar os ficheiros do utilizador: "+pasta)
            shutil.move(source, destination)
        else:
            error = 1
            errorMsg += " "+ pasta + " ||"
if error == 0:
    print ("As pastas foram todas movidas com sucesso!!")
else:
    print (errorMsg)