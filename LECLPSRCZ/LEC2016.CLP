/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Loan Manager drip feed control program')     */
/********************************************************************/
/*                                                                  */
/*  Midas   - Customer Lending Module                               */
/*                                                                  */
/*  LEC2016 - Lending PC Front-End Drip Feed Control Program        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD054605           Date 17Oct19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE035             Date 22Sep03              */
/*                 BUG7286           Date  23May05                  */
/*                 CSC020            Date  31Mar04                  */
/*                 CLE034            Date  31May03                  */
/*                 216709            Date  07Apr03                  */
/*                 CLE031            Date  19Mar03                  */
/*                 215668            Date  07Mar03                  */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                 203561            Date  19Jun02                  */
/*                 205489            Date  03May02                  */
/*                 205491            Date  03May02                  */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                 199932            Date  08NOV01                  */
/*                 196343            Date  31JUL01                  */
/*                 194768            Date  22JUN01                  */
/*                 CCB009            Date  22JUN01                  */
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                 175213            Date  18Feb99                  */
/*                 166453            Date  17Aug99                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                 CLE005            Date  22May97                  */
/*                 126384            Date  21Nov97                  */
/*                 122658            DATE  03OCT97                  */
/*                 122660            DATE  10SEP97                  */
/*                 CLE004  *CREATE   DATE  27FEB97                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD054605 - Deliverable Data Split for SDSVALPD              */
/*       MD046248 - Finastra Rebranding                              */
/*  CCB020 - COB Restructure - Secondary COB Infrastructure         */
/*  CLE035 - Lending Enhancements for Nordea Phase 1 Priority 2:    */
/*           Income Splits                                          */
/*       BUG7286 - Error in SCRTVJEVT command                        */
/*  CSC020 - Journaling changes for MidasPlus.                      */
/*  CLE034 - Settlement Allocations                                 */
/*  216709 - Do not send job shutdown message to Loan Manager if    */
/*           phase is not 'A'                                       */
/*  CLE031 - Head Office Lending Enhancements                       */
/*  215668 - SCSARDPD added to list of files to be included when    */
/*           reading the journal. Component rewritten for clarity   */
/*  203561 - Loan Manager must be sent a message when the drip feed */
/*           job is stopped or started                              */
/*  205489 - Processing to continue processing when journal         */
/*           is changed.                                            */
/*  205491 - Error in checking validity of journal sequence number  */
/*           from data area LEJNSQ.  Check directly to see if       */
/*           sequence is valid.                                     */
/*  199932 - Check that LEJNSQ value is not lower than the lowest   */
/*           value in the receiver range                            */
/*  196343 - RCVJRNE should specify RCVRNG(ICRCV001 *CURRENT) so    */
/*           that out of range problems are avoided, especially if  */
/*           CCB009 is switched on                                  */
/*  194768 - Program should terminate gracefully if the sequence    */
/*           number on data area LEJNSQ is outside current range    */
/*  CCB009 - Include MUSERDD in list if 24hr journaling (CCB009) on */
/*  175213 - MUSERDD should not be included in the list of files    */
/*           which are specified on the RTVJRNE command             */
/*  166453 - Cannot alocate LEDRIP during re-open of the I/C        */
/*  CLE005 - Customer Lending Enhancements - Others (T3).           */
/*  126384 - Do not drip feed the swichable features file           */
/*  122658 - LEC2016 is not ending.                                 */
/*  122660 - Monitor for start sequence number greater than last.   */
/*  CLE004 - Customer Lending Enhancements - Syndications.          */
/*                                                                  */
/********************************************************************/
             PGM

             DCL        VAR(&WLEJNSQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P#RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WORK) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&LJNSQ) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&RCVSAV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURRRCV) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)                          */ /*216709 CCB020*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(4)                                    /*CCB020*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        &STRRCV  TYPE(*CHAR)  LEN(10)                                     /*CSC020*/
             DCL        VAR(&STRSEQ) TYPE(*DEC) LEN(10 0)                                /*BUG7286*/
/*/COPY WNCPYSRC,LEC2016001                                          */

/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitorred message occurs perform error processing     */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     SWS(00000000)
/*                                                                                          CSC020*/
/*  Determine journal receiver of next day set up.                                          CSC020*/
/*  (Equivalent to ICRCV001 in previous releases)                                           CSC020*/
/*                                                                                          CSC020*/
/************SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV)                           *CSC020**BUG7286*/
             SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV) SEQ(&STRSEQ)                     /*BUG7286*/
