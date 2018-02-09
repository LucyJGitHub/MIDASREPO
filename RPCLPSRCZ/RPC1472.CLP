/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RP PB Available Balances - Take on')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1472 - Available Balances Take On                        */
/*                                                                   */
/*       (c) Finastra International Limited 2013                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1055588 *CREATE  Date 08Feb13              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1055588 - Available Balances in TOF (Child:AR1055591)     */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2012')
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/*-------------------------------------------------------------------*/
/*  Set switches U7 and U8 off.                                      */
/*-------------------------------------------------------------------*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*-------------------------------------------------------------------*/
/*  Select only records for Retail Private Banking Accounts          */
/*-------------------------------------------------------------------*/
 
             OVRDBF     FILE(GLACNTL4) SHARE(*YES)
 
             OPNQRYF    FILE((GLACNTL4 *FIRST *ONLY) (SDCUSTPD +
                          *FIRST *ONLY) (ACCNTAB *FIRST *ONLY)) +
                          FORMAT(GLACNTL4 GLACNTD0) QRYSLT('BBPRBA +
                          *EQ "Y" *AND ATYP *EQ "R" *AND DACC = 0') +
                          KEYFLD((GLACNTL4/F1CNUM *ASCEND *N) +
                          (GLACNTL4/F1CCY *ASCEND *N) +
                          (GLACNTL4/F1ACOD *ASCEND *N) +
                          (GLACNTL4/F1ACSQ *ASCEND *N) +
                          (GLACNTL4/F1BRCA *ASCEND *N)) +
                          JFLD((GLACNTL4/F1CNUM ACCNTAB/CNUM *EQ) +
                          (GLACNTL4/F1CCY ACCNTAB/CCY *EQ) +
                          (GLACNTL4/F1ACOD ACCNTAB/ACOD *EQ) +
                          (GLACNTL4/F1ACSQ ACCNTAB/ACSQ *EQ) +
                          (GLACNTL4/F1BRCA ACCNTAB/BRCA *EQ) +
                          (GLACNTL4/F1CNUM SDCUSTPD/BBCUST *EQ))
 
             CPYFRMQRYF FROMOPNID(GLACNTL4) TOFILE(RPACNTQD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
 
             CLOF       OPNID(GLACNTL4)
             DLTOVR     FILE(GLACNTL4)
 
             GOTO       CMDLBL(ENDPGM)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          RPC1472 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
