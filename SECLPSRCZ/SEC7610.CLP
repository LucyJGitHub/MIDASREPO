/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Treaty WHT extract and report generation')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7610 - Treaty withholding tax extract and report         */
/*                 generation                                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. CSE023  *CREATE    Date 12Jul00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE023 - Treaty Withholding Tax                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,SEC7610INT                                          */
 
             DCL        VAR(&CNAM)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)    TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&GROUP)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL)  TYPE(*DEC)  LEN(4)
             DCL        VAR(&TIMEO)   TYPE(*DEC)  LEN(5)
             DCL        VAR(&ERRORC)  TYPE(*DEC)  LEN(1) VALUE(0)
             DCL        VAR(&MIDASLG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MULT)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&BUSY)    TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
             CHGJOB     SWS(00000000)
 
/* Multiple language support                                         */
 
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)
 
             IF         COND(&MULT *EQ '  ') THEN(DO)
               CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
 
/* Build multiple language support object name                       */
 
             CHGVAR     VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')
 
/* Apply multiple language support overrides                         */
 
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)
 
/*/COPY WNCPYSRC,SEC7610MPS                                          */
 
/* Send program message to MRUNQ that this component is running */
 
             SNDPGMMSG  MSG('SEC7610 - Treaty withholding tax and +
                          report generation') TOMSGQ(MRUNQ)
 
/* Retrieve System ID */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
 
/* Journal POSETD, MGOREFPD and MGOMSGPD */
 
             ENDCMTCTL
             MONMSG     MSGID(CPF8350)
             ENDJRNAP   FILE(*ALL) JRN(&JLIB/JSEC7610)
             MONMSG     MSGID(CPF0000)
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/JSEC7610)
             MONMSG     MSGID(CPF0000)
             DLTJRN     JRN(&JLIB/JSEC7610)
             MONMSG     MSGID(CPF2105)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(&JLIB/JRSEC7610)
             MONMSG     MSGID(CPF2105)
             CHGJOB     INQMSGRPY(*RQD)
 
             CRTJRNRCV  JRNRCV(&JLIB/JRSEC7610) TEXT('Journal +
                          Receiver for SEC7610 backup journalling')
             MONMSG     MSGID(CPF0000)
             CRTJRN     JRN(&JLIB/JSEC7610) JRNRCV(&JLIB/JRSEC7610) +
                          TEXT('Journal file for SEC7610 backup +
                          journalling')
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(POSETD MGOREFPD MGOMSGPD) +
                          JRN(&JLIB/JSEC7610) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
 
/* Start commitment control for batch jobs with file updates */
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
 
/* Call CB0150 to update restart indicator */
 
                CHGVAR     VAR(&BUSY) VALUE('Y')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
 
/* MT565 Extract messages */
             CLRPFM     FILE(MGF565PD)
             CALL       PGM(SE1877)
 
/* Format MT0565 message */
             CALL       PGM(MG0565)
 
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
                ENDCMTCTL
                MONMSG     MSGID(CPF8350)
                ENDJRNAP   FILE(*ALL) JRN(&JLIB/JSEC7610)
                MONMSG     MSGID(CPF0000)
                ENDJRNPF   FILE(*ALL) JRN(&JLIB/JSEC7610)
                MONMSG     MSGID(CPF0000)
 
                DLTJRN     JRN(&JLIB/JSEC7610)
                MONMSG     MSGID(CPF0000)
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(&JLIB/JRSEC7610)
                MONMSG     MSGID(CPF0000)
                CHGJOB     INQMSGRPY(*RQD)
 
                GOTO       CMDLBL(END)
             ENDDO
 
/*  DROP ASTERISKED RECORDS                                        */
 
             CPYF       FROMFILE(POSETD) TOFILE(&TOLIB/XPOSETD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF RECI *NE '*')) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPOSETD) MBR(POSETD))
 
/*  COPY BACK LIVE RECORDS                                         */
 
             CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +
                          FROMMBR(POSETD) TOMBR(POSETD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETD) MBR(POSETD))
/*  CLEAR WORK FILES                                               */
 
             DLTF       FILE(XPOSETD)
                MONMSG MSGID(CPF0000)
 
/* MT565 not sent to depot report */
             CALL       PGM(SE7607)
 
/* Clear output files before processing starts */
             CLRPFM     FILE(SDCUINPD)
 
/* Customer income extract */
 
             CALL       PGM(SE7610)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
                ENDJRNAP   FILE(*ALL) JRN(&JLIB/JSEC7610)
                MONMSG     MSGID(CPF0000)
                ENDJRNPF   FILE(*ALL) JRN(&JLIB/JSEC7610)
                MONMSG     MSGID(CPF0000)
 
                DLTJRN     JRN(&JLIB/JSEC7610)
                MONMSG     MSGID(CPF0000)
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(&JLIB/JRSEC7610)
                MONMSG     MSGID(CPF0000)
                CHGJOB     INQMSGRPY(*RQD)
 
                GOTO       CMDLBL(END)
             ENDDO
 
/* Tax paid by basket detail */
             CALL       PGM(SE7605) PARM('     ' '2' ' ')
 
/* Tax paid by basket summary */
             CALL       PGM(SE7606) PARM('     ' '2' ' ')
 
/* Allocation per dividend payment summary */
             CALL       PGM(SE7602) PARM('     ' '2' ' ')
 
/* Allocation per dividend payment full report */
 
             CALL       PGM(SE7603) PARM('     ' '2' ' ')
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             COMMIT
             ENDCMTCTL
                MONMSG     MSGID(CPF8350)
 
             ENDJRNAP   FILE(*ALL) JRN(&JLIB/JSEC7610)
             MONMSG     MSGID(CPF0000)
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/JSEC7610)
             MONMSG     MSGID(CPF0000)
             DLTJRN     JRN(&JLIB/JSEC7610)
             MONMSG     MSGID(CPF2105)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(&JLIB/JRSEC7610)
             MONMSG     MSGID(CPF2105)
             CHGJOB     INQMSGRPY(*RQD)
 
             SNDPGMMSG  MSG('SEC7610 - Treaty withholding tax and +
                          report generation Completed Normally') +
                          TOMSGQ(MRUNQ)
 
/* Call CB0150 to setof restart indicator if no error occurred */
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
 
/*/COPY WNCPYSRC,SEC7610MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SEC7610ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SEC7610 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SEC7610END                                          */
 
             ENDPGM
