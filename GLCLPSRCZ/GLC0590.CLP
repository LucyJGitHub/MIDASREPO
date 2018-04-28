/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Retail capitalisation')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger                                      */
/*                                                                   */
/*       GLC0590 - Retail Capitalisation                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCB001 *CREATE     Date 01Mar95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       CCB009 - Journal files throughout close of business         */
/*       CCB001 - CoB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP &CSEQ)
 
/***COPY*GLCPYSRC,GLC0590INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,GLC0590INT                                          */                   /*CPK024*/
 
             DCL        VAR(&COMP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature**/                        /*CCB009 CCB023*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)            */              /*CCB009 CCB023*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)           */              /*CCB009 CCB023*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                      CCB009*/
/***Check*for*Switchable*feature*CCB009.**/                                        /*CCB009 CCB023*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                         */              /*CCB009 CCB023*/
 
             CALL       PGM(CB0160) PARM(&COMP &CSEQ &BUSY)
 
             IF         COND(&BUSY *EQ 'N') THEN(DO)
                CHGVAR     VAR(&BUSY) VALUE('Y')
                CALL       PGM(CB0150) PARM(&COMP &CSEQ &BUSY)
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),**/                /*CCB009 CCB023*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */              /*CCB009 CCB023*/
/**********     STRJRNPF   FILE(ACCNTAA) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)                      */                     /*CCB023*/
/**********     MONMSG     MSGID(CPF7030)                          */                     /*CCB023*/
/**********     STRJRNPF   FILE(ACCNTAB) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)                      */                     /*CCB023*/
/**********     MONMSG     MSGID(CPF7030)                          */                     /*CCB023*/
/**********     STRJRNPF   FILE(ACCNTAC) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                         */                     /*CCB023*/
/**********     MONMSG     MSGID(CPF7030)                          */                     /*CCB023*/
/**********     STRJRNPF   FILE(RETAGD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)                      */                     /*CCB023*/
/**********     MONMSG     MSGID(CPF7030)                          */                     /*CCB023*/
/**********  ENDDO                                                 */              /*CCB009 CCB023*/
             ENDDO
 
/***COPY*GLCPYSRC,GLC0590MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,GLC0590MPS                                          */                   /*CPK024*/
 
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),**/                /*CCB009 CCB023*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */              /*CCB009 CCB023*/
/**********  ENDJRNPF   FILE(ACCNTAA ACCNTAB ACCNTAC RETAGD) JRN(ICJRN)*/                 /*CCB023*/
/**********  ENDDO                                                 */              /*CCB009 CCB023*/
 
             CALL       PGM(GL0590)
 
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),**/                /*CCB009 CCB023*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */              /*CCB009 CCB023*/
/**********  STRJRNPF   FILE(ACCNTAA ACCNTAB ACCNTAC RETAGD) +
                          JRN(ICJRN) IMAGES(*BOTH)                 */                     /*CCB023*/
/**********  ENDDO                                                 */              /*CCB009 CCB023*/
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*GLCPYSRC,GLC0590MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,GLC0590MPE                                          */                   /*CPK024*/
 
             IF         COND(&BUSY *EQ 'Y') THEN(DO)
                CHGVAR     VAR(&BUSY) VALUE('N')
                CALL       PGM(CB0150) PARM(&COMP &CSEQ &BUSY)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*GLCPYSRC,GLC0590ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,GLC0590ERR                                          */                   /*CPK024*/
 
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),**/                /*CCB009 CCB023*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */              /*CCB009 CCB023*/
/**********  ENDJRNPF   FILE(ACCNTAA ACCNTAB ACCNTAC RETAGD) JRN(ICJRN)*/                 /*CCB023*/
/**********  MONMSG     MSGID(CPF0000 MCH0000)                     */                     /*CCB023*/
/**********  ENDDO                                                 */              /*CCB009 CCB023*/
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDMSG     MSG('GLC0590 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
 
/***COPY*GLCPYSRC,GLC0590END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,GLC0590END                                          */                   /*CPK024*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
