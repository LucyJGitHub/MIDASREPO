/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Interest history switchability')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC9110 - INTEREST HISTORY PURGE PROGRAM                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. 073175 *CREATE     DATE 24NOV97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       073175 - New program created to call DL9110 as pgm has      */
/*                different parameters than DL9100.                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
 
/*/COPY WNCPYSRC,DLC9110INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
 
/**/
/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,DLC9110MPS                                          */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('AUS006')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *NE '       ') THEN(DO)
                  RTVMSG     MSGID(XXM0001) MSGF(MIDASMSG) MSG(&MESSAGE)
                  CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                  RTVMSG     MSGID(XXM0004) MSGF(MIDASMSG) MSG(&MESSAGE)
                  CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
                  RTVMSG     MSGID(XXM0004) MSGF(MIDASMSG) MSG(&MESSAGE)
                  CHGDTAARA  DTAARA(MIDASMSG (451 50)) VALUE(&MESSAGE)
                  CALL       PGM(SCC0040) PARM('DLC9110' 'ENTER' &REPLY)
             ENDDO
/* */
             ELSE       CMD(DO)
             CALL       PGM(&PARM)
             ENDDO
 
/*/COPY WNCPYSRC,DLC9110MPE                                        */
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
/*/COPY WNCPYSRC,DLC9110ERR                                        */
 
             CHGJOB     SWS(XXXXXX11)
 
/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN  */
             RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
             RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')
             MONMSG     MSGID(CPF0000 MCH0000)
             CALL       PGM(SCC0010) PARM('DLC9100' 'ENTER' &REPLY)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DLC9110END                                          */
 
             ENDPGM
