@ECHO OFF

docker run -it -p8899:8899 -v c:/users/seb/Onedrive/Code/Notebooks:/home/foobar/notebooks -t sdevine/ihaskell:latest 
