/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('MIDAS - Generate spot date event postings.**new**')   */
/*********************************************************************/
/*                                                                   */
/*        Midas - Dealing Module                                     */
/*                                                                   */
/*       DLC8602 - Generate Spot Date Event Postings                 */
/*                                                                   */
/*       Function:  This program controls the production of postings */
/*                  for Spot Date processing and is based on the     */
/*                  existing MIDAS program DLC0606C.                 */
/*                                                                   */
/*       Called By: COB dependencies                                 */
/*                                                                   */
/*       Calls    : DL0295                                           */
/*                                                                   */
/*       (c) Finastra International Limited 2021                     */
/*                                                                   */
/*       Last Amend No. CDL086             Date 04May21              */
/*                      AR1014698 *Create  Date 04May21              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  CDL086 - Portuguese FX Revaluation Extensions                    */
/*           Upgrade to FM 2.1 2021.A                                */
/*           Upgrade with fix AR1014698.                             */
/*  AR1014698 - Reconciliation issues with Midas R4 system           */
/*              (Child: AR1014700). Upgrade LBM001 as part of        */
/*              CDL086.                                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&NAM &SEQ)
/*                                                                   */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2021')
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
/*   Clear generated spot date postings files  */
             CHGJOB     SWS(10000000)
             CLRPFM     FILE(GLGESPPH)
             CLRPFM     FILE(GLGESPPP)
             CLRPFM     FILE(GLGESPPT)

/*  Is retail module present ? */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)

             IF         COND((%SUBSTRING(&MMOD 16 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 23 1) = 'Y')) THEN(DO)
             CHGJOB     SWS(X1XXXXXX)
             ENDDO

             OVRDBF     FILE(GEDLHH) TOFILE(GLGESPPH)
             OVRDBF     FILE(GEDLPD) TOFILE(GLGESPPP)
             OVRDBF     FILE(GEDLZZ) TOFILE(GLGESPPT)
             OVRDBF     FILE(SDKEYB) TOFILE(DLSPKYV0)

  /*         SNDPGMMSG  MSG('Spot Date Generated Account Postings.') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)  */

             CALL       PGM(DL0295)
             DLTOVR     FILE(*ALL)

/* Error ? */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             CLRPFM     FILE(GLGESPPH)
             CLRPFM     FILE(GLGESPPP)
             CLRPFM     FILE(GLGESPPT)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                          TOMSGQ(MOPERQ MRUNQ)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
             ELSE       CMD(DO)
             SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
             ENDDO

             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
/* Missing account keys */
             IF         COND(%SWITCH(XXX1XXXX)) THEN(DO)

             IF         COND(%SUBSTRING(&DLSTAT 15 1) *EQ 'Y') +
                          THEN(SNDPGMMSG MSG('SPOT DATE A/C KEYS +
                          MISSING - PROCESSING CONTINUED') +
                          TOMSGQ(MRUNQ))

             ELSE       CMD(DO)
             SNDPGMMSG  MSG('SPOT DATE A/C KEYS MISSING - PROCESSING +
                          HALTED') TOMSGQ(MOPERQ MRUNQ)
             CALL       PGM(CB0175) PARM(&NAM &SEQ)
             ENDDO
             ENDDO
/*                                                                   */
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
