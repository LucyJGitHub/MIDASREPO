/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ML Override ZZGBLANG files')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       MLC0120  - Override ZZGBLANG files                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUT004             Date 25Sep98              */
/*                      S01516             Date 18Jul94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC017 - Change to 250 library list.                        */
/*       CUT004 - Allow Core and Non-Core mode of compilation for    */
/*                Multilanguage                                      */
/*       S01516 - Incorporation into core                            */
/*                                                                   */
/*********************************************************************/
/************PGM********PARM(&SOURCE &LIBRAIRIE &SRCF &MULTLIB +    /* CUT004 */
/*************************&QUALOUTQ)                                /* CUT004 */
             PGM        PARM(&SOURCE &LIBRAIRIE &SRCF &MULTLIB +
                          &QUALOUTQ &CORE)                          /* CUT004 */
 
             DCL        VAR(&LIBRAIRIE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MULTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFNX) TYPE(*CHAR) LEN(10)            /* CUT004 */
/************DCL        VAR(&LIBL) TYPE(*CHAR) LEN(275)                                */ /*CSC017*/
/************DCL        VAR(&CMD) TYPE(*CHAR) LEN(285)                                 */ /*CSC017*/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(2750)                                  /*CSC017*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(2764)                                   /*CSC017*/
             DCL        VAR(&WSTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&QUALOUTQ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&CORE) TYPE(*CHAR) LEN(1)              /* CUT004 */
             DCL        VAR(&SOURCE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(70)
             DCL        VAR(&SBMM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SBMML) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BATINT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/*    Save job attributes                                          */
             RTVJOBA    JOB(&WSTN) USER(&USER) TYPE(&BATINT) +
                          USRLIBL(&LIBL) SBMMSGQ(&SBMM) +
                          SBMMSGQLIB(&SBMML)
             IF         COND(&BATINT *EQ '0') THEN(DO)
             CHGVAR     VAR(&WSTN) VALUE(&SBMM)
             ENDDO
 
/*    Recreate MSGQ for later report                               */
             DLTMSGQ    MSGQ(QTEMP/RPGMSGQ)
             MONMSG     MSGID(CPF0000)
             CRTMSGQ    MSGQ(QTEMP/RPGMSGQ) SIZE(3 1 *NOMAX)
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('LIST OF RPG PROGRAMS NEEDED TO BE +
                              CHANGED') TOMSGQ(QTEMP/RPGMSGQ)
 
/*    Ensure DTALIB and DPLIB are in library list                  */
             IF         COND(&MULTLIB *NE '          ') THEN(DO)
             ADDLIBLE   LIB(&MULTLIB) POSITION(*LAST)
             MONMSG     MSGID(CPF2103 CPF2110 CPF2118)
             ENDDO
             IF         COND(&LIBRAIRIE *NE '          ') THEN(DO)
             ADDLIBLE   LIB(&LIBRAIRIE) POSITION(*LAST)
             MONMSG     MSGID(CPF2103 CPF2110 CPF2118)
             ENDDO
 
/*    Apply overrides needed to set up temporary files             */
             OVRDBF     FILE(MULTB) TOFILE(ZZGBLANG) SHARE(*NO)
             OVRDBF     FILE(MULXB) TOFILE(ZZGBXXLANG) SHARE(*NO)   /* CUT004 */
             OVRDBF     FILE(MULTLANG) TOFILE(ZZGBLANG) SHARE(*NO)
             OVRDBF     FILE(MULTLANX) TOFILE(ZZGBXXLANG) SHARE(*NO)/* CUT004 */
             OVRDBF     FILE(MULTA) TOFILE(ZZGBLANGL) SHARE(*NO)
             OVRDBF     FILE(MULXA) TOFILE(ZZGBXLANGL) SHARE(*NO)   /* CUT004 */
             OVRDBF     FILE(MULTO) TOFILE(ZZGBLANGO) SHARE(*NO)
             OVRDBF     FILE(MULXO) TOFILE(ZZGBXLANGO) SHARE(*NO)   /* CUT004 */
             OVRDBF     FILE(MULTN) TOFILE(ZZGBLANGN) SHARE(*NO)
             CHGVAR     VAR(&MSGFNM) VALUE('ZZGBMSGF')
             CHGVAR     VAR(&MSGFNX) VALUE('ZZGBXXMSGF')            /* CUT004 */
 
/************CALL*******PGM(MLC0110) PARM(&SOURCE &LIBRAIRIE &SRCF +/* CUT004 */
/*************************&MSGFNM &MULTLIB)                         /* CUT004 */
             CALL       PGM(MLC0110) PARM(&SOURCE &LIBRAIRIE &SRCF +
                          &MSGFNM &MULTLIB &CORE &MSGFNX)           /* CUT004 */
 
             DLTOVR     FILE(MULTB)
             DLTOVR     FILE(MULTLANG)
             DLTOVR     FILE(MULTA)
             DLTOVR     FILE(MULTO)
             DLTOVR     FILE(MULTN)
/**/
 ERROR:      RCVMSG     MSGDTA(&MSGDTA) MSGID(&MSGID)
/**/
             IF         COND(&MSGID *NE '       ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(QCPFMSG) MSGDTA(&MSGDTA)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             DSPMSG   MSGQ(QTEMP/RPGMSGQ) OUTPUT(*PRINT) START(*FIRST)
/**/
/*FIN:*******CHGVAR     VAR(&CMD) VALUE('CHGLIBL (' *CAT &LIBL *TCAT +                 */ /*CSC017*/
/************             ')')                                                         */ /*CSC017*/
/************CALL       PGM(QCMDEXC) PARM(&CMD 285)                                    */ /*CSC017*/
FIN:                                                                                      /*CSC017*/
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL (' *CAT &LIBL *TCAT +
                          ')')                                                            /*CSC017*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSC017*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
     ENDPGM
