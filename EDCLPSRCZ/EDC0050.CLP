/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Drip feed batch creator')                    */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas Export Data Module                           */
/*                                                                  */
/*       EDC0050 - Drip Feed Batch Creator                          */
/*                                                                  */
/*       Function : This program creates Drip Feed Batches.         */
/*                                                                  */
/*       Called by : EDC0040                                        */
/*                                                                  */
/*       Calls :  ED0060                                            */
/*                ED0080                                            */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9941            Date 14Dec05              */
/*       Prev Amend No. BUG7286            Date 23May05              */
/*                      228542             Date 05Aug04              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      113682             DATE 04FEB98              */
/*                      104404             DATE 05JUN96             */
/*                      101971             DATE 17JUL95             */
/*                      S01408             DATE 19JUN95             */
/*                      S01493 *CREATE     DATE 16MAY94             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       BUG9941 - Job ends if abnormally if no entries to process   */
/*       BUG7286 - Error in SCRTVJEVT command                        */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       113682 - Error messages should be sent to MOPERQ not       */
/*                QSYSOPR.                                          */
/*       104404 - Reorganisation of EDOLDJPD.                       */
/*       101971 - Phase II Modifications                            */
/*       S01408 - Addition of core hook EDC0050MP1                  */
/*       S01493 - Midas Export Data Module                          */
/*                                                                  */
/********************************************************************/
             PGM
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&EDDRIP) TYPE(*CHAR) LEN(43)
             DCL        VAR(&STRSNO) TYPE(*DEC) LEN(10)
             DCL        VAR(&PSEQNO) TYPE(*DEC) LEN(10)
             DCL        VAR(&BCHNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENDSNO) TYPE(*DEC) LEN(10)
             DCL        VAR(&ENDSNA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&BCHNO) TYPE(*CHAR) LEN(7)
             DCL        VAR(&BCHNON) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&PRW) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PEOF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CURJRNRCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STRRCV) TYPE(*CHAR) LEN(10)                                  /*CSC020*/
             DCL        VAR(&STRSEQ) TYPE(*DEC) LEN(10 0)                                /*BUG7286*/
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* Access the Drip Feed process data area */
 
START:
             RTVDTAARA  DTAARA(EDDRIP) RTNVAR(&EDDRIP)
             CHGVAR     VAR(&STRSNO) VALUE(%SST(&EDDRIP 1 10))
             CHGVAR     VAR(&BCHNO) VALUE(%SST(&EDDRIP 11 7))
 
/* Get the current journal receiver ID. */
 
             RTVJRNE    JRN(ICJRN) RTNRCV(&CURJRNRCV)
/*                                                                                          CSC020*/
/* Get the name of the first receiver for the current day.                                  CSC020*/
/* This is the equivalent of 'ICRCV001' in earlier releases of Midas.                       CSC020*/
/*                                                                                          CSC020*/
/**********  SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV)                           *CSC020**BUG7286*/
             SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV) SEQ(&STRSEQ)                     /*BUG7286*/
/*                                                                                          CSC020*/
/*  If no value returned, then set receiver to first available.                             CSC020*/
/*                                                                                          CSC020*/
             IF         COND(&STRRCV *EQ '          ') THEN(DO)                           /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNRCV(&STRRCV)                                                 /*CSC020*/
             ENDDO                                                                        /*CSC020*/
 
/* Get the journal sequence number of the most recent end of */
/* commitment cycle event (COMMIT or ROLLBACK).              */
/* If no entries found, exit the program                     */
 
/*********** RTVJRNE    JRN(ICJRN) RCVRNG(&CURJRNRCV ICRCV001) +
                          FROMENT(*LAST) TOENT(&STRSNO) +
                          SEARCH(*DESCEND) ENTTYP(CM RB) +
                          RTNSEQNBR(&ENDSNO)************************************************CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(&CURJRNRCV &STRRCV) +
                          FROMENT(*LAST) TOENT(&STRSNO) +
                          SEARCH(*DESCEND) ENTTYP(CM RB) +
                          RTNSEQNBR(&ENDSNO)                                              /*CSC020*/
 
             MONMSG     MSGID(CPF7073) EXEC(GOTO CMDLBL(ENDCLPGM))
 
/* If there are no new entries, the end sequence number will be     */                   /*BUG9941*/
/* less than the starting sequence number - so exit to avoid error. */                   /*BUG9941*/
             IF         COND(&STRSNO *GT &ENDSNO) THEN(GOTO +
                          CMDLBL(ENDCLPGM))                                              /*BUG9941*/
                                                                                         /*BUG9941*/
/* Get all entries between Start & End sequence number that are     */
/* of the right sort & out them into the file EDNEWJPD.  Note that  */
/* RB entries - rollbacks - are needed because some of the UP PT DL */
/* records will actually have been rolled-back.                     */
 
