/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis Message Generation')                  */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas-Fontis Interface                             */
/*                                                                  */
/*       GLC2804    Fontis Message Generation                       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL006             Date 31Oct97              */
/*                      CGL004 *C *CREATE  Date 21Jan97              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL006 - Incremental MT942s for FONTIS V3 Compatability    */
/*       CGL004 - Midas-Fontis Interface                            */
/*                                                                  */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(10) +
                           VALUE('  DPLIB')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
             DCL        VAR(&SDSTT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MNM) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
/* Global Error Trap */
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
             CHGVAR     VAR(&MSG) VALUE('GLC2804 - Fontis Message +
                          Generation')
/* Send message to MRUNQ */
             SNDPGMMSG  TOMSGQ(MRUNQ) MSG(&MSG)
 
/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)
/**/
             CLRPFM     FILE(GLRSSVPD)                             /*CGL006*/
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTT)
             CHGVAR     VAR(%SST(&PREF 1 2)) VALUE(%SST(&SDSTT 6 2))
             RMVM       FILE(GLFDTAPD) MBR(GLFDTAPD)
             MONMSG     MSGID(CPF0000 MCH0000)
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/* If Not Restart */
             IF         COND(&STAT *EQ 'N') THEN(DO)
               CLRPFM     FILE(XGLFONAPD)
               MONMSG     MSGID(CPF0000 MCH0000)
               CPYF       FROMFILE(GLFONAPD) TOFILE(&PREF/XGLFONAPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
/* Monitor for from-file being empty */
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
/**/
             ELSE       CMD(DO)
/* If Restart */
               CPYF       FROMFILE(XGLFONAPD) TOFILE(GLFONAPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(GLFONAPD))
             ENDDO
/**/
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ADDPFM     FILE(GLFDTAPD) MBR(GLFDTAPD)
             OVRDBF     FILE(GLFDTAPD) MBR(GLFDTAPD)
             CALL       PGM(GL2804) PARM(&MNM)
             DLTOVR     FILE(GLFDTAPD)
 
/* IF Both U7 & U8 are OFF */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               RNMMBR     OLDFILE(GLFDTAPD) MBR(GLFDTAPD) NEWMBR(&MNM)
/*/COPY WNCPYSRC,GLC2804001                                          */
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               CLRPFM     FILE(XGLFONAPD)
 
/* Monitor for all messages */
               MONMSG     MSGID(CPF0000 MCH0000)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* If U7 or U8 are ON, perform standard database error processing */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
/**/
 DBERR:        RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
               MONMSG     MSGID(CPF0000 MCH0000)
               CHGVAR     VAR(&MSG) VALUE(%SST(&LDA 134 50))
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MSG) +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/**/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
