/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Trader Support MDI Stop Check')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trader Support Module                               */
/*                                                                   */
/*       TSC8570 - Control COB MDI Startup                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 089491             Date 30JUN95              */
/*       Prev Amend No. 077466             Date 17OCT94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       089491 - To prevent TSC0550 Looping in COB create           */
/*                QUITJRN.TSM when deleting COBFIN.TSM.              */
/*       077466 - Split this processing into it's own component.     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
 
             DCL        VAR(&TSM) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000) */             /*077466*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*077466*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIB)
             CHGVAR     VAR(&TSM) VALUE('TSM' *CAT &LIB)
 
/* If MODE is CREATE */
             IF         COND(&MODE *EQ 'CREATE') THEN(DO)
             CPYDOC     FROMDOC(REFJRN.TSM) FROMFLR(&TSM) +
                          TODOC(COBFIN.TSM) TOFLR(&TSM)
             ENDDO
 
/* If MODE is DELETE */
             IF         COND(&MODE *EQ 'DELETE') THEN(DO)
             CPYDOC     FROMDOC(REFJRN.TSM) FROMFLR(&TSM) +
                          TODOC(QUITJRN.TSM) TOFLR(&TSM)              /*089491*/
             MONMSG     MSGID(CPF0000)                                /*089491*/
             CHKDLO     DLO(COBFIN.TSM) FLR(&TSM) OBJTYPE(*DOC)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(TSNODOC))
             DLTDLO     DLO(COBFIN.TSM) FLR(&TSM)
 TSNODOC:    ENDDO
 
             GOTO       CMDLBL(ENDPGM)                                /*077466*/
                                                                      /*077466*/
 ABNOR:                                                               /*077466*/
             CHGJOB     SWS(XXXXXX11)                                 /*077466*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*077466*/
                                                                      /*077466*/
             SNDPGMMSG  MSG('Program TSC8570 ended abnormally') +
                          TOMSGQ(MOPERQ)                              /*077466*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*077466*/
 ENDPGM:                                                              /*077466*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
