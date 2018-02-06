/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas BoE Create/Delete Extract Files For Branch')    */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC9090 - Create/Delete Abacus Extract File For Branch        */
/*                                                                   */
/*     (c) Finastra International Limited 1997                       */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN012             Date 23Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  LLN012 - Financial Services Authority - Liquidity Report         */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&LMODE &LBRCA &LRTCD)
 
             DCL        VAR(&LMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LBRCA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LSYID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LDMLB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LBYEX) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LBYAB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LBYLR) TYPE(*CHAR) LEN(10)                                 /* LLN012 */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
 
/*  Global Monitor Message  */
             MONMSG     MSGID(RPG0000 CPF0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
 
/*  Check if switchable feature LLN007 - Bank of England is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' ' ')
             IF         COND(&LRTCD *NE ' ') THEN(RETURN)
 
/* Get system id.  */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LSYID)
             CHGVAR     VAR(&LDMLB) VALUE(&LSYID *CAT 'DMLIB')
 
/*  Format Abacus extract file name  */
             CHGVAR     VAR(&LBYAB) VALUE('BYAB' *CAT &LBRCA *CAT 'PP')
 
/*  Create file if insert mode  */
             IF         COND(&LMODE *EQ 'I') THEN(DO)
              CRTDUPOBJ OBJ(BYEXABPP) FROMLIB(&LDMLB) OBJTYPE(*FILE) +
                        TOLIB(&LDMLB) NEWOBJ(&LBYAB)
              MONMSG    MSGID(CPF2130) CMPDTA(CPD2104) EXEC(CLRPFM +
                        FILE(&LBYAB))
             ENDDO
 
/*  Delete file if delete mode  */
             IF         COND(&LMODE *EQ 'D') THEN(DO)
              DLTF      FILE(&LDMLB/&LBYAB)
              MONMSG    MSGID(CPF2105)
             ENDDO
 
/*  LLN012 start */
/*  Check if switchable feature LLN012 - FSA Liquidity Report is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN012' ' ')
             IF         COND(&LRTCD *NE ' ') THEN(RETURN)
 
/*  Format Liquidity Reporting extract file name  */
             CHGVAR     VAR(&LBYLR) VALUE('BYLR' *CAT &LBRCA *CAT 'PP')
 
/*  Create file if insert mode  */
             IF         COND(&LMODE *EQ 'I') THEN(DO)
              CRTDUPOBJ OBJ(BYEXLRPP) FROMLIB(&LDMLB) OBJTYPE(*FILE) +
                        TOLIB(&LDMLB) NEWOBJ(&LBYLR)
              MONMSG    MSGID(CPF2130) CMPDTA(CPD2104) EXEC(CLRPFM +
                        FILE(&LBYLR))
             ENDDO
 
/*  Delete file if delete mode  */
             IF         COND(&LMODE *EQ 'D') THEN(DO)
              DLTF      FILE(&LDMLB/&LBYLR)
              MONMSG    MSGID(CPF2105)
             ENDDO
 
/*  LLN012 end */
 
/*  Terminate program normally  */
             RETURN
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC9090 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             CHGVAR     VAR(&LRTCD) VALUE('Y')
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
