/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Check disabled status of LM branch')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2019 - Check disabled status of Loan Manager branch      */
/*                                                                   */
/*       Function: To return the status of a Loan Manager branch     */
/*                                                                   */
/*       Calls:    None.                                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Last Amend No. 203561 *CREATE     Date 21Jun02              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       203561 - Check whether a Loan Manager branch has been       */
/*                disabled                                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SERV &DISABLED)
 
             DCL        VAR(&SERV) TYPE(*CHAR) LEN(3)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LMDTAARA) TYPE(*CHAR) LEN(5) VALUE(' ')
             DCL        VAR(&DISABLED) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('LEC2019 - Check disabled status of +
                          branch') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
             RTVOBJD    OBJ(&DPLIB) OBJTYPE(*LIB) OWNER(&OWNER)
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT &SERV)
 
/* Create the Loan Manager Branch data area if it doesn't already exist */
 
             CHKOBJ     OBJ(&LMDTAARA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(&DPLIB/&LMDTAARA) TYPE(*CHAR) +
                             LEN(256) VALUE('    NNNN')
 
/* Correct the ownership of the dtaara */
 
                CHGOBJOWN  OBJ(&LMDTAARA) OBJTYPE(*DTAARA) +
                          NEWOWN(&OWNER)
             ENDDO
 
/* Check if LM Server Interface has been disabled */
 
             RTVDTAARA  DTAARA(&LMDTAARA (7 1)) RTNVAR(&DISABLED)
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
 ABNOR:
             SNDPGMMSG  MSG('LEC2019 - Check disabled status for Loan +
                          Manager branch HAS ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
