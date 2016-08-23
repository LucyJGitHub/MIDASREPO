/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Check existence of output queue')            */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC0520 - SYNON EXCUSRPGM TO CHECK EXISTANCE OF OUTPUT QUEUE */
    /*                                                               */
/*       (c) Misys International Banking Systems Ltd. 2001           */
    /*                                                               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*       LAST AMEND.NO.LN1235            DATE 12APR91            */
    /*       PREV AMEND.NO.                  DATE 00/00/00           */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*  LN1235 - ADD MONMSG TO PREVENT ABNORMAL TERMINATION OF PGM   */
    /*           WHEN OUTQ BEGINS WITH A NUMBER                      */
    /*                                                               */
    /*****************************************************************/
             PGM        PARM(&OUTQ &RTN)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             CHGVAR     VAR(&RTN) VALUE('       ')
             CHKOBJ     OBJ(&OUTQ) OBJTYPE(*OUTQ)
/*                                                                      LN1235*/
/*********** MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&RTN) + *******  LN1235*/
/***********              VALUE('Y2U0005')) **************************  LN1235*/
             MONMSG     MSGID(CPF9801 CPF0001) EXEC(CHGVAR VAR(&RTN) +
                          VALUE('Y2U0005'))                           /*LN1235*/
/*                                                                      LN1235*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
