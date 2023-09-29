import os
import shutil

with open('C:/Teste_Mudanca_NAS/nomes_servicos.txt') as ficheiro:
    errorMsg = "Ocorreu um erro ao mover as seguintes pastas:"
    error = 0
    lines = ficheiro.read().splitlines()
    # print (lines)
    for pasta in lines:
        # print (pasta)
        if pasta[0] == '#':
            pastaMae = pasta[1:]
            print ("pastaMae: "+pastaMae)
            os.mkdir("C:/Teste_Mudanca_NAS/Partilha/Serviços/"+pastaMae)
        else:
            source = "C:/Teste_Mudanca_NAS/Partilhados/"+pasta
            destination = 'C:/Teste_Mudanca_NAS/Partilha/Serviços/'+pastaMae+"/"+pasta
            # print (pasta)
            # print ("Source is folder: "+ str(os.path.isdir(source)))
            # print ("Destination is folder: "+ str(os.path.isdir(destination)))
            # verifica apenas se o source é pasta e se foi criada a pasta mae
            if(os.path.isdir(source) and os.path.isdir('C:/Teste_Mudanca_NAS/Partilha/Serviços/'+pastaMae)): 
                print ("A copiar os ficheiros do servico: "+pasta)
                shutil.move(source, destination)
            else:
                error = 1
                errorMsg += " "+ pasta + " ||"
if error == 0:
    print ("As pastas foram todas movidas com sucesso!!")
else:
    print (errorMsg)

