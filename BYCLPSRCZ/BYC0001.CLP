/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Initialisation Program')                    */
/*********************************************************************/
/*                                                                   */
/*     Midas - Bank of England                                       */
/*                                                                   */
/*     BYC0001 - BOE Initialisation Program                          */
/*                                                                   */
/*     (c) Finastra International Limited 2005                       */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. BUG7336            Date 07Jun06              */
/*                      LLN022  *CREATE    Date 24Jan05              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG7336- BYCNTYPP not migrated to MidasPlus BOE             */
/*       LLN022 - BOE upgrade to MidasPlus                           */
/*                                                                   */
/*********************************************************************/
             PGM        (&PRTCD &PMODE)
 
/** Declare variables */
 
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LBRCA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LSYID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LDMLB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LBYAB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LBYLR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
             DCLF       FILE(SDBRCHPD)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
 
/** Mode 1 and Mode 2 */
 
             IF         COND(&PMODE *NE '3') THEN(DO)
 
/** Initialise extension files */
 
             CALL       PGM(BY0001)
                                                                                         /*BUG7336*/
/** Database error processing */                                                         /*BUG7336*/
                                                                                         /*BUG7336*/
              IF        COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                 /*BUG7336*/
                                                                                         /*BUG7336*/
/** Initialise country codes and ISO codes file */                                       /*BUG7336*/
                                                                                         /*BUG7336*/
             CALL       PGM(BY0002)                                                      /*BUG7336*/
 
/** Database error processing */
 
              IF        COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/** Get system id.  */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LSYID)
             CHGVAR     VAR(&LDMLB) VALUE(&LSYID *CAT 'DMLIB')
 
 
/** Read through all branches  */
 
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/** Format BT extract file name  */
 
             CHGVAR     VAR(&LBYAB) VALUE('BYAB' *CAT &A8BRCD *CAT 'PP')
 
/** Create BT branch file  */
 
             CRTDUPOBJ OBJ(BYEXABPP) FROMLIB(&LDMLB) OBJTYPE(*FILE) +
                        TOLIB(&LDMLB) NEWOBJ(&LBYAB)
             MONMSG     MSGID(CPF0000) EXEC(CLRPFM FILE(&LBYAB))
 
 
/** Format Liquidity Reporting extract file name  */
 
             CHGVAR     VAR(&LBYLR) VALUE('BYLR' *CAT &A8BRCD *CAT 'PP')
 
/** Create LR branch extract file  */
 
             CRTDUPOBJ OBJ(BYEXLRPP) FROMLIB(&LDMLB) OBJTYPE(*FILE) +
                        TOLIB(&LDMLB) NEWOBJ(&LBYLR)
             MONMSG     MSGID(CPF0000) EXEC(CLRPFM FILE(&LBYLR))
 
/** Read next branch record  */
 
             GOTO       CMDLBL(READ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** Abnormal termination */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&PRTCD) VALUE('*ERROR*')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          BYC0001 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/** End program */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
