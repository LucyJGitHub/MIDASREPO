/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC8120  - User Depot Position Calculation                  */
/*                                                                   */
/*       CALLED BY: SEC8100 - Position Calculation Routine           */
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
             DCL        VAR(&DEPOT) TYPE(*CHAR) LEN(6)              /*HUT118A*/
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(6)               /*HUT118A*/
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

/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNORM))

/*  Set job switches  */
             CHGJOB SWS(XXXXXX00)

/*  Override files to SHARE(*NO)  */
             OVRDBF     FILE(UDEPL1) SHARE(*NO)
             OVRDBF     FILE(SEPCALL5) SHARE(*NO)
             OVRDBF     FILE(SEPCALL6) SHARE(*NO)

/*  Call SE8120 to calculate User Depot Position  */
             CALL       PGM(SE8120) PARM(&BRCD &SESN &BKCD &MARK +
                          &DEPOT &CUST &PTFR &BASIS &DATE &TYPE +
                          &REPO &UAUT &BALA &XBAL &PRIC &ERR)

/*  Remove override */
             DLTOVR     FILE(UDEPL1)
             DLTOVR     FILE(SEPCALL5)
             DLTOVR     FILE(SEPCALL6)

/*  Return to calling program  */
             RETURN


 ABNORM:
             SNDPGMMSG  MSG('Program SEC8120 ended abnormally - see +
                          job log for detail') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)

 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra Ltd.')
             ENDPGM
