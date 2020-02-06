/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas BoE Securities Trades Extract/Validation')      */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC2055 - Security extract and validation                     */
/*                                                                   */
/*     (c) Finastra International Limited 1999                       */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN021             Date : 23nOV0             */
/*                      LLN012             Date 26Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     Amendment Details:                                            */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     LLN021 - BoE PL Reports                                       */
/*     LLN012    CREATE                                              */
/*                                                                   */
/********************************************************************/
             PGM   PARM(&LMODE &LRSEQ &LRLVL &LRENT)
 
             DCL        VAR(&LMODE) TYPE(*CHAR) LEN(7)      /* Run mode */
             DCL        VAR(&LRSEQ) TYPE(*CHAR) LEN(5)      /* Report seq */
             DCL        VAR(&LRLVL) TYPE(*CHAR) LEN(1)      /* Report level */
             DCL        VAR(&LRENT) TYPE(*CHAR) LEN(3)      /* Report entity */
             DCL        VAR(&LBRCA) TYPE(*CHAR) LEN(3)      /* Branch code */
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)      /* Return code*/
             DCL        VAR(&LMSG1) TYPE(*CHAR) LEN(100)    /* Message */
             DCL        VAR(&LMBIN) TYPE(*CHAR) LEN(1)      /* Multi-branch */
             DCL        VAR(&LFILE) TYPE(*CHAR) LEN(10)     /* Extract file */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
 
/*  Global Monitor Message  */
             MONMSG     MSGID(RPG0000 CPF0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
             CHGJOB     SWS(XXXXXX00)
 
/*  Check if switchable feature LLN007 - Bank of England is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' +
                          ' ')
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('The Bank of England +
                          module is not available')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
             IF         COND((&LRTCD *NE ' ') *AND (&LRTCD *NE '*NRF')) +
                        THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('Error occured in BYC2055 +
                          on call to program AOSARDR0')
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
 
/* Clear extract file member if EXTRACT mode */
               IF        COND(&LMODE *EQ 'EXTRACT') THEN(DO)
                CLRPFM   FILE(BYEXDTPP) MBR(BYEXTRM)
                CLRPFM   FILE(BYMTDTPP) MBR(BYEXTRM)                                      /*LLN021*/
               ENDDO
 
               CHGVAR    VAR(&LRTCD) VALUE(' ')                                           /*LLN012*/
               OVRDBF    FILE(BYEXDTPP) TOFILE(BYEXDTPP) MBR(BYEXTRM)
               OVRDBF    FILE(BYMTDTPP) TOFILE(BYMTDTPP) MBR(BYEXTRM)                     /*LLN021*/
               CALL      PGM(BY2055) PARM(&LMODE &LRSEQ &LRTCD)
               DLTOVR    FILE(BYEXDTPP)
               DLTOVR    FILE(BYMTDTPP)                                                   /*LLN021*/
               IF        COND(&LRTCD *NE ' ') THEN(DO)
                CHGVAR   VAR(&LMSG1) VALUE('Error occured in BYC2055 +
                         on call to program BY2055')
                GOTO     CMDLBL(ABNORM)
               ENDDO
 
 
/*  End program normally  */
             RCLRSC
             CHGDTAARA  DTAARA(BYSTAT (6 1)) VALUE(' ')
             RETURN
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC2055 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             CHGDTAARA  DTAARA(BYSTAT (6 1)) VALUE(E)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
/*  Send any detail message  */
 SNDMSG:     IF         COND(&LMSG1 *NE ' ') THEN(DO)
               SNDPGMMSG  MSG(&LMSG1) TOMSGQ(MRUNQ MOPERQ)
               MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
