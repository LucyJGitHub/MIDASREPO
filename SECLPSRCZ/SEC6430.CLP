/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Gen SC Postings from Settlements')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                   */
/*                                                                   */
/*       CL/SEC6430 - Generate Safe Custody Fees Postings from       */
/*                      Settlements                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 049067             DATE 02MAY96              */
/*       PREV AMEND NO. S01464             DATE 04APR94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       049067 - SE6430 needs to be able to process deleted         */
/*                settlements.                                       */
/*       S01464 - Safe Custody Fees                                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&CNAM &CSEQ)                             /*S01464*/
             PGM        PARM(&CNAM &CSEQ &MODE)                       /*S01464*/
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
/* */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*FIRST ')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)
/* */
             DCL        VAR(&STAT)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SCPS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EVDT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*S01464*/
/* */
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
/* */
/* Check Safe Custody Fees flag on Securities Trading ICD          */
/* */
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)
/* */
             IF         COND((%SST(&FMT 189 1) *NE 'Y') *OR (&RTCD +
                          *NE '       ')) THEN(GOTO CMDLBL(END))
/* */
/** Check whether custody postings are to be generated today       */
/* */
             RTVDTAARA  DTAARA(SESTAT (80 1)) RTNVAR(&SCPS)
             IF         COND(&SCPS *NE 'Y') THEN(GOTO CMDLBL(END))
/* */
/** Access SDSTAT for the system prefix and set up xxDPLIB         */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&TOLIB) VALUE(&SYSID *TCAT 'DPLIB')
/* */
/** Setup and send program message                                 */
/* */
             SNDPGMMSG  MSG('SEC6430 - Generate postings from safe +
                          custody fee settlements') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
/* */
/** Create LDA if not present                                      */
/* */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                             AUT(*EXCLUDE)
             ENDDO
/* */
/** Set off all switches                                           */
/* */
             CHGJOB SWS(00000000)
/* */
/** Restart/recovery processing - check for component restart      */
/* */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/* */
             IF         COND(&MODE = '1') THEN(DO)                    /*S01464*/
             OVRDBF     FILE(GESCPD) TOFILE(GESC1PD)                  /*S01464*/
             OVRDBF     FILE(GESCZZ) TOFILE(GESC1ZZ)                  /*S01464*/
             ENDDO                                                    /*S01464*/
/* */
/** If restart, override to SEQONLY(*YES 100)                      */
/* */
             IF         COND(&STAT = 'Y') THEN(DO)
               OVRDBF     FILE(XGESCPD) SEQONLY(*YES 100)
               OVRDBF     FILE(GESCPD) SEQONLY(*YES 100)
               OVRDBF     FILE(XGESCZZ) SEQONLY(*YES 100)
               OVRDBF     FILE(GESCZZ) SEQONLY(*YES 100)
               OVRDBF     FILE(XSEOCFSPD) SEQONLY(*YES 100)
               OVRDBF     FILE(SEOCFSPD) SEQONLY(*YES 100)
/* */
/** and copy files (from backup)                                   */
/* */
               CPYF       FROMFILE(XGESCPD) TOFILE(GESCPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(GESCPD))
               CPYF       FROMFILE(XGESCZZ) TOFILE(GESCZZ) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(GESCZZ))
               CPYF       FROMFILE(XSEOCFSPD) TOFILE(SEOCFSPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(SEOCFSPD))
/* */
/** Change status to 'N'                                           */
/* */
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
/* */
/** Else, if status is 'N' (not restart)                           */
/* */
             ELSE       CMD(DO)
/* */
/** Override to SEQONLY(*YES 100)                                  */
/* */
               OVRDBF     FILE(GESCPD) SEQONLY(*YES 100)
               OVRDBF     FILE(XGESCPD) SEQONLY(*YES 100)
               OVRDBF     FILE(GESCZZ)  SEQONLY(*YES 100)
               OVRDBF     FILE(XGESCZZ) SEQONLY(*YES 100)
               OVRDBF     FILE(SEOCFSPD)  SEQONLY(*YES 100)
               OVRDBF     FILE(XSEOCFSPD) SEQONLY(*YES 100)
