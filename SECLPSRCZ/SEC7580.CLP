/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Drop Of Corporate Actions Event')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC7580 - SE Drop of Corporate Action Events                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. 161732             Date 21Mar00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU017             Date 02Apr98              */
/*                      CSE007  *CREATE    Date 25Feb98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       161732 - Corporate Actions Exercise and Conversion -        */
/*                Part Stock/Keep Rest Calculation in SECOEXPD (reco)*/
/*       CEU017 - Securities Redenomination Euro Changes             */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)   TYPE(*DEC)  LEN(5)
             DCL        VAR(&BUSY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(52)
             DCL        VAR(&DLIB)   TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO)  TYPE(*CHAR) LEN(6)
 
/* Global Monitor Message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Retrieve Job attributes */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)
 
/* Get system ID to build DPLIB name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DPLIB')
 
/* Send Information Program Message */
             SNDPGMMSG  MSG('SEC7580 - Drop of Corporate Action   +
                          Events') TOMSGQ(MRUNQ)
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/* Override to SEQONLY(*YES 100) */
             OVRDBF     FILE(SECODRPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECODPPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECOALPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECOREPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECOEXPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECOFRPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECOCEPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECONFPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECONCPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECODVPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECORGPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECOOFPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECOCRPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SECOCCPD)  SEQONLY(*YES 100)              /*CEU017*/
             OVRDBF     FILE(SECORBPD)  SEQONLY(*YES 100)              /*CEU017*/
             OVRDBF     FILE(SECORSPD)  SEQONLY(*YES 100)              /*CEU017*/
 
             OVRDBF     FILE(XSECODRPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECODPPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECOALPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECOREPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECOEXPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECOFRPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECOCEPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECONFPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECONCPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECODVPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECORGPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECOOFPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECOCRPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSECOCCPD)  SEQONLY(*YES 100)             /*CEU017*/
             OVRDBF     FILE(XSECORBPD)  SEQONLY(*YES 100)             /*CEU017*/
             OVRDBF     FILE(XSECORSPD)  SEQONLY(*YES 100)             /*CEU017*/
 
/* Retrieve the field indicating a Restart */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* If it's a Restart, Restore Security Copies */
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&DLIB/XSECODRPD) TOFILE(SECODRPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECODRPD))
 
             CPYF       FROMFILE(&DLIB/XSECODPPD) TOFILE(SECODPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECODPPD))
 
             CPYF       FROMFILE(&DLIB/XSECOALPD) TOFILE(SECOALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOALPD))
 
             CPYF       FROMFILE(&DLIB/XSECOREPD) TOFILE(SECOREPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOREPD))
 
             CPYF       FROMFILE(&DLIB/XSECOEXPD) TOFILE(SECOEXPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOEXPD))
 
             CPYF       FROMFILE(&DLIB/XSECOFRPD) TOFILE(SECOFRPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOFRPD))
 
             CPYF       FROMFILE(&DLIB/XSECOCEPD) TOFILE(SECOCEPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOCEPD))
 
             CPYF       FROMFILE(&DLIB/XSECONFPD) TOFILE(SECONFPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECONFPD))
 
             CPYF       FROMFILE(&DLIB/XSECONCPD) TOFILE(SECONCPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECONCPD))
 
             CPYF       FROMFILE(&DLIB/XSECODVPD) TOFILE(SECODVPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECODVPD))
 
             CPYF       FROMFILE(&DLIB/XSECORGPD) TOFILE(SECORGPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECORGPD))
 
             CPYF       FROMFILE(&DLIB/XSECOFPPD) TOFILE(SECOFPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOFPPD))
 
             CPYF       FROMFILE(&DLIB/XSECOCRPD) TOFILE(SECOCRPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOCRPD))
 
             CPYF       FROMFILE(&DLIB/XSECOCCPD) TOFILE(SECOCCPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)               /*CEU017*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOCCPD))                              /*CEU017*/
 
             CPYF       FROMFILE(&DLIB/XSECORBPD) TOFILE(SECORBPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)               /*CEU017*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECORBPD))                              /*CEU017*/
 
             CPYF       FROMFILE(&DLIB/XSECORSPD) TOFILE(SECORSPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)               /*CEU017*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECORSPD))                              /*CEU017*/
             ENDDO
 
             ELSE CMD(DO)
 
