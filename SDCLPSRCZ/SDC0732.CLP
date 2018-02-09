/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Collateral locations file purge')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC0732 - Collateral Locations File Purge                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CGL011  *CREATE    Date 20Sep99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CCB009 - Journal files throughout close of business         */
/*       CGL011 - Collateral Processing for Midas                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PCNAM &PCSEQ)
 
             DCL        VAR(&PCNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCSEQ)   TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&INQMSGRPY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
 
             RTVJOBA    INQMSGRPY(&INQMSGRPY) TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Send program message to MRUNQ that this component is running */
 
             SNDPGMMSG  MSG('SDC0732 - Collateral Locations +
                          File Purge') TOMSGQ(MRUNQ)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
 
             CHGJOB     INQMSGRPY(&INQMSGRPY)
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             CRTJRNRCV  JRNRCV(&JLIB/JRSDC0732) TEXT('Journal +
                          Receiver for SD0732 backup journalling')
             MONMSG     MSGID(CPF0000)
             CRTJRN     JRN(&JLIB/JSDC0732) JRNRCV(&JLIB/JRSDC0732) +
                          TEXT('Journal file for SD0732 backup +
                          journalling')
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SDCOLOPD SDFCTLPA) JRN(&JLIB/JSDC0732) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             STRJRNAP   FILE(SDCOLOPD SDFCTLPA) JRN(&JLIB/JSDC0732)
             MONMSG     MSGID(CPF0000)
             ENDDO                                                    /*CCB009*/
 
/* Start commitment control */
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
 
/* Call SD0732 */
 
             CALL       PGM(SD0732)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
                CHGJOB     INQMSGRPY(*RQD)
 
                GOTO       CMDLBL(END)
             ENDDO
 
/* No Database Error */
 
             COMMIT
             SNDPGMMSG  MSG('SDC0732 - Collateral Locations +
                          File Purge Completed Normally') TOMSGQ(MRUNQ)
 
             CHGJOB     INQMSGRPY(*RQD)
 
/**********  RGZPFM     FILE(SDCOLOPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('SDCOLOPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                          /*228542*/
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                            MSGDTA('Program SDC0732 ended +
                            abnormally - see job log') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 END:
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNAP   FILE(*ALL) JRN(&JLIB/JSDC0732)
             MONMSG     MSGID(CPF0000)
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/JSDC0732)
             MONMSG     MSGID(CPF0000)
             ENDDO                                                    /*CCB009*/
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             DLTJRN     JRN(&JLIB/JSDC0732)
             MONMSG     MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(&JLIB/JRSDC0732)
             MONMSG     MSGID(CPF0000)
             ENDDO                                                    /*CCB009*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
