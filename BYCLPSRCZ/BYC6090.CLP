/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas BoE Consolidated PL Extract Report')            */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC6090 - Consolidated PL Extract Report                      */
/*                                                                   */
/*     (c) Finastra International Limited 1998                       */
/*                                                                   */
/*     Last Amend No. MD046248         Date 27Oct17                  */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*     Prev Amend No. LLN021 *create   Date: 01DEC03                 */
/*                    xxxxxx           Date  xxxxxxx                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     MD046248 - Finastra Rebranding                                */
/*     LLN021 - Profit and loss return                               */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&RSEQ &RLVL &RENT)
 
             DCL        VAR(&RUNMOD) TYPE(*CHAR) LEN(7) /* Run mode          */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)   /* Report sequence   */
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)   /* Report level      */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)   /* Report entity     */
             DCL        VAR(&LFILE) TYPE(*CHAR) LEN(10)     /* Extract file */
             DCL        VAR(&LMBIN) TYPE(*CHAR) LEN(1)      /* Multi-branch */
             DCL        VAR(&LMSG1) TYPE(*CHAR) LEN(100)    /* Message */
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)      /* Return code*/
             DCL        VAR(&LFLAG1) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG2) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG3) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas phase */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
/*  Global Monitor Message  */
             MONMSG     MSGID(RPG0000 CPF0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/*  Check if switchable feature LLN021 - BoE P&L Return       */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN021' +
                          ' ')
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('The Bank of England +
                          module is not available')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
             IF         COND((&LRTCD *NE ' ') *AND (&LRTCD *NE '*NRF')) +
                        THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('Error occured in BYC6090 +
                          on call to program AOSARDR0')
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
/* Retrieve midas phase */
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&LPHAS)
 
/* If close of businesss check if extract required   */
             IF         COND(&LPHAS *EQ 'C') THEN(DO)
 
/* Retrieve three flags: 1. End of Month Indicator      */
/*                       2. Daily BT Extract Indicator  */
/*                       2. Extract On-Request Flag     */
               RTVDTAARA  DTAARA(BYSTAT (54 1)) RTNVAR(&LFLAG1)
               RTVDTAARA  DTAARA(BYSTAT (55 1)) RTNVAR(&LFLAG2)
               RTVDTAARA  DTAARA(BYSTAT (56 1)) RTNVAR(&LFLAG3)
               IF         COND(&LFLAG1 *NE 'Y' *AND &LFLAG2 *NE 'Y' +
                          *AND &LFLAG3 *NE 'Y') THEN(GOTO EXIT)
 
             ENDDO
/*  Call program BY6090  */
             OVRDBF     FILE(BYEXPLPP) SHARE(*YES)
             OPNQRYF    FILE((BYEXPLPP)) KEYFLD((L9BRCD) (L9PCOD) +
                          (L9MMOD) (L9TRAN))
             CALL       PGM(BY6090) PARM(' ')
 
             CLOF       OPNID(BYEXPLPP)
 
 
 
/*  End program normally  */
       RCLRSC
       GOTO EXIT
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC6090 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
/*  Send any detail message  */
 SNDMSG:     IF         COND(&LMSG1 *NE ' ') THEN(DO)
               SNDPGMMSG  MSG(&LMSG1) TOMSGQ(MRUNQ MOPERQ)
               MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 EXIT:       ENDPGM
