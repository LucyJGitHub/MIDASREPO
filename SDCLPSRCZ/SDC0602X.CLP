/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Clear TABLETX Audit Control')                   */
/*********************************************************************/
/*                                                                   */
/*  Midas Standing Data Module                               */
/*                                                                   */
/*  SDC0602X - RESET OLD AUDIT CONTROL TABLETX                       */
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
/*       Prev Amend No. E22137             Date 18/05/90             */
/*                      00                 Date 00/00/00             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  E22137 - RPG PROGRAM TABLEX HAS BEEN RENAMED TO SD2430.          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL          VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             RTVJOBA      JOB(&JOB)
/**/
/************CALL**********PGM(TABLETX) ***********************E22137*/
             CALL          PGM(SD2430)                       /*E22137*/
/**/
             IF            COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG     MSG('JOB TERMINATED - DATABASE IN +
                              ERROR') TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                SNDPGMMSG     MSG('JOB TERMINATED - DATABASE IN +
                              ERROR') TOMSGQ(&JOB) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
          ENDPGM
