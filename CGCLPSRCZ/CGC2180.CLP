/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Funds transfer debit/credit advices')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2180  - Funds Transfer Debit/Credit Advices              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 211713             Date 08Nov02              */
/*                      207984             Date 31Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CFT009             Date 01Jun00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/*                      CFT008             Date 04Jan00              */
/*                      CFT006             Date 19Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      086130             Date 29Mar95              */
/*                      S01522             Date 15Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       211713 - ENDJRNPF on JRN/CGCOBJRN not required if CCB009    */
/*                is not present.                                    */
/*       207984 - Initialise &SARD before calling AOSARDR0.          */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       CFT009 - FT Fees and Charge Development-Recompiled          */
/*       CCB009 - Journal files throughout close of business         */
/*       CFT008 - Funds Transfer/Swift Messages MT102                */
/*       CFT006 - Funds Transfer/Swift Messages MT101                */
/*       086130 - Correct Endjrn in recovery processing              */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ &EXTRACT &MEMBER +
                          &COMMIT_OPT)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&COMP_NAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ)   TYPE(*DEC)  LEN(5)
             DCL        VAR(&COMP_SEQA)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&EXTRACT)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMMIT_OPT) TYPE(*CHAR) LEN(3)
/* */
             DCL        VAR(&RTN_CODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&STATUS)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_DATA)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CFT006')                             /*CFT006*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CFT006*/
             DCL        VAR(&SARD1) TYPE(*CHAR) LEN(6) +
                          VALUE('CFT008')                             /*CFT008*/
             DCL        VAR(&RTCD1) TYPE(*CHAR) LEN(7)                /*CFT008*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CFT006*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
 
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2180 - Funds Transfer Debit/Credit +
                          Advices') TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
             CHGJOB     SWS(XXXXX000)
 
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
 
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        MONMSG     MSGID(CPF1023)
 
             CHGVAR     VAR(&SARD) VALUE('CFT006')                                        /*207984*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)         /*CFT006*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                         /*CFT006*/
                 SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                               TOMSGQ(MOPERQ)                         /*CFT006*/
                 CHGJOB     SWS(XXXXXX11)                             /*CFT006*/
                 GOTO       CMDLBL(ENDPGM)                            /*CFT006*/
             ENDDO                                                    /*CFT006*/
                                                                      /*CFT008*/
             CHGVAR     VAR(&SARD1) VALUE('CFT008')                                       /*207984*/
             CALL       PGM(AOSARDR0) PARM(&RTCD1 &OPTN &SARD1)       /*CFT008*/
             IF         COND(&RTCD1 *NE '       ' *AND &RTCD1 *NE +
                          '*NRF   ') THEN(DO)                         /*CFT008*/
                 SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                               TOMSGQ(MOPERQ)                         /*CFT008*/
                 CHGJOB     SWS(XXXXXX11)                             /*CFT008*/
                 GOTO       CMDLBL(ENDPGM)                            /*CFT008*/
             ENDDO                                                    /*CFT008*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* */
/* Journal Files to CGCOBJRN */
/* */
             STRJRNPF   FILE(CQCODDD CQCOCDD CQPACDD CQPADDD INPAYDD +
                          OTPAYDD) JRN(CGCOBJRN) IMAGES(*BOTH)
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CFT006*/
                  STRJRNPF   FILE(FT101HPD) JRN(CGCOBJRN) +
                                 IMAGES(*BOTH)                        /*CFT006*/
             ENDDO                                                    /*CFT006*/
/* */                                                                 /*CFT008*/
             IF         COND(&RTCD1 *EQ '       ') THEN(DO)           /*CFT008*/
                  STRJRNPF   FILE(FT102HPD) JRN(CGCOBJRN) +
                                 IMAGES(*BOTH)                        /*CFT008*/
             ENDDO                                                    /*CFT008*/
             ENDDO                                                    /*CCB009*/
                                                                                          /*CCG015*/
/** Call Extract File Instance Management */                                              /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
                                                                                          /*CCG015*/
/* */
/* Run Extract Component */
/* */
             CHGVAR     VAR(&COMP_SEQA) VALUE(&COMP_SEQ)
             CHGVAR     VAR(&MSG_DATA) VALUE(&COMP_NAME *CAT +
                          &COMP_SEQA *CAT &EXTRACT *CAT &MEMBER +
                          *CAT &COMMIT_OPT)
             SNDPGMMSG  MSGID(CGD1271) MSGF(CGUSRMSG) +
                          MSGDTA(&MSG_DATA) TOPGMQ(*PRV)
             CALL       PGM(CG4620) PARM(&RTN_CODE &COMMIT_OPT)
             ROLLBACK
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
                                                                                          /*CCG015*/
/** Call Custom Defined Data Extract pgm */                                               /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)                             /*CCG015*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                     /*CCG015*/
                GOTO       CMDLBL(ABNORMAL)                                               /*CCG015*/
             ENDDO                                                                        /*CCG015*/
                                                                                          /*CCG015*/
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
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(CQCODDD CQCOCDD CQPACDD CQPADDD INPAYDD +
                          OTPAYDD) JRN(CGCOBJRN)                      /*086130*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*086130*/
             ENDDO                                                    /*CCB009*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CFT006*/
                  ENDJRNPF   FILE(FT101HPD) JRN(CGCOBJRN)             /*CFT006*/
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)           /*CFT006*/
             ENDDO                                                    /*CFT006*/
             IF         COND(&RTCD1 *EQ '       ') THEN(DO)           /*CFT008*/
                  ENDJRNPF   FILE(FT102HPD) JRN(CGCOBJRN)             /*CFT008*/
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)           /*CFT008*/
             ENDDO                                                    /*CFT008*/
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2180 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2180 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             IF         COND(&CCB009 *NE '       ') THEN(DO)                              /*211713*/
             ENDJRNPF   FILE(CQCODDD CQCOCDD CQPACDD CQPADDD INPAYDD +
                          OTPAYDD) JRN(CGCOBJRN)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CFT006*/
                  ENDJRNPF   FILE(FT101HPD) JRN(CGCOBJRN)             /*CFT006*/
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)           /*CFT006*/
             ENDDO                                                    /*CFT006*/
             IF         COND(&RTCD1 *EQ '       ') THEN(DO)           /*CFT008*/
                  ENDJRNPF   FILE(FT102HPD) JRN(CGCOBJRN)             /*CFT008*/
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)           /*CFT008*/
             ENDDO                                                    /*CFT008*/
             ENDDO                                                                        /*211713*/
 ENDPGM:                                                              /*CFT008*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
