/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Securities redenomination bulk input')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7521  - Redenomination Bulk Input Maintenance            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 149399             Date 12Dec98              */
/*       Prev Amend No. CEU017  *CREATE    Date 26Feb98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       149399 - SE7522 CPF4293 - Commitment Control not valid for  */
/*                file SECTY                                         */
/*       CEU017 - Securities Redenomination Euro Changes             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
/*/COPY WNCPYSRC,SEC7521002                                          */
 
             CHGJOB SWS(00000000)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)
             ENDDO
 
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')
             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE('SE7521')
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
 
             OVRDBF FILE(SECTYX)   TOFILE(SECTY)    SHARE(*NO)
             OVRDBF FILE(SECTYZ1)  TOFILE(SECTY)    SHARE(*NO)
             OVRDBF FILE(SECTYZ2)  TOFILE(SECTY)    SHARE(*NO)
             OVRDBF     FILE(SECTY) SHARE(*NO)                        /*149399*/
 
             CALL       PGM(SE7521) PARM(&PARM)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
             ENDDO
 
/* For Database Errors Recover Data from LDA */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR VAR(&MEM) VALUE('SEC7521 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*/COPY WNCPYSRC,SEC7521001                                          */
             RCLRSC
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
