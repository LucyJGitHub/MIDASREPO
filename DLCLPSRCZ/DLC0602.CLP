/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL COB update phase 1')                         */
/********************************************************************/
/*                                                                  */
/*        Midas - Dealing Module                            */
/*                                                                  */
/*       DLC0602 - DAILY FILE MAINTENANCE - PHASE 1                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. CDL008             Date 02May00             */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                        CCB009           DATE 01Jun00             */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                        S01408           DATE 29MAY96             */
/*                        S01408           DATE 04MAY95             */
/*                        042944           DATE 10MAY93             */
/*                        042943           DATE 10MAY93             */
/*                        LN1258           DATE  1MAY91             */
/*                        BHF982           DATE 18FEB91             */
/*                        E21851           DATE 28JUL90             */
/*                        E13989(LN0701)   DATE 15FEB90             */
/*                        S01189           DATE 04JAN90             */
/*                        S01194           DATE 01/09/89            */
/*                        S01119           DATE 17/06/87            */
/*                        E10496           DATE 20/03/87            */
/*                        E10363           DATE 18/02/87            */
/*                        S01093           DATE 22/09/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CDL008 - Continuous Linked Settlement (Recompiled CUSDE/   */
/*                CUSDL/DEALS)                                      */
/*       CCB009 - Journal files throughout close of business        */
/*       S01408  -  Addition Of Core Hook DLC0602001                */
/*       S01408  -  Addition Of Core Hook DLC0602MP1                */
/*       042944  -  ERROR IN PROCESSING,RESTART OF DLC0602          */
/*                  AFTER ABNORMAL TERMINATION NOT WORKING.         */
/*                  THEREFORE THE LOGICAL FILE MEMBERS WERE         */
/*                  ADDED BEFORE DLCC0264 IS CALLED>                */
/*       042943  -  ERROR IN RESTART PROCESSING. MUST ADD A MEMBER  */
/*                  TO DEALSL DURING ABNORMAL TERMINATION.          */
/*                                                                  */
/*       LN1258  -  THE FOLLOWING FILES ARE NOW REDUNDANT           */
/*                  EMDFX,EMDLS,EMDMM,EMFXDL,EMLSDL,EMMMDL          */
/*       BHF982  -  ADDLFM SHOULD HAVE SHARE(*YES)                  */
/*       E21851  -  If DL0264 or DL0279 end abnormally for any      */
/*                  reason other than a database error or file      */
/*                  controls out of balance then the job switches   */
/*                  are not being being set to inform the stream    */
/*                  controller that an error has occurred. This     */
/*                  could happen with an RPG error such as Array    */
/*                  Index error.                                    */
/*       E13989  -  END JOURNALINGIF THERE IS A DATABASE ERROR      */
/*                  IN DL0279 AND TEST FOR ERRORS IN DL0264         */
/*                  INDEPENDENTLY FROM DL0279.                      */
/*       S01189  -  COB recovery processing.                        */
/*       S01194  -  NEW STANDING DATA FILES                         */
/*       S01119  -  ADDITION OF FRA/IRS FILE                        *  *S01119*/
/*       E10496  -  SHOULD NOT OVRDBF DEALS TO CUSDE BEFORE DL0264  */
/*                  IS CALLED.                                      */
/*       E10363  -  DLSTAT NOT BEING UPDATED CORRECTLY, THUS        */
/*                  MAKING COMPONENT UNRESTARTABLE.                 */
/*       S01093  -  REWRITTEN TO INTRODUCE JOUNALLING               */
/*                                                                  */
/********************************************************************/
/************PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
/********    DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*                                                                      CCB009*/
/* Declare job name, user and number for remove journal changes         CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)            /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)            /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
/*/COPY WNCPYSRC,DLC0602002                                          */
/**/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/* Retrieve current job attributes.                                     CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
             ENDDO                                                    /*CCB009*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/**/
             CLRPFM     FILE(DAUPDHH)
             CLRPFM     FILE(DAUPDDI)
             CLRPFM     FILE(DAUPDDJ)
             CLRPFM     FILE(DAINDHH)
             CLRPFM     FILE(DAINDDL)
             CLRPFM     FILE(DAINDEX)
             CLRPFM     FILE(DLINDHH)
             CLRPFM     FILE(DLINDDM)
             CLRPFM     FILE(DLINDZX)
