/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Retrieve download job batch delay period')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2000 - Retrieve download job batch delay period          */
/*                                                                   */
/*       Function: To return the delay period Loan Manager branch    */
/*                                                                   */
/*       Calls:    None.                                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 223603 *CREATE     Date 21Jun02              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       223603 - Check whether a Loan Manager branch has been       */
/*                disabled                                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SERV &SETDLY &RTNCDE)
 
             DCL        VAR(&SERV) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SETDLY) TYPE(*CHAR) LEN(14)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LMDTAARA) TYPE(*CHAR) LEN(5) VALUE(' ')
             DCL        VAR(&DLYPERIOD) TYPE(*CHAR) LEN(2) VALUE('10')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('LEC2000 - Determine message batch delay period for download') +
                          TOMSGQ(MRUNQ)
 
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
             RTVOBJD    OBJ(&DPLIB) OBJTYPE(*LIB) OWNER(&OWNER)
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT &SERV)
 
/* Create the Loan Manager Branch data area if it doesn't already exist */
 
             CHKOBJ     OBJ(&LMDTAARA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(&DPLIB/&LMDTAARA) TYPE(*CHAR) +
                             LEN(256) VALUE('    NNNN10')
 
/* Correct the ownership of the dtaara */
 
                CHGOBJOWN  OBJ(&LMDTAARA) OBJTYPE(*DTAARA) +
                          NEWOWN(&OWNER)
             ENDDO
 
/* Check if LM Server Interface has been disabled */
 
             RTVDTAARA  DTAARA(&LMDTAARA (9 2)) RTNVAR(&DLYPERIOD)
 
             IF         COND(&DLYPERIOD *EQ '  ') THEN(DO)
                CHGVAR     VAR(&DLYPERIOD) VALUE('01')
                CHGDTAARA  DTAARA(&LMDTAARA (9 2)) VALUE(&DLYPERIOD)
             ENDDO
 
             CHGVAR     VAR(&SETDLY) VALUE('DLYJOB DLY(' *CAT +
                          &DLYPERIOD *CAT ')')
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
 ABNOR:
             SNDPGMMSG  MSG('LEC2000 - Retrieve message batch delay period +
                          for download HAS ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&RTNCDE) VALUE('FAILED')
             MONMSG     MSGID(CPF0000 MCH0000)
 END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
