/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('Midas DL Fixed Deposits Automatic Rollover')          */
/********************************************************************/
/*                                                                  */
/*       Midas - Dealing Module                                     */
/*                                                                  */
/*       DLC5350 - MM Automatic Rollover (COB process)              */
/*                                                                  */
/*       (C) Copyright Finastra International Limited 2004           */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. 259376             Date 20Sep12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      243473             Date 09Nov06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG4122           Date 14Sep04              */
/*                      CDL016  *Create   Date 03Feb04              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*      259376 - Produce confirmations in Correspondence Manager    */
/*               for auto-rollover deals.                           */
/*             - Applied for AR1034429 (Child: AR1034430)           */
/*      243473 - Add commit boundary *NO parameter                  */
/*      BUG4122 - Add members to MMDEAULL and SDTIX before ending   */
/*                the program.                                      */
/*      CDL016 - Automatic Rollover of Fixed deposits               */
/*                                                                  */
/********************************************************************/
/**/
     PGM        PARM(&CNAM &CSEQ)
/**/
     DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                   Finastra International Limited +
                   2004')
     DCL VAR(&MEM) TYPE(*CHAR) LEN(50)
     DCL VAR(&LDA) TYPE(*CHAR) LEN(256)
     DCL VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
     DCL VAR(&CNAM) TYPE(*CHAR) LEN(10)
     DCL VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
     DCL VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
     DCL VAR(&RTCD)    TYPE(*CHAR) LEN(7)
     DCL VAR(&OPTN)    TYPE(*CHAR) LEN(7)
     DCL VAR(&SAR)     TYPE(*CHAR) LEN(6)
     DCL VAR(&CCB009) TYPE(*CHAR) LEN(7)
     DCL VAR(&SCSARD)  TYPE(*CHAR) LEN(200)
     DCL VAR(&SYSID) TYPE(*CHAR) LEN(2)
/**/
/* Declare job name, user and number for remove journal changes      */
/**/
     DCL VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)
     DCL VAR(&CCB009USR) TYPE(*CHAR) LEN(10)
     DCL VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)
     DCL VAR(&CB0180DA) TYPE(*CHAR) LEN(26)
     DCL VAR(&START) TYPE(*DEC) LEN(10 0)
     DCL VAR(&FINISH) TYPE(*DEC) LEN(10 0)
     DCL VAR(&W0RTN) TYPE(*CHAR) LEN(7)                                                   /*259376*/
     DCL VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')                                      /*259376*/
     DCL VAR(&FMT) TYPE(*CHAR) LEN(200)                                                   /*259376*/
     DCL VAR(&ACTION) TYPE(*CHAR) LEN(8)                                                  /*259376*/
     DCL VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)                                               /*259376*/
     DCL VAR(&MULT) TYPE(*CHAR) LEN(2)                                                    /*259376*/
     DCL VAR(&GROUP) TYPE(*CHAR) LEN(50)                                                  /*259376*/
     DCL VAR(&USER) TYPE(*CHAR) LEN(25)                                                   /*259376*/
     DCL VAR(&SLEVEL) TYPE(*DEC) LEN(4)                                                   /*259376*/
     DCL VAR(&TIMEO) TYPE(*DEC) LEN(5)                                                    /*259376*/
     DCL VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)                                          /*259376*/
/*/COPY WNCPYSRC,DLH00323                                            */
/**/
     RTVDTAARA DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
 
/*  Start commitment control  */
             STRCMTCTL  LCKLVL(*CHG)
/**/
     CHGJOB SWS(00000000)
/**/
     SNDMSG MSG('Generate rollover deals for fixed deposits') -
TOMSGQ(MRUNQ)
/**/
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR)  VALUE('CDL016')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *NE '       ') THEN(GOTO ENDPGM)
/**/                                                                                      /*259376*/
/** Multiple Language Support -                                    */                     /*259376*/
/** Set Of Overrides for Message Files                             */                     /*259376*/
/**/                                                                                      /*259376*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                                                  /*259376*/
                                                                                          /*259376*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                                     /*259376*/
                CHGVAR     VAR(&MULT) VALUE('GB')                                         /*259376*/
             ENDDO                                                                        /*259376*/
/**/                                                                                      /*259376*/
/** Build Multiple Language Support Object Names                   */                     /*259376*/
/**/                                                                                      /*259376*/
             CHGVAR     VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ')                     /*259376*/
/**/                                                                                      /*259376*/
/** Apply Multiple Language Support Overrides                      */                     /*259376*/
/**/                                                                                      /*259376*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)                                  /*259376*/
/**/
/** Check for Switchable feature CCB009.    */
/**/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &SCSARD)
/**/
/* If Feature CCB009 is 'on' (close of business journaling)  */
/**/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)
/**/
/* Retrieve current job attributes.     */
/**/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)
             ENDDO