/**********  DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001 *CURRENT) +
                          FROMENT(&STRSNO) TOENT(&ENDSNO) +
                          JRNCDE(*ALL) ENTTYP(UP PT DL CM RB) +
                          OUTPUT(*OUTFILE) OUTFILE(EDNEWJPD) +
                          OUTMBR(*FIRST *REPLACE)*******************************************CSC020*/
             DSPJRN     JRN(ICJRN) RCVRNG(&STRRCV *CURRENT) +
                          FROMENT(&STRSNO) TOENT(&ENDSNO) +
                          JRNCDE(*ALL) ENTTYP(UP PT DL CM RB) +
                          OUTPUT(*OUTFILE) OUTFILE(EDNEWJPD) +
                          OUTMBR(*FIRST *REPLACE)                                         /*CSC020*/
 
/* Set up library name */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&PDPLIB) VALUE(&PREF *CAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,EDC0050MP1                                          */
                                                                      /*S01408*/
/* Set up batch name for these journal entries */
 
             CHGVAR     VAR(&PSEQNO) VALUE(&STRSNO)
NEXT:
             CHGVAR     VAR(&BCHNON) VALUE(&BCHNO)
             CHGVAR     VAR(&BCHNON) VALUE(&BCHNON + 1)
             CHGVAR     VAR(&BCHNO) VALUE(&BCHNON)
             CHGVAR     VAR(&BCHNAM) VALUE('EDD' *TCAT &BCHNO)
 
/* Create new member in PF/EDJRNEPD */
 
             RMVM       FILE(EDJRNEPD) MBR(&BCHNAM)
             MONMSG     MSGID(CPF7310)
 
             ADDPFM     FILE(EDJRNEPD) MBR(&BCHNAM)
 
             OVRDBF     FILE(EDJRNEPD) MBR(&BCHNAM)
 
/* Write all logical transactions (ie all complete commitment */
/* cycles) for all new journal entries                        */
 
             OVRDBF     FILE(EDOLDJPD) SHARE(*YES)                    /*101971*/
             OVRDBF     FILE(EDNEWJPD) SHARE(*YES)                    /*101971*/
 
             CALL       PGM(ED0060) PARM(&BCHNAM &PSEQNO &PDPLIB +
                          &PRW &PEOF)
 
             DLTOVR     FILE(EDJRNEPD)
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
               RMVM       FILE(EDJRNEPD) MBR(&BCHNAM)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If no error then commit the batch */
 
               COMMIT
 
/* If no records were written to the new batch member then delete it */
 
             IF         COND(&PRW *EQ 'N') THEN(RMVM FILE(EDJRNEPD) +
                          MBR(&BCHNAM))
 
/* If a batch was written then update number of next batch */
 
             IF         COND(&PRW *EQ 'Y') THEN(DO)
               CHGDTAARA  DTAARA(EDDRIP (11 7)) VALUE(&BCHNO)
             ENDDO
 
/* Save the journal sequence number from which to start looking for */
/* Commitment cycle endings.                                        */
 
             CHGVAR     VAR(&PSEQNO) VALUE(&PSEQNO + 1)
             CHGVAR     VAR(&ENDSNA) VALUE(&PSEQNO)
             CHGDTAARA  DTAARA(EDDRIP (1 10)) VALUE(&ENDSNA)
 
/* If more entries to process, delete any new batches processed by */
/* the remote machine & inform the remote m/c of the next batch to */
/* process, and then process the remaining entries.                */
 
             IF         COND(&PEOF *EQ ' ') THEN(DO)
               CALL       PGM(ED0080)
               IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                 ROLLBACK
                 GOTO       CMDLBL(ABNOR)
               ENDDO
 
               COMMIT
 
               GOTO       CMDLBL(NEXT)
             ENDDO
 
/* Copy the new journal entries into a store of old ones. This     */
/* allows data changes started but not yet commited to be accessed */
/* (by ED0060) once the commit has been done. (There will be rare).*/
/* (Only UPDATE AFTER / ADD RECORD / DELETE RECORD entries copied) */
 
/**********  RGZPFM     FILE(EDOLDJPD)                                /*104404*/          /*228542*/
/**********  MONMSG     MSGID(CPF0000)                                /*104404*/          /*228542*/
             CALL       PGM(SCC000060) PARM('EDOLDJPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
 
             CPYF       FROMFILE(EDNEWJPD) TOFILE(EDOLDJPD) +
                          MBROPT(*ADD) INCREL((*IF JOENTT *EQ 'UP') +
                          (*OR JOENTT *EQ 'PT') (*OR JOENTT *EQ +
                          'DL')) FMTOPT(*NONE)
 
             CLRPFM     FILE(EDNEWJPD)
 
             COMMIT
 
             GOTO       CMDLBL(ENDCLPGM)
 
ABNOR:
             ROLLBACK
 
/*113682*****SNDPGMMSG  MSG('EDC0050 Midas Export Data Drip Feed +
                          Batch Creator TERMINATED ABNORMALLY') +
                          TOMSGQ(*SYSOPR) MSGTYPE(*INQ)              /*113682*/
             SNDPGMMSG  MSG('EDC0050 Midas Export Data Drip Feed +
                          Batch Creator TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                       /*113682*/
             MONMSG     MSGID(CPF0000 MCH0000)
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
                DMPCLPGM
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
ENDCLPGM:
             DLTOVR     FILE(*ALL)                                    /*101971*/
             MONMSG     MSGID(CPF5809)                                /*101971*/
 
             ENDPGM
