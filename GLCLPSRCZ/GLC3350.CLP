/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Collateral details file purge')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       GLC3350 - Collateral Details File Purge                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CUP005             Date 27Aug10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CAP205             Date 23Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 05Aug04              */
/*                      CPK016             Date 04Jun03              */
/*                      CGL018             DATE 20Oct02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CGL011  *CREATE    Date 20Sep99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP005 - Change processing of temporary files for IASP      */
/*       CAP205 - Teller Related APIs - Account Balance Check        */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       CGL018 - Risk Weighted Assets                               */
/*       CCB009 - Journal files throughout close of business         */
/*       CGL011 - Collateral Processing for Midas DBA                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PCNAM &PCSEQ)
 
             DCL        VAR(&PCNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCSEQ)   TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
/*                                                                                        /*CAP205*/
/* Declare variable CAP205 - flag for switchable feature                                  /*CAP205*/
/*                                                                                        /*CAP205*/
             DCL        VAR(&CAP205) TYPE(*CHAR) LEN(7)                                   /*CAP205*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
 
             CALL       PGM(AOSARDR0) PARM(&CAP205 '*VERIFY' +
                          'CAP205' &AOFMT)                                                /*CAP205*/
                                                                                          /*CAP205*/
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Send program message to MRUNQ that this component is running */
 
             SNDPGMMSG  MSG('GLC3350 - Collateral Details +
                          File Purge') TOMSGQ(MRUNQ)
 
/* Retrieve System ID */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
 
/*********                                                                  */ /*CCB009*/ /*CUP005*/
/**If Feature*CCB009*is*NOT*'on'*(close*of business*journaling),*           */ /*CCB009*/ /*CUP005*/
/**********                                                                 */ /*CCB009*/ /*CUP005*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                */ /*CCB009*/ /*CUP005*/
/**Journal*GLCOLLPD,*GLCOLAPD*and*GLCOLNPD**/ /*                                       */ /*CUP005*/
 
/**********  ENDJRNAP   FILE(*ALL) JRN(&JLIB/JGLC3350)                                 */ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/JGLC3350)                                 */ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  ENDCMTCTL                                                                 */ /*CUP005*/
/**********  MONMSG     MSGID(CPF8350)                                                 */ /*CUP005*/
/**********  DLTJRN     JRN(&JLIB/JGLC3350)                                            */ /*CUP005*/
/**********  MONMSG     MSGID(CPF2105)                                                 */ /*CUP005*/
/**********  CHGJOB     INQMSGRPY(*DFT)                                                */ /*CUP005*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRGLC3350)                                        */ /*CUP005*/
/**********  MONMSG     MSGID(CPF2105)                                                 */ /*CUP005*/
/**********  CHGJOB     INQMSGRPY(*RQD)                                                */ /*CUP005*/
 
/**********  CRTJRNRCV  JRNRCV(&JLIB/JRGLC3350) TEXT('Journal +                        */ /*CUP005*/
/**********               Receiver for GL3350 backup journalling')                     */ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  CRTJRN     JRN(&JLIB/JGLC3350) JRNRCV(&JLIB/JRGLC3350) +                  */ /*CUP005*/
/**********               TEXT('Journal file for GL3350 backup +                       */ /*CUP005*/
/**********               journalling')                                                */ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  STRJRNPF   FILE(GLCOLLPD GLCOLAPD GLCOLNPD GLORWAPD) +                       /*CGL018*/
/**********               JRN(&JLIB/JGLC3350) IMAGES(*BOTH) +                             /*CGL018*/
/**********               OMTJRNE(*OPNCLO)                                                /*CGL018*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  ENDDO                                                          */ /*CCB009*/ /*CUP005*/
 
/* Start commitment control */
 
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) */                                    /*CPK016*/
/**********  MONMSG     MSGID(CPF8351) */                                                 /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
 
/* Call GL3350 */
 
             CALL       PGM(GL3350)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
