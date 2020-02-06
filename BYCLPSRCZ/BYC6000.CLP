/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE On-Request PL Extract/Validation')          */
/*********************************************************************/
/*                                                                   */
/*   Midas - Bank of England Module                                  */
/*                                                                   */
/*   BYC6000 - On-Request PL Extract/Validation                      */
/*                                                                   */
/*   (c) Finastra International Limited 2003                         */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN021/02          Date 03Mar04              */
/*                      LLN021             Date : 22oCT0             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   LLN021/026 - Also need to call BYC6075                          */
/*   LLN021 - Bank of England Profit & Loss Return                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LMODE &LRSEQ &LRLVL &LRENT)
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)  /* Return code      */
             DCL        VAR(&LMODE) TYPE(*CHAR) LEN(7)  /* Run mode         */
             DCL        VAR(&LRSEQ) TYPE(*CHAR) LEN(5)  /* Report sequence  */
             DCL        VAR(&LRLVL) TYPE(*CHAR) LEN(1)  /* Report level     */
             DCL        VAR(&LRENT) TYPE(*CHAR) LEN(3)  /* Report entity    */
             DCL        VAR(&LMMOD) TYPE(*CHAR) LEN(128)/* Module check     */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas Phase  */
             DCL        VAR(&LEOM) TYPE(*CHAR) LEN(1)  /* End of Month      */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000 RPG0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/*  Check if feature 'LLN021 - Bank of England PL Extract'is on */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN021' +
                          ' ')
             IF         COND(&LRTCD *NE '    ') THEN(RETURN)
 
/* Retrieve midas phase */
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&LPHAS)
 
/*  Check if system is in Close of Business   */
             IF         COND(&LPHAS *EQ 'C' *AND &LMODE *EQ +
                          'EXTRACT') THEN(DO)
 
/*  If end of month do not extract as extract runs automatically  */
               RTVDTAARA  DTAARA(BYSTAT (54 1)) RTNVAR(&LEOM)
               IF         COND(&LEOM *EQ 'Y') THEN(RETURN)
 
/*  Create BT extract file if 'LLN012 - LR Extract' is not on  */
               CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN012' +
                          ' ')
               IF         COND(&LRTCD *NE '    ') THEN(DO)
                  CALL    PGM(BYC2000) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
               ENDDO
 
             ENDDO
 
 
/*  Module check  */
             CALL       PGM(AOMMODR0) PARM(&LRTCD '*FIRST' &LMMOD)
             IF         COND(&LRTCD *NE ' ') THEN(GOTO CMDLBL(ABNORM))
 
 
/*  Retail Accounts Details Extract/Validation  */
             CALL       PGM(BYC6010) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
              SNDPGMMSG MSG('Error has occurred on call to BYC6010')   +
                        TOMSGQ(MRUNQ MOPERQ)
              GOTO      CMDLBL(ABNORM)
             ENDDO
 
/*  Journal Entry & Accrual Amounts Extract/Validation  */
             CALL       PGM(BYC6020) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
              SNDPGMMSG MSG('Error has occurred on call to BYC6020')   +
                        TOMSGQ(MRUNQ MOPERQ)
              GOTO      CMDLBL(ABNORM)
             ENDDO
 
/*  Deals Details Extract/Validation  */
             IF         COND((%SST(&LMMOD 23 1) *EQ 'Y') *OR +
                          (%SST(&LMMOD 48 1) *EQ 'Y')) THEN(DO)
               CALL     PGM(BYC6030) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC6030') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
             ENDDO
 
 
/*  Loans Details Extract/Validation  */
             IF         COND(%SST(&LMMOD 28 1) *EQ 'Y') THEN(DO)
               CALL     PGM(BYC6040) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC6040') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
             ENDDO
 
/*  Facilities Extract/Validation  */
             IF         COND(%SST(&LMMOD 28 1) *EQ 'Y') THEN(DO)
               CALL     PGM(BYC6050) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC6050') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
             ENDDO
 
 
/*  Securities Trading Details Extract/Validation */
             IF         COND(%SST(&LMMOD 31 1) *EQ 'Y') THEN(DO)
               CALL     PGM(BYC6060) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC6060') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
             ENDDO
 
 
/*  Futures and Options Extract/Validation  */
             IF         COND(%SST(&LMMOD 41 1) *EQ 'Y') THEN(DO)
               CALL    PGM(BYC6070) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC6070') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
/* Begin LLN021/026 */
               CALL    PGM(BYC6075) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Error has occurred on call to BYC6075') +
                          TOMSGQ(MOPERQ/MRUNQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
/* End LLN021/026 */
             ENDDO
 
/*  EXTRACT mode requested  */
             IF         COND(&LMODE *EQ 'EXTRACT') THEN(DO)
 
/*  Create PL Download  Files */
               CALL     PGM(BYC6080)
               IF       COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC6080') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
 
/*  Run Consolidated Reports  */
               CALL     PGM(BYC6090) PARM(&LRSEQ &LRLVL 'ALL')
               IF       COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC6090') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
 
             ENDDO
 
/*  Reset "on-request extract flag"  */
             IF         COND(&LMODE *EQ 'EXTRACT') THEN(DO)
               CHGDTAARA  DTAARA(BYSTAT (57 1)) VALUE('N')
             ENDDO
 
             RCLRSC
             RETURN
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC6000 terminated abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
