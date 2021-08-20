/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Retail Stamp Duty Report Component')         */
/*********************************************************************/
/*                                                                   */
/*      Midas   - Retail Module                                      */
/*                                                                   */
/*******RECM004 - Retail Stamp Duty Report Component                 */
/*      XXC1404 - Retail Stamp Duty Report Component                 */
/*                                                                   */
/*   (C) Copyright Midas-Kapiti International Ltd. 1998              */
/*                                                                   */
/*      Last Amend No. LUC140             Date 24Feb21               */
/*      Prev Amend No. 145668             Date 28SEP98               */
/*                     MMI013 *CREATE     Date 31Mar98               */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC140 - Upgrade MMI013 to FM2.1                            */
/*       145668 - ERROR IN CALL TO REM004                            */
/*       MMI013 - Retail Stamp Duty and Account Charges              */
/*                                                                   */
/*********************************************************************/
/*********   PGM        PARM(&RSEQ &RLEV &RENT &RPARM) ***********/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT &RPARM)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1998')
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RPMON) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RPD#S) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RPMOD) TYPE(*CHAR) LEN(1)

             DCL        VAR(&MEM)   TYPE(*CHAR) LEN(50)

             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MNUM) TYPE(*CHAR) LEN(2)

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Set off switches */
             CHGJOB     SWS(00000000)

/* Send program message Stamp Duty Code Report is running */
             SNDPGMMSG  MSG('XXC1404 - Stamp Duty Code Report') TOMSGQ(MRUNQ)
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) /*LUC140*/

/* Get input cycle or close of business from data area */
                RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)

/*  If report is running in Input Cycle */

             IF         COND(&MPHAS = 'A') THEN(DO)

             CHGVAR     VAR(&RPMON) VALUE(%SST(&RPARM 1 2))
             CHGVAR     VAR(&RPD#S) VALUE(%SST(&RPARM 3 1))
             CHGVAR     VAR(&RPMOD) VALUE('I')
             CALL       PGM(XX1404) PARM(&RSEQ &RLEV &RENT &RPMON &RPD#S &RPMOD)


/* Database error processing */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)

                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO

             ENDDO

/*  End of input cycle processing */

/*  If report is running in Close of Business */

             IF         COND(&MPHAS ¬= 'A') THEN(DO)

/*  Retrieve library prefix from data area SDSTAT */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')

/* Obtain value of restart flag &STAT */
/*           CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)      */ /*LUC140*/

/* If it is not a restart , copy master file to backup file ,*/
/* change status to restart , else , copy backup files to    */
/* master files */
/*           IF         COND(&STAT *EQ 'N') THEN(DO)         */  /*LUC140*/
/************CPYF       FROMFILE(SDMSTDX0) TOFILE(&DPLIB/XSDMSTDX0) +
                          MBROPT(*ADD) CRTFILE(*YES) */               /*145668*/
/*           CPYF       FROMFILE(XXMSTDX0) TOFILE(&DPLIB/XXXMSTDX0) +
                          MBROPT(*REPLACE) CRTFILE(*YES) */ /*145668    LUC140*/
/*           CHGVAR     VAR(&STAT) VALUE('Y')             */ /*LUC140*/
/*                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     */  /*LUC140*/
/*           ENDDO                 */  /*LUC140*/
/*           ELSE       CMD(DO)    */  /*LUC140*/
/*         CPYF       FROMFILE(&DPLIB/XXXMSTDX0) TOFILE(XXMSTDX0) MBROPT(*REPLACE) +
             CRTFILE(*NO)                        */  /*LUC140*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM XXMSTDX0)    */ /*LUC140*/
/*           ENDDO                                                            */ /*LUC140*/

/* Get month number from rundate */

             CALL       PGM(XX1406) PARM(&MNUM)


             CHGVAR     VAR(&RPMON) VALUE(&MNUM)
             CHGVAR     VAR(&RPD#S) VALUE('D')
             CHGVAR     VAR(&RPMOD) VALUE('C')
/*********** CALL       PGM(REM004) PARM(&RPMON &RPD#S &RPMOD) */     /*145668*/

             CALL       PGM(XX1404) PARM(&RSEQ &RLEV &RENT &RPMON &RPD#S &RPMOD) +
                          /*145668*/


/* Database error processing */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)

                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                DMPCLPGM
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* If the component completes normally, reset the value of the */
/* restart flag to 'N'  */

                   CHGVAR     VAR(&STAT) VALUE('N')
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/* Delete back-up files */
/*                 DLTF       FILE(XXXMSTDX0)           */  /*LUC140*/

             ENDDO

/*  End of close of business processing */

/* Normal Completion */
             COMMIT     /*LUC140*/
             GOTO       CMDLBL(END)

 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK   /*LUC140*/

/* Abnormal termination  */

             SNDPGMMSG  MSG('Program XXC1404 ended abnormally ') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000 MCH0000)



 END:        CHGVAR     VAR(&CPYFLD) VALUE('Copyright Midas-Kapiti +
                          International Ltd 1998.')
             ENDCMTCTL  /*LUC140*/

             ENDPGM
