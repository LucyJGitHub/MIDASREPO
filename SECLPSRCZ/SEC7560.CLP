/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Generation trades and depot movements')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7560 - SE Generation Trades & Depot Movements            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1092150          Date 01Mar13              */
/*                      CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      235041             Date 20Jul05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      183597             Date 12Sep00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      178065             Date 11Jul00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE017             Date 20Oct99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      160851             Date 02Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      142338             Date 23Sep98              */
/*                      CSE007  *CREATE    Date 02Feb98              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1092150 - SEC7560 is looping during GN EN clean COB       */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       235041 - EU Tax changes                                     */
/*       183597 - Re-start recovery incorrect X files being sent to  */
/*                DM instead of DP library.                          */
/*       178065 - Component did not stop COB when it ended in error. */
/*                Added ABNOR processing.                            */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*       160851 - ADD PRODUCTION OF CONFIRMATIONS FOR CORPORATE DEPOT*/
/*                MOVEMENTS                                          */
/*       142338 - Change RESTART processing by using program CB0160  */
/*                CB0150 instead to check XPOSETD                    */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
/*********** PGM  ****************************************/     /*142338*/
             PGM        PARM(&CNAM &CSEQ)                       /*142338*/
 
/* Declare PGM Variables */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(52)
/**********  DCL        VAR(&PRESBS) TYPE(*CHAR) LEN(2)            */                     /*CCB023*/
/************DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)************/ /*183597*/
/**********  DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)           */              /*183597 CCB023*/
/************DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE('Y')*/ /*142338*/
/**********  DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE('N')*/              /*142338 CCB023*/
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)               /*142338*/
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)               /*142338*/
/*/COPY WNCPYSRC,SEH00039                                            */
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CCB023*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                   /*CCB023*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                  /*CCB023*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                     /*CCB023*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                     /*CCB023*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                      /*CCB023*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                  /*CCB023*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                                 /*CCB023*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                                /*CCB023*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                                /*CCB023*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*178065*/
                                                                      /*178065*/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))
 
/* Reset Switches */
 
             CHGJOB     SWS(00000000)
 
             SNDPGMMSG  MSG('SEC7560 - CO Generation Trades & Depot Movements +
                          Processing') TOMSGQ(MRUNQ)
 
/*/COPY WNCPYSRC,SEH00040                                            */
/* Write current journal sequence number to file SCJSEQPD, using   */                     /*CCB023*/
/* command SCWRTJREG                                               */                     /*CCB023*/
                                                                                          /*CCB023*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CCB023*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CCB023*/
/**********  CHGVAR     VAR(&SEVENT) VALUE(&CNAM *CAT &CSEQA)      */           /*CCB023 AR1092150*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                         /*AR1092150*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                          /*CCB023*/
                                                                                          /*CCB023*/
/**Do*Security*Copies**/                                                                  /*CCB023*/
 
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRESBS)       */                     /*CCB023*/
/************CHGVAR     VAR(&DMLIB) VALUE(&PRESBS *TCAT 'DMLIB')****/ /*183597*/
/**********  CHGVAR     VAR(&TOLIB) VALUE(&PRESBS *TCAT 'DPLIB')   */              /*183597 CCB023*/
 
/**********  CALL       CB0160 PARM(&CNAM &CSEQ &STATUS)           */              /*142338 CCB023*/
/************CHKOBJ     OBJ(XPOSETD) OBJTYPE(*FILE)                */ /*142338*/
/************MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&STATUS) +  */ /*142338*/
/************             VALUE('N'))                              */ /*142338*/
/**Override*to*SEQONLY(*YES*100)**/                                                       /*CCB023*/
/**********  OVRDBF     FILE(XSECORFPD) SEQONLY(*YES 100)          */                     /*CCB023*/
/**********  OVRDBF     FILE(XSECODRPD) SEQONLY(*YES 100)          */                     /*CCB023*/
/**********  OVRDBF     FILE(XSECOALPD) SEQONLY(*YES 100)          */                     /*CCB023*/
/**********  OVRDBF     FILE(XSECONCPD) SEQONLY(*YES 100)          */                     /*CCB023*/
/**********  OVRDBF     FILE(XSEPCBD) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(XSEPCCD) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(XSEPCA) SEQONLY(*YES 100)             */                     /*CCB023*/
/**********  OVRDBF     FILE(XTRADSD) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(XTRADSA) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(XTRADSDX1) SEQONLY(*YES 100)          */                     /*CCB023*/
/**********  OVRDBF     FILE(XDPTMVD) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(XDPTMVA) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(XDPTMVDX1) SEQONLY(*YES 100)          */                     /*CCB023*/
/**********  OVRDBF     FILE(XSECTYD) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(XTNRANAA) SEQONLY(*YES 100)           */                     /*CCB023*/
/**********  OVRDBF     FILE(XTNRANAB) SEQONLY(*YES 100)           */                     /*CCB023*/
/**********  OVRDBF     FILE(XPOSETA) MBR(POSETA) SEQONLY(*YES 100)*/                     /*CCB023*/
/**********  OVRDBF     FILE(XPOSETD) MBR(POSETD) SEQONLY(*YES 100)*/                     /*CCB023*/
 