/*/COPY WNCPYSRC,DLH00324                                            */
/**/
     CHGVAR     VAR(&STAT) VALUE(' ')
     CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
     IF COND(&STAT = 'Y') THEN(DO)
/**/
/* If Feature CCB009 is 'on' (close of business journaling) */
/**/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)
/**/
/* Retrieve data area CB0180DA from QTEMP.  */
/**/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)
/**/
/* If data area is not blank, calculate the job name, user and number  */
/* of the previous run of this component.                              */
/**/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)
/**/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10)) +
 
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6)) +
 
/**/
/*  Retrieve the most recent journal entry sequence number     */
/*  for the specific job.                                      */
/**/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             CHGVAR     VAR(&START) VALUE(0)
             ENDDO
/**/
/*  Retrieve the first journal entry sequence number     */
/*  for the specific job.                                */
/**/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*FIRST) +
                          TOENT(*LAST) SEARCH(*ASCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&FINISH)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             CHGVAR     VAR(&FINISH) VALUE(0)
             ENDDO
/**/
/*  Remove journaled changes.    */
/**/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)
             RMVJRNCHG  JRN(ICJRN) FILE((MMDELDPP) (MMDENSPP) +
                          (MMDENBPP) (DEALSDB) (DEALSDC) (DEALSDD) +
                          (DEALSDE) (DEALSDF) (DEALSDG) (DTRIXHH) +
                          (DTRIXDD)) FROMENT(&START) TOENT(&FINISH) /*EFIXAR*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
 
             ENDDO
             ENDDO
             ENDDO
 
             ELSE       CMD(DO)
 
     CHKOBJ OBJ(JRDLC5350) OBJTYPE(*JRNRCV)
     MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))
 
     CHKOBJ OBJ(JDLC5350) OBJTYPE(*JRN)
     MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))
 
     RMVM FILE(MMDEAULL) MBR(MMDEAULL)
     MONMSG MSGID(CPF0000)
     RMVM FILE(DEALS) MBR(DEALS)
     MONMSG MSGID(CPF0000)
     RMVM FILE(SDTIX) MBR(SDTIX)
     MONMSG MSGID(CPF0000)
 
     RMVJRNCHG JRN(JDLC5350) FILE((MMDELDPP) (MMDENSPP) (MMDENBPP))
     MONMSG MSGID(CPF7042 CPF7049)
 
     RMVJRNCHG JRN(JDLC5350) FILE((DEALSDB) (DEALSDC) (DEALSDD) -
(DEALSDE) (DEALSDF) (DEALSDG))
     MONMSG MSGID(CPF7042 CPF7049)
 
     RMVJRNCHG JRN(JDLC5350) FILE((DTRIXHH) (DTRIXDD))
     MONMSG MSGID(CPF7042 CPF7049)
 
     ENDJRNPF FILE(*ALL) JRN(JDLC5350)
     MONMSG MSGID(CPF7032)
 
     DLTJRN JRN(JDLC5350)
 
     ADDLFM     FILE(MMDEAULL) MBR(MMDEAULL) SHARE(*YES)
     MONMSG MSGID(CPF0000)
     ADDLFM FILE(DEALS) MBR(DEALS)
     MONMSG MSGID(CPF0000)
     ADDLFM FILE(SDTIX) MBR(SDTIX)
     MONMSG MSGID(CPF0000)
 
NOJRN: +
     CHGJOB INQMSGRPY(*DFT)
     DLTJRNRCV JRNRCV(JRDLC5350)
     CHGJOB INQMSGRPY(*RQD)
             ENDDO
 
NOJRNRCV: +
     CHGVAR     VAR(&STAT) VALUE('N')
     CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
     ENDDO
     CHGVAR     VAR(&STAT) VALUE('Y')
      CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
     CHGVAR VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
 
/**/
/* If Feature CCB009 is NOT 'on' (close of business journaling)  */
/**/
 
     IF        COND(&CCB009 *NE '       ') THEN(DO)
 
     CRTJRNRCV JRNRCV(&JLIB/JRDLC5350)
     CRTJRN JRN(&JLIB/JDLC5350) JRNRCV(&JLIB/JRDLC5350)
 
     STRJRNPF   FILE(MMDELDPP MMDENSPP MMDENBPP) +
                          JRN(JDLC5350) IMAGES(*BOTH)
     MONMSG   MSGID(CPF7030)
 
     STRJRNPF   FILE(DEALSDB DEALSDC DEALSDD DEALSDE DEALSDF +
                          DEALSDG) JRN(JDLC5350) IMAGES(*BOTH)
     MONMSG   MSGID(CPF7030)
 
     STRJRNPF FILE(DTRIXHH DTRIXDD) JRN(JDLC5350) IMAGES(*BOTH)
     MONMSG   MSGID(CPF7030)
 
             ENDDO
 
     CALL PGM(DL5350)
 
     MONMSG MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