/*   DEAL AMENDMENTS FILE UPDATE - PHASE 1                      */
             SNDPGMMSG  MSG('DEAL AMENDMENTS UPDATE-PHASE 1') +
                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/*/COPY WNCPYSRC,DLC0602016                                          */
/*  */                                                                /*042944*/
/*   If RESTART,add logical file members in case they are missing       042944*/
/*  */                                                                /*042944*/
          CHGVAR    VAR(&STAT) VALUE(' ')                             /*042944*/
          CALL      PGM(CB0160) PARM(&CNAM &CSEQ &STAT)               /*042944*/
          IF        COND(&STAT *EQ 'Y') THEN(DO)                      /*042944*/
             ADDLFM    FILE(CUSDE) MBR(CUSDE)                         /*042944*/
             MONMSG    MSGID(CPF0000)                                 /*042944*/
             ADDLFM    FILE(DEALS) MBR(DEALS)                         /*042944*/
             MONMSG    MSGID(CPF0000)                                 /*042944*/
             ADDLFM    FILE(DEALSI) MBR(DEALSI)                       /*042944*/
             MONMSG    MSGID(CPF0000)                                 /*042944*/
             ADDLFM    FILE(DEALSH) MBR(DEALSH)                       /*042944*/
             MONMSG    MSGID(CPF0000)                                 /*042944*/
             ADDLFM    FILE(DEALSBRC) MBR(DEALSBRC)                   /*042944*/
             MONMSG    MSGID(CPF0000)                                 /*042944*/
             ADDLFM    FILE(DEALSL) MBR(DEALSL)                       /*042944*/
             MONMSG    MSGID(CPF0000)                                 /*042944*/
/*/COPY WNCPYSRC,DLC0602017                                          */
     ENDDO                                                            /*042944*/
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('XXXXXX00')
             CHGJOB     SWS(&SWS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEI)                   /*S01194*/
 /*********  OVRDBF     FILE(DEALS) TOFILE(CUSDE)     */              /*E10496*/
/**********  OVRDBF     FILE(TABLED) TOFILE(TABDLEI) SHARE(*NO)       /*S01194*/
             CALL       PGM(DL0264)
                                                                      /*E21851*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)       /*E21851*/
             CHGJOB     SWS(XXXXXX1X)                                 /*E21851*/
             SNDPGMMSG  MSG('DEAL AMENDMENTS UPDATE-PHASE 1 ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ) MSGTYPE(*INFO)  /*E21851*/
             GOTO       CMDLBL(ENDPGM)                                /*E21851*/
             ENDDO                                                    /*E21851*/
                                                                      /*E21851*/
/**********  DLTOVR     FILE(*ALL)                                    /*S01194*/
                                                                      /*E13989*/
 /* E21851   MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDPGM))                  /*E13989*/ /*E21851*/
                                                                      /*E13989*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*E13989*/
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)              /*E13989*/
             GOTO       CMDLBL(ENDPGM)                                /*E13989*/
             ENDDO                                                    /*E13989*/
                                                                      /*E13989*/
/*   DEALS FILE UPDATE - PHASE 1                                 */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                SNDPGMMSG  MSG('DEALS FILE UPDATE-PHASE 1') +
                           TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/***************RTVDTAARA  DTAARA(DLSTAT (17 3)) RTNVAR(&BUSY)*/      /*S01189*/
                CHGVAR     VAR(&STAT) VALUE(' ')                      /*S01189*/
                CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
/*   IF RESTART, REMOVE JOURNALLED CHANGES   */
/***************IF         COND(&BUSY = 'NEW') THEN(DO)               /*S01189*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)               /*S01189*/
                   CHKOBJ     OBJ(JRDLC0602) OBJTYPE(*JRNRCV)
                   MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))
                   CHKOBJ     OBJ(JDLC0602) OBJTYPE(*JRN)
                   MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))
                   RMVM       FILE(CUSDE) MBR(CUSDE)
                   MONMSG     MSGID(CPF0000)
                   RMVM       FILE(DEALS) MBR(DEALS)
                   MONMSG     MSGID(CPF0000)
                   RMVM       FILE(CUSDL) MBR(CUSDL)
                   MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,DLC0602018                                          */
