/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE End of tax year processing')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                               */
/*                                                                   */
/*       REC2189 - BRT END OF TAX YEAR PROCESSING                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 09May95              */
/*                      053520            DATE  23NOV93              */
/*                      042015            DATE  08JUL92              */
/*                      S01383            DATE  27APR92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       S01408 - Addition of core hook REC2189MPS                   */
/*       053520 - PSEQ must be passed as parameter, since this pgm   */
/*                may be run as on-request or as a mandatory report. */
/*                Pass a blank sequence number to RE2196 and remove  */
/*                fix 042015 from RE2196.                            */
/*       042015 - COMPONENT SEQUENCE NUMBER SHOULD NOT BE PASSED     */
/*                TO RE2195                                          */
/*       S01383 - BASIC RATE TAX INCORPORATION                       */
/*                NEW PROGRAM                                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
      PGM   PARM(&CNAM &CSEQ)
      DCL   VAR(&DATA)     TYPE(*CHAR) LEN(50)
      DCL   VAR(&MEM)      TYPE(*CHAR) LEN(50)
      DCL   VAR(&LDA)      TYPE(*CHAR) LEN(256)
      DCL   VAR(&EOTY)     TYPE(*CHAR) LEN(1)
      DCL   VAR(&YY)       TYPE(*CHAR) LEN(2)
      DCL   VAR(&CNAM)     TYPE(*CHAR) LEN(10)
      DCL   VAR(&CSEQ)     TYPE(*DEC)  LEN(5)
      DCL   VAR(&BUSY)     TYPE(*CHAR) LEN(1)
      DCL   VAR(&INTPSYY)  TYPE(*CHAR) LEN(7)
      DCL   VAR(&COINTYY)  TYPE(*CHAR) LEN(7)
      DCL   VAR(&S17RTNYY) TYPE(*CHAR) LEN(8)
      DCL   VAR(&SRTCD)    TYPE(*CHAR) LEN(7)
      DCL   VAR(&SOPTN)    TYPE(*CHAR) LEN(7) +
            VALUE('*VERIFY')
      DCL   VAR(&SSARD)    TYPE(*CHAR) LEN(6) +
            VALUE('S01383')
      DCL   VAR(&DPLIB)    TYPE(*CHAR) LEN(10)
      DCL   VAR(&LDA)      TYPE(*CHAR) LEN(256)
      DCL   VAR(&SDSTAT)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
      RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
/*****CHGVAR*****&DPLIB**VALUE(%SUBSTRING(&SDSTAT 6 2)**'DPLIB')     */ /*BG18886*/
             CHGVAR     VAR(&DPLIB) VALUE(%SUBSTRING(&SDSTAT 6 2) +
                          *CAT 'DPLIB')                                 /*BG18886*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC2189MPS                                          */
                                                                      /*S01408*/
 
/* Set switches                                                     */
 
      CHGJOB  SWS(00000000)
 
/**/
/* DETERMINE IF BRT SAR INSTALLED */
/**/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/**/
/* BRT SAR NOT INSTALLED */
/**/
             IF         COND(&SRTCD *NE '       ') THEN(DO)
                GOTO FINISH
             ENDDO
 
/**/
/* DETERMINE IF END OF TAX YEAR HAS ARRIVED */
/**/
             CALL       PGM(RE2189) PARM(&EOTY &YY)
 
/* If data base error send appropriate message and terminate pgm    */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('REC2189 - Job Terminated, +
                            Database in Error')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO    CMDLBL(FINISH)
             ENDDO
 
 
             IF         COND(&EOTY *NE 'Y') THEN(GOTO CMDLBL(FINISH))
 
 
             SNDPGMMSG  MSG('REC2189 - BRT End of Tax Year +
                          Processing') TOMSGQ(MRUNQ)
 
/* CHECK FOR COMPONENT RESTART                                      */
 
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* IF RESTART, RESTORE SAVED FILES                                  */
 
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&DPLIB/XACCNTAB) TOFILE(ACCNTAB) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM ACCNTAB)
 
             CPYF       FROMFILE(&DPLIB/XDEALSDC) TOFILE(DEALSDC) +
                         MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM DEALSDC)
 
             CPYF       FROMFILE(&DPLIB/XPTYHSTPD) TOFILE(PTYHSTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM PTYHSTPD)
 
             CPYF       FROMFILE(&DPLIB/XPTYSEQPD) TOFILE(PTYSEQPD) +
                          FROMMBR(PTYSEQPD) TOMBR(PTYSEQPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PTYSEQPD) MBR(PTYSEQPD))
 
             CPYF       FROMFILE(&DPLIB/XINTPSDD) TOFILE(INTPSDD) +
                          FROMMBR(INTPSDD) TOMBR(INTPSDD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(INTPSDD) MBR(INTPSDD))
 
             CPYF       FROMFILE(&DPLIB/XCOINTDD) TOFILE(COINTDD) +
                          FROMMBR(COINTDD) TOMBR(COINTDD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(COINTDD) MBR(COINTDD))
 
             CPYF       FROMFILE(&DPLIB/XSDBRTDPD) TOFILE(SDBRTDPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SDBRTDPD)
 
/* CHANGE FLAG TO NOT BUSY              */
 
                CHGVAR     VAR(&BUSY) VALUE('N')
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
             ENDDO
 