/**********  OVRDBF     FILE(SECORFPD) SEQONLY(*YES 100)           */                     /*CCB023*/
/**********  OVRDBF     FILE(SECODRPD) SEQONLY(*YES 100)           */                     /*CCB023*/
/**********  OVRDBF     FILE(SECOALPD) SEQONLY(*YES 100)           */                     /*CCB023*/
/**********  OVRDBF     FILE(SECONCPD) SEQONLY(*YES 100)           */                     /*CCB023*/
/**********  OVRDBF     FILE(SEPCBD) SEQONLY(*YES 100)             */                     /*CCB023*/
/**********  OVRDBF     FILE(SEPCCD) SEQONLY(*YES 100)             */                     /*CCB023*/
/**********  OVRDBF     FILE(SEPCA) SEQONLY(*YES 100)              */                     /*CCB023*/
/**********  OVRDBF     FILE(TRADSD) SEQONLY(*YES 100)             */                     /*CCB023*/
/**********  OVRDBF     FILE(TRADSA) SEQONLY(*YES 100)             */                     /*CCB023*/
/**********  OVRDBF     FILE(TRADSDX1) SEQONLY(*YES 100)           */                     /*CCB023*/
/**********  OVRDBF     FILE(DPTMVD) SEQONLY(*YES 100)             */                     /*CCB023*/
/**********  OVRDBF     FILE(DPTMVA) SEQONLY(*YES 100)             */                     /*CCB023*/
/**********  OVRDBF     FILE(DPTMVDX1) SEQONLY(*YES 100)           */                     /*CCB023*/
/**********  OVRDBF     FILE(SECTYD) SEQONLY(*YES 100)             */                     /*CCB023*/
/**********  OVRDBF     FILE(TNRANAA) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(TNRANAB) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(POSETA) MBR(POSETA) SEQONLY(*YES 100) */                     /*CCB023*/
/**********  OVRDBF     FILE(POSETD) MBR(POSETD) SEQONLY(*YES 100) */                     /*CCB023*/
 
/**If*Restart,*Take*Security*Copies**/                                                    /*CCB023*/
/**********  IF         COND(&STATUS = 'Y') THEN(DO)               */                     /*CCB023*/
 
