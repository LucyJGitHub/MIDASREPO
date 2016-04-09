/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Add logical file members')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0266 - Add logical file members                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. 256038 *MOVED      Date 05Mar02              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CUP015             Date 28Jun01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CUP008 *CREATE     Date 21Jul00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       256038 - Should be in the Global Layer                      */
/*       CPK015 - 4.01 packaging. Add MONMSG to error processing.    */
/*       CUP015 - Check logical file does not exist already before   */
/*                 attempting to add it.                             */
/*       CUP008 - Add logical file members.                          */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&CMD &CMDLEN &REPLY)                                      */ /*CUP015*/
             PGM        PARM(&CMD &CMDLEN &MBRLIB &MBRFILE &MBR &REPLY)                   /*CUP015*/
 
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1160)
             DCL        VAR(&CMDLEN) TYPE(*DEC) LEN(15 5)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBRLIB) TYPE(*CHAR) LEN(10)                                  /*CUP015*/
             DCL        VAR(&MBRFILE) TYPE(*CHAR) LEN(10)                                 /*CUP015*/
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)                                     /*CUP015*/
 
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
RETRY:
/* Check that member does not already exist before attempting to add it. */               /*CUP015*/
             CHKOBJ     OBJ(&MBRLIB/&MBRFILE) OBJTYPE(*FILE) MBR(&MBR)                    /*CUP015*/
             MONMSG     MSGID(CPF9815) EXEC(DO)                                           /*CUP015*/
                CALL       PGM(QCMDEXC) PARM(&CMD &CMDLEN)
                MONMSG     MSGID(CPF7306) EXEC(DO)
REDISPLAY:
                   RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                             MSGDTA('UPC0266') MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                   RTVMSG     MSGID(UPM0007) MSGF(UTMSGF) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)
                   RTVMSG     MSGID(UPM0008) MSGF(UTMSGF) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                   RTVMSG     MSGID(UPM0009) MSGF(UTMSGF) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
                   RTVMSG     MSGID(UPM0010) MSGF(UTMSGF) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                   RTVMSG     MSGID(UPM0011) MSGF(UTMSGF) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)
                   CALL       PGM(SCC0010) PARM('UPC0266' 'OPTION2' &REPLY)
 
                   IF         COND(&REPLY *EQ 'J') THEN(DO)
                      DSPJOBLOG
                      MONMSG     MSGID(CPF0000)
                      CHGVAR     VAR(&REPLY) VALUE(' ')
                      GOTO       CMDLBL(REDISPLAY)
                   ENDDO
 
                   IF         COND(&REPLY *EQ 'I') THEN(DO)
                      CHGDTAARA  DTAARA(MIDASMSG *ALL) VALUE(' ')
                      GOTO       CMDLBL(END)
                   ENDDO
 
                   IF         COND(&REPLY *EQ 'R') THEN(DO)
                      CHGDTAARA  DTAARA(MIDASMSG *ALL) VALUE(' ')
                      GOTO       CMDLBL(RETRY)
                   ENDDO
 
                   IF         COND(&REPLY *EQ 'C') THEN(DO)
                      GOTO       CMDLBL(END)
                   ENDDO
 
   /* If not one of the options then redisplay screen with message */
                   IF         COND(&REPLY *NE 'C' *AND &REPLY *NE 'I' +
                             *AND &REPLY *NE 'R' *AND &REPLY *NE +
                             'J') THEN(DO)
                      RTVMSG     MSGID(UPM0012) MSGF(UTMSGF) MSG(&MESSAGE)
                      CHGDTAARA  DTAARA(MIDASMSG (551 50)) VALUE(&MESSAGE)
                      GOTO       CMDLBL(REDISPLAY)
                   ENDDO
 
                ENDDO
             ENDDO                                                                        /*CUP015*/
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0266') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CALL       PGM(SCC0010) PARM('UPC0266' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CPK015*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