/* Delete Copy Files */
             DLTF       FILE(&DLIB/XSECODRPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECODPPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOALPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOREPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOEXPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOFRPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOCEPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECONFPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECONCPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECODVPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECORGPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOOFPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOCRPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOCCPD)                          /*CEU017*/
             MONMSG MSGID(CPF0000)                                     /*CEU017*/
             DLTF       FILE(&DLIB/XSECORBPD)                          /*CEU017*/
             MONMSG MSGID(CPF0000)                                     /*CEU017*/
             DLTF       FILE(&DLIB/XSECORSPD)                          /*CEU017*/
             MONMSG MSGID(CPF0000)                                     /*CEU017*/
 
             CPYF       FROMFILE(SECODRPD) TOFILE(&DLIB/XSECODRPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECODPPD) TOFILE(&DLIB/XSECODPPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECOALPD) TOFILE(&DLIB/XSECOALPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECOREPD) TOFILE(&DLIB/XSECOREPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECOEXPD) TOFILE(&DLIB/XSECOEXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECOFRPD) TOFILE(&DLIB/XSECOFRPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECOCEPD) TOFILE(&DLIB/XSECOCEPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECONFPD) TOFILE(&DLIB/XSECONFPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECONCPD) TOFILE(&DLIB/XSECONCPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECODVPD) TOFILE(&DLIB/XSECODVPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECORGPD) TOFILE(&DLIB/XSECORGPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECOOFPD) TOFILE(&DLIB/XSECOOFPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECOCRPD) TOFILE(&DLIB/XSECOCRPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(SECOCCPD) TOFILE(&DLIB/XSECOCCPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                 /*CEU017*/
 
             CPYF       FROMFILE(SECORBPD) TOFILE(&DLIB/XSECORBPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                 /*CEU017*/
 
             CPYF       FROMFILE(SECORSPD) TOFILE(&DLIB/XSECORSPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                 /*CEU017*/
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
             ENDDO
 
/* Delete overrides */
/*           DLTOVR     FILE(SECODRPD SECODPPD SECOALPD SECOREPD +
                          SECOEXPD SECOFRPD SECOCEPD SECONFPD    +
                          SECONCPD SECODVPD SECORGPD SECOOFPD    +
                          SECOCRPD)                                 */ /*CEU017*/
             DLTOVR     FILE(SECODRPD SECODPPD SECOALPD SECOREPD +
                          SECOEXPD SECOFRPD SECOCEPD SECONFPD    +
                          SECONCPD SECODVPD SECORGPD SECOOFPD    +
                          SECOCRPD SECOCCPD SECORBPD SECORSPD)         /*CEU017*/
 
/*           DLTOVR     FILE(XSECODRPD XSECODPPD XSECOALPD XSECOREPD +
                          XSECOEXPD XSECOFRPD XSECOCEPD XSECONFPD    +
                          XSECONCPD XSECODVPD XSECORGPD XSECOOFPD    +
                          XSECOCRPD)                                */ /*CEU017*/
             DLTOVR     FILE(XSECODRPD XSECODPPD XSECOALPD XSECOREPD +
                          XSECOEXPD XSECOFRPD XSECOCEPD XSECONFPD    +
                          XSECONCPD XSECODVPD XSECORGPD XSECOOFPD    +
                          XSECOCRPD XSECOCCPD XSECORBPD XSECORSPD)     /*CEU017*/
/* Call RPG name */
             CALL       PGM(SE7580)
 
/* If error */
ABNOR:       MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
               CHGJOB     SWS(XXXXXX11)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               SNDMSG     MSG('SE6764 ENDED ABNORMALLY FOR JOB ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               SNDMSG     MSG('SE6764 ENDED ABNORMALLY FOR JOB ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
/* If the job is completed normally */
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
/* Delete Security Copies */
             DLTF       FILE(&DLIB/XSECODRPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECODPPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOALPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOREPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOEXPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOFRPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOCEPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECONFPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECONCPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECODVPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECORGPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOOFPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOCRPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSECOCRPD)                          /*CEU017*/
             MONMSG MSGID(CPF0000)                                     /*CEU017*/
             DLTF       FILE(&DLIB/XSECORBPD)                          /*CEU017*/
             MONMSG MSGID(CPF0000)                                     /*CEU017*/
             DLTF       FILE(&DLIB/XSECORSPD)                          /*CEU017*/
             MONMSG MSGID(CPF0000)                                     /*CEU017*/
 
ENDCLPGM:    CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
