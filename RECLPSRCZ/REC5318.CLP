/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE A/c's Not Subject to Fees Report')           */
/*                                                                   */
/*       Midas     Retail Module                                 */
/*                                                                   */
/*       REC5318 - MIDAS ACCOUNTS NOT SUBJECT TO FEES REPORT         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CPK002             DATE 17MAY95              */
/*       PREV AMEND NO. S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK002 - Remove creation parameters which were using the    */
/*                adoption profile - USRPRF(*OWNER) -                */
/*                Use the standard CLP creation parameters instead.  */
/*       S01413 - Retail 3 Incorporation.                            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/***T  : CRTCLPGM                                                   :*/
/***T  :  PGM(BISBISBISB/BISBISBISB) SRCFILE(BISBISBISB/BISBISBISB) :*/
/***T  : SRCMBR(*PGM) USRPRF(*OWNER) LOG(*JOB)                      :*/
/***T  : ALWRTVSRC(*YES)    AUT(*USE )  TEXT(*SRCMBRTXT)            :*/
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCLF       FILE(TABTBRE)
             MONMSG MSGID(CPF0000)
 
/**/
/*    Check if 'Statement Charges' Ind. is on. */
/**/
             RCVF       RCDFMT(TABTBREF)
             IF         COND(&TSTMC *EQ 'Y') THEN(DO)
/**/
/* SET OFF SWITCHES                                              */
 
             CHGJOB     SWS(00000000)
 
             CALL PGM(RE5318)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50))
 
             SNDPGMMSG  MSGID(PEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             ENDDO
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
 ENDPGM:     ENDPGM
