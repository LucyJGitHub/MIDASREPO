/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Save previous days SE book posn headers')    */
/********************************************************************/
/*                                                                  */
/*       Midas - Export Data Interface Module                       */
/*                                                                  */
/*       EDC0551 -  Save previous days SE Book Position Headers     */
/*                                                                  */
/*       Function : This program is called during the Close of      */
/*                  Business processing via the Components and      */
/*                  Dependencies files. It is called immediately    */
/*                  after EDC0550.                                  */
/*                  The program takes a copy of the SE Book         */
/*                  Positions for use the following day.            */
/*                                                                  */
/*       Called By: CBC0050  Midas Close of Business component      */
/*                                                                  */
/*       Calls :    *None                                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. CED006 *CREATE     DATE 18AUG97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       CED006 - Midas ED Enhancements                             */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Copyright statement definition */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
 
/* Global error monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
             CLRPFM     FILE(EDPSBHPD)
 
/* Save copy of SE Book position headers for comparison */
/* during next COB */
             CPYF       FROMFILE(EDCSBHPD) TOFILE(EDPSBHPD) +
                          MBROPT(*ADD)
 
/* Normal termination */
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ENDCLPGM))
 
 
/* Abnormal termination */
ABNOR:
 
             SNDPGMMSG  MSG('EDC0551 - Save previous days SE Book +
                          Position Headers TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
