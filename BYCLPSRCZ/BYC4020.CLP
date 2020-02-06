/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Update Accounts Max Dr/Cr Control')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bank of England Module                              */
/*                                                                   */
/*       BYC4020 - Update Accounts Max Dr/Cr Controlling Program     */
/*                                                                   */
/*       (c) Finastra International Limited 1998                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*    CoB program, calls BY4020 to update PF/BYACNTPP.               */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. 121832             Date 14Aug97              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       121832 - Message being sent TOMSGQ(MRUNQ/MOPERQ) in error.  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Finastra International Limited 1997')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
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
 
/* Restarted CoB? */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
          IF         COND(&STAT *EQ 'N') THEN(DO)
 
/* This is not a restart - copy masters to back-up files */
 
              DLTF       FILE(&DPLIB/XBYACNTPP)
              MONMSG     MSGID(CPF0000)
              CPYF       FROMFILE(BYACNTPP) TOFILE(&DPLIB/XBYACNTPP) +
                           MBROPT(*REPLACE) CRTFILE(*YES)
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
              CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')
          ENDDO
 
          ELSE       CMD(DO)
 
/* This is a restart - copy security copies back to file */
 
              CPYF       FROMFILE(&DPLIB/XBYACNTPP) +
                           TOFILE(&DMLIB/BYACNTPP) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BYACNTPP))
 
          ENDDO
 
/* Call RPG Update Max Cr/Dr Positions prog */
 
             CALL       PGM(BY4020)
 
/* Program completed normally? */
 
          IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Set off 'STAT' flag */
 
              CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')
              DLTF       FILE(&DPLIB/XBYACNTPP)
              MONMSG     MSGID(CPF0000)
          ENDDO
 
/* Database error processing */
 
          ELSE       CMD(DO)
 
              RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
              SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
          ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            BYC4020 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) +
                     VALUE('Finastra International Limited')
 
             ENDPGM
