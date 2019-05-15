/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MA Set-up mbr overrides for header')            */
/*********************************************************************/
/*                                                                   */
/*  Midas - Optical Disk Archiving Module                    */
/*                                                                   */
/*  MAC0660 - Set up member overrides for header copy.               */
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
/*       Prev Amend No. S01382             Date 23Jul92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  S01382 - OPTICAL DISK REPORTING                                  */
/*           NEW PROGRAM CREATED FOR SAR                             */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&IFILE &IMEMBER &IHSTRING)
 
             DCL        VAR(&IFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&IMEMBER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&IHSTRING) TYPE(*CHAR) LEN(198)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* Override to file member */
 
             OVRDBF     FILE(&IFILE) MBR(&IMEMBER)
 
/* Call program to write header records to archive file */
 
             CALL       PGM(MA0660) PARM(&IFILE &IHSTRING)
 
             DLTOVR     FILE(&IFILE)
 
             GOTO       CMDLBL(END)
 
/* Abnormal processing */
 
 ABNOR:      SNDMSG     MSG('MAC0660 - Set up member overrides for +
                          header copy ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
 END:        ENDPGM
