/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('EMU Limit Currency Conversions Report Control')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Module                                          */
/*                                                                   */
/*       EUC0410 - Limit Currency Conversion Control                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      139846             Date 28Aug98              */
/*                      CEU010  *CREATE    Date 19Feb98              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       139846 - Rollback was issued even if EU0410 files were not  */
/*                under commitment control. Fix is to put the said   */
/*                files under commitment control for recovery during */
/*                Database error.                                    */
/*       CEU010 - Limit Currency Conversion                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LCCY &MODI &RFAC)
 
/* Define Paramters to EU0400   */
             DCL        VAR(&LCCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MODI) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RFAC) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
 
             CHGJOB     SWS(XXXXXX00)
                                                                      /*139846*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))     /*139846 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*139846*/
             MONMSG     MSGID(CPF8351)                                /*139846*/
                                                                      /*139846*/
 
/* Call Report Program */
 
             CALL       PGM(EU0410) PARM(&LCCY &MODI &RFAC)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            EUC0400 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
