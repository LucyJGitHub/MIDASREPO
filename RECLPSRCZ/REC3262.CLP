/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Todays unlinked account')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                               */
/*                                                                   */
/*       REC3262 - TODAY'S UNLINKED ACCOUNT                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. 230844             Date 17Dec04              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/*                      170768             DATE 12Jan00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      092891             DATE 23JAN96              */
/*                      S01408             DATE 09MAY95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       230844 - There is problem with charges after unlink of      */
/*                accounts. Applied fix 200199.                      */
/*       CCB009 - Journal files throughout close of business         */
/*       170768 - FUSIONPD needs to be journalled as it is updated   */
/*                under commitment control in RE3262.                */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       092891 - If STRJRNPF fails because pgm cannot allocate      */
/*                XXJLIB, retry before failing.                      */
/*              - Add Global Monitor message and ABNOR processing    */
/*       S01408  - Addition of core hook REC3262MP1                  */
/*       S01413  -  Retail 3 Incorporation                           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*092891*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*/COPY WNCPYSRC,REC3262001                                          */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*092891*/
                                                                      /*092891*/
             SNDPGMMSG  MSG('REC3262 - Today''s unlinked accnt +
                          ') TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**/
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&JLIB) VALUE(&PRE *TCAT 'JLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3262MP1                                          */
                                                                      /*S01408*/
/**/
            ENDCMTCTL
             MONMSG     MSGID(CPF0000)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                 ENDJRNPF   FILE(*ALL) JRN(JREC3262)
             MONMSG MSGID(CPF0000)
                 DLTJRN     JRN(JREC3262)
             MONMSG     MSGID(CPF0000)
                 CHGJOB     INQMSGRPY(*DFT)
                 DLTJRNRCV  JRNRCV(JRREC3262)
             MONMSG     MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*RQD)
               CRTJRNRCV  JRNRCV(&JLIB/JRREC3262)
               CRTJRN     JRN(&JLIB/JREC3262) JRNRCV(&JLIB/JRREC3262)
/*********** STRJRNPF   FILE(REEODPF REHISPS ACCNTAB REHPOSPP REACRD + *092891*/
/************************ REHISPD RECOMD RELINKP) JRN(JREC3262) +      *092891*/
/************************ IMAGES(*BOTH) OMTJRNE(*OPNCLO)               *092891*/
RETRY1:                                                               /*092891*/
             STRJRNPF   FILE(*LIBL/REEODPF) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*092891*/
             MONMSG     MSGID(CPF7030)                                /*092891*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*092891*/
                                                                      /*092891*/
             STRJRNPF   FILE(*LIBL/REHISPS) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*092891*/
             MONMSG     MSGID(CPF7030)                                /*092891*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*092891*/
                                                                      /*092891*/
             STRJRNPF   FILE(*LIBL/ACCNTAB) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*092891*/
             MONMSG     MSGID(CPF7030)                                /*092891*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*092891*/
                                                                      /*092891*/
             STRJRNPF   FILE(*LIBL/REHPOSPP) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*092891*/
             MONMSG     MSGID(CPF7030)                                /*092891*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*092891*/
                                                                      /*092891*/
             STRJRNPF   FILE(*LIBL/REACRD) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*092891*/
             MONMSG     MSGID(CPF7030)                                /*092891*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*092891*/
                                                                      /*092891*/
             STRJRNPF   FILE(*LIBL/REHISPD) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*092891*/
             MONMSG     MSGID(CPF7030)                                /*092891*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*092891*/
                                                                      /*092891*/
             STRJRNPF   FILE(*LIBL/RECOMD) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*092891*/
             MONMSG     MSGID(CPF7030)                                /*092891*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*092891*/
                                                                      /*092891*/
             STRJRNPF   FILE(*LIBL/RELINKP) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*092891*/
             MONMSG     MSGID(CPF7030)                                /*092891*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*092891*/
 
             STRJRNPF   FILE(*LIBL/REIACA) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)                                  /*230844*/
             MONMSG     MSGID(CPF7030)                                                    /*230844*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                         /*230844*/
             STRJRNPF   FILE(*LIBL/REIACD) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)                                  /*230844*/
             MONMSG     MSGID(CPF7030)                                                    /*230844*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                         /*230844*/
             STRJRNPF   FILE(*LIBL/REIACZ) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)                                  /*230844*/
             MONMSG     MSGID(CPF7030)                                                    /*230844*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                         /*230844*/
