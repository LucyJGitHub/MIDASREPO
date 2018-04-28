/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Tax Advice Extract')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC7410 - CG Tax Advice Extract (COB processing)            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. CER059             Date 19Jul10              */
/*       Prev Amend No. BUG24188           Date 09Jun09              */
/*                      BUG23135A          Date 18Mar09              */
/*                      BUG22564A          Date 13Jan09              */
/*                      BUG22564           Date 30Jan09              */
/*                      CER048  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG24188 - No Single Tax advices produced (Recompile)       */
/*       BUG23135A - DL Single Tax Advice missing in COB extract     */
/*       BUG22564A -Component CGC2050 00023 failed. (Re-opened)      */
/*       BUG22564 - Component CGC2050 00023 failed.                  */
/*       CER048 - German Features - Taxes                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ &EXTRACT &MEMBER +
                          &COMMIT_OPT)
/*                                                                   */
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking +
                          Systems Ltd. 2008')
/*                                                                   */
/** Declare variables                                                */
/*                                                                   */
             DCL        VAR(&COMP_NAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&COMP_SEQA)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&EXTRACT)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMMIT_OPT) TYPE(*CHAR) LEN(3)
/*                                                                   */
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) VALUE('CER048')
/*                                                                   */
             DCL        VAR(&RTN_CODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&STATUS)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_DATA)   TYPE(*CHAR) LEN(256)
/*                                                                   */
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)
/**********  DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                            /*BUG22564A*/
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')           /*BUG22564A*/
 
/*                                                                   */
/** Global Monitor Message                                           */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/*                                                                   */
/** Access to available SAR CER048 (Withholding tax)                 */
/*                                                                   */
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/*                                                                   */
/** If found, do                                                     */
/*                                                                   */
             IF         COND(&SRTCD *EQ '        ') THEN(DO)
/*                                                                   */
/** Send Message to MRUNQ and standard processing parameters         */
/*                                                                   */
             SNDPGMMSG  MSG('CGC7410 - Customer Tax Advice') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
 
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
 
/**** Setup system prefix variable from SDSTAT data area. ****/                   /*BUG22564A*/
 
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                       /*BUG22564A*/
/**********  CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)                 /*BUG22564A*/
 
/*                                                                   */
/** Create data LDA in QTEMP                                         */
/*                                                                   */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        MONMSG     MSGID(CPF1023)
 
/*                                                                   */
/***** Call program CB0160 to get value of restart indicator.         ****/       /*BUG22564A*/
/**********                                                          */           /*BUG22564A*/
 
/**********  CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)            /*BUG22564A*/
 
/**********                                                          */           /*BUG22564A*/
/******If it is NOT a restart. ****/                                              /*BUG22564A*/
/**********                                                          */           /*BUG22564A*/
 
/**********  IF         COND(&STATUS *NE 'Y') THEN(DO)                            /*BUG22564A*/
/**********    DLTF       FILE(XSDINPHPD)                                         /*BUG22564A*/
/**********    MONMSG     MSGID(CPF0000)                                          /*BUG22564A*/
 
/**********    CPYF       FROMFILE(SDINPHPD) TOFILE(&DPLIB/XSDINPHPD) +           /*BUG22564A*/
/**********               MBROPT(*REPLACE) CRTFILE(*YES)                          /*BUG22564A*/
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*BUG22564A*/
/**********  ENDDO                                                                /*BUG22564A*/
 
/**********                                                          */           /*BUG22564A*/
/***** If it is a restart.                                           ****/        /*BUG22564A*/
/**********                                                          */           /*BUG22564A*/
 
/**********  IF         COND(&STATUS *EQ 'Y') THEN(DO)                            /*BUG22564A*/
/**********    CPYF       FROMFILE(XSDINPHPD) TOFILE(SDINPHPD) +                  /*BUG22564A*/
/**********               MBROPT(*REPLACE)                                        /*BUG22564A*/
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*BUG22564A*/
/**********  ENDDO                                                                /*BUG22564A*/
 
/**********  CHGVAR     VAR(&STATUS) VALUE('Y')                                   /*BUG22564A*/
 
/**********                                                          */           /*BUG22564A*/
/***** Call CB0150 to update restart indicator                       ****/        /*BUG22564A*/
/*********                                                           */           /*BUG22564A*/
 
/*********   CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)            /*BUG22564A*/
/*                                                                   */                /*BUG23135A*/
/** Override Message File                                            */                /*BUG23135A*/
/*                                                                   */                /*BUG23135A*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(GBCGUSRMSG)                              /*BUG23135A*/
 
/*                                                                   */
/** Call Extract File Instance Management                            */
/*                                                                   */
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')
             CALL       PGM(CGC3605) PARM(&ACTION)
/*                                                                   */
/** Run Extract Component                                            */
/*                                                                   */
             CHGVAR     VAR(&COMP_SEQA) VALUE(&COMP_SEQ)
             CHGVAR     VAR(&MSG_DATA) VALUE(&COMP_NAME *CAT +
                          &COMP_SEQA *CAT &EXTRACT *CAT &MEMBER +
                          *CAT &COMMIT_OPT)
             SNDPGMMSG  MSGID(CGD1271) MSGF(CGUSRMSG) +
                          MSGDTA(&MSG_DATA) TOPGMQ(*PRV)
 
             CALL       PGM(CG7410) PARM(&RTN_CODE &COMMIT_OPT)
 
             ROLLBACK
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/*                                                                   */
/** Check for Database errors trapped by program                     */
/*                                                                   */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
/*                                                                   */
/** Call Custom-Defined Data Extract pgm                             */
/*                                                                   */
             CALL       PGM(CGC3604)
/*                                                                   */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/*                                                                   */
/** If no error occured in the program                               */
/*                                                                   */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*                                                                   */
/** Call CB0150 to update restart indicator.                         */
/*                                                                   */
 
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
             DLTF       FILE(XSDINPHPD)
             MONMSG     MSGID(CPF0000)
 
             RGZPFM     FILE(SDINPHPD)
/*********   MONMSG     MSGID(CPF2995 CPF2981)                                          /*BUG22564*/
             MONMSG     MSGID(CPF2995 CPF2981 CPF3135)                                  /*BUG22564*/
             ENDDO
/*                                                                   */
             ENDDO
/*                                                                   */
             GOTO       CMDLBL(ENDCLPGM)
 
/*                                                                   */
/** Report Database errors trapped by program                        */
/*                                                                   */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
/*                                                                   */
/** Abnormal termination processing                                  */
/*                                                                   */
ABNORMAL:
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')
             CALL       PGM(CGC3605) PARM(&ACTION)
 
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
             SNDPGMMSG  MSG('Program CGC7410 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC7410 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/*                                                                   */
/** Normal termination of processing                                 */
/*                                                                   */
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&ACTCPY) VALUE('(c) Copyright Misys +
                          International Banking +
                          Systems Ltd. 2008')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
             ENDPGM
