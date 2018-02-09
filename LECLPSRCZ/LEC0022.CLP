/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE History of Margin File')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0022 - History of Margin File                            */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB023A            Date 28Feb13              */
/*                      CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 10Aug04              */
/*                      CAS005  *CREATE    Date 16Dec02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB023A - COB Restructure - Input Cycle Termination         */
/*                 Restructuring                                     */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**********  DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2) */                                 /*CCB023*/
/**********  DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ') */                       /*CCB023*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')*/                 /*CCB023*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CCB023*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                   /*CCB023*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                  /*CCB023*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                     /*CCB023*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                     /*CCB023*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                      /*CCB023*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                  /*CCB023*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                                 /*CCB023*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                                /*CCB023*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                                /*CCB023*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Write current journal sequence number to file SCJSEQPD, using   */                     /*CCB023*/
/* command SCWRTJREG                                               */                     /*CCB023*/
                                                                                          /*CCB023*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CCB023*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CCB023*/
/**********  CHGVAR     VAR(&SEVENT) VALUE(&CNAM *CAT &CSEQA)      */             /*CCB023 CCB023A*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                           /*CCB023A*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                          /*CCB023*/
                                                                                          /*CCB023*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID) */                            /*CCB023*/
/**********  CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID) */                      /*CCB023*/
 
/**Call*program*CB0160*to*get*value*of*restart*indicator**/                               /*CCB023*/
 
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT) */                            /*CCB023*/
 
/**If*it*is*NOT*a*restart**/                                                              /*CCB023*/
 
/**********  IF         COND(&STAT *EQ 'N') THEN(DO) */                                   /*CCB023*/
/**********       DLTF       FILE(XMRGHISPD) */                                           /*CCB023*/
/**********       MONMSG     MSGID(CPF2105) */                                            /*CCB023*/
 
/**********       CPYF       FROMFILE(MRGHISPD) TOFILE(&DPLIB/XMRGHISPD) +
                               MBROPT(*REPLACE) CRTFILE(*YES) */                          /*CCB023*/
/**********       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) */                            /*CCB023*/
/**********  ENDDO */                                                                     /*CCB023*/
 
/**If*it*is*a*restart**/                                                                  /*CCB023*/
 
/**********  IF         COND(&STAT *EQ 'Y') THEN(DO) */                                   /*CCB023*/
/**********       CPYF       FROMFILE(XMRGHISPD) TOFILE(MRGHISPD) +
                               MBROPT(*REPLACE) */                                        /*CCB023*/
/**********       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) */                            /*CCB023*/
/**********  ENDDO */                                                                     /*CCB023*/
 
/**********  CHGVAR     VAR(&STAT) VALUE('Y') */                                          /*CCB023*/
 
/**Call*CB0150*to*update*restart*indicator**/                                             /*CCB023*/
 
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT) *                             /*CCB023*/
 
             CALL       PGM(LE0022)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/**Call*CB0150*to*update*restart*indicator**/                                             /*CCB023*/
 
/**********       CHGVAR     VAR(&STAT) VALUE('N') */                                     /*CCB023*/
/**********       CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT) */                       /*CCB023*/
/**********       DLTF       FILE(XMRGHISPD) */                                           /*CCB023*/
/**********       MONMSG     MSGID(CPF2105) */                                            /*CCB023*/
/**********       RGZPFM     FILE(MRGHISPD)                                               /*228542*/
/**********       MONMSG     MSGID(CPF2995 CPF2981)                                       /*228542*/
                  CALL       PGM(SCC000060) PARM('MRGHISPD' '*FIRST')                     /*228542*/
                  IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))                                               /*228542*/
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                         LEC0022 ended abnormally - see job log') +
                         TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Retrieve attributes of current job */                                                  /*CCB023*/
                                                                                          /*CCB023*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                    /*CCB023*/
                                                                                          /*CCB023*/
/* Retrieve the most recent journal entry sequence number for      */                     /*CCB023*/
/* the specific job                                                */                     /*CCB023*/
                                                                                          /*CCB023*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                               /*CCB023*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                   /*CCB023*/
             CHGVAR     VAR(&START) VALUE(0)                                              /*CCB023*/
             ENDDO                                                                        /*CCB023*/
                                                                                          /*CCB023*/
/* Determine starting journal sequence number of current job       */                     /*CCB023*/
                                                                                          /*CCB023*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                   /*CCB023*/
                                                                                          /*CCB023*/
/* Remove journal changes                                          */                     /*CCB023*/
                                                                                          /*CCB023*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                        /*CCB023*/
             RMVJRNCHG  JRN(ICJRN) FILE((MRGHISPD)) +
                          FROMENT(&START) TOENT(&FINISH) +
                          RCVRNG(&SJRNRCVR &FJRNRCVR)                                     /*CCB023*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                            /*CCB023*/
             ENDDO                                                                        /*CCB023*/
                                                                                          /*CCB023*/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* Write current journal sequence number to file SCJSEQPD, using   */                     /*CCB023*/
/* command SCWRTJREG                                               */                     /*CCB023*/
                                                                                          /*CCB023*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CCB023*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM *CAT +
                          &CSEQA)                                                         /*CCB023*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                          /*CCB023*/
             ENDPGM
