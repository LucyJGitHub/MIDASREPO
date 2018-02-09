/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EU In ccy - Euro GL a/c mapping maintenance')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Module                                          */
/*                                                                   */
/*       EUC0740 - 'In' Currency to Euro GL Account Mapping Mainte-  */
/*                  nance                                            */
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
/*                      CEU028  *CREATE    Date 24Aug98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CEU028 - EMU GL Utilities                                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/** Create LDA if not present */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                             TEXT('Midas SD Local Data Area') +
                               AUT(*EXCLUDE)
                MONMSG     MSGID(CPF0000)
             ENDDO
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/** Initialise Job Switches */
 
             CHGJOB     SWS(XXXXXX00)
 
/** Start commitment control */
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF0000)
 
/* Call RPG Program */
 
             CALL       PGM(EU0740)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                MONMSG     MSGID(CPF0000 MCH0000)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:       CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                        EUC0740 ended abnormally - see job log') +
                        TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
