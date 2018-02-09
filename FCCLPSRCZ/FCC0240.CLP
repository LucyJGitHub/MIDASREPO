/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Add message to program sfl MSGQ')            */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC0240 - SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES          */
    /*                                                               */
/*       (c) Finastra International Limited 2001                     */
    /*                                                               */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. LN1186             Date 06Mar91              */
/*                                         Date DDMmmYY              */
    /*                                                               */
    /*****************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     LN1186 - CHANGE TO USE FCUSRMSG MESSAGE FILE, FOR CONSISTENCY */
/*********************************************************************/
/**/
PGM        PARM(&@MSGID)
/**VERSION**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES**/
             DCL        VAR(&@MSGID) TYPE(*CHAR) LEN(7)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/************SNDPGMMSG  MSGID(&@MSGID) MSGF(RCFMSG)                     LN1186*/
             SNDPGMMSG  MSGID(&@MSGID) MSGF(FCUSRMSG)                 /*LN1186*/
/**/
ENDPGM
