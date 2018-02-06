/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Customer bills and telexes')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC6004 - Customer Bills and Telexes                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      211713             Date 08Nov02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      142013             Date 30May01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCG008 *CREATE     Date 30Oct95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       211713 - ENDJRNPF on JRN/CGCOBJRN not required if CCB009    */
/*                is not present.                                    */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       142013 - Dummy OVRDBF on CLOAN because of database          */
/*                integrity when record format CLOANCK is used in    */
/*                subprogram CG6001.                                 */
/*       CCB009 - Journal files throughout close of business         */
/*       CCG008 - User Defined Correspondence - Lending              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ &EXTRACT &MEMBER +
                          &COMMIT_OPT)
/**/
             DCL        VAR(&COMP_NAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ)   TYPE(*DEC)  LEN(5)
             DCL        VAR(&COMP_SEQA)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&EXTRACT)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMMIT_OPT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTN_CODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATA)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_DATA)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
/*/COPY WNCPYSRC,CGC6004001                                          */
/**/
/* Global monitor message                                            */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Send Message to MRUNQ and standard processing parameters          */
/**/
             SNDPGMMSG  MSG('CGC6004 - Customer Bills ad Telexes')  +
                          TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
             CHGJOB     SWS(XXXXX000)
/*/COPY WNCPYSRC,CGC6004002                                          */
/**/
/* Create data LDA in QTEMP                                          */
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        MONMSG     MSGID(CPF1023)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**/
/* Journal Files to CGCOBJRN                                         */
/**/
/*/COPY WNCPYSRC,CGC6004003                                          */
             STRJRNPF   FILE(CUTX1HN CUTX1HP CUTX2HP CUTX1HQ) +
                          JRN(CGCOBJRN) IMAGES(*BOTH)                 /*CGX016*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,CGC6004004                                          */
                                                                                          /*CCG015*/
/** Call Extract File Instance Management */                                              /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
                                                                                          /*CCG015*/
/**/
/* Run Extract Component                                             */
/**/
             CHGVAR     VAR(&COMP_SEQA) VALUE(&COMP_SEQ)
             CHGVAR     VAR(&MSG_DATA) VALUE(&COMP_NAME *CAT +
                          &COMP_SEQA *CAT &EXTRACT *CAT &MEMBER +
                          *CAT &COMMIT_OPT)
             SNDPGMMSG  MSGID(CGD1271) MSGF(CGUSRMSG) +
                          MSGDTA(&MSG_DATA) TOPGMQ(*PRV)
             OVRDBF     FILE(SCUTX) SHARE(*NO)                        /*CGX016*/
             OVRDBF     FILE(LECUTXL0) SHARE(*NO)                     /*CGX016*/
             OVRDBF     FILE(CLOAN) SHARE(*NO)                        /*142013*/
             CALL       PGM(CG6030) PARM(&RTN_CODE &COMMIT_OPT)
             DLTOVR     FILE(SCUTX LECUTXL0)
             DLTOVR     FILE(CLOAN)                                   /*142013*/
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)
               ROLLBACK
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
/**/
/* Check for Database errors trapped by program                      */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
                                                                                          /*CCG015*/
/** Call Custom Defined Data Extract pgm */                                               /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)                                /*CCG015*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                     /*CCG015*/
             GOTO       CMDLBL(ABNOR)                                                     /*CCG015*/
             ENDDO                                                                        /*CCG015*/
                                                                                          /*CCG015*/
/**/
             GOTO       CMDLBL(END)
/**/
/* Abnormal termination                                              */
/**/
 ABNOR:
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,CGC6004005                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(CUTX1HN CUTX1HP CUTX2HP CUTX1HQ) +
                          JRN(CGCOBJRN)                               /*CGX016*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,CGC6004006                                          */
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC6004 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC6004 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,CGC6004007                                          */
             IF         COND(&CCB009 *NE '       ') THEN(DO)                              /*211713*/
             ENDJRNPF   FILE(CUTX1HN CUTX1HP CUTX2HP CUTX1HQ) +
                          JRN(CGCOBJRN)                               /*CGX016*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*211713*/
/*/COPY WNCPYSRC,CGC6004008                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
