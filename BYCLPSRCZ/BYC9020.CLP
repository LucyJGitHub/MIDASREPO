/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas BoE Clear Bank of England Extract Files')       */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC9020 - Clear Bank of England Extract Files                 */
/*                                                                   */
/*     (c) Misys International Banking Systems Ltd. 1997             */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*     Last amend no. 183612           Date  26Sep00                 */
/*     Prev amend no. LLN016           Date  17MAY00                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     183612 - Do not clear files if the extract is not running     */
/*              today.                                               */
/*     LLN016 - Upgrade BoE to DBAR3.                                */
/*                                                                   */
/********************************************************************/
             PGM
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)      /* Return code*/
             DCL        VAR(&LMSG1) TYPE(*CHAR) LEN(100)    /* Message */
             DCL        VAR(&LMBIN) TYPE(*CHAR) LEN(1)      /* Multi-branch */
             DCL        VAR(&LFILE) TYPE(*CHAR) LEN(10)     /* Extract file */
             DCL        VAR(&LLN012) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LFLAG1) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG2) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG3) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas phase */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Misys International Banking Systems Ltd. 2006')
             DCLF       FILE(BYBRCHY1)
 
 
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
 
 
/*  Check if switchable feature LLN012 - BoE Liquidity is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN012' +
                          ' ')
             IF         COND(&LRTCD *EQ ' ') THEN(CHGVAR +
                          VAR(&LLN012) VALUE('Y'))
                                                                                          /*183612*/
/* Retrieve midas phase */                                                                /*183612*/
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&LPHAS)                                /*183612*/
                                                                                          /*183612*/
/* Retrieve three flags: 1. End of Month Indicator      */                                /*183612*/
/*                       2. Daily BT Extract Indicator  */                                /*183612*/
/*                       2. Extract On-Request Flag     */                                /*183612*/
             RTVDTAARA  DTAARA(BYSTAT (54 1)) RTNVAR(&LFLAG1)                             /*183612*/
             RTVDTAARA  DTAARA(BYSTAT (55 1)) RTNVAR(&LFLAG2)                             /*183612*/
             RTVDTAARA  DTAARA(BYSTAT (56 1)) RTNVAR(&LFLAG3)                             /*183612*/
                                                                                          /*183612*/
/* Check for valid conditions for program to continue */                                  /*183612*/
             IF         COND(&LPHAS *EQ 'C')  THEN(DO)                                    /*183612*/
               IF       COND(&LLN012 *NE 'Y' *AND &LFLAG1 *NE 'Y' +
                        *AND &LFLAG2 *NE 'Y' *AND &LFLAG3 *NE 'Y') +
                          THEN(RETURN)                                                    /*183612*/
             ENDDO                                                                        /*183612*/
 
 
/* Clear all members of extract file PF/BYEXDTPP */
             CLRPFM     FILE(BYEXDTPP) MBR(BYEXACM)
             CLRPFM     FILE(BYEXDTPP) MBR(BYEXDLM)
             CLRPFM     FILE(BYEXDTPP) MBR(BYEXLEM)
             CLRPFM     FILE(BYEXDTPP) MBR(BYEXSEM)
             IF         COND(&LLN012 *EQ 'Y') THEN(DO)
               CLRPFM   FILE(BYEXDTPP) MBR(BYEXFRM)
               CLRPFM   FILE(BYEXDTPP) MBR(BYEXFFM)
               CLRPFM   FILE(BYEXDTPP) MBR(BYEXTRM)
             ENDDO
 
 
/* Clear Abacus extract file PF/BYEXABPP */
             CLRPFM     FILE(BYEXABPP)
 
 
/*  If multi-branching clear Abacus extract file for each branch */
             OVRDBF     FILE(BYEXABPP) SHARE(*YES)
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&LMBIN)
             IF         COND(&LMBIN *EQ 'Y') THEN(DO)
 READ:         RCVF     RCDFMT(BYBRCHD0)
               MONMSG   MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
               CHGVAR   VAR(&LFILE) VALUE('BYAB' *CAT &A8BRCD *CAT 'PP')
               CLRPFM   FILE(&LFILE)
 
               IF       COND(&LLN012 *EQ 'Y') THEN(DO)
                CHGVAR  VAR(&LFILE) VALUE('BYLR' *CAT &A8BRCD *CAT +
                        'PP')
                CLRPFM  FILE(&LFILE)
               ENDDO
 
               GOTO     CMDLBL(READ)
             ENDDO
 
 
/*  End program normally  */
END:         RCLRSC
             RETURN
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC9020 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
/*  Send any detail message  */
 SNDMSG:     IF         COND(&LMSG1 *NE ' ') THEN(DO)
               SNDPGMMSG  MSG(&LMSG1) TOMSGQ(MRUNQ MOPERQ)
               MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
