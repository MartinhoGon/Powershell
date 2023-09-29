import os
import shutil

with open('C:/Teste_Mudanca_NAS/nomes_utilizadores2.txt') as ficheiro:
    lines = ficheiro.read().splitlines()
    # print (lines)
    for pasta in lines:
        print ("A copior os ficheiros do utilizador: "+pasta)
        source = "C:/Teste_Mudanca_NAS/Partilhados/"+pasta+"/"
        destination = 'C:/Teste_Mudanca_NAS/Partilha/Pessoais/'+pasta
        shutil.move(source, destination)