/* */
/** Delete copy files                                              */
/* */
               DLTF       FILE(XGESCPD)
               MONMSG MSGID(CPF0000)
               DLTF       FILE(XGESCZZ)
               MONMSG MSGID(CPF0000)
               DLTF       FILE(XSEOCFSPD)
               MONMSG MSGID(CPF0000)
/* */
/** and copy files (make backup copies)                            */
/* */
               CPYF       FROMFILE(GESCPD) TOFILE(&TOLIB/XGESCPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES) +
                             FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(XGESCPD))
               CPYF       FROMFILE(GESCZZ) TOFILE(&TOLIB/XGESCZZ) +
                             MBROPT(*REPLACE) CRTFILE(*YES) +
                             FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(XGESCZZ))
               CPYF       FROMFILE(SEOCFSPD) TOFILE(&TOLIB/XSEOCFSPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES) +
                             FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(XSEOCFSPD))
             ENDDO
/* */
/** Change status to 'Y'                                           */
/* */
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/* */
             RTVDTAARA  DTAARA(SDSTAT (122 5)) RTNVAR(&EVDT)
/* */
/*  Select authorised settlements & deleted ones.                      049067*/
/* */
             OVRDBF     FILE(SEOCFSPD) SHARE(*YES)
/*           OPNQRYF    FILE((SEOCFSPD)) OPTION(*ALL) QRYSLT('SERECI + 049067*/
/*                        *EQ "D" *AND RDATE *LE "' *CAT &EVDT *CAT +  049067*/
/*                        '" *AND SEAUIN *EQ "Y"') KEYFLD(*FILE) +     049067*/
/*                        MAPFLD((WDATE SESEVD *ZONED 5) (RDATE +      049067*/
/*                        WDATE *CHAR 5))                              049067*/
             OPNQRYF    FILE((SEOCFSPD)) OPTION(*ALL) QRYSLT('SERECI +
                          *EQ "D" *AND RDATE *LE "' *CAT &EVDT *CAT +
                          '" *AND SEAUIN *EQ "Y" *OR SERECI *EQ "*" +
                          *AND RDATE *LE "' *CAT &EVDT *CAT '"') +
                          KEYFLD(*FILE) MAPFLD((WDATE SESEVD *ZONED +
                          5) (RDATE WDATE *CHAR 5))                   /*049067*/
/* */
/** Call program                                                   */
/* */
             CALL       PGM(SE6430)
/* */
             CLOF       OPNID(SEOCFSPD)
             DLTOVR     FILE(SEOCFSPD)
/* */
/** Database error                                                 */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/* */
/** Change status to 'N'                                           */
/* */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/* */
/** Delete backup files                                            */
/* */
               DLTF       FILE(XGESCPD)
               MONMSG     MSGID(CPF0000)
               DLTF       FILE(XGESCZZ)
               MONMSG     MSGID(CPF0000)
               DLTF       FILE(XSEOCFSPD)
               MONMSG     MSGID(CPF0000)
/* */
/** Copy records out of PF/SEOCFSPD                                */
/* */
               OVRDBF     FILE(SEOCFSPD) SEQONLY(*YES 100)
               CPYF       FROMFILE(SEOCFSPD) +
                             TOFILE(&TOLIB/XSEOCFSPD) +
                             MBROPT(*ADD) CRTFILE(*YES) +
                             INCREL((*IF SERECI *EQ 'D'))
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(XSEOCFSPD))
               OVRDBF     FILE(XSEOCFSPD) SEQONLY(*YES 100)
               CPYF       FROMFILE(XSEOCFSPD) TOFILE(SEOCFSPD) +
                             MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(SEOCFSPD))
               DLTF       FILE(XSEOCFSPD)
               MONMSG     MSGID(CPF0000)
             ENDDO
/* */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
