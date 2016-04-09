/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Initialisation program for feature CSE022')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC00022 - Initialisation Program for Enhancement CSE022    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CSE022  *CREATE    Date 29Mar01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE022  - Depository Definition Enhancement                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &PMODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Mode 1 - First call or Mode 2 - Second call */
 
             IF         COND((&PMODE *EQ '1') *OR (&PMODE  *EQ '2')) THEN(DO)
 
/*    Get system prefix                                              */
 
                RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
 
                CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
                CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
/*    Create temporary file to hold SDSECSPD records                 */
 
                CPYF       FROMFILE(SDSECSPD) TOFILE(&TOLIB/SDSECSPDX) +
                             MBROPT(*REPLACE) CRTFILE(*YES) +
                             FMTOPT(*NONE)
 
                MONMSG     (CPF2817) CMPDTA(CPF2869)
 
/*    Create temporary file to hold CLINTSE records                  */
 
                CPYF       FROMFILE(CLINTSE) TOFILE(&TOLIB/CLINTSEX) +
                             MBROPT(*REPLACE) CRTFILE(*YES) +
                             FMTOPT(*NONE)
 
                MONMSG     (CPF2817) CMPDTA(CPF2869)
 
                CALL       PGM(SD00022)
 
                IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
 
                ELSE       CMD(DO)
 
                   CPYF       FROMFILE(SDSECSPDX) TOFILE(SDSECSPD) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)
                   MONMSG     (CPF2817) CMPDTA(CPF2869)
 
                   CPYF       FROMFILE(CLINTSEX) TOFILE(CLINTSE) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)
                   MONMSG     (CPF2817) CMPDTA(CPF2869)
 
                   CHGVAR     VAR(&RTCD) VALUE('*ERROR*')
                   CHGJOB     SWS(00000000)
 
                ENDDO
 
/* End of Mode 1/Mode 2 */
 
             ENDDO
 
/* Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSG('Program SDC00022 ended abnormally')   +
                          TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             IF         COND((&PMODE *EQ '1') *OR (&PMODE  *EQ '2')) THEN(DO)
                DLTF       FILE(SDSECSPDX)
                MONMSG     MSGID(CPF0000 MCH0000)
                DLTF       FILE(CLINTSEX)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             ENDPGM