/**/                                                                                      /*259376*/
/** User Defined Correspondence processing                         */                     /*259376*/
/**/                                                                                      /*259376*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*259376*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                                       /*259376*/
/**/                                                                                      /*259376*/
/** Access PF/SDMMODPD to determine whether UDC module is on       */                     /*259376*/
/**/                                                                                      /*259376*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)                              /*259376*/
/**/                                                                                      /*259376*/
/** Database error handling                                        */                     /*259376*/
/**/                                                                                      /*259376*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                                /*259376*/
             SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                                                  /*259376*/
             GOTO       CMDLBL(ABNOR)                                                     /*259376*/
             ENDDO                                                                        /*259376*/
                                                                                          /*259376*/
             OVRDBF     FILE(DEALS) SHARE(*NO)                                            /*259376*/
/** If Correspondence manager is switched on, override files       */                     /*259376*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*259376*/
                                                                                          /*259376*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*259376*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*259376*/
                                                                                          /*259376*/
             CALL       PGM(CG4000) PARM(&W0RTN &W0CMT)                                   /*259376*/
                                                                                          /*259376*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)                               /*259376*/
             SNDPGMMSG  MSG('User Defined Correspondence Extract +
                          failure') TOPGMQ(*EXT)                                          /*259376*/
             ROLLBACK                                                                     /*259376*/
             GOTO       CMDLBL(ABNOR)                                                     /*259376*/
             ENDDO                                                                        /*259376*/
                                                                                          /*259376*/
/** If Correspondence manager is switched on, call custom defined  */                     /*259376*/
/** extract program                                                */                     /*259376*/
                                                                                          /*259376*/
             CALL       PGM(CGC3604)                                                      /*259376*/
                                                                                          /*259376*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*259376*/
             SNDPGMMSG  MSG('Correspondence Manager Custom-Defined +
                          Data Extract failed') TOPGMQ(*EXT)                              /*259376*/
             GOTO       CMDLBL(ABNOR)                                                     /*259376*/
             ENDDO                                                                        /*259376*/
             ENDDO                                                                        /*259376*/
                                                                                          /*259376*/
/**/
/*   SUCCESSFUL COMPLETION - DELETE JOURNAL & RECEIVER  */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/* If Feature CCB009 is NOT 'on' (close of business journaling) */
/**/
             IF         COND(&CCB009 *NE '       ') THEN(DO)
                ENDJRNPF   FILE(*ALL) JRN(JDLC5350)
                DLTJRN     JDLC5350
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRDLC5350
                CHGJOB     INQMSGRPY(*RQD)
             ENDDO
 
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')
 
             ENDDO
 
     IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
 
     RTVDTAARA DTAARA(LDA) RTNVAR(&LDA)
     CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
     SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) TOMSGQ(MOPERQ)
     GOTO CMDLBL(ABNOR)
 
     ENDDO
 
     IF COND(%SWITCH(XXXXXX01)) THEN(DO)
 
/**/
/* If Feature CCB009 is 'on' (close of business journaling) */
/**/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)
/**/
/*  Retrieve attributes of current job */
/**/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)
/**/
/*  Retrieve the most recent journal entry sequence number  */
/*  for the specific job.                                   */
/**/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             CHGVAR     VAR(&START) VALUE(0)
             ENDDO
/**/
/*  Retrieve the first journal entry sequence number  */
/*  for the specific job.                             */
/**/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*FIRST) +
                          TOENT(*LAST) SEARCH(*ASCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&FINISH)
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             CHGVAR     VAR(&FINISH) VALUE(0)
             ENDDO
/**/
/*  Remove journaled changes.    */
/**/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)
             RMVJRNCHG  JRN(ICJRN) FILE((MMDELDPP) (MMDENSPP) +
                          (MMDENBPP) (DEALSDB) (DEALSDC) (DEALSDD) +
                          (DEALSDE) (DEALSDF) (DEALSDG) (DTRIXHH) +
                          (DTRIXDD) ) +
                          FROMENT(&START) TOENT(&FINISH)
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
 
             ENDDO
             ENDDO
 
             ELSE       CMD(DO)
 
     SNDPGMMSG MSG('FILE CONTROLS OUT OF BALANCE') TOMSGQ(MOPERQ) -
