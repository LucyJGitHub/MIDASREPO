/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Interest Statement Print RCVF RECAPM')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     Retail Module                                 */
/*                                                                   */
/*       REC376 - RETAIL INTEREST AND CHARGE GENERATION RCVF RECAPM  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CRE083AD           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CCB016             Date 18Feb08              */
/*                      CGL061             Date 27Jun06              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE083AD - COB Restructure - RE COB Optimisation Phase 1    */
/*       CCB016 - CoB Performance Enhancements.                      */
/*                Split REC376 and REC376A to allow REC376A to       */
/*                be removed from immediate dependencies (that is    */
/*                the whole point of copying ACCNTAB etc to extract  */
/*                files).                                            */
/*       CGL061 - Multi-streaming GL Statements - Task Split         */
/*                Call GL0420 as specified by Dtaq STMTSERVE         */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*************************************************************/                         /*CRE083AD*/
/**THIS*PGM*USE*SECURITY*COPY*OF*FILES*INSTEAD*OF*JOURNALING */                         /*CRE083AD*/
/*************************************************************/                         /*CRE083AD*/
/*********** PGM                                                      /*CGL061*/
             PGM        PARM(&CNAM &CSEQ)                             /*CGL061*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(50)               /*CGL061*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*CGL061*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*CGL061*/
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                /*CGL061*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(12)              /*CGL061*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)            /*CGL061*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50) /*CGL061*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)             /*CGL061*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)             /*CGL061*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)  /*CGL061*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)              /*CGL061*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                 /*CGL061*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCLF       FILE(RECAPM)
/*/COPY WNCPYSRC,REC376001                                           */
/**/
/*  FOLLOWING CHECK IS DONE TO AVOID RUN OF PROGRAM IF NO INTEREST  */
/*  PROCESSING IS REQUIRED : FILE RECAPM IS EMPTY                   */
/**/
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
              GOTO       CMDLBL(ENDCL)
             ENDDO
/**/
/**********  CPYF       FROMFILE(ACCNTAB) TOFILE(*LIBL/EACCNTAB) + */                   /*CRE083AD*/
/**********               MBROPT(*REPLACE) FMTOPT(*NOCHK) */                            /*CRE083AD*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) */                               /*CRE083AD*/
/**/
/**********  CPYF       FROMFILE(CLINTCB) TOFILE(*LIBL/ECLINTCB) + */                   /*CRE083AD*/
/**********               MBROPT(*REPLACE) FMTOPT(*NOCHK) */                            /*CRE083AD*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) */                               /*CRE083AD*/
/**/
/**********  CPYF       FROMFILE(REACRD) TOFILE(*LIBL/EREACRD) + */                     /*CRE083AD*/
/**********               MBROPT(*REPLACE) FMTOPT(*NOCHK) */                            /*CRE083AD*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) */                               /*CRE083AD*/
/**/
/**********  CPYF       FROMFILE(REIACD) TOFILE(*LIBL/EREIACD) + */                     /*CRE083AD*/
/**********               MBROPT(*REPLACE) FMTOPT(*NOCHK) */                            /*CRE083AD*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) */                               /*CRE083AD*/
/*/COPY WNCPYSRC,REC376002                                           */
/**/
             GOTO       CMDLBL(ENDCL)                                                     /*CCB016*/
                                                                                          /*CCB016*/
             CALL       PGM(REC376A)
/**/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
                 CHGJOB     INQMSGRPY(*RQD)
                 RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))
                 SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDCL:       ENDPGM
