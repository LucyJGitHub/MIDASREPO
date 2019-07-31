/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME BIC Database Converter')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas   - Message Management Module                         */
/*                                                                   */
/*       MEC1460 - ME BIC Database Converter                         */
/*                                                                   */
/*       (c) Finastra International Limited 2007                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. 262412             Date 11Nov09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CFT040             Date 15Sep08              */
/*                      CFT035  *Create    Date 22Jan07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       262412 - Call ME1460 when CFT035 is switched ON             */
/*       CFT040 - BIC Plus IBAN                                      */
/*       CFT035 - BIC Database Changes 2007                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2007')
             DCL        VAR(&ERRTYP) TYPE(*CHAR) LEN(1) VALUE('0')                        /*CFT040*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CFT040*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CFT040*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CFT035')                      /*CFT040*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CFT040*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
 
/* Call the BIC Plus IBAN */                                                              /*CFT040*/
             CALL       PGM(MEC1461) PARM(&ERRTYP)                                        /*CFT040*/
             IF         COND(&ERRTYP *NE '0') THEN(DO)                                    /*CFT040*/
             GOTO       CMDLBL(ABNOR)                                                     /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             CLRPFM     METICPPD
             CLRPFM     METICCPD
             CLRPFM     METICVPD
             OVRDBF     FILE(MEDWFIPD) TOFILE(MEDWFIPD) LVLCHK(*NO)
             OVRDBF     FILE(MEDWCTPD) TOFILE(MEDWCTPD) LVLCHK(*NO)
             OVRDBF     FILE(MEDWHDPD) TOFILE(MEDWHDPD) LVLCHK(*NO)
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CFT040*/
 /********** IF         COND(&RTCD *NE '       ') THEN(DO) */                  /*CFT040*/ /*262412*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*262412*/
             CALL       PGM(ME1460)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)                                  /*CFT040*/
             GOTO       CMDLBL(ERROR1)                                                    /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             IF         COND(%SWITCH(X1XXXXXX)) THEN(DO)                                  /*CFT040*/
             GOTO       CMDLBL(ERROR2)                                                    /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)                                  /*CFT040*/
             GOTO       CMDLBL(ERROR3)                                                    /*CFT040*/
             ENDDO                                                                        /*CFT040*/
             ENDDO                                                                        /*CFT040*/
                                                                                          /*CFT040*/
             SNDPGMMSG  MSG('Program MEC1460 successfully +
                        completed') TOMSGQ(MOPERQ)                                        /*CFT040*/
 
             GOTO       CMDLBL(END)
 
 ERROR1:                                                                                  /*CFT040*/
             SNDPGMMSG  MSG('CT file has invalid data.') +
                          TOMSGQ(MOPERQ)                                                  /*CFT040*/
             GOTO       CMDLBL(ABNOR)                                                     /*CFT040*/
 ERROR2:                                                                                  /*CFT040*/
             SNDPGMMSG  MSG('BI file has invalid data.') +
                          TOMSGQ(MOPERQ)                                                  /*CFT040*/
             GOTO       CMDLBL(ABNOR)                                                     /*CFT040*/
 ERROR3:                                                                                  /*CFT040*/
             SNDPGMMSG  MSG('IS file has invalid data.') +
                          TOMSGQ(MOPERQ)                                                  /*CFT040*/
             GOTO       CMDLBL(ABNOR)                                                     /*CFT040*/
 ABNOR:
/*********   CHGJOB     SWS(XXXXXX11) */                                                  /*CFT040*/
             CHGJOB     SWS(000XXX11)                                                     /*CFT040*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1460 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
 
