/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DE Historic Extract Controller')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0002 - Historic Extract Controller for CCRM Revenue      */
/*                 Analysis                                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CDE002  *CREATE    Date 12Nov99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TTYP &CPGM)
 
/*/COPY WNCPYSRC,DEC0002INT                                          */
 
             DCL        VAR(&TTYP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CPGM) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&EXTT) TYPE(*CHAR) LEN( 4) VALUE('*ALL')
             DCL        VAR(&EOB ) TYPE(*CHAR) LEN( 1)
/**********  DCL        VAR(&TREF) TYPE(*CHAR) LEN(20) */                                 /*CGL029*/
             DCL        VAR(&TREF) TYPE(*CHAR) LEN(26)                                    /*CGL029*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0002 - Historic Extracts') +
                          TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0002MPS                                          */
 
             CHGVAR     VAR(&PGM) VALUE('DEHXC' *CAT &CPGM)
 
             CLRPFM     FILE(DEHTRANPD) MBR(&TTYP)
             CLRPFM     FILE(DEHPOSNPD) MBR(&TTYP)
             CLRPFM     FILE(DEHEVNTPD) MBR(&TTYP)
             CLRPFM     FILE(DEHCASHPD) MBR(&TTYP)
 
             OVRDBF     FILE(DEHTRANPD) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEHPOSNPD) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEHEVNTPD) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEHCASHPD) MBR(&TTYP) SHARE(*NO)
 
             IF         COND(&CPGM *EQ 'GETR') THEN(DO)
             OVRDBF     FILE(DEGTRANL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEGPOSNL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEGEVNTL1) MBR(&TTYP) SHARE(*NO)
             ENDDO
 
             IF         COND(&CPGM *EQ 'LOAN') THEN(DO)
             OVRDBF     FILE(CLOANX)   TOFILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(HISTSXHM) TOFILE(HISTS) SHARE(*NO)
             OVRDBF     FILE(HISTSXHN) TOFILE(HISTS) SHARE(*NO)
             ENDDO
 
             IF         COND(&CPGM *EQ 'ACCT') THEN(DO)
             OVRDBF     FILE(DEHTRANL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEOTRANL1) MBR(&TTYP) SHARE(*NO)
             ENDDO
 
             CALL       PGM(&PGM) PARM(&RTCD &ERMS &EXTT &EOB &TREF)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
              IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0002 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
                GOTO       CMDLBL(END)
              ENDDO
              IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
              ENDDO
             ENDDO
 
/*/COPY WNCPYSRC,DEC0002MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0002ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0002 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DEC0002END                                          */
 
             RCLRSC
             RCLRSC     LVL(*CALLER)
 
             ENDPGM
