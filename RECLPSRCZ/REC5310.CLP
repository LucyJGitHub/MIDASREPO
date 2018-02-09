/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Statement Fees Table File Setup')            */
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC5310 - MIDAS STATEMENT CHARGES TABLE FILE SETUP          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK002             Date 17May95              */
/*                      S01413 *C *CREATE  Date 13Apr93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
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
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             MONMSG MSGID(CPF0000)
 
/* SET OFF SWITCHES                                              */
 
             CHGJOB     SWS(00000000)
 
             CLRPFM FILE(RESTCHPD)
 
             CALL PGM(RE5310)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50))
 
             SNDPGMMSG  MSGID(PEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             ENDDO
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
