/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Input cycle initiation - V')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0411V - Input Cycle Initiation V                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. 260192             Date 11May09              */
/*       Prev Amend No. 260091  *CREATE    Date 04May09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       260192 - Discrepancies in files MMDEAMPP and MMDELDPP in    */
/*                Release 4 and MidasPlus.                           */
/*       260091 - COB performance fixes.                             */
/*                Split SCC0411 into multiple components.            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SDMMOD) TYPE(*CHAR) LEN(128)
             DCL        VAR(&AB8010) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('*')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
 
/* Global Monitor Message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Set up copyright statement */
             CHGVAR     VAR(&CPYFLD) VALUE(&CPYFLD)
 
/* Get Modules Installed */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/* Access PF/SDMMODPD to determine which modules are live */
/**********  CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &SDMMOD) */                        /*260192*/
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &SDMMOD)                        /*260192*/
 
/* Database error */
             IF         COND(&RTCD *NE '       ') THEN(DO)
                 SNDPGMMSG  MSG('Error on access to +
                    ICD file AOMMODPD')  TOMSGQ(MOPERQ)
                 GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Check for switchable feature CEU009 - EMU Base Currency for       */
/* Dealing Conversion                                                */
             CHGVAR     VAR(&RTN) VALUE('       ')
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CEU009')
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)
             IF         COND(&RTN *EQ '       ') THEN(DO)
 
/* Reclaim resource to close down program AODEALR0 if active since   */
/* Dealing ICD updated by conversion                                 */
                 RCLRSC
 
/* Start commitment control in case not already started i.e. if      */
/* restarting from after recovery point 'R'                          */
                 STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
                 MONMSG     MSGID(CPF8351)
 
                 CALL       PGM(EUC0510)
                 IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBETAG))
             ENDDO
 
             IF         COND((%SUBSTRING(&SDMMOD 50 1)) = 'Y') THEN(DO)
                 CALL       PGM(DLC6030)
             ENDDO
             ELSE       CMD(DO)
                 IF         COND((%SUBSTRING(&SDMMOD 48 1)) = 'Y') +
                        THEN(CALL PGM(MM0102) PARM(' '))
 
/* THIS SHOULD ONLY RUN AFTER MM0102 AND NOT DLC6030, AS DLC6030     */
/* ALREADY CALLS AB8010                                              */
/* ONCE MM0102 HAS FINISHED SUCESSFULLY (U7 & U8 BOTH OFF)           */
/* AND IF INTERNAL CONTRACT MODULE IS TURNED ON (SDMMODPD POS.49 = Y */
/* THEN RUN THE INTERNAL CONTACTS DEALS FILE UPDATE AND REORG        */
/* IF AN ERROR OCCURS, END ABNORMALLY                                */
 
                 IF         COND((%SUBSTRING(&SDMMOD 49 1)) = 'Y' *AND +
                            (%SWITCH(XXXXXX00))) THEN(DO)
                     CALL       PGM(AB8010) PARM(&AB8010)
                     IF         COND(&AB8010 *EQ 'E') THEN(DO)
                         GOTO       CMDLBL(ABNOR)
                     ENDDO
                 ENDDO
 
             ENDDO
             IF         COND((%SWITCH(XXXXXX1X)) *OR +
                          (%SWITCH(XXXXXXX1))) THEN(DO)
                  GOTO       CMDLBL(ABNOR)
             ENDDO
 
 /* Check for database error: */
 
             IF         COND(%SWITCH(XXXXX000) *EQ '0') THEN(GOTO +
                           CMDLBL(DBETAG))
 
/* Successful completion */
             GOTO       CMDLBL(ENDPGM)
 
/* Database error processing */
DBETAG:
 
/* Retrieve database error information from LDA */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             ENDDO
 
/* Abnormal error processing */
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG(&CNAM *CAT ' ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDPGM:     ENDPGM
