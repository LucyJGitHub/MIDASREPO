/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER - Interface to FRS - Ctry Rept')             */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERC0701A- EUROPEAN REPORTING                                 */
/*                                                                  */
/*       (c) Finastra International Limited 2005                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                                         Date                      */
/*********************************************************************/
/**/
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*********************************************************************/
             PGM        PARM(&NBRCTRY &NBRREPT)
 
             DCL        VAR(&NBRCTRY) TYPE(*DEC) LEN(2 0) VALUE(0) +
                          /* Nbr of ctries defined on ER ICD */
 
             DCL        VAR(&NBRREPT) TYPE(*DEC) LEN(2 0) VALUE(0) +
                          /* Nbr of REPT'S defined on ER ICD */
 
/**********  DCLF       FILE(ERICDRPD) RCDFMT(ERICDRD0)                   */              /*CER001*/
             DCLF       FILE(ERICDXPD) RCDFMT(ERICDRD0)                                   /*CER001*/
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
 
 LOOP:   RCVF       RCDFMT(ERICDRD0)
         MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOJ))
 
             IF         COND(&VDICCD *NE *BLANK) THEN(DO)
             CHGVAR     VAR(&NBRCTRY) VALUE(&NBRCTRY + 1)
             IF         COND(&VDUCCD *NE *BLANK) THEN(DO)
             CHGVAR     VAR(&NBRREPT) VALUE(&NBRREPT + 1)
                                                      ENDDO
                                                      ENDDO
         GOTO LOOP
/*------------------------ ERROR  --------------------------------*/
 ERROR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) MSGDTA('ERC0701A  +
                          001') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
EOJ:         ENDPGM
