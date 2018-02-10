/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Deposits Collateral Released Exception Rp')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Money Market Module                                 */
/*                                                                   */
/*       MMC5340 - MM Deposits Collateral Released Exception Report  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CGL011  *CREATE    Date 20Sep99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL011 - Collateral Processing for Midas                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&RSEQ)    TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&RLEV)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             OVRDBF     FILE(DEALSC) SHARE(*YES)
 
             OPNQRYF    FILE((DEALSC)) QRYSLT('(COLF *EQ ''Y'' *AND +
                          (DTYP *EQ ''IT'' *OR DTYP *EQ ''CD'' *OR +
                          DTYP *EQ ''TD'' *OR DTYP *EQ ''CI'' *OR +
                          DTYP *EQ ''FT'' *OR DTYP *EQ ''DT'' *OR +
                          DTYP *EQ ''LT'')) *OR (COLF *EQ ''Y'' +
                          *AND (RECI *EQ ''R'' *OR RECI *EQ ''*'') +
                          *AND (DTYP *EQ ''IT'' *OR DTYP *EQ ''CD'' +
                          *OR DTYP *EQ ''TD'' *OR DTYP *EQ ''CI'' +
                          *OR DTYP *EQ ''FT'' *OR DTYP *EQ ''DT'' +
                          *OR DTYP *EQ ''LT''))')
 
             CALL       PGM(MM5340) PARM(&RSEQ &RLEV &RENT)
 
             DLTOVR     FILE(DEALSC)
             CLOF       OPNID(DEALSC)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MMC5340 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
