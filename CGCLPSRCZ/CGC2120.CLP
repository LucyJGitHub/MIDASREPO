/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Purge UDC data')                             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2120  - Purge UDC data                                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Jul99              */
/*                      079860             Date 07Dec94              */
/*                      S01522             DATE 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       079860 - STRCMTCTL should be *CHG                           */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COMP_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTN_CDE) TYPE(*CHAR) LEN(10)                                 /*CCG015*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CCG015*/
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(7)                                   /*CCG015*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CCG015*/
             DCL        VAR(&CCG015) TYPE(*CHAR) LEN(1)                                   /*CCG015*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2120 - Purge UDC data') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Start Commitment Control */
/* */
/************STRCMTCTL  LCKLVL(*ALL)                                    *79860*/
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))       /*79860CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF8351)
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
                                                                                          /*CCG015*/
/** Determine if CCG015 is installed */                                                   /*CCG015*/
                                                                                          /*CCG015*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                                     /*CCG015*/
             CHGVAR     VAR(&OPTION) VALUE('*VERIFY')                                     /*CCG015*/
             CHGVAR     VAR(&SARD) VALUE('CCG015')                                        /*CCG015*/
                                                                                          /*CCG015*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTION &SARD)                         /*CCG015*/
             IF         COND(&RTNCDE *EQ '       ') THEN(CHGVAR +
                          VAR(&CCG015) VALUE('Y'))                                        /*CCG015*/
/* */
/* Get run status */
/* */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* If status is active - Perform recovery */
/* */
             IF         COND(&STATUS *NE 'N') THEN(DO)
             ENDDO
/* */
/* Update status to Active */
/* */
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* Run CG2010 - Purge UDC data */
/* */
             CALL       PGM(CG2010) PARM(&RTN_CODE)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/                                                                                      /*CCG015*/
/** Do purging directories processing when CCG015 is Installed */                         /*CCG015*/
/**/                                                                                      /*CCG015*/
             IF         COND(&CCG015 *EQ 'Y') THEN(DO)                                    /*CCG015*/
                 CHGVAR   VAR(&RTN_CDE) VALUE('          ')                               /*CCG015*/
                 CALL     PGM(CG3632) PARM(&RTN_CDE)                                      /*CCG015*/
                                                                                          /*CCG015*/
                 IF       COND(%SWITCH(XXXXXX11) *OR (&RTN_CDE *NE '       ')) +
                 THEN(DO)                                                                 /*CCG015*/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)                          /*CCG015*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                 /*CCG015*/
                   GOTO       CMDLBL(ABNORMAL)                                            /*CCG015*/
                 ENDDO                                                                    /*CCG015*/
             ENDDO                                                                        /*CCG015*/
/* */
/* Update status to Not Active - component finished */
/* */
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2120 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2120 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
