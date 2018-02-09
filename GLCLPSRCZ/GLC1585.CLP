/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Change postings profit centre')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - GENERAL LEDGER MODULE                           */
/*                                                                   */
/*       GLC1585 - CHANGE PROFIT CENTRE ON POSTING                   */
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
/*       Prev Amend No. 000000             Date 00Xxx00              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       000000 -                                                    */
/*                                                                  */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             CALL       PGM(GL1585)
             CALL       PGM(GL1586)
             MONMSG     MSGID(CPF0001) EXEC(DO)
             SNDPGMMSG  MSG('Request to change Profit Centre failed. +
                          Submit your request again.') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ENDLBL)
             ENDDO
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ENDLBL)
             ENDDO
/* CLEAR FILES AFTER PROGRAMME IS CALLED SUCCESSFULLY */
             CLRPFM     FILE(PSTPRF1)
             CLRPFM     FILE(PSTPRF2)
             CLRPFM     FILE(PSTPRF3)
/* RESET GLSTAT FOR 'REQUEST PENDING' TO 'N'  */
             CHGDTAARA  DTAARA(GLSTAT (68 1)) VALUE('N')
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDLBL:     ENDPGM
