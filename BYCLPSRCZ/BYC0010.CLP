/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE ICD Maintenance')                           */
/*********************************************************************/
/*                                                                   */
/*   MIDAS - Bank of England                                         */
/*                                                                   */
/*   BYC0010 - Account Details Extract Maintenance Control Program   */
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
/*       LLN022 - BOE upgrade to MidasPlus                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)    /* Return code */
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
               SNDPGMMSG  MSG('The Bank of England module is not +
                          available') TOPGMQ(*EXT)
               RETURN
             ENDDO
 
/* Check for error on call to AOSARDR0  */
             IF         COND(&LRTCD *NE ' ' *AND &LRTCD *NE '*NRF') +
                          THEN(DO)
               SNDPGMMSG  MSG('Error occured on call to program +
                          AOSARDR0') TOPGMQ(*EXT)
                GOTO    CMDLBL(ABNORM)
             ENDDO
 
 
/* Call Account Extract Maintenance program */
             CALL       PGM(BY0010) PARM(&LRTCD)
             IF         COND(&LRTCD *NE ' ') THEN(DO)
               SNDPGMMSG  MSG('Error has occured on call to BY0010') +
                          TOPGMQ(*EXT)
               GOTO    CMDLBL(ABNORM)
             ENDDO
 
/*  End program normally  */
             RETURN
 
/*  Program has ended abnormally  */
 ABNORM:     SNDPGMMSG  MSG('Bank of England ICD Maintenance +
                          terminated abnormally') TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 
             ENDPGM
