/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('AOOULEU0 wrapper for On-line Update LE Posn Files')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Access Objects Module                               */
/*                                                                   */
/*       AOCOULEU0 - AOOULEU0 wrapper for On-Line Update LE Posn     */
/*                   Files                                           */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. CSD103             Date 10Aug20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      CER049             Date 06Dec10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG10617           Date 20Feb06              */
/*                      CLE106 *Create     Date 03May05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD103 - LIBOR Deregulation - Common Layer/Standing Data    */
/*       MD046248 - Finastra Rebranding                              */
/*       CER049 - Stamp Tax                                          */
/*       BUG10617 - An error occured while calling the RPG program   */
/*                  A0OULEU0. Create dtaara ZMITEM.                  */
/*       CLE106 - Syndication Manager                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRTCD &Z#BSTS &Z#ASTS &Z#WSTS &Z#BSTK +
                          &Z#ASTK)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&Z#BSTS) TYPE(*CHAR) LEN(2560)
             DCL        VAR(&Z#ASTS) TYPE(*CHAR) LEN(2560)
             DCL        VAR(&Z#WSTS) TYPE(*CHAR) LEN(2560)
             DCL        VAR(&Z#BSTK) TYPE(*CHAR) LEN(2048)
             DCL        VAR(&Z#ASTK) TYPE(*CHAR) LEN(2048)
             DCL        VAR(&CLONQD) TYPE(*CHAR) LEN(256)                                 /*CER049*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
                                                                                        /*BUG10617*/
/** Create the data area ZMITEM in QTEMP */                                             /*BUG10617*/
                                                                                        /*BUG10617*/
             CRTDTAARA  DTAARA(QTEMP/ZMITEM) TYPE(*CHAR) LEN(10) +
                          TEXT('Midas SF Menu group/item code')                         /*BUG10617*/
             MONMSG     MSGID(CPF1023)                                                  /*BUG10617*/
                                                                                        /*BUG10617*/
             CHGJOB     SWS(XXXXXX00)
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
/**********  CALL       PGM(AOOULEU0) PARM(&PRTCD &Z#BSTS &Z#ASTS +
                          &Z#WSTS &Z#BSTK &Z#ASTK)                    */                  /*CER049*/
             CALL       PGM(AOOULEU0) PARM(&PRTCD &Z#BSTS &Z#ASTS +
                          &Z#WSTS &Z#BSTK &Z#ASTK &CLONQD)                                /*CER049*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
             COMMIT
             RCLRSC
             ENDCMTCTL
             GOTO       CMDLBL(ENDPGM)
ABNOR:
             DMPCLPGM
             CHGVAR     VAR(&PRTCD) VALUE('*ERROR*')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          AOCOULEU0 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
ENDPGM:
             RCLRSC
             ENDPGM
