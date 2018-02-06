/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Account extract maintenance')               */
/*********************************************************************/
/*                                                                   */
/*   MIDAS - Bank of England                                         */
/*                                                                   */
/*   BYC1010 - Account Details Extract Maintenance Control Program   */
/*                                                                   */
/*   (c) Finastra International Limited 1998                         */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN022  *CREATE    Date 24Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)    /* Return code */
             DCL        VAR(&LJOB)  TYPE(*CHAR) LEN(10)   /* Job name      */
             DCL        VAR(&LEXRQ) TYPE(*CHAR) LEN(1)    /* Extract request? */
             DCL        VAR(&LEXFL) TYPE(*CHAR) LEN(1)    /* Extract fail?    */
             DCL        VAR(&LMSG1) TYPE(*CHAR) LEN(50)   /* Message */
             DCL        VAR(&LMSG2) TYPE(*CHAR) LEN(50)   /* Message */
             DCL        VAR(&LMSG3) TYPE(*CHAR) LEN(50)   /* Message */
             DCL        VAR(&LMSG4) TYPE(*CHAR) LEN(50)   /* Message */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
 
/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000 RPG0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/*  Reset job switches  */
             CHGJOB     SWS(00000000)
 
/* Check if switchable feature LLN007 - Bank of Englnd is on   */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' +
                          ' ')
/* LLN007 not present  */
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('The Bank of England module +
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
             RTVDTAARA  DTAARA(*LIBL/BYSTAT (2 1)) RTNVAR(&LEXRQ)
             IF         COND(&LEXRQ *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&LMSG1) VALUE('     Job cannot be run.')
             CHGVAR     VAR(&LMSG2) VALUE('Extract has been +
                          requested.')
               GOTO     CMDLBL(SNDMSG)
             ENDDO
 
/* Check if Account extract has failed previously */
             RTVDTAARA  DTAARA(*LIBL/BYSTAT (3 1)) RTNVAR(&LEXFL)
             IF         COND(&LEXFL *EQ 'E') THEN(DO)
             CHGVAR     VAR(&LMSG1) VALUE('   Job cannot be run at +
                          this time.')
             CHGVAR     VAR(&LMSG2) VALUE('Error has occured in +
                          Account Extract.')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
 
 
/* Call Account Extract Maintenance program */
             CALL       PGM(BY1010) PARM(&LRTCD)
             IF         COND(&LRTCD *NE ' ') THEN(DO)
             CHGVAR     VAR(&LMSG1) VALUE('  Error has occured on +
                          call to BY1010:')
             CHGVAR     VAR(&LMSG2) VALUE('- Account Details Extract +
                          Maintenance.')
                GOTO    CMDLBL(ABNORM)
             ENDDO
 
/*  End program normally  */
             RETURN
 
/*  Program has ended abnormally  */
 ABNORM:     CHGVAR     VAR(&LMSG3) VALUE('BYC1010 - Account Extract +
                          Details Maintenance')
             CHGVAR     VAR(&LMSG4) VALUE('          Terminated +
                          Abnormally')
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
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&LMSG3)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&LMSG4)
             MONMSG     MSGID(CPF0000 MCH0000)
             RTVJOBA    JOB(&LJOB)
             MONMSG     MSGID(CPF0000 MCH0000)
             CALL       PGM(SCC0040) PARM(&LJOB 'ENTER    '  ' ')
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
