/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Penalty Termination Unauth Check')           */
/*********************************************************************/
/*                                                                   */
/*       MIDAS¦DBA - Dealing Money Market Module                     */
/*                                                                   */
/*       MMC5293 - Penalty Termination Unauthorized check            */
/*                                                                   */
/*       (C) Copyright Finastra International Limited 2008           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 256795  *CREATE    Date 25Sep08              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       256795 - Penalty Termination of Time Deposits (CDL052)      */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                        Copyright FINASTRA INTERNATIONAL LIMITED 2008')
 
             DCL        VAR(&CHECK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(7) VALUE('CDL052')
             DCL        VAR(&DSDY) TYPE(*CHAR) LEN(200)
 
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/** Check if LDA Data area exists and create it if not **/
 
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA DTAARA(QTEMP/LDA) +
                        TYPE(*CHAR) LEN(256) VALUE(' ') +
                        TEXT('Midas SD LOCAL DATA AREA EQUIVALENT') +
                        AUT(*USE))
 
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSDY)
             IF         COND(&RTCD *NE '       ') +
                           THEN(GOTO CMDLBL(END))
 
             SNDPGMMSG  MSG('MMC5293 - MM Penalty Termination Unauthorized +
                        Check') TOMSGQ(MRUNQ)
 
/** Call program **/
 
             CALL       PGM(MM5293) PARM(&CHECK)
 
/** Check for unauthorized deals **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
             IF         COND(&CHECK *EQ 'N') THEN(DO)
                        CHGJOB SWS('XXXXXX11')
                        SNDMSG MSG('MM Penalty Termination Records +
                          remain unauthorized') TOMSGQ(MOPERQ)
                        GOTO END
             ENDDO
 
             GOTO END
 
ABNOR:
 
             SNDPGMMSG  MSG('MM5293 -  MM Penalty Termination +
                authorized check terminated abnormally') +
                        TOMSGQ(MRUNQ MOPERQ)
             CHGJOB     SWS(XXXXXX11)
 
 END:
     CHGVAR &MKICPY '(c) Copyright FINASTRA INTERNATIONAL LIMITED 2008'
 
 ENDPGM
