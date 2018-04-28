/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DE Projections on-line extract')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0005 - Projections On-line Extract for CCRM Limits       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CDE002             Date 05Dec00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CDE001  *CREATE    Date 12Nov99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*       CDE001 - Data Export - CCRM Limits                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DEC0005INT                                          */
 
             DCL        VAR(&TEMPENTYP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JSEQN) TYPE(*DEC) LEN(10)
             DCL        VAR(&JSEQA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(DEOLEJPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             ALCOBJ     OBJ((DEOLEJPD *FILE *EXCLRD)) WAIT(30)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                SNDPGMMSG  MSG('Attempt to start CCRM Limits Drip +
                           Feed process has failed. Probable cause: +
                           process is active already.') +
                           TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0005MPS                                          */
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
 
             OVRDBF     FILE(DEOLEJPD) SHARE(*NO)
 
             RCVF
 
             OVRDBF     FILE(DEPTRANPD) MBR(INT) SHARE(*NO)
             OVRDBF     FILE(DEPPOSNPD) MBR(INT) SHARE(*NO)
             OVRDBF     FILE(DEPEVNTPD) MBR(INT) SHARE(*NO)
             OVRDBF     FILE(DEPCASHPD) MBR(INT) SHARE(*NO)
 
             OVRDBF     FILE(DEALS)    SHARE(*NO)
             OVRDBF     FILE(DEALSX) TOFILE(DEALS) SHARE(*NO) +
                          /*CDE002*/
             OVRDBF     FILE(MMDEALLL) SHARE(*NO)
             OVRDBF     FILE(CLOANX) TOFILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(CLOAN) TOFILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(TRANS) MBR(OTC) SHARE(*NO)
             OVRDBF     FILE(TRSET) MBR(OTC) SHARE(*NO)
             OVRDBF     FILE(PRICS) MBR(OTC) SHARE(*NO)
 
             CHGVAR     VAR(&JSEQN) VALUE(&I#LASTSEQ)
 
/* Check if journal sequence exists. */
/* If journal sequence does not exist, set to restart at first entry */
 
             RTVJRNE    JRN(ICJRN) FROMENT(&JSEQN) TOENT(&JSEQN) +
                          RTNENTTYP(&TEMPENTYP)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   CHGVAR     VAR(&JSEQN) VALUE(0)
                   RTVJRNE    JRN(ICJRN) FROMENT(*FIRST) +
                                TOENT(*FIRST) RTNSEQNBR(&JSEQN)
                   MONMSG     MSGID(CPF0000)
                ENDDO
 
             CHGVAR     VAR(&JSEQN) VALUE(&JSEQN + 1)
 
             RCVJRNE    JRN(ICJRN) EXITPGM(DEPONLINE) +
                          FILE((DETRIGPD)) RCVRNG(*CURCHAIN) +
                          FROMENT(&JSEQN) ENTTYP(PT) ENTFMT(*TYPE1) +
                          DELAY(*NEXTENT)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               ROLLBACK
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0005 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,DEC0005MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0005ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
               ROLLBACK
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0005 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DEC0005END                                          */
 
             DLCOBJ     OBJ((DEOLEJPD *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             RCLRSC
             RCLRSC     LVL(*CALLER)
 
             ENDPGM
