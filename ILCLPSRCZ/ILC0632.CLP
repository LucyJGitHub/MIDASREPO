/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Loans & Customer changes')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0632  - IBLC 2002 Print loans,deals and customer changed */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 22Jul05              */
/*                      ULX043             Date 21Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT)
 
/***  Declare PGM Variables  ***/
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/*                                                                            */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
/**********  DCL        VAR(&STRJRN) TYPE(*CHAR) LEN(8)                                     CER001*/
             DCL        VAR(&STRJRN) TYPE(*CHAR) LEN(10)                                  /*CER001*/
             DCL        VAR(&LAST) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
/***         DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)                 ***/
 
/***  Declare PGM Variables for RTVJOBA ***/
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RETSAR) TYPE(*CHAR) LEN(7) VALUE('      ')
             DCL        VAR(&FMTSAR) TYPE(*CHAR) LEN(200) VALUE('   ')
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***         RTVDTAARA  DTAARA(ILSTAT) RTNVAR(&ILSTAT)                    ***/
/***         IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +     ***/
/***                      CMDLBL(ENDPG))                                  ***/
 
/***  Ensure ULX043 is installed.  ***/
 
             CALL       PGM(AOSARDR0) PARM(&RETSAR '*KEY    ' 'ULX043' &FMTSAR)
             IF         COND(&RETSAR *NE '       ') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/***  Send message to program message queue.  ***/
 
             SNDPGMMSG  MSG('ILC0632 - Retrieve Loans with Maturity +
                          Date Changed & Customers with Location +
                          changed') TOMSGQ(MOPERQ MRUNQ)
 
/***  Reset Switches ***/
 
             CHGJOB     SWS(00000000)
 
/***  Retrieve Job Attributes  ***/
 
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)
 
/***  Data area JNSTAT must exist to retrieve journal receiver  ***/
 
             CHKOBJ     OBJ(*LIBL/JNSTAT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(ABNOR))
/**********  RTVDTAARA  DTAARA(JNSTAT (1 8)) RTNVAR(&STRJRN)       */                     /*CER001*/
             RTVDTAARA  DTAARA(JNSTAT (1 10)) RTNVAR(&STRJRN)                             /*CER001*/
 
/***  Retrieve last sequence to ended ILC0632  ***/
 
             RTVJRNE    JRN(ICJRN) RCVRNG(&STRJRN) FROMENT(*LAST) +
                          RTNSEQNBR(&LAST)
 
             CLRPFM     FILE(ILMATCPD)
 
 LOOP:       RCVJRNE    JRN(ICJRN) EXITPGM(IL0632) +
                          FILE((*LIBL/CLOANCL *FIRST)) +
                          RCVRNG(&STRJRN) FROMENT(*FIRST) +
                          TOENT(&LAST) JRNCDE(R) ENTTYP(UB UP)
 
/***  Loop here when cannot assign object  ***/
 
             MONMSG     MSGID(CPF9803) EXEC(DO)
             DLYJOB     DLY(10)
             GOTO       CMDLBL(LOOP)
             ENDDO
 
/***  If no entry received.  ***/
 
             MONMSG     MSGID(CPF7062)
             RCLRSC
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  Print loan duration changes  ***/
 
             CALL       PGM(IL0633) PARM(&RSEQ &RLEV &RENT)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  Retrieve last sequence to ended ILC0632 ***/
 
             CLRPFM     FILE(ILLOCCPD)
 
 LOOP2:      RCVJRNE    JRN(ICJRN) EXITPGM(IL0634) +
                          FILE((*LIBL/SDCUSTPD *FIRST)) +
                          RCVRNG(&STRJRN) FROMENT(*FIRST) +
                          TOENT(&LAST) JRNCDE(R) ENTTYP(UB UP)
 
/***  Loop here when cannot assign object  ***/
 
             MONMSG     MSGID(CPF9803) EXEC(DO)
             DLYJOB     DLY(10)
             GOTO       CMDLBL(LOOP2)
             ENDDO
 
/***  If no entry received.  ***/
 
             MONMSG     MSGID(CPF7062)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
             RCLRSC
 
/***  Print if there is a change of location  ***/
 
             CALL       PGM(IL0635) PARM(&RSEQ &RLEV &RENT)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  Retrieve last sequence to ended ILC0632 ***/
 
             CLRPFM     FILE(ILDMATPD)
 
 LOOP3:      RCVJRNE    JRN(ICJRN) EXITPGM(IL0636) +
                          FILE((*LIBL/DEALSDC *FIRST)) +
                          RCVRNG(&STRJRN) FROMENT(*FIRST) +
                          TOENT(&LAST) JRNCDE(R) ENTTYP(UB UP)
 
/***  Loop here when cannot assign object  ***/
 
             MONMSG     MSGID(CPF9803) EXEC(DO)
             DLYJOB     DLY(10)
             GOTO       CMDLBL(LOOP3)
             ENDDO
 
/***  If no entry received.  ***/
 
             MONMSG     MSGID(CPF7062)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
                                   GOTO       CMDLBL(ENDPGM)
             ENDDO
             RCLRSC
 
/***  Print if there is a change of deal duration.  ***/
 
             CALL       PGM(IL0637) PARM(&RSEQ &RLEV &RENT)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Abnormal  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0632 ENDED ABNORMALLY FOR JOB ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX11)
 
 ENDPGM:     RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
