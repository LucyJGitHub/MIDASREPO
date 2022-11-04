/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC8110  - Customer Depot Position Calculation              */
/*                                                                   */
/*       Called By: SEC8100 - Position Calculation Routine           */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. HUT118A  *CREATE    Date 03Nov22             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT118A - Position Settlements Online Generation (CSE063)   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BRCD &SESN &BKCD &MARK &DEPOT &CUST +
                          &PTFR &BASIS &DATE &TYPE &REPO &UAUT +
                          &BALA &XBAL &PRIC &ERR)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra Ltd. +
                          2022')
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SESN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BKCD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MARK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEPOT) TYPE(*CHAR) LEN(6)               /*HUT118A*/
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(6)                /*HUT118A*/
             DCL        VAR(&CUSTA) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PTFR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BASIS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATE) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REPO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&UAUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BALA) TYPE(*DEC) LEN(15 0)
             DCL        VAR(&XBAL) TYPE(*DEC) LEN(15 0)
             DCL        VAR(&PRIC) TYPE(*DEC) LEN(15 8)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEPOTA) TYPE(*CHAR) LEN(6)
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(512)

/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNORM))

/*  Set job switches  */
             CHGJOB SWS(XXXXXX00)

/*  Override files to SHARE(*NO)  */
             OVRDBF     FILE(CDEPD) SHARE(*NO)
             OVRDBF     FILE(SEPCALL0) SHARE(*NO)
             OVRDBF     FILE(SEPCALL1) SHARE(*NO)
             OVRDBF     FILE(SEPCALL3) SHARE(*NO)
             OVRDBF     FILE(SEPCALL4) SHARE(*NO)
             OVRDBF     FILE(SETLEL0) SHARE(*NO)
             OVRDBF     FILE(SEPCALJ0) SHARE(*YES)

/* If setttlement position required run open query file  */
             IF         COND(&BASIS *EQ 'S') THEN(DO)

/*  Set up query definiton selection criteria for JF/SEPCALJ0  */
               CHGVAR     VAR(&CUSTA) VALUE(&CUST)
               CHGVAR     VAR(&QRYSLT) VALUE('DVSESN  *EQ' *BCAT '"' +
                          *CAT &SESN *BCAT '"' *BCAT '*AND DVBRCA +
                          *EQ' *BCAT '"' *CAT &BRCD *CAT '"' *BCAT +
                          '*AND DVCNUM *EQ' *BCAT &CUSTA)

/*  Open query definition over LF/SEPCALJ0 */
               OPNQRYF    FILE((SEPCALJ0)) QRYSLT(&QRYSLT) +
                          KEYFLD((DRSEDE))

             ENDDO


/*  Call SE8110 to calculate Customer Depot Position  */
             CALL       PGM(SE8110) PARM(&BRCD &SESN &BKCD &MARK +
                          &DEPOT &CUST &PTFR &BASIS &DATE &TYPE +
                          &REPO &UAUT &BALA &XBAL &PRIC &ERR)

/*  Close query definition over JF/SEPCALJ0 */
             CLOF       OPNID(SEPCALJ0)
             MONMSG     MSGID(CPF0000)

/*  Remove override */
             DLTOVR     FILE(CDEPD)
             DLTOVR     FILE(SEPCALL0)
             DLTOVR     FILE(SEPCALL1)
             DLTOVR     FILE(SEPCALL3)
             DLTOVR     FILE(SEPCALL4)
             DLTOVR     FILE(SEPCALJ0)
             DLTOVR     FILE(SETLEL0)

/*  Return to calling program  */
             RETURN


 ABNORM:
             SNDPGMMSG  MSG('Program SEC8110 ended abnormally - see +
                          job log for detail') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)

 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra Ltd.')
             ENDPGM
