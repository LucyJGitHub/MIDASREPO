/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Create Master Files')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                   */
/*                                                                   */
/*       REC4207 -  Create Master File Controls                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 121590             DATE 06AUG97             */
/*       PREV AMEND NO. CRT001  *CREATE    DATE 28FEB95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       121590 - Remove check for MPHAS 'D'                         */
/*       CRT001 - Retail Teller System.                              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MSG)    TYPE(*CHAR) LEN(130)
             DCL        VAR(&BLANK)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&RESTAT) TYPE(*CHAR) LEN(256)
/************DCL        VAR(&MPHAS)  TYPE(*CHAR) LEN(1)  */       /*121590*/
 
 
/**  Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
 
 
/**  Retrieve data area */
 
             RTVDTAARA  DTAARA(RESTAT *ALL) RTNVAR(&RESTAT)
/************RTVDTAARA  DTAARA(MPHAS *ALL) RTNVAR(&MPHAS) */      /*121590*/
 
 
/**  Send program message */
 
             SNDPGMMSG  MSG('Retail Teller System File Set Up') +
                          TOMSGQ(MOPERQ)
 
 
/**  Check for other modules and EOD phase */
 
/************IF         COND(&MPHAS *NE 'D') THEN(DO)                   /*121590*/
/************CHGVAR     VAR(&MSG) VALUE('Retail Teller System Files +   /*121590*/
/************             cannot be setup (Incorrect phase) - +         /*121590*/
/************             Abnormal termination')                        /*121590*/
/************  GOTO       CMDLBL(ABNORMAL)                              /*121590*/
/************ENDDO                                                      /*121590*/
 
             IF         COND(&RESTAT *EQ &BLANK) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Retail Teller System Files +
                          cannot be setup (Retail not present) - +
                          Abnormal termination')
               GOTO ABNORMAL
             ENDDO
 
 
/**  Create Master File Controls */
 
                CALL       PGM(RE4207)
 
 
/**  End the program */
 
             GOTO       CMDLBL(ENDPGM)
 
 
/**  Abnormal end */
 
/*ABNORMAL:    SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) * CRT001*/
 
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4207 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/**  End of program */
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
/**/
