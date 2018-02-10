/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MA Order optical disk headers')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Microfiche/Optical Disk Archiving Module    */
/*                                                                   */
/*       MAC0652  - ORDER OPTICAL DISK HEADERS                       */
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
/*       Prev Amend No. 108447             Date 29Jan98              */
/*                      056401             Date 27Jan94              */
/*                      S01382             DATE 05AUG92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       108447 - Check that MAOPTFPD is available before calling    */
/*                MA0652.                                            */
/*       056401 - Remove the checking of existence of PF/MAOPTFPD    */
/*                in QTEMP, and the creation of that file in QTEMP,  */
/*                since MAOPTFPD will be created in the DP library.  */
/*       S01382 - OPTICAL DISK DEVELOPMENT                           */
/*              - NEW PROGRAM CREATED FOR SAR                        */
/*              - ORDERS OPTICAL DISK HEADER RECORDS IN ARCHIVE ID   */
/*                ORDER AND ALPHABETICALLY BY REPORT                 */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* DECLARE OUTFILE FOR DSPFD *MBRLIST */
 
             DCLF       FILE(QSYS/QAFDMBRL)
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* OBTAIN MEMBER LIST OF MAOPTDPD. THIS IS A LIST OF ARCHIVE IDS */
 
             DSPFD      FILE(MAOPTDPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/OPTICMBR)
 
/* REDIRECT TO USE FILE IN QTEMP */
 
             OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/OPTICMBR)
 
/* READ MEMBER LIST (IE ARCHIVE IDS) UNTIL EOF */
 
 LOOP1:
             RCVF
 
/* EXIT IF NO MORE MEMBERS */
 
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ELOOP1))
 
/* READ NEXT MEMBER IF CURRENT MEMBER HAS NO RECORDS */
 
             IF         COND(&MLNRCD *EQ 0) THEN(GOTO CMDLBL(LOOP1))
 
/* CREATE HEADERS FILE FOR OPTICAL DISK SELECTING '*$*$' ON MAOPTDPD +
   (SELECTING ON '$' WILL BE SUFFICIENT */
 
             CPYF       FROMFILE(MAOPTDPD) TOFILE(MAOPTEPD) +
                          FROMMBR(&MLNAME) MBROPT(*REPLACE) +
                          INCCHAR(*RCD 3 *EQ '$') FMTOPT(*MAP *DROP)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
/**CREATE*A*TEMPORARY*FILE*TO*ORDER*REPORTS*BY*ARCHIVE*ID*+********/  /*056401*/
/**(CHECK*IF*FILE*EXISTS*BEFORE*CREATING IT)***********************/  /*056401*/
 
/************CHKOBJ     OBJ(QTEMP/MAOPTFPD) OBJTYPE(*FILE)        */  /*056401*/
/************MONMSG     MSGID(CPF9801) EXEC(DO)                   */  /*056401*/
/************CPYF       FROMFILE(MAOPTDPD) TOFILE(QTEMP/MAOPTFPD)+*/  /*056401*/
/************             MBROPT(*NONE) CRTFILE(*YES)             */  /*056401*/
/************CLRPFM     FILE(MAOPTFPD)                            */  /*056401*/
/************ENDDO                                                */  /*056401*/
 
/* Make sure that MAOPTFPD is not in use before calling MA0652   */   /*108447*/
 ALCOBJ:     ALCOBJ     OBJ((MAOPTFPD *FILE *EXCL)) WAIT(20)          /*108447*/
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(DO)               /*108447*/
             GOTO       CMDLBL(ALCOBJ)                                /*108447*/
             ENDDO                                                    /*108447*/
/* WRITE THE ARCHIVE ID AS 'BREAK' RECORD TO TEMPORARY FILE */
 
             CALL       PGM(MA0652) PARM('MAOPTFPD' &MLNAME)
 
/* COPY REPORTS IN REPORT SEQUENCE TO THE TEMPORARY FILE AFTER THE +
   'BREAK' RECORD */
 
             CPYF       FROMFILE(MAOPTEL0) TOFILE(MAOPTFPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
             GOTO       CMDLBL(LOOP1)
 
 ELOOP1:
 
             DLCOBJ     OBJ((MAOPTFPD *FILE *EXCL))                   /*108447*/
 
 /* PROCESS ARCHIVE AUDIT REPORT IN ARCHIVE SEQUENCE AND REPORT +
    SEQUENCE */
             CALL       PGM(MA0630)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(THEEND)
 
/* ABNORMAL TERMINATION */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
             SNDMSG     MSG('Archiving Audit Report Processing ended +
                          abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
 THEEND:     CLRPFM     FILE(MAOPTEPD)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
             CLRPFM     FILE(MAOPTFPD)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
             ENDPGM