/***********       RMVM       FILE(EMFXDL) MBR(EMFXDL)               * *LN1258*/
/***********       MONMSG     MSGID(CPF0000)                         * *LN1258*/
/***********       RMVM       FILE(EMDFX) MBR(EMDFX)                 * *LN1258*/
/***********       MONMSG     MSGID(CPF0000)                         * *LN1258*/
/***********       RMVM       FILE(EMDMM) MBR(EMDMM)                 * *LN1258*/
/***********       MONMSG     MSGID(CPF0000)                         * *LN1258*/
/***********       RMVM       FILE(EMMMDL) MBR(EMMMDL)               * *LN1258*/
/***********       MONMSG     MSGID(CPF0000)                         * *LN1258*/
/***********       RMVM       FILE(EMLSDL) MBR(EMLSDL)               * *LN1258*/
/***********       MONMSG     MSGID(CPF0000)                         * *LN1258*/
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                              CCB009*/
/*                                                                      CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)
/*                                                                      CCB009*/
/* If data area is not blank, calculate the job name, user and number   CCB009*/
/* of the previous run of this component.                               CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)              /*CCB009*/
/*                                                                      CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10)) +
                                                                      /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6)) +
                                                                      /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of job.                                      CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((DEALSDB) (DEALSDC) +
                          (DEALSDD) (DEALSDE) (DEALSDF) (DEALSDG)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*/COPY WNCPYSRC,DLC0602019                                          */
                   RMVJRNCHG  JRN(JDLC0602) FILE((DEALSDB) (DEALSDC) +
                        (DEALSDD) (DEALSDE) (DEALSDF) (DEALSDG))      /*S01119*/
/****************               (DEALSDD) (DEALSDE) (DEALSDF))   */   /*S01119*/
                   MONMSG     (CPF7042 CPF7049)
/*/COPY WNCPYSRC,DLC0602020                                          */
                   ENDJRNPF   FILE(*ALL) JRN(JDLC0602)
                   MONMSG     MSGID(CPF7032)
             ENDDO                                                    /*CCB009*/
                   DLTJRN     JRN(JDLC0602)
/*                 ADDLFM     FILE(CUSDE) MBR(CUSDE) */               /*BHF982*/
                   ADDLFM     FILE(CUSDE) MBR(CUSDE) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)
/*                 ADDLFM     FILE(DEALS) MBR(DEALS) */               /*BHF982*/
                   ADDLFM     FILE(DEALS) MBR(DEALS) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)
/*                 ADDLFM     FILE(CUSDL) MBR(CUSDL) */               /*BHF982*/
                   ADDLFM     FILE(CUSDL) MBR(CUSDL) SHARE(*YES)      /*BHF982*/
                   MONMSG     MSGID(CPF0000)
/*                 ADDLFM     FILE(EMFXDL) MBR(EMFXDL) */             /*BHF982*/
/**********        ADDLFM FILE(EMFXDL) MBR(EMFXDL) SHARE(*YES)*BHF982* *LN1258*/
/**********        MONMSG     MSGID(CPF0000)                         * *LN1258*/
/*                 ADDLFM     FILE(EMDFX) MBR(EMDFX) */               /*BHF982*/
/**********        ADDLFM FILE(EMDFX) MBR(EMDFX) SHARE(*YES)  *BHF982* *LN1258*/
/**********        MONMSG     MSGID(CPF0000)                         * *LN1258*/
/*                 ADDLFM     FILE(EMDMM) MBR(EMDMM) */               /*BHF982*/
/**********        ADDLFM FILE(EMDMM) MBR(EMDMM) SHARE(*YES)  *BHF982* *LN1258*/
/**********        MONMSG     MSGID(CPF0000)                         * *LN1258*/
/*                 ADDLFM     FILE(EMMMDL) MBR(EMMMDL) */             /*BHF982*/
/**********        ADDLFM FILE(EMMMDL) MBR(EMMMDL) SHARE(*YES)*BHF982* *LN1258*/
/**********        MONMSG     MSGID(CPF0000)                         * *LN1258*/
/*                 ADDLFM     FILE(EMLSDL) MBR(EMLSDL) */             /*BHF982*/
/**********        ADDLFM FILE(EMLSDL) MBR(EMLSDL) SHARE(*YES)*BHF982* *LN1258*/
/**********        MONMSG     MSGID(CPF0000)                         * *LN1258*/
             ADDLFM    FILE(DEALSL) MBR(DEALSL)                       /*042943*/
             MONMSG    MSGID(CPF0000)                                 /*042943*/
/*/COPY WNCPYSRC,DLC0602021                                          */
NOJRN:             CHGJOB     INQMSGRPY(*DFT)
/*/COPY WNCPYSRC,DLC0602005                                          */
                   DLTJRNRCV  JRNRCV(JRDLC0602)
