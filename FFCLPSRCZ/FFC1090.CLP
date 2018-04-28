/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Recover EOC Cmpnt OR Reopen Markt')          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1090  -  RECOVERY OF EOC COMPONENT OR REOPEN OF MARKET       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9619            Date 01Feb06              */
/*       Prev Amend No. BUG7286            Date 23May05              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  126493             DATE 18DEC97                  */
/*                  CED005             DATE 12AUG97                  */
/*                  S01117             DATE 21JUN90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       BUG7286 - Error in SCRTVJEVT command                        */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*   126493 - EOC crashed with duplicate records in CGFFCFL0,        */
/*            because previous reopen had failed trying to clear     */
/*            FFMMFD MBR(DT), which didn't exist. Add member if it   */
/*            doesn't exist.                                         */
/*   CED005 - Trade MIS and Cashflow                                 */
/*   S01117 - MULTIBRANCHING                                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MKT &FORN)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        &MKT    TYPE(*CHAR)  LEN(2)
             DCL        &ACT    TYPE(*CHAR)  LEN(1)
             DCL        &MSG    TYPE(*CHAR)  LEN(70)
/*********** DCL        &MEM1   TYPE(*CHAR)  LEN(44)               */ /*S01117*/
             DCL        &MEM1   TYPE(*CHAR)  LEN(50)                  /*S01117*/
             DCL        &FORN   TYPE(*CHAR)  LEN(1)
             DCL        &TOPNA  TYPE(*CHAR)  LEN(10)
/************DCL        &LRECS  TYPE(*DEC)   LEN(3)*****************************************CSC020*/
             DCL        &LRECS  TYPE(*DEC)   LEN(8)                                       /*CSC020*/
/************DCL        &NRECS  TYPE(*DEC)   LEN(3)*****************************************CSC020*/
             DCL        &NRECS  TYPE(*DEC)   LEN(8)                                       /*CSC020*/
/************DCL        &CRECS  TYPE(*CHAR)  LEN(3)   VALUE('001')**************************CSC020*/
             DCL        &CRECS  TYPE(*CHAR)  LEN(8)   VALUE('00000001')                   /*CSC020*/
/************DCL        &XREC   TYPE(*CHAR)  LEN(3)*****************************************CSC020*/
             DCL        &XREC   TYPE(*CHAR)  LEN(8)                                       /*CSC020*/
/************DCL        &RECSAV TYPE(*CHAR)  LEN(8)*****************************************CSC020*/
             DCL        &RECSAV TYPE(*CHAR)  LEN(10)                                      /*CSC020*/
             DCL        &FAIL   TYPE(*CHAR)  LEN(1)   VALUE(' ')
             DCL        &ESD    TYPE(*CHAR)  LEN(12)
             DCL        &JNSTAT TYPE(*CHAR)  LEN(200)
             DCL        VAR(&ED_RTCD) TYPE(*CHAR) LEN(7)              /*CED005*/
             DCL        VAR(&ED_FMT)  TYPE(*CHAR) LEN(200)            /*CED005*/
             DCLF       RSTRDF
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        &STRRCV  TYPE(*CHAR)  LEN(10)                                     /*CSC020*/
             DCL        VAR(&STRSEQ) TYPE(*DEC) LEN(10 0)                                /*BUG7286*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
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
             CHGVAR     VAR(&CRECS) VALUE(%SST(&STRRCV 3 8))                              /*CSC020*/
/**/
/* READ IN JNSTAT FOR DETAILS OF RECEIVER SAVES                      */
/**/
             RTVDTAARA  DTAARA(JNSTAT *ALL) RTNVAR(&JNSTAT)
/**/
/* SETUP LAST RECEIVER SAVED                                         */
/**/
/************CHGVAR     VAR(&LRECS) VALUE(%SST(&JNSTAT 16 3))*******************************CSC020*/
/************CHGVAR     VAR(&XREC) VALUE(%SST(&JNSTAT 6 3))*********************************CSC020*/
             CHGVAR     VAR(&LRECS) VALUE(%SST(&JNSTAT 13 8))                             /*CSC020*/
             CHGVAR     VAR(&XREC) VALUE(%SST(&JNSTAT 3 8))                               /*CSC020*/
             CHGVAR     VAR(&LRECS) VALUE(&LRECS - 1)
