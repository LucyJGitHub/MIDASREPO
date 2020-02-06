/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Trader Support MDI Stop Check')                 */
/*********************************************************************/
/*                                                                   */
/*     Midas - TRADER SUPPORT MODULE                         */
/*                                                                   */
/*     TSC8560 -  REAL TIME MDI CHECK TO STOP GETTING JOURNAL ENTRIES*/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     PREV AMEND NO. C1734             DATE 20MAY93                 */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       C1734 - Change folder name from TSM to TSMxx where xx is    */
/*               Midas system prefix                                 */
/*********************************************************************/
             PGM        PARM(&RETURN)
 
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TSM) TYPE(*CHAR) LEN(5)        /* C1734 */
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(2)        /* C1734 */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                     /* C1734 */
/********************************************************************** C1734 */
 
/* Global monitor messages */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) +
                          EXEC(GOTO ERROR)
 
/* Set up the TSM folder */                                 /* C1734 */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIB)   /* C1734 */
             CHGVAR     VAR(&TSM) VALUE('TSM' *CAT &LIB)    /* C1734 */
 
/************CHKDLO*****DLO(STOPJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******** C1734 */
             CHKDLO     DLO(STOPJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(CHKQUITJRN))
             CHGVAR     VAR(&RETURN) VALUE('E')
             GOTO       CMDLBL(END)
 
/*CHKQUITJRN:*CHKDLO*****DLO(QUITJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******* C1734 */
 CHKQUITJRN: CHKDLO     DLO(QUITJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
             CHGVAR     VAR(&RETURN) VALUE('Q')
             GOTO       CMDLBL(END)
 
/* Global error handling */
/*ERROR:******CPYDOC*****FROMDOC(REFJRN.TSM)*FROMFLR(TSM)*+************ C1734 */
/*************************TODOC(QUITJRN.TSM)*TOFLR(TSM)**************** C1734 */
 ERROR:      CPYDOC     FROMDOC(REFJRN.TSM) FROMFLR(&TSM) +
                          TODOC(QUITJRN.TSM) TOFLR(&TSM)             /* C1734 */
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