/************CPYF       FROMFILE(&DMLIB/XSECORFPD) TOFILE(SECORFPD) + **183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(SECORFPD))               ****183597*/
/************CPYF       FROMFILE(&DMLIB/XSECODRPD) TOFILE(SECODRPD) + **183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(SECODRPD))               ****183597*/
/************CPYF       FROMFILE(&DMLIB/XSECOALPD) TOFILE(SECOALPD) + **183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(SECOALPD))               ****183597*/
/************CPYF       FROMFILE(&DMLIB/XSECONCPD) TOFILE(SECONCPD) + **183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(SECONCPD))               ****183597*/
/************CPYF       FROMFILE(&DMLIB/XSEPCCD) TOFILE(SEPCCD) +   ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(SEPCCD))                 ****183597*/
/************CPYF       FROMFILE(&DMLIB/XSEPCBD) TOFILE(SEPCBD) +   ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(SEPCBD))                 ****183597*/
/************CPYF       FROMFILE(&DMLIB/XSEPCA) TOFILE(SEPCA) +     ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(SEPCA))                  ****183597*/
/************CPYF       FROMFILE(&DMLIB/XTRADSD) TOFILE(TRADSD) +   ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(TRADSD))                 ****183597*/
/************CPYF       FROMFILE(&DMLIB/XTRADSA) TOFILE(TRADSA) +   ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(TRADSA))                 ****183597*/
/************CPYF       FROMFILE(&DMLIB/XTRADSDX1) TOFILE(TRADSDX1) + **183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(TRADSDX1))               ****183597*/
/************CPYF       FROMFILE(&DMLIB/XDPTMVD) TOFILE(DPTMVD) +   ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(DPTMVD))                 ****183597*/
/************CPYF       FROMFILE(&DMLIB/XDPTMVA) TOFILE(DPTMVA) +   ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(DPTMVA))                 ****183597*/
/************CPYF       FROMFILE(&DMLIB/XDPTMVDX1) TOFILE(DPTMVDX1) + **183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(DPTMVDX1))               ****183597*/
/************CPYF       FROMFILE(&DMLIB/XSECTYD) TOFILE(SECTYD) +   ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(SECTYD))                 ****183597*/
/************CPYF       FROMFILE(&DMLIB/XTNRANAA) TOFILE(TNRANAA) + ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(TNRANAA))                ****183597*/
/************CPYF       FROMFILE(&DMLIB/XTNRANAB) TOFILE(TNRANAB) + ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(TNRANAB))                ****183597*/
/************CPYF       FROMFILE(&DMLIB/XPOSETA) TOFILE(POSETA) +   ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(POSETA))                 ****183597*/
/************CPYF       FROMFILE(&DMLIB/XPOSETD) TOFILE(POSETD) +   ****183597*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)            ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +         ****183597*/
/************             EXEC(CLRPFM FILE(POSETD))                 ****183597*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XSECORFPD) TOFILE(SECORFPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(SECORFPD))              */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XSECODRPD) TOFILE(SECODRPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(SECODRPD))              */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XSECOALPD) TOFILE(SECOALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(SECOALPD))              */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XSECONCPD) TOFILE(SECONCPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(SECONCPD))              */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XSEPCCD) TOFILE(SEPCCD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(SEPCCD))                */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XSEPCBD) TOFILE(SEPCBD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(SEPCBD))                */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XSEPCA) TOFILE(SEPCA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(SEPCA))                 */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XTRADSD) TOFILE(TRADSD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(TRADSD))                */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XTRADSA) TOFILE(TRADSA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(TRADSA))                */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XTRADSDX1) TOFILE(TRADSDX1) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(TRADSDX1))              */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XDPTMVD) TOFILE(DPTMVD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(DPTMVD))                */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XDPTMVA) TOFILE(DPTMVA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(DPTMVA))                */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XDPTMVDX1) TOFILE(DPTMVDX1) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(DPTMVDX1))              */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XSECTYD) TOFILE(SECTYD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(SECTYD))                */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XTNRANAA) TOFILE(TNRANAA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(TNRANAA))               */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XTNRANAB) TOFILE(TNRANAB) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(TNRANAB))               */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XPOSETA) TOFILE(POSETA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(POSETA))                */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XPOSETD) TOFILE(POSETD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(POSETD))                */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(&TOLIB/XETCPOSND) TOFILE(ETCPOSND) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */              /*235041 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(ETCPOSND))              */              /*235041 CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**********  ELSE CMD(DO)                                          */                     /*CCB023*/
 
/**Delete*Copy*Files**/                                                                   /*CCB023*/
/**********  DLTF       FILE(XSECORFPD)                            */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XSECODRPD)                            */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XSECOALPD)                            */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XSECONCPD)                            */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XSEPCCD)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XSEPCBD)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XSEPCA)                               */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XTRADSD)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XTRADSA)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XTRADSDX1)                            */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XDPTMVD)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XDPTMVA)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XDPTMVDX1)                            */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XSECTYD)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XTNRANAA)                             */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XTNRANAB)                             */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XPOSETA)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XPOSETD)                              */                     /*CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */                     /*CCB023*/
/**********  DLTF       FILE(XETCPOSND)                            */              /*235041 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*235041 CCB023*/
 