/**********                                                                 */ /*CCB009*/ /*CUP005*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),*           */ /*CCB009*/ /*CUP005*/
/**********                                                                 */ /*CCB009*/ /*CUP005*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                */ /*CCB009*/ /*CUP005*/
/**********     ENDJRNAP   FILE(*ALL) JRN(&JLIB/JGLC3350)                              */ /*CUP005*/
/**********     MONMSG     MSGID(CPF0000)                                              */ /*CUP005*/
/**********     ENDJRNPF   FILE(GLCOLLPD) JRN(&JLIB/JGLC3350)                          */ /*CUP005*/
/**********     MONMSG     MSGID(CPF0000)                                              */ /*CUP005*/
/**********     ENDJRNPF   FILE(GLCOLAPD) JRN(&JLIB/JGLC3350)                          */ /*CUP005*/
/**********     MONMSG     MSGID(CPF0000)                                              */ /*CUP005*/
/**********     ENDJRNPF   FILE(GLCOLNPD) JRN(&JLIB/JGLC3350)                          */ /*CUP005*/
/**********     MONMSG     MSGID(CPF0000)                                              */ /*CUP005*/
/**********     ENDJRNPF   FILE(GLORWAPD) JRN(&JLIB/JGLC3350)                             /*CGL018*/
/**********     MONMSG     MSGID(CPF0000)                                                 /*CGL018*/
/**********  ENDDO                                                          */ /*CCB009*/ /*CUP005*/
 
                ENDCMTCTL
                MONMSG     MSGID(CPF8350)
 
/**********                                                                 */ /*CCB009*/ /*CUP005*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),*           */ /*CCB009*/ /*CUP005*/
/**********                                                                 */ /*CCB009*/ /*CUP005*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                */ /*CCB009*/ /*CUP005*/
/**********     DLTJRN     JRN(&JLIB/JGLC3350)                                         */ /*CUP005*/
/**********     MONMSG     MSGID(CPF0000)                                              */ /*CUP005*/
/**********     CHGJOB     INQMSGRPY(*DFT)                                             */ /*CUP005*/
/**********     DLTJRNRCV  JRNRCV(&JLIB/JRGLC3350)                                     */ /*CUP005*/
/**********     MONMSG     MSGID(CPF0000)                                              */ /*CUP005*/
/**********     CHGJOB     INQMSGRPY(*RQD)                                             */ /*CUP005*/
/**********  ENDDO                                                          */ /*CCB009*/ /*CUP005*/
 
                GOTO       CMDLBL(END)
             ENDDO
 
/* No Database Error */
 
             COMMIT
             SNDPGMMSG  MSG('GLC3350 - Collateral Details File +
                          Purge Completed Normally') TOMSGQ(MRUNQ)
 
/**********                                                                 */ /*CCB009*/ /*CUP005*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),*           */ /*CCB009*/ /*CUP005*/
/**********                                                                 */ /*CCB009*/ /*CUP005*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                */ /*CCB009*/ /*CUP005*/
/**********  ENDJRNAP   FILE(*ALL) JRN(&JLIB/JGLC3350)                                 */ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  ENDJRNPF   FILE(GLCOLLPD) JRN(&JLIB/JGLC3350)                             */ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  ENDJRNPF   FILE(GLCOLAPD) JRN(&JLIB/JGLC3350)                             */ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  ENDJRNPF   FILE(GLCOLNPD) JRN(&JLIB/JGLC3350)                             */ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  ENDJRNPF   FILE(GLORWAPD) JRN(&JLIB/JGLC3350)                                /*CGL018*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*CGL018*/
/**********  ENDDO                                                          */ /*CCB009*/ /*CUP005*/
 
             ENDCMTCTL
             MONMSG     MSGID(CPF8350)
 
/**********                                                                 */ /*CCB009*/ /*CUP005*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),*           */ /*CCB009*/ /*CUP005*/
/**********                                                                 */ /*CCB009*/ /*CUP005*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                */ /*CCB009*/ /*CUP005*/
/**********  DLTJRN     JRN(&JLIB/JGLC3350)                                            */ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  CHGJOB     INQMSGRPY(*DFT)                                                */ /*CUP005*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRGLC3350)                                        */ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP005*/
/**********  CHGJOB     INQMSGRPY(*RQD)                                                */ /*CUP005*/
/**********  ENDDO                                                          */ /*CCB009*/ /*CUP005*/
 
/**********  RGZPFM     FILE(GLCOLLPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('GLCOLLPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(GLCOLAPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('GLCOLAPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(GLCOLNPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('GLCOLNPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(GLORWAPD)                    /* CGL018 */                    /*228542*/
/**********  MONMSG     MSGID(CPF2981)                    /* CGL018 */                    /*228542*/
             CALL       PGM(SCC000060) PARM('GLORWAPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                          /*228542*/
/*                                                                                        /*CAP205*/
/* If Feature CAP205 is 'on' (Retail Account Balance Check)                               /*CAP205*/
/*                                                                                        /*CAP205*/
             IF         COND(&CAP205 *EQ '       ') THEN(DO)                              /*CAP205*/
             CALL       PGM(SCC000060) PARM('GLCOLLQD' '*FIRST')                          /*CAP205*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CAP205*/
             ENDDO                                                                        /*CAP205*/
                                                                                          /*CAP205*/
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                            MSGDTA('Program GLC3350 ended +
                            abnormally - see job log') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
