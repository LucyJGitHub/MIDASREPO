/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Journal receiver save')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       SCC0401 - Journal receiver save                             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. 260790             Date 19Jun09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01495 *C *CREATE  Date 01Oct94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       260790 - COB performance improvements                       */
/*                Save journal receivers as they are detached        */
/*       S01495 - COB enhancements.                                  */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
             DCL        VAR(&PFX) TYPE(*CHAR) LEN(2)                                      /*260790*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)                                    /*260790*/
             DCL        VAR(&DATAQN) TYPE(*CHAR) LEN(10)                                  /*260790*/
             DCL        VAR(&DATAQE) TYPE(*CHAR) LEN(10)                                  /*260790*/
             DCL        VAR(&DLEN) TYPE(*DEC) LEN(5 0) VALUE(10)                          /*260790*/
                                                                                          /*260790*/
/*/COPY WNCPYSRC,SCC0401004                                          */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/*/COPY WNCPYSRC,SCC0401003                                          */
/**/
/* If save of receivers is to disk call SCC2449 */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
             IF         COND(%SST(&CB_AUTO 31 5) *EQ '*DISK') THEN(DO)
               CALL       PGM(SCC2449)
             ENDDO
             ELSE       CMD(DO)
               CALL       PGM(SDC1715) PARM(&PARM)
/**/
/* Call CB0602U to update COB data fields on CBAICDPD */
/**/
               CHGVAR    VAR(%SST(&CB_AUTO 1 10)) VALUE('*SETRCV   ')
               CHGVAR    VAR(%SST(&CB_AUTO 83 5)) VALUE('*TAPE')
               CHGVAR    VAR(%SST(&CB_AUTO 93 4)) VALUE(%SST(&CB_AUTO +
                          53 56))
               CALL      PGM(CB0602U) PARM(&CB_RTN_CDE &CB_AUTO)
/**/
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ABNOR)
/*/COPY WNCPYSRC,SCC0401005                                          */
/**/
/* Set up XLIB */                                                                         /*260790*/
/**/                                                                                      /*260790*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PFX)                                 /*260790*/
             CHGVAR     VAR(&XLIB) VALUE(&PFX *CAT 'XLIB')                                /*260790*/
/**/                                                                                      /*260790*/
/* Recreate the DATAQS used by SCC2470MON */                                              /*260790*/
/**/                                                                                      /*260790*/
             CHGVAR     VAR(&DATAQN) VALUE('SCC2470MON')                                  /*260790*/
             DLTDTAQ    DTAQ(&XLIB/&DATAQN)                                               /*260790*/
             MONMSG     MSGID(CPF0000 RPG0000)                                            /*260790*/
             CRTDTAQ    DTAQ(&XLIB/&DATAQN) MAXLEN(10)                                    /*260790*/
                                                                                          /*260790*/
             CHGVAR     VAR(&DATAQE) VALUE('SCC2470END')                                  /*260790*/
             DLTDTAQ    DTAQ(&XLIB/&DATAQE)                                               /*260790*/
             MONMSG     MSGID(CPF0000 RPG0000)                                            /*260790*/
             CRTDTAQ    DTAQ(&XLIB/&DATAQE) MAXLEN(10)                                    /*260790*/
/**/                                                                                      /*260790*/
/* Put a STOPPED message on SCC2470END. The first thing SCC2470MON */                     /*260790*/
/* will do is to remove the message. SCC2470MON will place a STOPPED */                   /*260790*/
/* message on this DATAQ when it completes at the request of SCC0405.*/                   /*260790*/
/* If SCC2470MON fail to start then the STOPPED message on SCC2470END*/                   /*260790*/
/* will ensure SCC0405 will not hang waiting on a response from */                        /*260790*/
/* SCC2470MON. */                                                                         /*260790*/
/**/                                                                                      /*260790*/
             CHGVAR     VAR(&DLEN) VALUE(10)                                              /*260790*/
             CALL       PGM(QSNDDTAQ) PARM(&DATAQE &XLIB &DLEN +
                          'STOPPED   ')                                                   /*260790*/
/**/                                                                                      /*260790*/
/* Now submit SCC2470MON to monitor the COB */                                            /*260790*/
/**/                                                                                      /*260790*/
             SBMJOB     CMD(CALL PGM(SCC2470MON)) JOB(COBJRNMON) +
                          JOBD(MEODD) JOBQ(BULKTJOBQ) PRTDEV(*JOBD) +
                          OUTQ(*JOBD) USER(*JOBD) PRTTXT(*JOBD) +
                          INLLIBL(*JOBD) INLASPGRP(*JOBD) +
                          SPLFACN(*JOBD)                                                  /*260790*/
                                                                                          /*260790*/
             GOTO ENDPGM
/**/
/* ERROR PROCESSING */
/**/
 ABNOR:      SNDPGMMSG  MSG('Journal Receiver Save ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ )
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)                                                     /*260790*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*260790*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
