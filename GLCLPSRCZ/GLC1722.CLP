/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Generic Posting Interface Key Creation')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1722 - Posting Interface Key Creation                    */
/*                                                                   */
/*       (c) Finastra International Limited 2006                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD021155           Date 08Jul13              */
/*                      CGL127AF           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGL047 *Create     Date 27Jun06              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - End processing is open to looping                */
/*                - RGZPFM not moved                                 */
/*       CGL127AF - COB Restructure - GL COB Optimisation Phase 1    */
/*       CGL047 - Midas Generic Posting Interface                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&MISYS) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2006')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                 /*CGL127AF*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CGL127AF*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                 /*CGL127AF*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CGL127AF*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CGL127AF*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CGL127AF*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CGL127AF*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CGL127AF*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CGL127AF*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CGL127AF*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CGL127AF*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Set job switch settings */
             CHGJOB     SWS(00000000)
 
/* Create LDA if it does not alredy exist  */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
/* Write current journal sequence number to file SCJSEQPD */                            /*CGL127AF*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CGL127AF*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CGL127AF*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CGL127AF*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*CGL127AF*/
 
/* Allocate object and check for restart */
/**********  ALCOBJ     OBJ((GLGPIFPD *FILE *EXCL)) WAIT(120)                           /*CGL127AF*/
/**********  RTVOBJD    OBJ(GLGPIFPD) OBJTYPE(*FILE) RTNLIB(&DPLIB)                     /*CGL127AF*/
/**********  CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                                  /*CGL127AF*/
 
/* Restart */
/**********  IF         COND(&BUSY *EQ 'Y') THEN(DO)                                    /*CGL127AF*/
 
/**Restore*data*in*GLGPIFPD***/                                                         /*CGL127AF*/
/**********  CPYF       FROMFILE(&DPLIB/GLGPIFPDX) TOFILE(GLGPIFPD) +                   /*CGL127AF*/
/**********               MBROPT(*REPLACE)                                              /*CGL127AF*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*CGL127AF*/
 
/**********  ENDDO                                                                      /*CGL127AF*/
/**********  ELSE       CMD(DO)                                                         /*CGL127AF*/
 
/**Take*copy*of*data*in*GLGPIFPD***/                                                    /*CGL127AF*/
/**********  CPYF       FROMFILE(GLGPIFPD) TOFILE(&DPLIB/GLGPIFPDX) +                   /*CGL127AF*/
/**********               MBROPT(*REPLACE) CRTFILE(*YES)                                /*CGL127AF*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*CGL127AF*/
 
/* Set active flag */
/**********  CHGVAR     VAR(&BUSY) VALUE('Y')                                           /*CGL127AF*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)                             /*CGL127AF*/
 
/**********  ENDDO                                                                      /*CGL127AF*/
 
/* Reset job switches */
             CHGJOB     SWS(00000000)
 
/* Create data area LDA if it does not already exist */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
/* Clear PF/GLGPIKPD  */
             CLRPFM     FILE(GLGPIKPD)
 
/* Call program to generate account keys */
             CALL       PGM(GL1722)
 
/* DB error  */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Set OK flag  */
/**********  CHGVAR     VAR(&BUSY) VALUE('N')                                           /*CGL127AF*/
/**********  CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                                  /*CGL127AF*/
 
/**Delete*security*copy*of*file***/                                                     /*CGL127AF*/
/**********  DLTF       FILE(&DPLIB/GLGPIFPDX)                                          /*CGL127AF*/
/**********  MONMSG     MSGID(CPF0000)                                                  /*CGL127AF*/
 
/**Re-organise*forward*postings*************************************/                   /*MD021155*/
/**********  RGZPFM     FILE(GLGPIFPD)                             */                   /*MD021155*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                     */                   /*MD021155*/
 
/* De-allocate object  */
             DLCOBJ     OBJ((GLGPIFPD *FILE *EXCL))
                                                                                        /*MD021155*/
/** Write current journal sequence number to file SCJSEQPD         */                   /*MD021155*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*MD021155*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM *CAT +
                          &CSEQA)                                                       /*MD021155*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*MD021155*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
/* Retrieve attributes of current job  */                                               /*CGL127AF*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CGL127AF*/
                                                                                        /*CGL127AF*/
/* Retrieve the most recent journal entry sequence number */                            /*CGL127AF*/
/* for the specific job. */                                                             /*CGL127AF*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*CGL127AF*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CGL127AF*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*CGL127AF*/
             ENDDO                                                                      /*CGL127AF*/
                                                                                        /*CGL127AF*/
/* Determine starting journal sequence number of current job. */                        /*CGL127AF*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CGL127AF*/
                                                                                        /*CGL127AF*/
/* Remove journal changes. */                                                           /*CGL127AF*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*CGL127AF*/
             RMVJRNCHG  JRN(ICJRN) FILE((GLGPIFPD)) +
                          FROMENT(&START) TOENT(&FINISH) +
                          RCVRNG(&SJRNRCVR &FJRNRCVR)                                   /*CGL127AF*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*CGL127AF*/
             ENDDO                                                                      /*CGL127AF*/
 
 END:
/*******************************************************************/          /*CGL127AF MD021155*/
/**Write*current*journal*sequence*number*to*file*SCJSEQPD***********/          /*CGL127AF MD021155*/
/**********  CHGVAR     VAR(&STEXT) VALUE(' ')                     */          /*CGL127AF MD021155*/
/**********  CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM *CAT +*/                 /*MD021155*/
/**********               &CSEQA)                                  */          /*CGL127AF MD021155*/
/**********  SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) + */                   /*MD021155*/
/**********               FLAG('E') TEXT(&STEXT)                   */          /*CGL127AF MD021155*/
/**********                                                        */          /*CGL127AF MD021155*/
             CHGVAR     VAR(&MISYS) VALUE('(c) Finastra International +
                          Limited 2006')
             ENDPGM
