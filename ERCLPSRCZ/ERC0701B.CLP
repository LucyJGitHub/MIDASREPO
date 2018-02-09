/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER  - Interface to FRS - Run Date')             */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERC0701A- EUROPEAN REPORTING                                 */
/*                                                                  */
/*       (c) Finastra International Limited 2005                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                                         Date                      */
/*********************************************************************/
/**/
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*********************************************************************/
             PGM        PARM(&BJMRDT &BJURPT)
 
             DCL        VAR(&BJMRDT) TYPE(*CHAR) LEN(7) /* Midas Run +
                          date */
             DCL        VAR(&BJURPT) TYPE(*CHAR) LEN(53) /* title */
 
/**********  DCLF       FILE(ERBANKPD) RCDFMT(SDBANKD0)                   */              /*CER001*/
             DCLF       FILE(ERBNKXPD) RCDFMT(SDBANKD0)                                   /*CER001*/
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
 
         RCVF       RCDFMT(SDBANKD0)
 
             IF         COND(&BJMRDT *EQ *BLANK) THEN(DO)
/**********  SNDPGMMSG  MSG('ERC0701B- Empty file ERBANKPD') +
                          TOMSGQ(ERMSGQ)                                  */              /*CER001*/
             SNDPGMMSG  MSG('ERC0701B- Empty file ERBANKLXPD') +
                          TOMSGQ(MOPERQ)                                                  /*CER001*/
             GOTO       CMDLBL(ERROR)
                                                      ENDDO
 
             GOTO       CMDLBL(EOJ)
 
/*------------------------ ERROR  --------------------------------*/
 ERROR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) MSGDTA('ERC0701B  +
                          001') TOMSGQ(ERMSGQ)
             MONMSG     MSGID(CPF0000)
 
EOJ:         ENDPGM
