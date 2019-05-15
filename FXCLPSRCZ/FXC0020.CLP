/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FX Daily Deals File Update Control')            */
/*********************************************************************/
/*                                                                   */
/*  Midas - FX Dealer Module                                 */
/*                                                                   */
/*  FXC0020 - FX DAILY DEALS FILE UPDATE CONTROL                     */
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
/*       Prev Amend No. S01408             Date 20May96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   S01408 - Core hook FXC0020001 added.                            */
/*            Core hook FXC0020002 added.                            */
/*   This program written in connection with E19033 to replace       */
/*   direct call of FX0690 and allow easier identification of        */
/*   DB errors.                                                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                 /*S01408*/
/*/COPY WNCPYSRC,FXC0020001                                        /*S01408*/
/*                                                                 /*S01408*/
                SNDPGMMSG  MSG('FX DAILY DEALS FILE UPDATE') +
                           TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             CHGJOB     SWS(XXXXXX00)
             CALL       PGM(FX0690)
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDPGM))
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(SNDPGMMSG +
                          MSG('FX0690-Daily Deals File Update ended +
                          abnormally') TOMSGQ(MOPERQ) MSGTYPE(*INFO))
 
/*                                                                 /*S01408*/
/*/COPY WNCPYSRC,FXC0020002                                        /*S01408*/
/*                                                                 /*S01408*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
