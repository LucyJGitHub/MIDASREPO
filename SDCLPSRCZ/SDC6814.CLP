/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UDC - updates format layouts')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                        */
/*                                                                   */
/*       SDC6814  -  CONFIRMATION FORMATS UPDATE.                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 060660             DATE 09DEC93              */
/*       PREV AMEND NO. S01405             DATE 30NOV92              */
/*                      S01390             DATE 22JUN92              */
/*                      AUS009             DATE 20DEC90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       060660 - Correct base file name used.                       */
/*       S01405 - User defined confirmations file names changed.     */
/*       S01390 - Release 10 Changes for Australianisation           */
/*       AUS009 - AUSTRALIAN PRODUCT - USER DEFINED CONFIRMATIONS    */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
             PGM        PARM(&USERID &ACTION &FMTTOUPD &FMTTOCOPY)
/*                                                                  */
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USERID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FMTTOUPD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FMTTOCOPY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* START S01405 */
             MONMSG     MSGID(CPF0000) EXEC( +
                          GOTO CMDLBL(ERROR))
/* END S01405 */
/*                                                                  */
             CHGJOB     SWS(00000000)
/*                                                                  */
/*    FOR INSERT USE SPECIFIED COPY OR BLANK FORMAT.                */
/*                                                                  */
             IF         COND(&ACTION *EQ 'INSERT') THEN( +
                  DO)
/* START S01405 */
/***********          IF         COND(&FMTTOCOPY *EQ '    ') THEN(CHGVAR +  */
/***********              VAR(&FMTTOCOPY) VALUE(BASE))                      */
/************IF         COND(&FMTTOCOPY *EQ '    ') THEN(CPYSRCF +*/ /*060660*/
/************             FROMFILE(SDUDCSBPD) TOFILE(SDUDCSPD) +  */ /*060660*/
/************             FROMMBR(SDUDCBASE) TOMBR(&FMTTOUPD) +   */ /*060660*/
/************             MBROPT(*ADD) SRCOPT(*DATE))             */ /*060660*/
/***********          CPYSRCF    FROMFILE(CONFSRC) +                    S01405*/
/***********              TOFILE(CONFSRC) +                             S01405*/
/***********              FROMMBR(&FMTTOCOPY) TOMBR(&FMTTOUPD) +        S01405*/
/***********              MBROPT(*ADD) SRCOPT(*DATE)                    S01405*/
             IF         COND(&FMTTOCOPY *EQ '    ') THEN(CPYSRCF +
                           FROMFILE(SDUDSBPD) TOFILE(SDUDCSPD) +
                           FROMMBR(SDUDCBASE) TOMBR(&FMTTOUPD) +
                           MBROPT(*ADD) SRCOPT(*DATE))               /*060660*/
             ELSE     CPYSRCF    FROMFILE(SDUDCSPD) +
                          TOFILE(SDUDCSPD) +
                          FROMMBR(&FMTTOCOPY) TOMBR(&FMTTOUPD) +
                          MBROPT(*ADD) SRCOPT(*DATE)
                  ENDDO
/***********          MONMSG     MSGID(CPF0000) EXEC( +          */
/***********              GOTO CMDLBL(ERROR))                    */
/***********      ENDDO   */
/* END S01405 */
/*    IS FORMAT ON FILE ?                                           */
/* START S01405 */
/*********** ELSE +      */
/***********      DO     */
/* END S01405 */
/***********          CHKOBJ     OBJ(CONFSRC) OBJTYPE(*FILE) +          S01405*/
/***********              MBR(&FMTTOUPD) AUT(*CHANGE)                   S01405*/
                      CHKOBJ     OBJ(SDUDCSPD) OBJTYPE(*FILE) +
                          MBR(&FMTTOUPD) AUT(*CHANGE)                 /*S01405*/
                      MONMSG     MSGID(CPF0000) EXEC( +
                          GOTO CMDLBL(ERROR))
/* START S01405 */
/***********      ENDDO          */
/* END S01405 */
/*                                                                  */
             IF         COND(&ACTION *EQ 'DELETE') THEN( +
                  DO)
/***********          RMVM       FILE(CONFSRC) MBR(&FMTTOUPD)           S01405*/
                      RMVM       FILE(SDUDCSPD) MBR(&FMTTOUPD)        /*S01405*/
                      MONMSG     MSGID(CPF0000) EXEC( +
                          GOTO CMDLBL(ERROR))
                  ENDDO
             ELSE CMD( +
                  DO)
/***********          STRSEU     SRCFILE(CONFSRC) SRCMBR(&FMTTOUPD)     S01405*/
                      STRSEU     SRCFILE(SDUDCSPD) SRCMBR(&FMTTOUPD)  /*S01405*/
                      MONMSG     MSGID(CPF0000 EDT0000) EXEC( +
                          CHGJOB SWS(XXXXXX1X))
                  ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RETURN
/*                                                                  */
 ERROR:      CHGJOB     SWS(XXXXXXX1)
/*                                                                  */
             ENDPGM
