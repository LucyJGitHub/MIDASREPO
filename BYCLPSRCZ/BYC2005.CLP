/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Prompt For I/C Extract/Validation Reqst')   */
/*********************************************************************/
/*                                                                   */
/*   MIDAS - Bank of England                                         */
/*                                                                   */
/*   BYC2005 - Prompt Program for I/C Extract/Vaildation Requests    */
/*                                                                   */
/*   (c) Misys International Banking Systems Ltd. 1997               */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*   Last Amend No. LLN009       Date: 15APR98                       */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   Amendment Details:                                              */
/*                                                                   */
/*   LLN009   DBA2 Upgrade                                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LRSEQ &LRLVL &LRENT &LRPARM &LRACT +
                          &LRCMD)
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)    /* Return code      */
             DCL        VAR(&LJOB)  TYPE(*CHAR) LEN(10)   /* Job name         */
             DCL        VAR(&LEXRQ) TYPE(*CHAR) LEN(1)    /* Extract request? */
             DCL        VAR(&LEXFL) TYPE(*CHAR) LEN(1)    /* Extract fail?    */
             DCL        VAR(&LMSG1) TYPE(*CHAR) LEN(50)   /* Message          */
             DCL        VAR(&LMSG2) TYPE(*CHAR) LEN(50)   /* Message          */
             DCL        VAR(&LMSG3) TYPE(*CHAR) LEN(50)   /* Message          */
             DCL        VAR(&LRSEQ) TYPE(*CHAR) LEN(5)    /* Report Sequence  */
             DCL        VAR(&LRLVL) TYPE(*CHAR) LEN(1)    /* Report Level     */
             DCL        VAR(&LRENT) TYPE(*CHAR) LEN(3)    /* Report Entity    */
             DCL        VAR(&LRPARM) TYPE(*CHAR) LEN(100) /* Report Parameter */
             DCL        VAR(&LRACT) TYPE(*CHAR) LEN(1)    /* Action           */
             DCL        VAR(&LRCMD) TYPE(*CHAR) LEN(1)    /* Command          */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Misys International Banking Systems Ltd. 2006')
 
 
/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000 RPG0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/*  Reset job switches  */
             CHGJOB     SWS(00000000)
 
/* Check if switchable feature LLN007 - Bank of England is on   */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' +
                          ' ')
/* LLN007 not present  */
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('Bank of England module +
                          is not available')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
 
/* Check for error on call to AOSARDR0  */
             IF         COND(&LRTCD *NE ' ' *AND &LRTCD *NE '*NRF') +
                          THEN(DO)
                CHGVAR  VAR(&LMSG1) VALUE('Error occured on call to +
                        program AOSARDR0')
                GOTO    CMDLBL(ABNORM)
             ENDDO
 
 
/* Check if extract has been requested */
             ALCOBJ     OBJ((BYSTAT *DTAARA *EXCL)) WAIT(5)
             RTVDTAARA  DTAARA(*LIBL/BYSTAT (2 1)) RTNVAR(&LEXRQ)
             IF         COND(&LEXRQ *EQ 'Y') THEN(DO)
               DLCOBJ   OBJ((BYSTAT *DTAARA *EXCL))
               CHGVAR   VAR(&LMSG1) VALUE('Job cannot be run.')
               CHGVAR   VAR(&LMSG2) VALUE('Extract has already been +
                          requested')
               GOTO     CMDLBL(SNDMSG)
             ENDDO
             CHGDTAARA  DTAARA(BYSTAT (2 1)) VALUE('Y')
             DLCOBJ     OBJ((BYSTAT *DTAARA *EXCL))
 
/* Check if Account Extract has failed previously */
             RTVDTAARA  DTAARA(*LIBL/BYSTAT (3 1)) RTNVAR(&LEXFL)
             IF         COND(&LEXFL *EQ 'E') THEN(DO)
               CHGVAR   VAR(&LMSG1) VALUE('Job cannot be run at this +
                          time.')
               CHGVAR   VAR(&LMSG2) VALUE('Error has occured in +
                          Account Extract')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
 
/* Check if Deals Extract has failed previously */
             RTVDTAARA  DTAARA(*LIBL/BYSTAT (4 1)) RTNVAR(&LEXFL)
             IF         COND(&LEXFL *EQ 'E') THEN(DO)
               CHGVAR   VAR(&LMSG1) VALUE('Job cannot be run at this +
                          time.')
               CHGVAR   VAR(&LMSG2) VALUE('Error has occured in +
                          Deals Extract')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
 
/* Check if Loan Extract has failed previously */
             RTVDTAARA  DTAARA(*LIBL/BYSTAT (5 1)) RTNVAR(&LEXFL)
             IF         COND(&LEXFL *EQ 'E') THEN(DO)
               CHGVAR   VAR(&LMSG1) VALUE('Job cannot be run at this +
                          time.')
               CHGVAR   VAR(&LMSG2) VALUE('Error has occured in +
                          Loan Extract')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
 
/* Check if Securities Extract has failed previously */
             RTVDTAARA  DTAARA(*LIBL/BYSTAT (6 1)) RTNVAR(&LEXFL)
             IF         COND(&LEXFL *EQ 'E') THEN(DO)
               CHGVAR   VAR(&LMSG1) VALUE('Job cannot be run at this +
                          time.')
               CHGVAR   VAR(&LMSG2) VALUE('Error has occured in +
                          Securities Extract')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
 
/* Check if Abacus Download has failed previously */
             RTVDTAARA  DTAARA(*LIBL/BYSTAT (7 1)) RTNVAR(&LEXFL)
             IF         COND(&LEXFL *EQ 'E') THEN(DO)
               CHGVAR   VAR(&LMSG1) VALUE('Job cannot be run at this +
                          time.')
               CHGVAR   VAR(&LMSG2) VALUE('Error has occured in +
                          Abacus download')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
 
/* Return to calling program  */
                 RETURN
 
/*  Program has ended abnormally  */
 ABNORM:     CHGVAR     VAR(&LMSG3) VALUE('I/C Extract/Validation +
                          Request terminated abnormally')
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*  Send message via program SCC0040  */
SNDMSG:      CHGDTAARA  DTAARA(MIDASMSG) VALUE(' ')
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&LMSG1)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&LMSG2)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&LMSG3)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&LRCMD) VALUE('E')
             MONMSG     MSGID(CPF0000 MCH0000)
             RTVJOBA    JOB(&LJOB)
             MONMSG     MSGID(CPF0000 MCH0000)
             CALL       PGM(SCC0040) PARM(&LJOB 'ENTER    '  ' ')
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
