/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas BoE ICD Audit Report control')                  */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC0010P - BoE ICD Audit Report Control Program               */
/*                                                                   */
/*     (c) Finastra International Limited 1999                       */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN013             Date 07May99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     LLN013 - Introduction of BoE Euro Bills and ISAs              */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&RSEQ &RLVL &RENT)
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)    /* Return code */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)   /* Report sequence   */
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)   /* Report level      */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)   /* Report entity     */
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
 
 
/* Call BoE ICD Audit Report program */
             CALL       PGM(BY0010P) PARM(&LRTCD)
             IF         COND(&LRTCD *NE ' ') THEN(DO)
               SNDPGMMSG  MSG('Error has occured on call to BY0010P') +
                          TOPGMQ(*EXT)
               GOTO    CMDLBL(ABNORM)
             ENDDO
 
/*  End program normally  */
             RETURN
 
/*  Program has ended abnormally  */
 ABNORM:     SNDPGMMSG  MSG('Bank of England ICD Audit Report +
                          control program terminated abnormally') +
                          TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
