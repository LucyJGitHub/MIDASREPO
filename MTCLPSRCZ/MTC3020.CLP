/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Control testkey interface installation')     */
/********************************************************************/
/*                                                                  */
/*        Midas     Midas TELX MODULE                               */
/*                                                                  */
/*        MTC3020 - CONTROL TESTKEY INTERFACE INSTALLATION          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 000000  *CREATE    Date 00Xxx00              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       000000 -                                                   */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&DEVD &IND)
 
             DCL        VAR(&DEVD) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&IND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*           CHKOBJ     OBJ(&DEVD.QSYS) OBJTYPE(*DEVD)        S01179*/
             CHKOBJ     OBJ(QSYS/&DEVD) OBJTYPE(*DEVD)      /*S01179*/
 
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&IND) VALUE(1))
 
             GOTO       CMDLBL(END)
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('Control Testkey Interface Installation +
                          ended abnormally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
