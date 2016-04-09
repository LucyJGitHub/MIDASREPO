/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Composite Currencies Details Report')       */
/*********************************************************************/
/*                                                                   */
/*   MIDAS - Bank of England                                         */
/*                                                                   */
/*   BYC3060 - Composite Currencies Details Report                   */
/*                                                                   */
/*   (c) Misys International Banking Systems Ltd. 1998               */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Last Amend No. LLN022  *CREATE    Date 24Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
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
                        Misys International Banking Systems Ltd. 2006')
 
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
               SNDPGMMSG  MSG('BY3060 - Composite Currencies +         +
                          Details Report') TOMSGQ(MRUNQ)
             ENDDO
 
/*  Call Composite Currencies Details Report Program  */
             CALL       PGM(BY3060) PARM(&RUNMOD &RSEQ &LRTCD)
             IF         COND(&LRTCD *NE ' ') THEN(DO)
               SNDPGMMSG  MSG('Error in calling BY3060 - Composite +
                          Currencies Details Report') TOMSGQ(MRUNQ +
                          MOPERQ)
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
/*  End program normally  */
             RETURN
 
 ABNORM:     SNDPGMMSG  MSG('BYC3060 - Composite Currencies +
                        Detail Report terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
