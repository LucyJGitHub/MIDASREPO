/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC8140  - Depot Position Calculation Routine               */
/*                                                                   */
/*       Called By: SEC8100 - Position Calculation Routine           */
/*                                                                   */
/*       (c) Finastra International Limited 2020                     */
/*                                                                   */
/*       Last Amend No. HUT118A  *CREATE    Date 16Dec20             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT118A - Position Settlements Online Generation (CSE063)   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BRCD &SESN &BKCD &MARK &DEPOT &CUST +
                          &PTFR &BASIS &DATE &TYPE &REPO &UAUT +
                          &BALA &XBAL &PRIC &ERR)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SESN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BKCD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MARK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEPOT) TYPE(*CHAR) LEN(6)               /*HUT118A*/
             DCL        VAR(&DEPOTA) TYPE(*CHAR) LEN(6)
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
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(512)

/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNORM))

/*  Set job switches  */
             CHGJOB SWS(XXXXXX00)

/*  Override files to SHARE(*NO)  */
             OVRDBF     FILE(DPOSH) SHARE(*NO)
             OVRDBF     FILE(SEPCALL7) SHARE(*NO)
             OVRDBF     FILE(SEPCALL8) SHARE(*NO)
             OVRDBF     FILE(SEPCALL9) SHARE(*NO)
             OVRDBF     FILE(SEPCALJ0) SHARE(*YES)

/* If setttlement position required run open query file  */
             IF         COND(&BASIS *EQ 'S') THEN(DO)

/*  Set up query definiton selection criteria for JF/SEPCALJ0  */
               CHGVAR     VAR(&DEPOTA) VALUE(&DEPOT)
               CHGVAR     VAR(&QRYSLT) VALUE('DVSESN  *EQ' *BCAT '"' +
                          *CAT &SESN *BCAT '"' *BCAT '*AND DVBRCA +
                          *EQ' *BCAT '"' *CAT &BRCD *CAT '"' *BCAT +
                          '*AND DVOUDP *EQ' *BCAT &DEPOTA)

/*  Open query definition over LF/SEPCALJ0 */
               OPNQRYF    FILE((SEPCALJ0)) QRYSLT(&QRYSLT) +
                          KEYFLD((DRSEDE))

             ENDDO


/*  Call SE8140 to calculate Depot Position  */
             CALL       PGM(SE8140) PARM(&BRCD &SESN &BKCD &MARK +
                          &DEPOT &CUST &PTFR &BASIS &DATE &TYPE +
                          &REPO &UAUT &BALA &XBAL &PRIC &ERR)

/*  Close query definition over JF/SEPCALJ0 */
             CLOF       OPNID(SEPCALJ0)
             MONMSG     MSGID(CPF0000)

/*  Remove override */
             DLTOVR     FILE(DPOSH)
             DLTOVR     FILE(SEPCALL7)
             DLTOVR     FILE(SEPCALL8)
             DLTOVR     FILE(SEPCALL9)
             DLTOVR     FILE(SEPCALJ0)

/*  Return to calling program  */
             RETURN


 ABNORM:
             SNDPGMMSG  MSG('Program SEC8140 ended abnormally - see +
                          job log for detail') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)

 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