/* SAVE FILES                                                       */
 
             DLTF       FILE(&DPLIB/XACCNTAB)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XDEALSDC)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XPTYHSTPD)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XPTYSEQPD)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XINTPSDD)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XCOINTDD)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XSDBRTDPD)
             MONMSG CPF0000
 
             CPYF       FROMFILE(ACCNTAB) TOFILE(&DPLIB/XACCNTAB) +
                          CRTFILE(*YES)
 
             CPYF       FROMFILE(DEALSDC) TOFILE(&DPLIB/XDEALSDC) +
                          CRTFILE(*YES)
 
             CPYF       FROMFILE(PTYHSTPD) TOFILE(&DPLIB/XPTYHSTPD) +
                          CRTFILE(*YES)
 
             CPYF       FROMFILE(PTYSEQPD) TOFILE(&DPLIB/XPTYSEQPD) +
                          CRTFILE(*YES)
 
             CPYF       FROMFILE(INTPSDD) TOFILE(&DPLIB/XINTPSDD) +
                          CRTFILE(*YES)
 
             CPYF       FROMFILE(COINTDD) TOFILE(&DPLIB/XCOINTDD) +
                          CRTFILE(*YES)
 
             CPYF       FROMFILE(SDBRTDPD) TOFILE(&DPLIB/XSDBRTDPD) +
                          CRTFILE(*YES)
 
/* CHANGE FLAG TO BUSY                  */
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
 
/************CALL  PGM(RE2195) PARM(&CSEQ 'Y') */                     /*042015*/
             CALL  PGM(RE2195) PARM('Y')                              /*042015*/
 
/* If data base error send appropriate message and terminate pgm    */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                        CMDLBL(DBERR))
 
             CLRPFM     FILE(NEWINTPD)
             CLRPFM     FILE(NEWCINPD)
             CLRPFM     FILE(S17RTNPD)
 
/************CALL  PGM(RE2196) PARM(&CSEQ 'Y') */                     /*042015*/
/************CALL  PGM(RE2196) PARM('Y')                    */ /*042015 053520*/
             CALL  PGM(RE2196) PARM('     ' 'Y')                      /*053520*/
 
/* If data base error send appropriate message and terminate pgm    */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                        CMDLBL(DBERR))
 
 
             CALL  PGM(RE2197)
 
/* If data base error send appropriate message and terminate pgm    */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                        CMDLBL(DBERR))
 
 
             CALL  PGM(RE2190)
 
/* If data base error send appropriate message and terminate pgm    */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                        CMDLBL(DBERR))
 
 
/*   NAME ARCHIVE COPY OF INTPSDD : INTPSYY                 */
/*   WHERE YY IS LAST TWO FIGURES OF CURRENT YEAR           */
 
             CHGVAR     VAR(&INTPSYY) VALUE('INTPS' *TCAT &YY)
 
 
/*   NAME ARCHIVE COPY OF COINTDD : COINTYY                 */
/*   WHERE YY IS LAST TWO FIGURES OF CURRENT YEAR           */
 
             CHGVAR     VAR(&COINTYY) VALUE('COINT' *TCAT &YY)
 
 
/*   NAME ARCHIVE COPY OF S17RTNPD : S17RTNYY               */
/*   WHERE YY IS LAST TWO FIGURES OF CURRENT YEAR           */
 
             CHGVAR     VAR(&S17RTNYY) VALUE('S17RTN' *TCAT &YY)
 
 
/*   SUCCESSFUL COMPLETION - MAKE ARCHIVE COPIES OF INTPSDD & S17RTNPD  */
 
             DLTF       FILE(&DPLIB/&INTPSYY)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DPLIB/&COINTYY)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DPLIB/&S17RTNYY)
             MONMSG     MSGID(CPF0000)
/**/
             CPYF       FROMFILE(INTPSDD) TOFILE(&DPLIB/&INTPSYY) +
                          FROMMBR(INTPSDD) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&INTPSYY))
/**/
             CPYF       FROMFILE(COINTDD) TOFILE(&DPLIB/&COINTYY) +
                          FROMMBR(COINTDD) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&COINTYY))
/**/
             CPYF       FROMFILE(S17RTNPD) TOFILE(&DPLIB/&S17RTNYY) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&S17RTNYY))
 
/* CHANGE FLAG TO NOT BUSY              */
 
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
/**/
/*   CLEAR INTPSDD AND REPLACE RECORDS STILL VALID FOR NEXT TAX YEAR */
/**/
 
             CPYF       FROMFILE(NEWINTPD) TOFILE(INTPSDD) +
                          TOMBR(INTPSDD) MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(INTPSDD) MBR(INTPSDD))
 
             CPYF       FROMFILE(NEWCINPD) TOFILE(COINTDD) +
                          TOMBR(COINTDD) MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(COINTDD) MBR(COINTDD))
 
             CLRPFM     FILE(NEWINTPD)
             CLRPFM     FILE(NEWCINPD)
             CLRPFM     FILE(S17RTNPD)
             CLRPFM     FILE(PTYSEQPD) MBR(PTYSEQPD)
/**/
             DLTF       FILE(&DPLIB/XACCNTAB)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XDEALSDC)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XPTYHSTPD)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XPTYSEQPD)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XINTPSDD)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XCOINTDD)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/XSDBRTDPD)
             MONMSG CPF0000
 
             GOTO       CMDLBL(FINISH)
 
/**/
 DBERR:       RTVDTAARA  DTAARA(LDA (134 50))   RTNVAR(&DATA)
              SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
              TOMSGQ(MOPERQ MRUNQ) TOPGMQ(*EXT)
              CHGVAR    VAR(&DATA) VALUE('REC2189 - Job Terminated, +
                          Database in Error')
              SNDPGMMSG  MSG(&DATA) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
/**/
 FINISH:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