/**Backup*File**/                                                                         /*CCB023*/
/************CPYF       FROMFILE(SECORFPD) TOFILE(&DMLIB/XSECORFPD) + **183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(SECODRPD) TOFILE(&DMLIB/XSECODRPD) + **183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(SECOALPD) TOFILE(&DMLIB/XSECOALPD) + **183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(SECONCPD) TOFILE(&DMLIB/XSECONCPD) + **183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(SEPCCD) TOFILE(&DMLIB/XSEPCCD) +   ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(SEPCBD) TOFILE(&DMLIB/XSEPCBD) +   ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(SEPCA) TOFILE(&DMLIB/XSEPCA) +     ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(TRADSD) TOFILE(&DMLIB/XTRADSD) +   ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(TRADSA) TOFILE(&DMLIB/XTRADSA) +   ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(TRADSDX1) TOFILE(&DMLIB/XTRADSDX1) + **183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(DPTMVD) TOFILE(&DMLIB/XDPTMVD) +   ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(DPTMVA) TOFILE(&DMLIB/XDPTMVA) +   ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(DPTMVDX1) TOFILE(&DMLIB/XDPTMVDX1) + **183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(SECTYD) TOFILE(&DMLIB/XSECTYD) +   ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(TNRANAA) TOFILE(&DMLIB/XTNRANAA) + ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(TNRANAB) TOFILE(&DMLIB/XTNRANAB) + ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(POSETA) TOFILE(&DMLIB/XPOSETA) +   ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
/************CPYF       FROMFILE(POSETD) TOFILE(&DMLIB/XPOSETD) +   ****183597*/
/*****************MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)      ****183597*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              ****183597*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(SECORFPD) TOFILE(&TOLIB/XSECORFPD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(SECODRPD) TOFILE(&TOLIB/XSECODRPD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(SECOALPD) TOFILE(&TOLIB/XSECOALPD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(SECONCPD) TOFILE(&TOLIB/XSECONCPD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(SEPCCD) TOFILE(&TOLIB/XSEPCCD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(SEPCBD) TOFILE(&TOLIB/XSEPCBD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(SEPCA) TOFILE(&TOLIB/XSEPCA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(TRADSD) TOFILE(&TOLIB/XTRADSD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(TRADSA) TOFILE(&TOLIB/XTRADSA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(TRADSDX1) TOFILE(&TOLIB/XTRADSDX1) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(DPTMVD) TOFILE(&TOLIB/XDPTMVD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(DPTMVA) TOFILE(&TOLIB/XDPTMVA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(DPTMVDX1) TOFILE(&TOLIB/XDPTMVDX1) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(SECTYD) TOFILE(&TOLIB/XSECTYD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(TNRANAA) TOFILE(&TOLIB/XTNRANAA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(TNRANAB) TOFILE(&TOLIB/XTNRANAB) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(POSETA) TOFILE(&TOLIB/XPOSETA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(POSETD) TOFILE(&TOLIB/XPOSETD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*183597 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*183597 CCB023*/
                                                                      /*183597*/
/**********  CPYF       FROMFILE(ETCPOSND) TOFILE(&TOLIB/XETCPOSND) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)     */              /*235041 CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */              /*235041 CCB023*/
                                                                      /*235041*/
/**********  CHGVAR     VAR(&STATUS) VALUE('Y')                    */              /*142338 CCB023*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)      */              /*142338 CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**********  DLTOVR     FILE(XSECORFPD XSECODRPD XSECOALPD XSECONCPD +
                          XSEPCCD XSEPCA XTRADSD XTRADSA XTRADSDX1 +
                          XDPTMVD XDPTMVA XDPTMVDX1 XSECTYD +
                          XTNRANAA XTNRANAB XPOSETA XPOSETD XSEPCBD)*/                    /*CCB023*/
 
/**********  DLTOVR     FILE(SECORFPD SECODRPD SECOALPD SECONCPD +
                          SEPCCD SEPCA TRADSD TRADSA TRADSDX1 +
                          DPTMVD DPTMVA DPTMVDX1 SECTYD TNRANAA +
                          TNRANAB POSETA POSETD SEPCBD)            */                     /*CCB023*/
 
