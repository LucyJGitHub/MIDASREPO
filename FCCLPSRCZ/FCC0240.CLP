/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Add message to program sfl MSGQ')            */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC0240 - SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES          */
    /*                                                               */
/*       (c) Misys International Banking Systems Ltd. 2001           */
    /*                                                               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*       LAST AMEND.NO.  LN1186          DATE 06MAR91            */
    /*       PREV AMEND.NO.                  DATE DDMMMYY            */
    /*                                                               */
    /*****************************************************************/
/*                                                                   */
/*     LN1186 - CHANGE TO USE FCUSRMSG MESSAGE FILE, FOR CONSISTENCY */
/*********************************************************************/
/**/
PGM        PARM(&@MSGID)
/**VERSION**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES**/
             DCL        VAR(&@MSGID) TYPE(*CHAR) LEN(7)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/************SNDPGMMSG  MSGID(&@MSGID) MSGF(RCFMSG)                     LN1186*/
             SNDPGMMSG  MSGID(&@MSGID) MSGF(FCUSRMSG)                 /*LN1186*/
/**/
ENDPGM