/*/COPY WNCPYSRC,REC3262002                                          */
                                                                      /*092891*/
             STRJRNPF   FILE(*LIBL/FUSIONPD) JRN(JREC3262) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*170768*/
             MONMSG     MSGID(CPF7030)                                /*170768*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*170768*/
                                                                      /*170768*/
             ENDDO                                                    /*CCB009*/
/**********    STRCMTCTL *ALL                                         /*CPK009*/
             STRCMTCTL  LCKLVL(*ALL) CMTSCOPE(*JOB)                   /*CPK009*/
                                                                      /*092891*/
             GOTO       CMDLBL(BYPASS)                                /*092891*/
                                                                      /*092891*/
JRNFAIL:                                                              /*092891*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*092891*/
             IF         COND(&COUNT *LE 5) THEN(DO)                   /*092891*/
             DLYJOB     DLY(60)                                       /*092891*/
             GOTO       CMDLBL(RETRY1)                                /*092891*/
             ENDDO                                                    /*092891*/
             ELSE       CMD(DO)                                       /*092891*/
             GOTO       CMDLBL(ABNOR)                                 /*092891*/
             ENDDO                                                    /*092891*/
/**/
BYPASS:                                                               /*092861*/
                   CHGVAR     VAR(&STAT) VALUE('Y')
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/*/COPY WNCPYSRC,REC3262003                                          */
/**/
             CALL       PGM(RE3262)
/*/COPY WNCPYSRC,REC3262004                                          */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/*   SUCCESSFUL COMPLETION - DELETE JOURNAL & RECEIVER   */
               IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                 ENDCMTCTL
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                 CHGVAR   VAR(&COUNT) VALUE(0)                        /*092891*/
 RETRY:
                 ENDJRNPF   FILE(*ALL) JRN(JREC3262)
 
                 MONMSG     MSGID(CPF9803 CPF9999) EXEC(DO)
                 CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)             /*092891*/
                 IF         COND(&COUNT *LE 6) THEN(DO)               /*092891*/
                    DLYJOB     DLY(30)
                    GOTO       CMDLBL(RETRY)
                 ENDDO                                                /*092891*/
                 ELSE       CMD(DO)                                   /*092891*/
                    GOTO       CMDLBL(ABNOR)                          /*092891*/
                 ENDDO                                                /*092891*/
                 ENDDO
 
                 DLTJRN     JRN(JREC3262)
                 CHGJOB     INQMSGRPY(*DFT)
                 DLTJRNRCV  JRNRCV(JRREC3262)
                 CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
               ENDDO
                   CHGVAR     VAR(&STAT) VALUE('N')
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/*/COPY WNCPYSRC,REC3262005                                          */
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/****UNSUCCESSFUL*COMPLETION*-*REMOVE*JOURNALLED*CHANGES****/         /*092891*/
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*092891*/
             SNDPGMMSG  MSG('REC3262 - Today''s unlinked accounts +
                          completed normally') TOMSGQ(MRUNQ)          /*092891*/
             GOTO       CMDLBL(END)                                   /*092891*/
             ENDDO                                                    /*092891*/
/************IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)          *092891*/
/**/
ABNOR:                                                                /*092891*/
                SNDPGMMSG  MSG('REC3262 - Today''s unlinked accounts +
                             ENDED ABNORMALLY') TOMSGQ(MRUNQ MOPERQ)  /*092891*/
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*092891*/
                                                                      /*092891*/
/*   If unsuccesful completion, remove journalled changes              *092891*/
                 ROLLBACK
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*092891*/
/*/COPY WNCPYSRC,REC3262006                                          */
                                                                      /*092891*/
                 DMPCLPGM                                             /*092891*/
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*092891*/
END:                                                                  /*092891*/
                 ENDCMTCTL
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*092891*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                 ENDJRNPF   FILE(*ALL) JRN(JREC3262)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*092891*/
                 DLTJRN     JRN(JREC3262)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*092891*/
                 CHGJOB     INQMSGRPY(*DFT)
                 DLTJRNRCV  JRNRCV(JRREC3262)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*092891*/
             CHGJOB     INQMSGRPY(*RQD)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*092891*/
             ENDDO                                                    /*CCB009*/
                                                                      /*092891*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)              /*092891*/
                 RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*092891*/
                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                 SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*092891*/
             ENDDO
                                                                      /*092891*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*092891*/
