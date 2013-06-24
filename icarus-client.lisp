;******************************************************************************
;******************************************************************************
; ICARUS-CLIENT.LISP
;
; This file implement a TCP Client in CLISP 
;******************************************************************************
;******************************************************************************

(defpackage "ICARUS-CLIENT" (:use "COMMON-LISP" "SOCKET"))

(setf SERVER_IP "127.0.0.1")
(setf SERVER_PORT 6003)

(DEFUN socketClose (socket)
    (WRITE-LINE "close()" socket)
    (FORCE-OUTPUT socket)
    (FORMAT T "Closing~%")
    (FORCE-OUTPUT T)
    (CLOSE socket)
)

(DEFUN socketClient (host port)
    ; Open connection
    (WITH-OPEN-STREAM (socket (SOCKET:SOCKET-CONNECT port host :EXTERNAL-FORMAT :DOS))
        (SETF i 0)
        ; Verify if the connection is ok
        (LOOP 
            (WHEN (EQ :eof (SOCKET:SOCKET-STATUS (cons socket :output))) (RETURN))
                ; Send data             
                (WRITE-LINE "getObjects()" socket)
                ; You need to send something to dont block the conection
                ;(WRITE-LINE "wait()" socket)
                (force-output socket)

                ; Receive data
                (SETF input "")
                (IF (EQ :eof (SOCKET:SOCKET-STATUS (cons socket :input))) (RETURN))
                (SETF input (READ-LINE socket))
                ; Print data on the output
                (FORMAT T "~&Output: ~A~%~%" input)
                (FORCE-OUTPUT T)
                (INCF i)
                (RETURN)
        )
        ; Close the connection
        (socketClose socket)
        (FORMAT T "Connection closed~%")
        (FORCE-OUTPUT T)
    )
)
(setf k 0)
(loop
(print k)
(socketClient SERVER_IP SERVER_PORT)
(incf k)
)