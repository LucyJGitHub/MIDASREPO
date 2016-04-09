/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas European Reporting - Recovery Processing')      */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERC0605  - RECOVERY PROCESSING                               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. 132400             Date 18Mar98              */
/*                      IMI001             Date 24May97              */
/*                    ER0356 PT          DATE 11AUG93               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*     132400 - EMERGENCY FIX TO INCREASE THE LENGHT OF &LIB1       */
/*     IMI001 - DLIB REPLACED BY DPLIB                              */
/*     ER0356 - CPYF NOT MONITORED FOR EMPTY FILE                   */
/*                                                                  */
/*********************************************************************/
/**/
PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)
DCL        VAR(&PARM1) TYPE(*CHAR) LEN(3)
DCL        VAR(&PARM2) TYPE(*CHAR) LEN(3)
DCL        VAR(&PARM3) TYPE(*CHAR) LEN(3)
DCL        VAR(&PARM4) TYPE(*CHAR) LEN(3)
DCL        VAR(&PARM5) TYPE(*CHAR) LEN(3)
/*   DCL        VAR(&LIB1) TYPE(*CHAR) LEN(6)                           132400*/
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(10)                /*132400*/
DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)
 
       RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)
/******CHGVAR     VAR(&LIB1) VALUE(&LIBID *CAT 'DLIB')                  IMI001*/
       CHGVAR     VAR(&LIB1) VALUE(&LIBID *CAT 'DPLIB')               /*IMI001*/
       OVRDBF     FILE(EREXTRPD) SHARE(*YES)
       OPNQRYF    FILE((EREXTRPD *FIRST EREXTRF0)) OPTION(*ALL) +
                  QRYSLT('EXLOTD *NE "' *CAT &PARM1 *CAT '" *AND +
                          EXLOTD *NE "' *CAT &PARM2 *CAT '" *AND +
                          EXLOTD *NE "' *CAT &PARM3 *CAT '" *AND +
                          EXLOTD *NE "' *CAT &PARM4 *CAT '" *AND +
                          EXLOTD *NE "' *CAT &PARM5 *CAT '"') +
                          ALWCPYDTA(*YES)
       CPYFRMQRYF FROMOPNID(EREXTRPD) TOFILE(&LIB1/EREXTRXX) +
                  MBROPT(*REPLACE) CRTFILE(*YES)
       DLTOVR     FILE(EREXTRPD)
       CLOF       OPNID(EREXTRPD)
       CPYF       FROMFILE(EREXTRXX) TOFILE(EREXTRPD) MBROPT(*REPLACE)
/* ER0356 START */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(EREXTRPD))
/* ER0356 END */
       DLTF       FILE(EREXTRXX)
ENDPGM
