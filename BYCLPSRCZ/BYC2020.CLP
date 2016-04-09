/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas BoE Deal Extract and Validation')               */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC2020 - Deal Extract and Validation                         */
/*                                                                   */
/*     (c) Misys International Banking Systems Ltd. 1997             */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*     Last Amend No. LLN021           Date: 23Nov03                 */
/*     Prev Amend No. LLN016           Date: 15MAY00                 */
/*                    LLN012           Date  30Sep99                 */
/*                    LLN012           Date  23Apr99                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     LLN021 - BoE PL Reports                                       */
/*     LLN016 - Upgrade BoE to DBAR3.                                */
/*     LLN012 - Additional BoE Changes (patch B)                     */
/*     LLN012 - Financial Services Authority - Liquidity Report      */
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
             DCL        VAR(&LLN012) TYPE(*CHAR) LEN(1)     /* LLN012 flag */
             DCL        VAR(&LFLAG1) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG2) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG3) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas phase */
             DCL        VAR(&CURSOM) TYPE(*CHAR) LEN(5)                                   /*LLN021*/
             DCL        VAR(&CUREOM) TYPE(*CHAR) LEN(5)                                   /*LLN021*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Misys International Banking Systems Ltd. 2006')
 
 
/*  Global Monitor Message  */
             MONMSG     MSGID(RPG0000 CPF0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
 
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
               CHGVAR     VAR(&LMSG1) VALUE('Error occured in BYC2020 +
                          on call to program AOSARDR0')
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
 
/*  Check if switchable feature LLN012 - BoE Liquidity is on  */                          /*LLN012*/
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN012' +
                          ' ')                                                            /*LLN012*/
             IF         COND(&LRTCD *EQ ' ') THEN(CHGVAR +
                          VAR(&LLN012) VALUE('Y'))                                        /*LLN012*/
                                                                                          /*LLN012*/
/* Retrieve midas phase */                                                                /*LLN012*/
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&LPHAS)                                /*LLN012*/
                                                                                          /*LLN012*/
/* Retrieve three flags: 1. End of Month Indicator      */                                /*LLN012*/
/*                       2. Daily BT Extract Indicator  */                                /*LLN012*/
/*                       2. Extract On-Request Flag     */                                /*LLN012*/
             RTVDTAARA  DTAARA(BYSTAT (54 1)) RTNVAR(&LFLAG1)                             /*LLN012*/
             RTVDTAARA  DTAARA(BYSTAT (55 1)) RTNVAR(&LFLAG2)                             /*LLN012*/
             RTVDTAARA  DTAARA(BYSTAT (56 1)) RTNVAR(&LFLAG3)                             /*LLN012*/
                                                                                          /*LLN012*/
/* Check for valid conditions for program to continue */                                  /*LLN012*/
             IF         COND(&LPHAS *EQ 'C' *AND &LMODE *EQ +
                        'EXTRACT') THEN(DO)                                               /*LLN012*/
               IF       COND(&LLN012 *NE 'Y' *AND &LFLAG1 *NE 'Y' +
                        *AND &LFLAG2 *NE 'Y' *AND &LFLAG3 *NE 'Y') +
                          THEN(RETURN)                                                    /*LLN012*/
             ENDDO                                                                        /*LLN012*/
 
/* Clear extract file member if EXTRACT mode */
               IF        COND(&LMODE *EQ 'EXTRACT') THEN(DO)
                CLRPFM   FILE(BYEXDTPP) MBR(BYEXDLM)
                CLRPFM   FILE(BYMTDTPP) MBR(BYEXDLM)                                      /*LLN021*/
/*************  CLRPFM   FILE(BYNETDPP) MBR(BYNETDLM)                                     /*LLN016*/
               ENDDO
 
/* Retrieve begin and end month dates */                                                  /*LLN021*/
 
             RTVDTAARA  DTAARA(MXEXPCTL (01 5)) RTNVAR(&CUREOM)
             RTVDTAARA  DTAARA(MXEXPCTL (06 5)) RTNVAR(&CURSOM)
/*  Call Deals Extract/Validation program   */
               CHGVAR    VAR(&LRTCD) VALUE(' ')                                           /*LLN012*/
               OVRDBF    FILE(BYEXDTPP) TOFILE(BYEXDTPP) MBR(BYEXDLM)
               OVRDBF    FILE(BYMTDTPP) TOFILE(BYMTDTPP) MBR(BYEXDLM)                     /*LLN021*/
/************  OVRDBF    FILE(BYNETDPP) TOFILE(BYNETDPP) MBR(BYNETDLM)                    /*LLN016*/
 
/* Clear file member BYTOTEDL if EXTRACT mode */                                          /*LLN012*/
               IF        COND(&LMODE *EQ 'EXTRACT') THEN(DO)                              /*LLN012*/
               OVRDBF     FILE(BYTOTEPP) TOFILE(BYTOTEPP) MBR(BYTOTEDL)                   /*LLN012*/
               CLRPFM     FILE(BYTOTEPP) MBR(BYTOTEDL)                                    /*LLN012*/
               ENDDO                                                                      /*LLN012*/
 
/*             CALL      PGM(BY2020) PARM(&LMODE &LRSEQ &LRTCD)*/
             CALL       PGM(BY2020) PARM(&LMODE &LRSEQ &LRTCD +
                          &CUREOM &CURSOM)                                                /*LLN021*/
               DLTOVR    FILE(BYEXDTPP)
               DLTOVR    FILE(BYMTDTPP)                                                   /*LLN021*/
/************* DLTOVR    FILE(BYNETDPP)                                                   /*LLN016*/
               IF        COND(&LRTCD *NE ' ') THEN(DO)
                CHGVAR   VAR(&LMSG1) VALUE('Error occured in BYC2020 +
                         on call to program BY2020')
                GOTO     CMDLBL(ABNORM)
               ENDDO
 
 
/*  End program normally  */
             RCLRSC
             CHGDTAARA  DTAARA(BYSTAT (4 1)) VALUE(' ')
             RETURN
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC2020 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             CHGDTAARA  DTAARA(BYSTAT (4 1)) VALUE(E)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
/*  Send any detail message  */
 SNDMSG:     IF         COND(&LMSG1 *NE ' ') THEN(DO)
               SNDPGMMSG  MSG(&LMSG1) TOMSGQ(MRUNQ MOPERQ)
               MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