/*/COPY WNCPYSRC,DLC0602006                                          */
                   CHGJOB     INQMSGRPY(*RQD)
/***NOJRNRCV:      CHGDTAARA  DTAARA(DLSTAT (17 3)) VALUE('OLD')      /*S01189*/
 NOJRNRCV:         CHGVAR     VAR(&STAT) VALUE('N')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
                ENDDO
/*   CREATE JOURNAL & RECEIVER   */
/***************CHGDTAARA  DTAARA(DLSTAT (17 3)) VALUE('NEW')         /*S01189*/
                CHGVAR     VAR(&STAT) VALUE('Y')                      /*S01189*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
                CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC0602MP1                                          */
                                                                      /*S01408*/
/***********    CRTJRNRCV  JRNRCV(JRDLC0602.&JLIB) */ /*S01179*/
                CRTJRNRCV  JRNRCV(&JLIB/JRDLC0602)    /*S01179*/
/***CRTJRN**** JRN(JDLC0602.&JLIB) JRNRCV(JRDLC0602.&JLIB)   S01179*/
    CRTJRN     JRN(&JLIB/JDLC0602) JRNRCV(&JLIB/JRDLC0602) /*S01179*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/***JRNPF      FILE(DEALSDB DEALSDC DEALSDD DEALSDE +      /*S01179*/
/*/COPY WNCPYSRC,DLC0602022                                          */
    STRJRNPF      FILE(DEALSDB DEALSDC DEALSDD DEALSDE +
                   DEALSDF DEALSDG) JRN(JDLC0602) IMAGES(*BOTH)       /*S01119*/
/**************             DEALSDF) JRN(JDLC0602) IMAGES(*BOTH)    *  *S01119*/
/*/COPY WNCPYSRC,DLC0602023                                          */
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,DLC0602007                                          */
/***********    OVRDBF     FILE(TABLE) TOFILE(TABDLEI)                /*S01194*/
/***********    OVRDBF     FILE(TABLE2) TOFILE(TABDLEE)               /*S01194*/
                OVRDBF     FILE(DEALS) TOFILE(CUSDE)
                OVRDBF     FILE(DLINDDM) SEQONLY(*YES 500)
                CALL       PGM(DL0279)
/* E21851       MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                           CMDLBL(ABNOR))                             /*E21851*/
                                                                      /*E21851*/
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)    /*E21851*/
/*/COPY WNCPYSRC,DLC0602003                                          */
                CHGJOB     SWS(XXXXXX1X)                              /*E21851*/
                SNDPGMMSG  MSG('DEALS FILE UPDATE-PHASE 1 ENDED +
                           ABNORMALLY') TOMSGQ(MOPERQ) MSGTYPE(*INFO) /*E21851*/
                GOTO       CMDLBL(ABNOR)                              /*E21851*/
                ENDDO                                                 /*E21851*/
                                                                      /*E21851*/
                DLTOVR     FILE(*ALL)
/*/COPY WNCPYSRC,DLC0602004                                          */
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                GOTO       CMDLBL(ABNOR)                              /*E13989*/
/***************GOTO       CMDLBL(ENDPGM)******************/          /*E13989*/
             ENDDO
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC0602001                                           /*S01408*/
/*                                                                    /*S01408*/
/*   SUCCESSFUL COMPLETION - DELETE JOURNAL & RECEIVER   */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JDLC0602)
             ENDDO                                                    /*CCB009*/
             DLTJRN     JDLC0602
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRDLC0602
             CHGJOB     INQMSGRPY(*RQD)
/*/COPY WNCPYSRC,DLC0602008                                          */
/************CHGDTAARA  DTAARA(DLSTAT (17 3)) VALUE('OLD')            /*S01189*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*S01189*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/*/COPY WNCPYSRC,DLC0602009                                          */
             GOTO ENDPGM
/*   UNSUCCESSFUL COMPLETION - REMOVE JOURNALLED CHANGES   */
ABNOR:       RMVM       FILE(CUSDE) MBR(CUSDE)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(DEALS) MBR(DEALS)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(CUSDL) MBR(CUSDL)
             MONMSG     MSGID(CPF0000)