/* Call RPG/SE7560 - SE Generation Trades & Depot Movements*/
 
             OVRDBF FILE(ETCPOSL0) SHARE(*NO)                          /*235041*/
             OVRDBF FILE(ETCPOSL3) SHARE(*NO)                          /*235041*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                    /*235041*/
             MONMSG     MSGID(CPF8351)                                 /*235041*/
             CALL       PGM(SE7560)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR VAR(&MEM) VALUE('SEC7560 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO       CMDLBL(ABNOR)                              /*178065*/
/***************GOTO       CMDLBL(END)                                 *178065*/
             ENDDO
 
/* For File in Balance Error */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MEM) VALUE('SEC7560 - FILE CONTROLS OUT +
                          OF BALANCE')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
/***************GOTO END                                              /*178065*/
                GOTO       CMDLBL(ABNOR)                              /*178065*/
             ENDDO
             CALL SEC0304                                             /*160851*/
/**********  CHGVAR     VAR(&STATUS) VALUE('N')                    */              /*142338 CCB023*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)      */              /*142338 CCB023*/
 
/* Delete Security Copy */
/************DLTF       FILE(&DMLIB/XSECORFPD)                     */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XSECODRPD)                     */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XSECOALPD)                     */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XSECONCPD)                     */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XSEPCCD)                       */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XSEPCBD)                       */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XSEPCA)                        */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XTRADSD)                       */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XTRADSA)                       */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XTRADSDX1)                     */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XDPTMVD)                       */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XDPTMVA)                       */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XDPTMVDX1)                     */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XSECTYD)                       */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XTNRANAA)                      */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XTNRANAB)                      */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XPOSETA)                       */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/************DLTF       FILE(&DMLIB/XPOSETD)                       */ /*183597*/
/************MONMSG MSGID(CPF0000)                                 */ /*183597*/
/**********  DLTF       FILE(&TOLIB/XSECORFPD)                     */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XSECODRPD)                     */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XSECOALPD)                     */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XSECONCPD)                     */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XSEPCCD)                       */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XSEPCBD)                       */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XSEPCA)                        */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XTRADSD)                       */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XTRADSA)                       */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XTRADSDX1)                     */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XDPTMVD)                       */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XDPTMVA)                       */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XDPTMVDX1)                     */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XSECTYD)                       */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XTNRANAA)                      */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XTNRANAB)                      */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XPOSETA)                       */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XPOSETD)                       */              /*183597 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*183597 CCB023*/
/**********  DLTF       FILE(&TOLIB/XETCPOSND)                     */              /*235041 CCB023*/
/**********  MONMSG MSGID(CPF0000)                                 */              /*235041 CCB023*/
 
             RCLRSC
 
             GOTO       CMDLBL(END)                                   /*178065*/
ABNOR:                                                                /*178065*/
             CHGJOB     SWS(XXXXXX11)                                 /*178065*/
             MONMSG MSGID(CPF0000)                                    /*178065*/
             DSPJOBLOG  OUTPUT(*PRINT)                                /*178065*/
             MONMSG MSGID(CPF0000)                                    /*178065*/
             DMPCLPGM                                                 /*178065*/
             MONMSG MSGID(CPF0000)                                    /*178065*/
                                                                      /*178065*/
                                                                                          /*CCB023*/
/* Retrieve attributes of current job */                                                  /*CCB023*/
                                                                                          /*CCB023*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                    /*CCB023*/
                                                                                          /*CCB023*/
/* Retrieve the most recent journal entry sequence number for      */                     /*CCB023*/
/* the specific job                                                */                     /*CCB023*/
                                                                                          /*CCB023*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                               /*CCB023*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                   /*CCB023*/
             CHGVAR     VAR(&START) VALUE(0)                                              /*CCB023*/
             ENDDO                                                                        /*CCB023*/
                                                                                          /*CCB023*/
/* Determine starting journal sequence number of current job       */                     /*CCB023*/
                                                                                          /*CCB023*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                   /*CCB023*/
                                                                                          /*CCB023*/
/* Remove journal changes                                          */                     /*CCB023*/
                                                                                          /*CCB023*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                        /*CCB023*/
             RMVJRNCHG  JRN(ICJRN) FILE((SECORFPD) (SECODRPD) +
                          (SECOALPD) (SECONCPD) (SEPCBD) (SEPCCD) +
                          (SEPCA) (TRADSD) (TRADSA) (TRADSDX1) +
                          (DPTMVD) (DPTMVA) (DPTMVDX1) (SECTYD) +
                          (TNRANAA) (TNRANAB) (POSETA POSETA) +
                          (POSETD POSETD)) RCVRNG(&SJRNRCVR +
                          &FJRNRCVR) FROMENT(&START) TOENT(&FINISH)                       /*CCB023*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                            /*CCB023*/
             ENDDO                                                                        /*CCB023*/
                                                                                          /*CCB023*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* Write current journal sequence number to file SCJSEQPD, using   */                     /*CCB023*/
/* command SCWRTJREG                                               */                     /*CCB023*/
                                                                                          /*CCB023*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CCB023*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM *CAT +
                          &CSEQA)                                                         /*CCB023*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                          /*CCB023*/
                                                                                          /*CCB023*/
             ENDPGM
