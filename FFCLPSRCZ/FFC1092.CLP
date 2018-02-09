/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Reorganize Files after recovery')            */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1092  -  REORGANIZE FILES AFTER EOC RECOVERY                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG7286            Date 23May05              */
/*                      228542             Date 05Aug04              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CHANGE DESCRIPTIONS                                           */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG7286 - Error in SCRTVJEVT command                        */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
             PGM        PARM(&MKT &TOPNT &XREC)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        &MKT    TYPE(*CHAR)  LEN(2)
             DCL        &TOPNT  TYPE(*CHAR)  LEN(10)
/************DCL        &XREC   TYPE(*CHAR)  LEN(3)*****************************************CSC020*/
             DCL        &XREC   TYPE(*CHAR)  LEN(8)                                       /*CSC020*/
/************DCL        &ENDRC  TYPE(*CHAR)  LEN(8)*****************************************CSC020*/
             DCL        &ENDRC  TYPE(*CHAR)  LEN(10)                                      /*CSC020*/
             DCL        &MKTCH  TYPE(*CHAR)  LEN(10)
             DCL        &BLNK8  TYPE(*CHAR)  LEN(8)
             DCL        &START  TYPE(*CHAR)  LEN(10)
/**/
             DCLF       FILE(JRNEFD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        &STRRCV  TYPE(*CHAR)  LEN(10)                                     /*CSC020*/
             DCL        VAR(&STRSEQ) TYPE(*DEC) LEN(10 0)                                /*BUG7286*/
             DCL        VAR(&CHKPOSN) TYPE(*DEC) LEN(2 0) VALUE(10)                       /*228542*/
             DCL        VAR(&LAST) TYPE(*CHAR) LEN(1)                                     /*228542*/
             DCL        VAR(&MRKTCHK) TYPE(*CHAR) LEN(10)                                 /*228542*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/*                                                                                          CSC020*/
/*  Determine journal receiver of next day set up.                                          CSC020*/
/*  (Equivalent to ICRCV001 in previous releases)                                           CSC020*/
/*                                                                                          CSC020*/
/************SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV)                          *CSC020***BUG7286*/
             SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV) SEQ(&STRSEQ)                     /*BUG7286*/
/*                                                                                          CSC020*/
/*  If no value returned, then set receiver to first available.                             CSC020*/
/*                                                                                          CSC020*/
             IF         COND(&STRRCV *EQ '          ') THEN(DO)                           /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNRCV(&STRRCV)                                                 /*CSC020*/
             ENDDO                                                                        /*CSC020*/
             CHGVAR     VAR(&MKTCH) VALUE(&MKT *CAT &BLNK8)
/**/
             OVRDBF     FILE(JRNEFD) MBR(&MKT)
/**/
/**/
/* OUTPUT RELEVANT JOURNAL ENTRIES TO FILE JRNEFD, MEMBER &MKT       */
/* EXTRA CHECK REQUIRED TO REORGANIZE PFM IF CHANGES REMOVED         */
/**/
             CLRPFM     JRNEFD MBR(&MKT)
/**/
/************CHGVAR     VAR(&ENDRC) VALUE('ICRCV' *CAT &XREC)*******************************CSC020*/
             CHGVAR     VAR(&ENDRC) VALUE('IR' *CAT &XREC)                                /*CSC020*/
/**/
/*DSPJRN   JRN(*LIBL/ICJRN) RCVRNG(*LIBL/ICRCV001 *LIBL/&ENDRC) +
             FROMENT(&TOPNT) ENTTYP(RC) OUTPUT(*OUTFILE) +
             OUTFILE(*LIBL/JRNEFD) OUTMBR(&MKT)*********************************************CSC020*/
DSPJRN     JRN(*LIBL/ICJRN) RCVRNG(*LIBL/&STRRCV *LIBL/&ENDRC) +
             FROMENT(&TOPNT) ENTTYP(RC) OUTPUT(*OUTFILE) +
             OUTFILE(*LIBL/JRNEFD) OUTMBR(&MKT)                                           /*CSC020*/
             MONMSG     MSGID(CPF7062)
/**/
FILE:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO END)
                                                                                          /*228542*/
/* Pad variable with blanks */                                                            /*228542*/
                                                                                          /*228542*/
             CHGVAR     VAR(&MRKTCHK) VALUE(&MKT)                                         /*228542*/
                                                                                          /*228542*/
 BLANKCHK:                                                                                /*228542*/
             CHGVAR     VAR(&LAST) VALUE(%SST(&MRKTCHK &CHKPOSN 1))                       /*228542*/
                                                                                          /*228542*/
             IF         COND(&LAST *EQ ' ') THEN(DO)                                      /*228542*/
                CHGVAR     VAR(%SST(&MRKTCHK &CHKPOSN 1)) +
                             VALUE('*')                                                   /*228542*/
                CHGVAR     VAR(&CHKPOSN) VALUE(&CHKPOSN - 1)                              /*228542*/
                GOTO       CMDLBL(BLANKCHK)                                               /*228542*/
             ENDDO                                                                        /*228542*/
                                                                                          /*228542*/
/**/
/* IF FROM POINT ON JOURNAL ENTRIES IS NON-ZERO,               */
/* AND IF FILE IS FOR SAME MARKET AS IS BEING PROCESSED,       */
/* REORGANIZE PHYSICAL FILE TO REMOVE DELETED RECORDS.         */
/**/
             CHGVAR     VAR(&START) VALUE(%SST(&INFO 1 10))
             IF     COND((&START *NE *ZEROS) *AND (&MKTCH *EQ +
                    &JOMBR) *AND (&JOOBJ *NE 'MKCMPD    ')) THEN(DO)
/**********         RGZPFM     FILE(&JOOBJ) MBR(&MKT)                                     /*228542*/
/**********         MONMSG     MSGID(CPF2981 CPF2995)                                     /*228542*/
                    CALL       PGM(SCC000060) PARM(&JOOBJ &MRKTCHK)                       /*228542*/
                    IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                               CMDLBL(ABNOR))                                             /*228542*/
             ENDDO
/**/
             GOTO FILE
/**/
ABNOR:       CHGJOB    SWS(XXXXXX1X)
/**/
END:         CLRPFM     JRNEFD MBR(&MKT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(JRNEFD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