/**/
/* CHECK THAT JRN RECEIVERS UP UNTIL LAST RECEIVER SAVED ARE PRESENT */
/* IF NOT SEND MESSAGE AND END PROGRAM                               */
/**/
/*CHECK:******CHGVAR*****VAR(&RECSAV) VALUE('ICRCV' *CAT &CRECS)****************************CSC020*/
 CHECK:      CHGVAR     VAR(&RECSAV) VALUE('IR' *CAT &CRECS)                              /*CSC020*/
             CHKOBJ     OBJ(&RECSAV) OBJTYPE(*JRNRCV)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CALL       FF0472 PARM('F' &MKT)
                SNDPGMMSG  MSG('Recovery cannot be run as journal +
                               receivers are missing. Run option to +
                               restore all journal receivers then retry'   ) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGJOB    SWS(XXXXXX1X)
                GOTO       FINISH
             ENDDO
/**/
/* ADD 1 TO SEQUENCE NUMBER TO GET NEXT RECEIVER TO CHECK. IF NEXT   */
/* RECEIVER IS PRIOR TO LAST RECEIVER TO BE SAVED, CHECK IT.         */
/**/
             CHGVAR     VAR(&NRECS) VALUE(&CRECS)
             IF         COND(&NRECS *LT &LRECS) THEN(DO)
                CHGVAR     VAR(&NRECS) VALUE(&NRECS + 1)
                CHGVAR     VAR(&CRECS) VALUE(&NRECS)
                GOTO       CMDLBL(CHECK)
             ENDDO
/**/
/* SEND JOURNAL ENTRY TYPE 'IE' TO JOURNAL */
/**/
             CHGVAR     VAR(&ESD) VALUE('          ' *CAT &MKT)
/**********  SNDJRNE    JRN(ICJRN) TYPE('IE') ENTDTA(&ESD) */                            /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('IE') ENTDTA(&ESD) +
                          FORCE(*YES)                                                    /*BUG9619*/
/**/
/* OUTPUT RELEVANT JOURNAL ENTRIES TO FILE JRNEFD, MEMBER &MKT       */
/**/
             CLRPFM     JRNEFD MBR(&MKT)
/*PJRN*****JRN(*LIBL/ICJRN) RCVRNG(*LIBL/ICRCV001 *CURRENT) +
             ENTTYP(SR RC FC NC IE EE ER) OUTPUT(*OUTFILE) +
             OUTFILE(*LIBL/JRNEFD) OUTMBR(&MKT)*********************************************CSC020*/
             DSPJRN     JRN(*LIBL/ICJRN) RCVRNG(*LIBL/&STRRCV +
                          *CURRENT) ENTTYP(SR RC FC NC IE EE ER) +
                          OUTPUT(*OUTFILE) OUTFILE(*LIBL/JRNEFD) +
                          OUTMBR(&MKT)                                                    /*CSC020*/
             MONMSG     MSGID(CPF7062)
/**/
/* CALL FF0490 TO SET UP RECOVERY AREAS FOR THE MARKET               */
/**/
             CLRPFM     RSTRDF MBR(&MKT)
             OVRDBF     FILE(JRNEF) MBR(&MKT)
             OVRDBF     FILE(RSTRDF) MBR(&MKT)
             CALL       FF0490 PARM(&MKT &FORN &FAIL)
/**/
/* IF A DATABASE ERROR OCCURS, SEND MESSAGE TO MOPERQ                */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM1)     */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM1)        /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM1) +
                              TOMSGQ(MOPERQ)
/**/
/* CALL FF0473 TO WRITE A MESSAGE TO THE END OF CENTRE MESSAGES FILE */
/**/
                 CHGVAR     VAR(&ACT) VALUE('I')
                 CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1090')
                 CALL       FF0473 PARM(&MKT &ACT &MSG)
                 GOTO       ABNOR
             ENDDO
/**/
/* CALL SD1742 TO SET UP NAMES OF FILES/MEMBERS REQUIRING RMVJRNCHG  */
/**/
             OVRDBF     FILE(FFMMFD) MBR(&MKT)
             CLRPFM     FFMMFD MBR(&MKT)
             MONMSG     MSGID(CPF3141) EXEC(ADDPFM FILE(FFMMFD) +
                          MBR(&MKT))                                  /*126493*/
             CALL       SD1742 PARM(&MKT)
/**/
/* CALL FFC1091 FOR EACH RECORD ON RSTRDF TO REMOVE JOURNAL CHANGES  */
/**/
FILE:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO END)
             CALL       PGM(FFC1091) PARM(&MKT &FAIL &FRPNT &TOPNT +
                          &XREC)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
               GOTO CMDLBL(FINISH)
             ENDDO
             GOTO       FILE
/**/
END:         CLRPFM     FFMMFD MBR(&MKT)
/**/
/* EXTRA CHECK REQUIRED TO REORGANIZE PFM IF CHANGES WERE REMOVED    */
/**/
             CHGVAR     VAR(&TOPNA) VALUE(&TOPNT)
             CALL       PGM(FFC1092) PARM(&MKT &TOPNA &XREC)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
               GOTO CMDLBL(ABNOR)
             ENDDO
 
/* If ED module FF account key extract required recover extract */    /*CED005*/
/* file */                                                            /*CED005*/
             CALL       PGM(AOBUTFR0) PARM('EDFKEYPD' '          ' +
                          &ED_RTCD &ED_FMT)                           /*CED005*/
             IF         COND(&ED_RTCD *NE '*FAILED') THEN(DO)         /*CED005*/
                                                                      /*CED005*/
             CPYF       FROMFILE(XEDSFKYPD) TOFILE(EDSFKYPD) +
                          FROMMBR(&MKT) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)                            /*CED005*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(EDSFKYPD) MBR(&MKT))                   /*CED005*/
                                                                      /*CED005*/
                          ENDDO                                       /*CED005*/
/**/
/* SEND JOURNAL ENTRY TYPE 'EE' TO JOURNAL */
/**/
/**********  SNDJRNE    JRN(ICJRN) TYPE('EE') ENTDTA(&TOPNA *CAT &MKT) */                /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('EE') ENTDTA(&TOPNA *CAT +
                          &MKT) FORCE(*YES)                                              /*BUG9619*/
             GOTO       FINISH
/**/
ABNOR:       SNDPGMMSG  MSG('FFC1090 - Recovery of EOC Component or +
                              Reopen of Market ENDED ABNORMALLY') +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* CALL FF0472 TO RESET END OF CENTRE STATUS INDICATOR               */
/**/
             CALL       FF0472 PARM('F' &MKT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* CALL FF0473 TO WRITE A MESSAGE TO THE END OF CENTRE MESSAGES FILE */
/**/
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('End of Centre Recovery +
                          or Reopen terminated abnormally')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB    SWS(XXXXXX1X)
/**/
FINISH:      DLTOVR     FILE(JRNEF)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(RSTRDF)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
/**/
