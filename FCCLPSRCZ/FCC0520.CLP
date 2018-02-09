/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Check existence of output queue')            */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC0520 - SYNON EXCUSRPGM TO CHECK EXISTANCE OF OUTPUT QUEUE */
    /*                                                               */
/*       (c) Finastra International Limited 2001                     */
    /*                                                               */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. LN1235             Date 12Apr91              */
/*                                         Date 00/00/00             */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
/*       MD046248 - Finastra Rebranding                              */
    /*  LN1235 - ADD MONMSG TO PREVENT ABNORMAL TERMINATION OF PGM   */
    /*           WHEN OUTQ BEGINS WITH A NUMBER                      */
    /*                                                               */
    /*****************************************************************/
             PGM        PARM(&OUTQ &RTN)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
                          Finastra International Limited')
 
             ENDPGM
