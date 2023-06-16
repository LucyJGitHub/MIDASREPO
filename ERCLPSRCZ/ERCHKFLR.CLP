/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER CH IRIS Check Folder')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERCHKFLR - Check Folder                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD027509           Date 10Oct22              */
/*       Prev Amend No. CSC059             Date 10Oct22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                      ULX040             Date 19Feb01              */
/*                      ULX008             Date 23Feb00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD027509 - Change folder calculation to use absolute path.  */
/*                  Applied for MD-38096                             */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX040 - FIRE - RT30 Generation in Midas                    */
/*                Re-use it                                          */
/*       ULX008 - CSSF Statutory Reporting : Commissariat aux Bourses*/
/*                                                                   */
/*********************************************************************/

  START:     PGM        PARM(&FOLDER &PATH &RETURNCODE)

             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PATH)   TYPE(*CHAR) LEN(51)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)                                    /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
/*                                                                                        /*CSC059*/
/* Check if feature CSC059 is on */                                                       /*CSC059*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CSC059*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC059) VALUE('Y'))                                        /*CSC059*/
/* If CSC059 is on, check IASP */                                                         /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
/*                                                                                        /*CSC059*/
/*  Get the global IASP system values */                                                  /*CSC059*/
/*                                                                                        /*CSC059*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 'IASPgroup' +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC059*/
/*                                                                                          CSC059*/
/** Check whether system is in IASP environment.                                            CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                             /*CSC059*/
/*                                                                                          CSC059*/
/*  If IASP environment,                                                                    CSC059*/
/*                                                                                          CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/*                                                                                          CSC059*/
/*  Get name of IASP.                                                                       CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                               /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/

/***  Check folder existance.  ***/

             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             OVRPRTF FILE(QSYSPRT) HOLD(*YES)                                             /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/**********  CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT &PATH +
                          *TCAT '/' *CAT &FOLDER)                            /*CSC059*/ /*MD027509*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &IASP *TCAT '/' *CAT &PATH +
                          *TCAT '/' *CAT &FOLDER)                                       /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &PATH +
                          *TCAT '/' *CAT &FOLDER)                                       /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             DSPLNK     OBJ(&FILE) OUTPUT(*PRINT) OBJTYPE(*DIR)                           /*CSC059*/
             MONMSG     MSGID(CPFA0A9) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPF8A77'))                                               /*CSC059*/
                                                                                          /*CSC059*/
             DLTSPLF FILE(QSYSPRT) SPLNBR(*LAST)                                          /*CSC059*/
             MONMSG  MSGID(CPF0000)                                                       /*CSC059*/
             DLTOVR  FILE(QSYSPRT)                                                        /*CSC059*/
                                                                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHKDLO     DLO(&FOLDER) FLR(&PATH) OBJTYPE(*FLR) -
                        AUT(*CHANGE)

/***  Folder does not exist.  ***/

             MONMSG     MSGID(CPF8A77) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPF8A77'))

/***  User not authorized to use folder.  ***/

             MONMSG     MSGID(CPF8A75) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPD8A75'))

/* List argument not valid*/

             MONMSG     MSGID(CPD0047) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPD0047'))

/* Name not valid          */

             MONMSG     MSGID(CPF0001) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPD8A97'))

/***  Command failed.   ***/

             MONMSG     MSGID(CPF0000) EXEC(CHGVAR +
                          VAR(&RETURNCODE) VALUE('OTHER  '))
             ENDDO                                                                        /*CSC059*/

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')

             ENDPGM
