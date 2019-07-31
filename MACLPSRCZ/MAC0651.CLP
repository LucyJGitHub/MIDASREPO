/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MA Archive to optical disk')                    */
/*********************************************************************/
/*                                                                   */
/*  Midas - Microfiche/Optical Disk Archiving Module         */
/*                                                                   */
/*  MAC0651  - ARCHIVE TO OPTICAL DISK CONTROL                       */
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
/*       Prev Amend No. S01382             Date 30Jul92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  S01382 - OPTICAL DISK DEVELOPMENT                                */
/*           NEW PROGRAM CREATED FOR SAR                             */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MACHK) TYPE(*CHAR) LEN(1)
 
/* DECLARE OUTFILE FOR DSPFD *MBRLIST */
 
             DCLF       FILE(QSYS/QAFDMBRL)
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,MAC0651001                                          */
 
/* OBTAIN MEMBER LIST OF MAOPTDPD */
 
             DSPFD      FILE(MAOPTDPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/OPTICMBR)
 
/* REDIRECT TO USE FILE IN QTEMP */
 
             OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/OPTICMBR)
 
/* READ MEMBER LIST UNTIL EOF */
 
 LOOP1:
             RCVF
 
/* EXIT IF NO MORE MEMBERS */
 
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ELOOP1))
 
/* READ NEXT MEMBER IF CURRENT MEMBER HAS NO RECORDS */
 
             IF         COND(&MLNRCD *EQ 0) THEN(GOTO CMDLBL(LOOP1))
/*/COPY WNCPYSRC,MAC0651002                                          */
 
/* CREATE PC DOCUMENTS FOR OPTICAL DISK - USING MEMBER NAME AND +
   MEMBER TEXT */
 
             CALL       PGM(MAC0120) PARM(&MLNAME &MLMTXT)
/*/COPY WNCPYSRC,MAC0651003                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
             GOTO       CMDLBL(LOOP1)
 
 ELOOP1:
 
/* UPDATE DTAARA/MACHK */
 
             RTVDTAARA  DTAARA(MACHK) RTNVAR(&MACHK)
             IF         COND(&MACHK *EQ 'M') THEN(DO)
             CHGDTAARA  DTAARA(MACHK) VALUE('C')
             ENDDO
             ELSE       CMD(DO)
             CHGDTAARA  DTAARA(MACHK) VALUE('O')
             ENDDO
 
/* CREATE READY.GO TO SIGNAL PC DOWNLOAD TO COMMENCE */
 
             CALL       PGM(MAC0130)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(THEEND)
 
/* ABNORMAL TERMINATION */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
             SNDMSG     MSG('Archive to optical disk control ended +
                          abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
 THEEND:     ENDPGM
