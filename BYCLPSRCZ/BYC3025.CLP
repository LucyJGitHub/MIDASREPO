/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Missing Dealing Extract Criteria Report')   */
/*********************************************************************/
/*                                                                   */
/*   MIDAS - Bank of England                                         */
/*                                                                   */
/*   BYC3025 - Missing Dealing Extract Criteria Report Program       */
/*                                                                   */
/*   (c) Finastra International Limited 2002                         */
/*                                                                   */
/*       Last Amend No. MD049901            Date 02Mar18             */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      LLN022  *CREATE    Date 24Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD049901 - Missing criteria reports are not generated       */
/*       MD046248 - Finastra Rebranding                              */
/*       LLN022 - BOE upgrade to MidasPlus                           */
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
 
/***Run*Missing*Accounts*Extract*Criteria*Report*Query  */                              /*MD049901*/
/**********  OVRPRTF    FILE(QPQUPRFIL) USRDTA(BY3025) + */                             /*MD044901*/
/**********               SPLFNAME(BY3025P1)                                            /*MD044901*/
/**********  RUNQRY     QRY(BY3025) QRYFILE((FDDTSTPD) (BYDLEXPP)) */                   /*MD044901*/
 
/***Record*spool*file*for*RCF*****/                                                     /*MD044901*/
/**********  CALL       PGM(ZSFILE) PARM(&RSEQ  '  '  'BY3025P1  ' + */                 /*MD044901*/
/**********               X'00001F' &ERROR) */                                          /*MD044901*/

/** Call Missing Dealing Extract Criteria Report */                                     /*MD049901*/
                                                                                        /*MD049901*/
             CALL       PGM(BY003025)                                                   /*MD049901*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*MD049901*/
             GOTO       CMDLBL(ABNORM)                                                  /*MD049901*/
             ENDDO                                                                      /*MD049901*/
 
/*  End program normally  */
             RETURN
 
 ABNORM:     SNDPGMMSG  MSG('BYC3025 - Missing Dealing Extract +
                          Criteria Report terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
