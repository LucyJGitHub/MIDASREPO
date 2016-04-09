/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Amount Accrual Update, Entry Gen - ANWD')    */
/********************************************************************/
/*                                                                  */
/*            Midas - General Ledger Module                         */
/*                                                                  */
/*       GLC1140A - AMOUNT ACCRUAL UPDATE & ENTRY GENERATION        */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CGL141             Date 12Dec12             */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 122794 *CREATE     Date 18JUN98             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*      CGL141 - Amount Accruals Extended Narrative                 */
/*               Added Hooks: CGL141_004 TO CGL141_006              */
/*      122794 - Upgrade 0f 69920 .Based on GLC1140                 */
/*               CREATED FOR NON WORKING DAY ACCRUAL                */
/*                                                                  */
/********************************************************************/
             PGM     PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(75)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA)     TYPE(*CHAR) LEN(256)
             DCL        VAR(&CNAM)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)    TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY)    TYPE(*CHAR) LEN(1)
/*/COPY OFCPYSRCZ,CGL141_004                                         */                   /*CGL141*/
/**/
/*   MONITOR ANY ERROR MESSAGE DURING PGM AND GO TO ABNORMAL */
/*   PROCESSING IF THERE IS A PROBLEM                        */
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGJOB   SWS(00000000)
/**/
/**/
           SNDPGMMSG  MSG('GLC1140A Amount Accrual Update & Entry Generation') +
                                TOMSGQ(MRUNQ)
/**/
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/**/
           IF         COND(&BUSY = 'N') THEN(DO)
/**/
/*/COPY OFCPYSRCZ,CGL141_005                                         */                   /*CGL141*/
             CLRPFM NAMACA
             CLRPFM NAMACD
             CLRPFM NAMACZ
             CLRPFM GEAA2HH
             CLRPFM GEAA2PD
             CLRPFM GEAA2ZZ
             OVRDBF FILE(GEAAPD) TOFILE(GEAA2PD) SEQONLY(*YES 250)
             OVRDBF FILE(GEAAHH) TOFILE(GEAA2HH)
             OVRDBF FILE(GEAAZZ) TOFILE(GEAA2ZZ)
/**/
             CALL   GL1140
/**/
             DLTOVR FILE(*ALL)
/**/
/**/
          ENDDO
/**/
           IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/**/
             CLRPFM AMACCA
             CLRPFM AMACCD
             CLRPFM AMACCZ
/**/
             CPYF NAMACA AMACCA MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(AMACCA))
             CPYF NAMACD AMACCD MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(AMACCD))
             CPYF NAMACZ AMACCZ MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(AMACCZ))
/*/COPY OFCPYSRCZ,CGL141_006                                         */                   /*CGL141*/
/**/
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/**/
          ENDDO
/**/
          DLTOVR *ALL
/**/
/*  SEND FILE CONTROL MESSAGES  */
/**/
             IF COND(%SWITCH(XXXXXX01)) THEN(DO)
/**/
               CHGVAR &MSG VALUE('FILE CONTROLS OUT OF BALANCE - FILE +
                                 AMACC')
               SNDPGMMSG &MSG TOMSGQ(MOPERQ)
               SNDPGMMSG &MSG TOPGMQ(*EXT)
             ENDDO
/**/
/*  SEND DATABASE MESSAGES  */
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
/**/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ) TOPGMQ(*EXT)
/**/
             ENDDO
/**/
/*   IF NO ERRORS OCCURED DURING PGM GO TO END OF PGM          */
/**/
             GOTO CMDLBL(ENDIT)
/**/
/*   ERROR PROCESSING FOR UNMONITORED MESSAGES                */
/**/
 ABNOR:      CHGJOB     SWS(XXXXXX11)
/**/
/*   MONITOR FOR ERRORS WITHIN ABNORMAL PROCESSING TO STOP LOOPING */
/**/
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&MSG) VALUE('ERROR IN GLC1140A - SEE JOB +
                          LOG')
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000)
/**/
 ENDIT:      ENDPGM