/*********** RMVM       FILE(EMFXDL) MBR(EMFXDL)                     * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*********** RMVM       FILE(EMDFX) MBR(EMDFX)                       * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*********** RMVM       FILE(EMDMM) MBR(EMDMM)                       * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*********** RMVM       FILE(EMMMDL) MBR(EMMMDL)                     * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*********** RMVM       FILE(EMLSDL) MBR(EMLSDL)                     * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*/COPY WNCPYSRC,DLC0602010                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve attributes of current job.                                 CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of current job.                              CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((DEALSDB) (DEALSDC) +
                          (DEALSDD) (DEALSDE) (DEALSDF) (DEALSDG)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*/COPY WNCPYSRC,DLC0602024                                          */
             RMVJRNCHG  JRN(JDLC0602) FILE((DEALSDB) (DEALSDC) +
                          (DEALSDD) (DEALSDE) (DEALSDF) (DEALSDG))    /*S01119*/
/***********              (DEALSDD) (DEALSDE) (DEALSDF))            *  *S01119*/
             MONMSG     (CPF7049)
/*/COPY WNCPYSRC,DLC0602025                                          */
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,DLC0602011                                          */
/*           ADDLFM     FILE(DEALS) MBR(DEALS) */                     /*BHF982*/
             ADDLFM     FILE(DEALS) MBR(DEALS) SHARE(*YES)            /*BHF982*/
             MONMSG     MSGID(CPF0000)
             MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,DLC0602012                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JDLC0602)
             ENDDO                                                    /*CCB009*/
             DLTJRN     JRN(JDLC0602)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JRDLC0602)
             CHGJOB     INQMSGRPY(*RQD)
/*/COPY WNCPYSRC,DLC0602013                                          */
/*           ADDLFM     FILE(CUSDE) MBR(CUSDE) */                     /*BHF982*/
             ADDLFM     FILE(CUSDE) MBR(CUSDE) SHARE(*YES)            /*BHF982*/
             MONMSG     MSGID(CPF0000)
/*           ADDLFM     FILE(DEALS) MBR(DEALS) */                     /*BHF982*/
             ADDLFM     FILE(DEALS) MBR(DEALS) SHARE(*YES)            /*BHF982*/
             MONMSG     MSGID(CPF0000)
/*           ADDLFM     FILE(CUSDL) MBR(CUSDL) */                     /*BHF982*/
             ADDLFM     FILE(CUSDL) MBR(CUSDL) SHARE(*YES)            /*BHF982*/
             MONMSG     MSGID(CPF0000)
/*           ADDLFM     FILE(EMFXDL) MBR(EMFXDL) */                   /*BHF982*/
/**********  ADDLFM     FILE(EMFXDL) MBR(EMFXDL) SHARE(*YES)  *BHF982* *LN1258*/
/**********  MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*           ADDLFM     FILE(EMDFX) MBR(EMDFX) */                     /*BHF982*/
/**********  ADDLFM     FILE(EMDFX) MBR(EMDFX) SHARE(*YES)    *BHF982* *LN1258*/
/**********  MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*           ADDLFM     FILE(EMDMM) MBR(EMDMM) */                     /*BHF982*/
/**********  ADDLFM     FILE(EMDMM) MBR(EMDMM) SHARE(*YES)    *BHF982* *LN1258*/
/**********  MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*           ADDLFM     FILE(EMMMDL) MBR(EMMMDL) */                   /*BHF982*/
/**********  ADDLFM     FILE(EMMMDL) MBR(EMMMDL) SHARE(*YES)  *BHF982* *LN1258*/
/**********  MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*           ADDLFM     FILE(EMLSDL) MBR(EMLSDL) */                   /*BHF982*/
/**********  ADDLFM     FILE(EMLSDL) MBR(EMLSDL) SHARE(*YES)  *BHF982* *LN1258*/
/**********  MONMSG     MSGID(CPF0000)                               * *LN1258*/
             ADDLFM    FILE(DEALSL) MBR(DEALSL)                       /*042943*/
             MONMSG    MSGID(CPF0000)                                 /*042943*/
/*/COPY WNCPYSRC,DLC0602026                                          */
/**********  CHGDTAARA  DTAARA(DLSTAT (17 1)) VALUE('OLD')  */        /*E10363*/
/************CHGDTAARA  DTAARA(DLSTAT (17 3)) VALUE('OLD')/*E10363*/  /*S01189*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*S01189*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,DLC0602014                                          */
/*ENDPGM:****ENDPGM*************************************************************************CSC020*/
ENDPGM:                                                                                   /*CSC020*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             RETURN                                                                       /*CSC020*/
             ENDPGM                                                                       /*CSC020*/
/*/COPY WNCPYSRC,DLC0602015                                          */