/*                                                                                          CSC020*/
/*  If no value returned, then set receiver to first available.                             CSC020*/
/*                                                                                          CSC020*/
             IF         COND(&STRRCV *EQ '          ') THEN(DO)                           /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNRCV(&STRRCV)                                                 /*CSC020*/
             ENDDO                                                                        /*CSC020*/

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)

             ALCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD)) WAIT(30)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                SNDPGMMSG  MSG('Attempt to start Lending Drip Feed +
                           process has failed: process already active') +
                           TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO


/* Send a message to all Loan Manager servers to indicate that the */
/* drip feed job has started                                       */

             CALL       PGM(LEC2017) PARM(&P#RTCD 'STRD' 'ALL' '   ')
             IF         COND(%SWITCH(XXXXXX11) *OR (&P#RTCD *NE +
                          '*SENT')) THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&P#RTCD) VALUE('       ')


 START:

/* Get last sequence number used from journal */

             RTVDTAARA  DTAARA(LEJNSQ (1 10)) RTNVAR(&WLEJNSQ)

/* Check if last sequence number read as held on LEJNSQ is valid */
/* for current receiver range                                    */

             CHGVAR     VAR(&WORK) VALUE(&WLEJNSQ)
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(&WORK) +
                          TOENT(&WORK) SEARCH(*DESCEND)
             MONMSG     MSGID(CPF7054) EXEC(DO)
                SNDPGMMSG  MSG('value on data area LEJNSQ (which +
                   should represent the last sequence number +
                   read from the journal) is outside the +
                   current receiver range') TOMSGQ(MOPERQ MRUNQ)
                GOTO CMDLBL(ABNOR)
             ENDDO

/*   Determine currently attached receiver and save the value.   */
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) SEARCH(*DESCEND) +
                          RTNRCV(&RCVSAV)
             MONMSG     MSGID(CPF7073)
/*   Add 1 to set up first journal sequence number of the range of */
/*   sequence numbers which have not yet been read                 */

             CHGVAR     VAR(&LJNSQ) VALUE(&WORK + 1)

/*/COPY WNCPYSRC,LEC2016002                                          */
/*/COPY WNCPYSRC,LEC2016OMT                                          */

/**********  RCVJRNE    JRN(ICJRN) EXITPGM(LE2016) FILE((FCLTYFM) +
/**********               (FCLTYFN) (CLOANCL) (CLOANCK) (LOAMSDK) +
/**********               (ACCNTAB) (SDMMODPD) (SDBANKPD) +
/**********               (SDGELRPD) (SDRETLPD) (SDCLNDPD) +
/**********               (SDPORTPD) (SDCUSTPD) (SDALTNPD) +
/**********               (SDFACTPD) (SDBRCHPD) (SDCURRPD) +
/**********               (SDCTRYPD) (SDINDSPD) (SDACOFPD) +
/**********               (SDPRFCPD) (SDPRFMPD) (SDBOOKPD) +
/**********               (SDLOANPD) (SDBSRTPD) (SDBSHSPD) +
/**********               (SDNOSTPD) (SDCNSTPD) (SDEXSTPD) +
/**********               (PMPORTPD) (SDPLCSPD) (SDHOLPD) +
/**********               (SDCODEPD) (SDTRADPD) (SDCCSYPD) +
/**********               (LEPARTPD) (SDPCACPD) (LEFCAMPD) +
/**********               (LEFEEAD) (SDFEEPD) (MUSERDD) (LEFEED) +
/**********               (SCSARDPD)) RCVRNG(ICRCV001 *CURRENT) +
/**********               FROMENT(&LJNSQ) JRNCDE((U) (R)) ENTTYP(PT +
/**********               UP DL UR DR YJ YE) DELAY(*NEXTENT) */           /*CLE031*/
/**********  RCVJRNE    JRN(ICJRN) EXITPGM(LE2016) FILE((FCLTYFM) +                       /*CLE034*/
/**********               (FCLTYFN) (CLOANCL) (CLOANCK) (LOAMSDK) +                       /*CLE034*/
/**********               (ACCNTAB) (SDMMODPD) (SDBANKPD) +                               /*CLE034*/
/**********               (SDGELRPD) (SDRETLPD) (SDCLNDPD) +                              /*CLE034*/
/**********               (SDPORTPD) (SDCUSTPD) (SDALTNPD) +                              /*CLE034*/
/**********               (SDFACTPD) (SDBRCHPD) (SDCURRPD) +                              /*CLE034*/
/**********               (SDCTRYPD) (SDINDSPD) (SDACOFPD) +                              /*CLE034*/
/**********               (SDPRFCPD) (SDPRFMPD) (SDBOOKPD) +                              /*CLE034*/
/**********               (SDLOANPD) (SDBSRTPD) (SDBSHSPD) +                              /*CLE034*/
/**********               (SDNOSTPD) (SDCNSTPD) (SDEXSTPD) +                              /*CLE034*/
/**********               (PMPORTPD) (SDPLCSPD) (SDHOLPD) +                               /*CLE034*/
/**********               (SDCODEPD) (SDTRADPD) (SDCCSYPD) +                              /*CLE034*/
/**********               (LEPARTPD) (SDPCACPD) (LEFCAMPD) +                              /*CLE034*/
/**********               (LEFEEAD) (SDFEEPD) (MUSERDD) (LEFEED) +                        /*CLE034*/
/**********               (SCSARDPD) (SDSVALPD)) RCVRNG(ICRCV001 +                        /*CLE034*/
/**********               *CURRENT) FROMENT(&LJNSQ) JRNCDE((U) (R)) +                     /*CLE034*/
/**********               ENTTYP(PT UP DL UR DR YJ YE) DELAY(*NEXTENT)         /*CLE031*/ /*CLE034*/
/**/
/********    RCVJRNE    JRN(ICJRN) EXITPGM(LE2016) FILE((FCLTYFM) +                         CSC020*/
/********                 (FCLTYFN) (CLOANCL) (CLOANCK) (LOAMSDK) +                         CSC020*/
/********                 (ACCNTAB) (SDMMODPD) (SDBANKPD) +                                 CSC020*/
/********                 (SDGELRPD) (SDRETLPD) (SDCLNDPD) +                                CSC020*/
/********                 (SDPORTPD) (SDCUSTPD) (SDALTNPD) +                                CSC020*/
/********                 (SDFACTPD) (SDBRCHPD) (SDCURRPD) +                                CSC020*/
/********                 (SDCTRYPD) (SDINDSPD) (SDACOFPD) +                                CSC020*/
/********                 (SDPRFCPD) (SDPRFMPD) (SDBOOKPD) +                                CSC020*/
/********                 (SDLOANPD) (SDBSRTPD) (SDBSHSPD) +                                CSC020*/
/********                 (SDNOSTPD) (SDCNSTPD) (SDEXSTPD) +                                CSC020*/
/********                 (PMPORTPD) (SDPLCSPD) (SDHOLPD) +                                 CSC020*/
/********                 (SDCODEPD) (SDTRADPD) (SDCCSYPD) +                                CSC020*/
/********                 (LEPARTPD) (SDPCACPD) (LEFCAMPD) (LESTALPD) +                     CSC020*/
/********                 (LEFEEAD) (SDFEEPD) (MUSERDD) (LEFEED) +                          CSC020*/
/********                 (SCSARDPD) (SDSVALPD)) RCVRNG(ICRCV001 +                          CSC020*/
/********                 *CURRENT) FROMENT(&LJNSQ) JRNCDE((U) (R)) +                       CSC020*/
/********                 ENTTYP(PT UP DL UR DR YJ YE) DELAY(*NEXTENT)               CLE034 CSC020*/
/**********                                                         */             /*CSC020 CLE035*/
/**********  RCVJRNE    JRN(ICJRN) EXITPGM(LE2016) FILE((FCLTYFM) + */             /*CSC020 CLE035*/
/**********               (FCLTYFN) (CLOANCL) (CLOANCK) (LOAMSDK) + */             /*CSC020 CLE035*/
/**********               (ACCNTAB) (SDMMODPD) (SDBANKPD) +         */             /*CSC020 CLE035*/
/**********               (SDGELRPD) (SDRETLPD) (SDCLNDPD) +        */             /*CSC020 CLE035*/
/**********               (SDPORTPD) (SDCUSTPD) (SDALTNPD) +        */             /*CSC020 CLE035*/
/**********               (SDFACTPD) (SDBRCHPD) (SDCURRPD) +        */             /*CSC020 CLE035*/
/**********               (SDCTRYPD) (SDINDSPD) (SDACOFPD) +        */             /*CSC020 CLE035*/
/**********               (SDPRFCPD) (SDPRFMPD) (SDBOOKPD) +        */             /*CSC020 CLE035*/
/**********               (SDLOANPD) (SDBSRTPD) (SDBSHSPD) +        */             /*CSC020 CLE035*/
/**********               (SDNOSTPD) (SDCNSTPD) (SDEXSTPD) +        */             /*CSC020 CLE035*/
/**********               (PMPORTPD) (SDPLCSPD) (SDHOLPD) +         */             /*CSC020 CLE035*/
/**********               (SDCODEPD) (SDTRADPD) (SDCCSYPD) +        */             /*CSC020 CLE035*/
/**********               (LEPARTPD) (SDPCACPD) (LEFCAMPD) +        */             /*CSC020 CLE035*/
/**********               (LESTALPD) (LEFEEAD) (SDFEEPD) (MUSERDD) +*/             /*CSC020 CLE035*/
/**********               (LEFEED) (SCSARDPD) (SDSVALPD)) +         */             /*CSC020 CLE035*/
/**********               RCVRNG(&STRRCV *CURRENT) FROMENT(&LJNSQ) +*/             /*CSC020 CLE035*/
/**********               JRNCDE((U) (R)) ENTTYP(PT UP DL UR DR YJ +*/             /*CSC020 CLE035*/
/**********               YE) DELAY(*NEXTENT)                       */             /*CSC020 CLE035*/
/**********  RCVJRNE    JRN(ICJRN) EXITPGM(LE2016) FILE((FCLTYFM) + */                  /*MD054605*/
/**********               (FCLTYFN) (CLOANCL) (CLOANCK) (LOAMSDK) + */                  /*MD054605*/
/**********               (ACCNTAB) (SDMMODPD) (SDBANKPD) +         */                  /*MD054605*/
/**********               (SDGELRPD) (SDRETLPD) (SDCLNDPD) +        */                  /*MD054605*/
/**********               (SDPORTPD) (SDCUSTPD) (SDALTNPD) +        */                  /*MD054605*/
/**********               (SDFACTPD) (SDBRCHPD) (SDCURRPD) +        */                  /*MD054605*/
/**********               (SDCTRYPD) (SDINDSPD) (SDACOFPD) +        */                  /*MD054605*/
/**********               (SDPRFCPD) (SDPRFMPD) (SDBOOKPD) +        */                  /*MD054605*/
/**********               (SDLOANPD) (SDBSRTPD) (SDBSHSPD) +        */                  /*MD054605*/
/**********               (SDNOSTPD) (SDCNSTPD) (SDEXSTPD) +        */                  /*MD054605*/
/**********               (PMPORTPD) (SDPLCSPD) (SDHOLPD) +         */                  /*MD054605*/
/**********               (SDCODEPD) (SDTRADPD) (SDCCSYPD) (LETISPPD) + */              /*MD054605*/
/**********               (LEPARTPD) (SDPCACPD) (LEFCAMPD) +        */                  /*MD054605*/
/**********               (LESTALPD) (LEFEEAD) (SDFEEPD) (MUSERDD) +*/                  /*MD054605*/
/**********               (LEFEED) (SCSARDPD) (SDSVALPD)) +         */                  /*MD054605*/
/**********               RCVRNG(&STRRCV *CURRENT) FROMENT(&LJNSQ) +*/                  /*MD054605*/
/**********               JRNCDE((U) (R)) ENTTYP(PT UP DL UR DR YJ +*/                  /*MD054605*/
/**********               YE) DELAY(*NEXTENT)                       */           /*CLE035 MD054605*/
             RCVJRNE    JRN(ICJRN) EXITPGM(LE2016) FILE((FCLTYFM) +
                          (FCLTYFN) (CLOANCL) (CLOANCK) (LOAMSDK) +
                          (ACCNTAB) (SDMMODPD) (SDBANKPD) +
                          (SDGELRPD) (SDRETLPD) (SDCLNDPD) +
                          (SDPORTPD) (SDCUSTPD) (SDALTNPD) +
                          (SDFACTPD) (SDBRCHPD) (SDCURRPD) +
                          (SDCTRYPD) (SDINDSPD) (SDACOFPD) +
                          (SDPRFCPD) (SDPRFMPD) (SDBOOKPD) +
                          (SDLOANPD) (SDBSRTPD) (SDBSHSPD) +
                          (SDNOSTPD) (SDCNSTPD) (SDEXSTPD) +
                          (PMPORTPD) (SDPLCSPD) (SDHOLPD) +
                          (SDCODEPD) (SDTRADPD) (SDCCSYPD) (LETISPPD) +
                          (LEPARTPD) (SDPCACPD) (LEFCAMPD) +
                          (LESTALPD) (LEFEEAD) (SDFEEPD) (MUSERDD) +
                          (LEFEED) (SCSARDPD) (SDSVLXTD)) +
                          RCVRNG(&STRRCV *CURRENT) FROMENT(&LJNSQ) +
                          JRNCDE((U) (R)) ENTTYP(PT UP DL UR DR YJ +
                          YE) DELAY(*NEXTENT)                                           /*MD054605*/
/**/
/* If lock prevents access to the journal or no new entries on ICJRN */
/**/
             MONMSG     MSGID(CPF9803 CPF7054) EXEC(DO)
                DLYJOB     DLY(5)
                GOTO       CMDLBL(START)
                ENDDO
             MONMSG     MSGID(CPF7062)

/*/COPY WNCPYSRC,LEC2016003                                          */

/* Current journal receiver is about to change                       */

             IF         COND(%SWITCH(XXXXX100)) THEN(DO)
             CHGJOB     SWS(00000000)
               DLYJOB     DLY(30)

/*   Processing to avoid termination if journal receiver changed. */
/*   Determine currently attached receiver.                       */

               RTVJRNE    JRN(ICJRN) SEARCH(*DESCEND) RTNRCV(&CURRRCV)
               MONMSG     MSGID(CPF7073)
/*   If receiver is different from when last checked, restart processing. */
               IF         COND(&CURRRCV *NE &RCVSAV) THEN(DO)
                 GOTO       CMDLBL(START)
               ENDDO
             ENDDO

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             GOTO       CMDLBL(END)

/*     Abnormal termination                                          */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Lending Drip Feed Process +
                          has ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)

/*     Normal termination                                            */
 END:
             DLCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/**********  RTVDTAARA  DTAARA(MPHAS *ALL) RTNVAR(&PHASE)                       */ /*216709 CCB020*/
             CALL       PGM(CBCNNN001) PARM(&MPHAS)                                       /*CCB020*/
/**********  IF         COND(&PHASE *EQ 'A') THEN(DO)                           */ /*216709 CCB020*/
             IF         COND(&MPHAS *EQ '*NO ') THEN(DO)                                  /*CCB020*/
             CALL       PGM(LEC2017) PARM(&P#RTCD 'ENDD' 'ALL' '   ')
             ENDDO                                                                        /*216709*/

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
