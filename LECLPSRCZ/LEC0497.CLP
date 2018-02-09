/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Contingent facility a/c key generation')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0497 - Contingent Facility A/c Keys Generation           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD030126           Date 27Oct14              */
/*                      CLE075AR           Date 06Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      210051             Date 30Sep02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE007 *CREATE     Date 22May97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD030126 - Added processing for 2nd run of LEC0497-PDCL run */
/*                  Patterned after MP1.4 AR996468.                  */
/*       CLE075AR - COB Restructure - LE COB Optimisation Phase 1    */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       210051 - Override CLOAN to PETEMPLN so that reversed loans  */
/*                will be picked up by LE0497 when checking for      */
/*                parts sold loan.                                   */
/*       CLE007 - Customer Lending Enhancements - Others (T3)        */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&CNAM &CSEQ)                            */                 /*MD030126*/
             PGM        PARM(&CNAM &CSEQ &RERUN)                                        /*MD030126*/
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
/**********  DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')   */                   /*CLE075AR*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)              */                   /*CLE075AR*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CLE075AR*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                 /*CLE075AR*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CLE075AR*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CLE075AR*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CLE075AR*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CLE075AR*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CLE075AR*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CLE075AR*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075AR*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075AR*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                 /*MD030126*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Contingent Facility A/c Keys +
                          Generation') TOMSGQ(MRUNQ)
 
/* Write current journal sequence number to file SCJSEQPD, using */                     /*CLE075AR*/
/* command SCWRTJREG */                                                                 /*CLE075AR*/
                                                                                        /*CLE075AR*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CLE075AR*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CLE075AR*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CLE075AR*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*CLE075AR*/
                                                                                        /*CLE075AR*/
/**Check*the*current*status*of*this*component**/                                        /*CLE075AR*/
 
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        */                   /*CLE075AR*/
 
/**If*this*is*not*a*restart,*copy*master*files*to*backup*files**/                       /*CLE075AR*/
 
/**********  IF         COND(&STAT *EQ 'N') THEN(DO)               */                   /*CLE075AR*/
/**********     CPYF       FROMFILE(FACHISA)  TOFILE(XFACHISA) +
                             MBROPT(*REPLACE)                      */                   /*CLE075AR*/
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XFACHISA))                       */                   /*CLE075AR*/
 
/**********     CHGVAR     VAR(&STAT) VALUE('Y')                   */                   /*CLE075AR*/
/**********     CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     */                   /*CLE075AR*/
/**********  ENDDO                                                 */                   /*CLE075AR*/
 
/**If*this*is*a*restart,*restore*master*files**/                                        /*CLE075AR*/
 
/**********  ELSE       CMD(DO)                                    */                   /*CLE075AR*/
 
/**********     CPYF       FROMFILE(XFACHISA) TOFILE(FACHISA) +
                             MBROPT(*REPLACE)                      */                   /*CLE075AR*/
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(FACHISA))                        */                   /*CLE075AR*/
/**********  ENDDO                                                 */                   /*CLE075AR*/
 
/* Clear the A/c Keys Files */
 
             CLRPFM     LKEYCFA
             CLRPFM     LKEYCFD
             CLRPFM     LKEYCFZ
             OVRDBF     FILE(CLOAN) TOFILE(PETEMPLN)                                      /*210051*/
                                                                                        /*MD030126*/
/** Override only when processing PDCL component                     */                 /*MD030126*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                              /*MD030126*/
             OVRDBF     FILE(HISUPD) TOFILE(LEHISAL4)                                   /*MD030126*/
             ENDDO                                                                      /*MD030126*/
/*/COPY WNCPYSRC,LEC0497001                                          */
 
/* Call Facility Amendments Processing */
 
/**********  CALL       PGM(LE0497)                                  */                 /*MD030126*/
             CALL       PGM(LE0497) PARM(&RERUN)                                        /*MD030126*/
 
/**No*database*error**/                                                                 /*CLE075AR*/
 
/**********  IF         COND(%SWITCH(XXXXXX00)) THEN(DO)           */                   /*CLE075AR*/
/**********     CLRPFM     FILE(XFACHISA)                          */                   /*CLE075AR*/
/**********     CHGVAR     VAR(&STAT) VALUE('N')                   */                   /*CLE075AR*/
/**********     CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     */                   /*CLE075AR*/
/**********  ENDDO                                                 */                   /*CLE075AR*/
 
/**Database*error*processing**/                                                         /*CLE075AR*/
 
/**********  ELSE       CMD(DO)                                    */                   /*CLE075AR*/
/**********     RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)       */                   /*CLE075AR*/
/**********     SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)     */                   /*CLE075AR*/
/**********  ENDDO                                                 */                   /*CLE075AR*/
 
             DLTOVR     FILE(CLOAN)                                                       /*210051*/
/** Execute only when processing PDCL component                      */                 /*MD030126*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                              /*MD030126*/
             DLTOVR     FILE(HISUPD)                                                    /*MD030126*/
             ENDDO                                                                      /*MD030126*/
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                /*MD030126*/
             GOTO       CMDLBL(END)
             ENDDO                                                                      /*MD030126*/
                                                                                        /*MD030126*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* If abnormal, retrieve attributes of current job */                                   /*CLE075AR*/
                                                                                        /*CLE075AR*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CLE075AR*/
                                                                                        /*CLE075AR*/
/* Retrieve the most recent journal entry sequence number */                            /*CLE075AR*/
/* for the specific job */                                                              /*CLE075AR*/
                                                                                        /*CLE075AR*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*CLE075AR*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CLE075AR*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*CLE075AR*/
             ENDDO                                                                      /*CLE075AR*/
                                                                                        /*CLE075AR*/
/* Determine starting journal sequence number of current job */                         /*CLE075AR*/
                                                                                        /*CLE075AR*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CLE075AR*/
                                                                                        /*CLE075AR*/
/* Remove journal changes */                                                            /*CLE075AR*/
                                                                                        /*CLE075AR*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*CLE075AR*/
             RMVJRNCHG  JRN(ICJRN) FILE((FACHISA)) RCVRNG(&SJRNRCVR +
                          &FJRNRCVR) FROMENT(&START) TOENT(&FINISH)                     /*CLE075AR*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*CLE075AR*/
             ENDDO                                                                      /*CLE075AR*/
                                                                                        /*CLE075AR*/
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             LEC0497 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                                                                                        /*CLE075AR*/
/* Write current journal sequence number to file SCJSEQPD, using */                     /*CLE075AR*/
/* command SCWRTJREG */                                                                 /*CLE075AR*/
                                                                                        /*CLE075AR*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*CLE075AR*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CLE075AR*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*CLE075AR*/
 
             ENDPGM
