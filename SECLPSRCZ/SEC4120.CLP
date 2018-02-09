/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Repos Report Control')                       */
/*********************************************************************/
/*                                                                   */
/*         Midas     - Securities Trading Module                     */
/*                                                                   */
/*       SEC4120 - Repos, Buy-Sell Backs and Bond Lending and        */
/*                 Buy-Sell Backs Report Control                     */
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
/*       Prev Amend No. CSE006  *CREATE    Date 10Sep99              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE006 - Repurchase Agreements (REPOs) enhancement          */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
/* Send PGM Message */
 
             CHGVAR     VAR(&MEM) VALUE('SEC4120 - Repos, PL, BL and +
                        BYSL Backs Report')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* Clear Switches */
 
             CHGJOB     SWS(XXXXXX00)
 
/*  Position File to the Particular Branch                           */
 
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)
             OVRDBF     FILE(SEDLDCL0) POSITION(*KEY 1 DEALSDCF &RENT)
             OPNDBF     FILE(SEDLDCL0) OPTION(*ALL)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             DLTOVR     FILE(SEDLDCL0)
             ENDDO
             OVRDBF     FILE(BSPOSDL1) POSITION(*KEY 1 BSPOSD0 &RENT)
             OPNDBF     FILE(BSPOSDL1) OPTION(*ALL)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             DLTOVR     FILE(BSPOSDL1)
             ENDDO
             CLOF       OPNID(TRDIP)
             MONMSG     MSGID(CPF0000)
             ENDDO
 
/* Call Report Program */
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CALL       PGM(SE4120) PARM(&RSEQ &RENT)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
 
