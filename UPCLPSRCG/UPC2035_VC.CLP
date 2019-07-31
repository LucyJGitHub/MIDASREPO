/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP CPYCPYSRC Validity Checker')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC2035_VC - Validity checker for CPYCPYSRC                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018             Date 03Mar04              */
/*       Prev Amend No. CPK016             Date 16Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP002 *CREATE     Date 16Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Handle Global layer.         */
/*       CPK016 - Release 5 packaging.  Make command more generic.   */
/*       CUP002 - Introduction of BRIDGE utility                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&TOLIB)                                                   */ /*CPK016*/
/**********  PGM        PARM(&FROMLIB &TOLIB)                               */ /*CPK016*/ /*CPK018*/
             PGM        PARM(&FROMLIB &TOLIB &LAYER)                                      /*CPK018*/
 
             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10)                                 /*CPK016*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LAYER) TYPE(*CHAR) LEN(7)                                    /*CPK018*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* See if FROMLIB exists */                                                               /*CPK016*/
             CHKOBJ     OBJ(*LIBL/&FROMLIB) OBJTYPE(*LIB)                                 /*CPK016*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CPK016*/
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000Library' *BCAT &FROMLIB *BCAT +
                             'does not exist') MSGTYPE(*DIAG)                             /*CPK016*/
                CHGVAR     VAR(&ERROR) VALUE('Y')                                         /*CPK016*/
                GOTO       CMDLBL(ABNOR)                                                  /*CPK016*/
             ENDDO                                                                        /*CPK016*/
 
/* See if TOLIB exists */
             CHKOBJ     OBJ(*LIBL/&TOLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/************   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +                              */ /*CPK016*/
/************             MSGDTA('0000Library does not exist') +                       */ /*CPK016*/
/************             MSGTYPE(*DIAG)                                               */ /*CPK016*/
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000Library' *BCAT &TOLIB *BCAT +
                             'does not exist') MSGTYPE(*DIAG)                             /*CPK016*/
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
 ABNOR:      IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
