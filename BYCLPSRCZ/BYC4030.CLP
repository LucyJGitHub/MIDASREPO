/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Update Deals positions control program')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bank of England Module                              */
/*                                                                   */
/*       BYC4030 - Update Deals positions control program            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 1998           */
/*-------------------------------------------------------------------*/
/*    CoB program, calls BY4030 - Update Deals Max DR/CR positions.  */
/*-------------------------------------------------------------------*/
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Last Amend No. 121832             Date 14AUG97              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       121832 - Message being sent TOMSGQ(MRUNQ/MOPERQ) in error.  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Misys International Banking Systems Ltd. 1997')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*  Check if switchable feature LLN007 - Bank of England is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' +
                          ' ')
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
/**************SNDPGMMSG  MSG('The Bank of England module is not avai+                    /*121832*/
/**************           lable') TOMSGQ(MRUNQ/MOPERQ)                                    /*121832*/
               SNDPGMMSG  MSG('The Bank of England module is not avai+
                          lable') TOMSGQ(MRUNQ MOPERQ)                                    /*121832*/
               GOTO       CMDLBL(END)
             ENDDO
 
/* Set-up library name */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
             RTVJOBA    TYPE(&JOBTYPE)
 
 
/* (For COB file updates add necessary code for security backups */
/* and recovery processing)                                      */
             IF COND(&STAT *EQ 'N') THEN(DO)
 
/*This is not a restart - copy master to back-up file XBYDLDCPP. */
              DLTF       FILE(&DPLIB/XBYDLDCPP)
              MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(&DMLIB/BYDLDCPP) +
                          TOFILE(&DPLIB/XBYDLDCPP) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
                  CHGVAR      VAR(&STAT) VALUE('Y')
                  CALL        PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
             ENDDO
 
             ELSE       CMD(DO)
 
/*This is a restart - copy back-up to master file BYDLDCPP. */
                   CPYF       FROMFILE(&DPLIB/XBYDLDCPP) +
                              TOFILE(&DMLIB/BYDLDCPP) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BYDLDCPP))
             ENDDO
 
                  CALL PGM(BY4030)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*If the component completes normally*/
                  CHGVAR VAR(&STAT) VALUE('N')
                  CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
              DLTF       FILE(&DPLIB/XBYDLDCPP)
              MONMSG     MSGID(CPF0000)
 
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERR)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&ERR) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            BYC4030 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 END:        CHGVAR     VAR(&CPYFLD) +
                     VALUE('Misys International Banking Systems Ltd.')
 
             ENDPGM
