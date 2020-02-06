/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Security Extract Criteria Report')          */
/*********************************************************************/
/*                                                                   */
/*   MIDAS - Bank of England                                         */
/*                                                                   */
/*   BYC3050 - Security Extract Criteria Report Program              */
/*                                                                   */
/*   (c) Finastra International Limited 1998                         */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN022  *CREATE    Date 24Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       LLN022 - BOE upgrade to MidasPlus                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RUNMOD &RSEQ &RLVL &RENT)
 
             DCL        VAR(&RUNMOD) TYPE(*CHAR) LEN(7) /* Run mode          */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)   /* Report sequence   */
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)   /* Report level      */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)   /* Report entity     */
             DCL        VAR(&LMPHAS) TYPE(*CHAR) LEN(1) /* MIDAS cycle point */
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)  /* Return code       */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000 RPG0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/*  Reset job switches  */
             CHGJOB     SWS(00000000)
 
/* Check if switchable feature LLN007 - Bank of England is on   */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' +
                          ' ')
 
/* LLN007 not present  */
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
               SNDPGMMSG  MSG('Bank of England module is not +
                          available') TOMSGQ(MRUNQ MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* Check for error on call to AOSARDR0  */
             IF         COND(&LRTCD *NE ' ' *AND &LRTCD *NE '*NRF') +
                          THEN(DO)
             SNDPGMMSG  MSG('Error occurred on call to program +
                          AOSARDR0') TOMSGQ(MRUNQ MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*  Check if MIDAS cycle is in close of business  */
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&LMPHAS)
             IF         COND(&LMPHAS *EQ 'C') THEN(DO)
               SNDPGMMSG  MSG('BY3050 - Security Extract Criteria +    +
                          Report') TOMSGQ(MRUNQ)
             ENDDO
 
/*  Call Security Extract Criteria Report Program  */
             CALL       PGM(BY3050) PARM(&RUNMOD &RSEQ &LRTCD)
             IF         COND(&LRTCD *NE ' ') THEN(DO)
               SNDPGMMSG  MSG('Error in calling BY3050 - Security +
                          Extract Criteria Report') TOMSGQ(MRUNQ +
                          MOPERQ)
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
/*  Re-organize file if AUDIT mode  */
             IF         COND(&RUNMOD *EQ 'AUDIT') THEN(DO)
               RGZPFM     FILE(BYSEEXPP)
               MONMSG     MSGID(CPF0000)
             ENDDO
 
/*  End program normally  */
             RETURN
 
 ABNORM:     SNDPGMMSG  MSG('BYC3050 - Security Extract Criteria +
                          Report Control terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