MSGTYPE(*INFO)
 
     GOTO CMDLBL(ENDPGM)
     ENDDO
 
     ENDJRNPF FILE(*ALL) JRN(JDLC5350)
 
     DLTJRN JRN(JDLC5350)
     CHGJOB INQMSGRPY(*DFT)
 
     DLTJRNRCV JRNRCV(JRDLC5350)
     CHGJOB INQMSGRPY(*RQD)
 
             ENDDO
 
     CHGVAR     VAR(&STAT) VALUE('N')
     CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
     GOTO CMDLBL(ENDPGM)
 
ABNOR: +
     RMVM FILE(MMDEAULL) MBR(MMDEAULL)
     MONMSG MSGID(CPF0000)
 
     RMVM FILE(DEALS) MBR(DEALS)
     MONMSG MSGID(CPF0000)
 
     RMVM FILE(SDTIX) MBR(SDTIX)
     MONMSG MSGID(CPF0000)
 
     RMVJRNCHG JRN(JDLC5350) FILE((MMDELDPP) (MMDENSPP) (MMDENBPP))
     MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
     RMVJRNCHG JRN(JDLC5350) FILE((DEALSDB) (DEALSDC) (DEALSDD) -
                  (DEALSDE) (DEALSDF) (DEALSDG))
     MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
     RMVJRNCHG JRN(JDLC5350) FILE((DTRIXHH) (DTRIXDD))
     MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
     ADDLFM FILE(DEALS) MBR(DEALS)
     MONMSG MSGID(CPF0000)
                                                                                         /*BUG4122*/
     ADDLFM FILE(MMDEAULL) MBR(MMDEAULL)                                                 /*BUG4122*/
     MONMSG MSGID(CPF0000)                                                               /*BUG4122*/
                                                                                         /*BUG4122*/
     ADDLFM FILE(SDTIX) MBR(SDTIX)                                                       /*BUG4122*/
     MONMSG MSGID(CPF0000)                                                               /*BUG4122*/
 
/**/                                                                                      /*259376*/
/** If Correspondence manager is switched on, delete overrides     */                     /*259376*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*259376*/
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                    /*259376*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*259376*/
             ENDDO                                                                        /*259376*/
/* */                                                                                     /*259376*/
/**/
/* If Feature CCB009 is NOT 'on' (close of business journaling) */
/**/
             IF         COND(&CCB009 *NE '       ') THEN(DO)
 
     ENDJRNPF FILE(*ALL) JRN(JDLC5350)
 
     DLTJRN JRN(JDLC5350)
 
     CHGJOB INQMSGRPY(*DFT)
 
     DLTJRNRCV JRNRCV(JRDLC5350)
 
     CHGJOB INQMSGRPY(*RQD)
 
     ADDLFM     FILE(MMDEAULL) MBR(MMDEAULL) SHARE(*YES)
     MONMSG MSGID(CPF0000)
 
     ADDLFM FILE(DEALS) MBR(DEALS)
     MONMSG MSGID(CPF0000)
 
     ADDLFM FILE(SDTIX) MBR(SDTIX)
     MONMSG MSGID(CPF0000)
 
             ENDDO
 
             ELSE       CMD(DO)
/**/
/*  Retrieve attributes of current job */
/**/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)
/**/
/*  Retrieve the most recent journal entry sequence number  */
/*  for the specific job.                                   */
/**/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             CHGVAR     VAR(&START) VALUE(0)
             ENDDO
/**/
/*  Retrieve the first journal entry sequence number   */
/*  for the specific job.                              */
/**/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*FIRST) +
                          TOENT(*LAST) SEARCH(*ASCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&FINISH)
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             CHGVAR     VAR(&FINISH) VALUE(0)
             ENDDO
/**/
/*  Remove journaled changes */
/**/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)
 
/**********  RMVJRNCHG  JRN(ICJRN) FILE((MMDELDPP) (MMDENSPP) +                        */ /*243473*/
/**********               (MMDENBPP) (DEALSDB) (DEALSDC) (DEALSDD) +                   */ /*243473*/
/**********               (DEALSDE) (DEALSDF) (DEALSDG) (DTRIXHH) +                    */ /*243473*/
/**********               (DTRIXDD) ) +                                                */ /*243473*/
/**********               FROMENT(&START) TOENT(&FINISH)                               */ /*243473*/
             RMVJRNCHG  JRN(ICJRN) FILE((MMDELDPP) (MMDENSPP) +
                          (MMDENBPP) (DEALSDB) (DEALSDC) (DEALSDD) +
                          (DEALSDE) (DEALSDF) (DEALSDG) (DTRIXHH) +
                          (DTRIXDD) ) +
                          FROMENT(&START) TOENT(&FINISH) +
                          CMTBDY(*NO)                                                     /*243473*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
 
/*/COPY WNCPYSRC,DLH00325                                            */
             ENDDO
             ENDDO
 
     CHGVAR     VAR(&STAT) VALUE('N')
     CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM: +
     ENDPGM
