/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Bulk Retail Account Maintenance - Call update pgms')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Retail Utilities                                */
/*                                                                   */
/*       EUC0120 - Bulk Retail Account Maintenance                   */
/*               - Calls update programs                             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 238788             Date 23Mar06              */
/*                      CER001             Date 25Apr05              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      137253             Date 18Jun98              */
/*                      CEU022  *CREATE    Date  5Jan98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       238788 - Ensure that the global files are closed before     */
/*                ENDCMTCTL command to prevent EUC0120 from looping. */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       137253 - GOTO command moved to ensure that abnormal proc.   */
/*                is bypassed if there are no errors                 */
/*       CEU022 - EMU Retail Utilities                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MAPN &OPTN)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DBER) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MAPN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(6)
/*/COPY WNCPYSRC,EUC0120003                                          */
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CER001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CER001*/
             DCL        VAR(&ULX004) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CER001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CER001*/
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(7)                                      /*CER001*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
             IF         COND(&OPTN = 'OPEN') THEN(CALL PGM(EU0140) +
                          PARM(&MAPN))
 
/*/COPY WNCPYSRC,EUC0120004                                          */
                                                                                          /*CER001*/
             CHGVAR     VAR(&OPT) VALUE('*VERIFY')                                        /*CER001*/
             CHGVAR     VAR(&SAR) VALUE('ULX004')                                         /*CER001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CER001*/
                                                                                          /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPT &SAR &SCSARD)                       /*CER001*/
                                                                                          /*CER001*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CER001*/
             CHGVAR     VAR(&ULX004) VALUE('Y')                                           /*CER001*/
             ENDDO                                                                        /*CER001*/
                                                                                          /*CER001*/
             IF         COND((&OPTN = 'OPEN') *AND +
                          (%SWITCH(XXXXXX00) *AND (&ULX004 *EQ +
                          'Y'))) THEN(DO)                                                 /*CER001*/
             CALL       PGM(EUU001) PARM(&MAPN)                                           /*CER001*/
             ENDDO                                                                        /*CER001*/
 
             IF         COND(&OPTN = 'SWEEP') THEN(CALL PGM(EU0150) +
                          PARM(&MAPN))
 
             IF         COND(&OPTN = 'CLOSE') THEN(CALL PGM(EU0160) +
                          PARM(&MAPN))
 
/*/COPY WNCPYSRC,EUC0120005                                          */
             IF         COND(&OPTN = 'GUAR') THEN(CALL PGM(EUU001) +
                          PARM(&MAPN))                                                    /*CER001*/
/**/
/*    Error processing                                               */
/*    Retrieve LDA and store values                                  */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&DBER) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DBER) +
                           TOMSGQ(MOPERQ MRUNQ)
/*********** GOTO       CMDLBL(END)                          /*137253*/
             ENDDO
 
             GOTO       CMDLBL(END)                          /*137253*/
 
/*     Abnormal termination                                          */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('EUC0120 - EMU Batch Job Ended +
                          Abnormally') TOMSGQ(MOPERQ MRUNQ)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
/*     Normal termination                                            */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:
/*/COPY WNCPYSRC,EUC0120001                                          */
             RCLRSC                                                                       /*238788*/
             ENDCMTCTL
/*/COPY WNCPYSRC,EUC0120002                                          */
             ENDPGM
