/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Missing Securities Extract Criteria Rept')  */
/*********************************************************************/
/*                                                                   */
/*   MIDAS - Bank of England                                         */
/*                                                                   */
/*   BYC3055 - Missing Securities Extract Criteria Report Program    */
/*                                                                   */
/*   (c) Finastra International Limited 2002                         */
/*                                                                   */
/*       Last Amend No. MD049901           Date 02Mar18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      LLN021             Date : 20nOV0             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD049901 - Missing criteria reports are not generated       */
/*       MD046248 - Finastra Rebranding                              */
/*   LLN021 - Query definition is for file INVTPD not SECTYD         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLVL &RENT)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)   /* Report sequence   */
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)   /* Report level      */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)   /* Report entity     */
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000 RPG0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/*  Reset job switches  */
             CHGJOB     SWS(00000000)
 
/***Run*Missing*Accounts*Extract*Criteria*Report*Query***/                              /*MD049901*/
/**********  OVRPRTF    FILE(QPQUPRFIL) USRDTA(BY3055) + */                             /*MD049901*/
/**********               SPLFNAME(BY3055P1) */                                         /*MD049901*/
/*           RUNQRY     QRY(BY3055) QRYFILE((SECTYD) (BYSEEXPP))*/  /*LLN021*/
/**********  RUNQRY     QRY(BY3055) QRYFILE((INVTPD) (BYSEEXPP))*/               /*MD049901 LLN021*/
 
/***Record*spool*file*for*RCF*****/                                                     /*MD049901*/
/**********  CALL       PGM(ZSFILE) PARM(&RSEQ  '  '  'BY3055P1  ' + */                 /*MD049901*/
/**********               X'00001F' &ERROR) */                                          /*MD049901*/

/** Call Missing Securities Extract Criteria Report */                                  /*MD049901*/
                                                                                        /*MD049901*/
             CALL       PGM(BY003055)                                                   /*MD049901*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*MD049901*/
             GOTO       CMDLBL(ABNORM)                                                  /*MD049901*/
             ENDDO                                                                      /*MD049901*/
              
/*  End program normally  */
             RETURN
 
 ABNORM:     SNDPGMMSG  MSG('BYC3055 - Missing Securities Extract +
                          Criteria Report terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
