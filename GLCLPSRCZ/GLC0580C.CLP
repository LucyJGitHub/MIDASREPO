/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       GLC0580C - PUT ITEM IN CLEARING INTO PROJECTED CLEAR BAL    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2015           */
/*                                                                   */
/*       Last Amend No. MD032907  *CREATE  Date 27Apr15              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  MD032907 - Local component to update PRONO based on CLBL         */
/*             instead of LDBL - SEE GL0575.                         */
/*             This program call GL0580C which will create a record  */
/*             in GLPRONTD for NOSTRO item in clearing.              */
/*             It is the standard background job that will update    */
/*             accordingly                                           */
/*             This program also do the housekeeping of new files    */
/*             GLPRONTD and GLPRONT2 introduced in 2.1 SP6.          */
/*             This component run in COB daily after the change of   */
/*             journal receiver SCC0408 00001 and before the datebase*/
/*             save SCC0410 00001.                                   */
/*********************************************************************/
 
/** &RLEV IS STANDARD RCF PARM NOT USED IN THIS PROGRAM  */
             PGM        PARM(&PARM &RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2015')
/** RCF sequence number */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
/** RCF level flag (S/C/B) */
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
/** RCF entity code(all/comp/bch)*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('Job +
                          terminated - database in error')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) VALUE('File +
                          controls out of balance')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/**/
/** Declare the variables to check the enhancements file */
/**/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01473')
             DCL        VAR(&SARDI) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&S01473) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CGL010) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CAP204) TYPE(*CHAR) LEN(1)
/**/
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &FMT)
/**/
/** Database error handling */
/**/
             IF         COND(&RTCD *NE '       ') THEN(DO)
                SNDPGMMSG  MSG('Database error on Midas modules +
                             file') TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/**/
             CHGJOB     SWS(00000000)
             SNDMSG     MSG('UPDATE PROJECTED CLEAR') TOMSGQ(MRUNQ)
/**/
             STRCMTCTL  LCKLVL(*ALL)
/**/
/** CLEAR FILES TOM ONLY HAVE TODAY PROJECTION. */
/**/
             CLRPFM     FILE(GLPRONTD)
             CLRPFM     FILE(GLPRONT2)
/**/
             CALL       PGM(GL0580C)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
             COMMIT
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') +
                          THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') +
                          THEN(SNDMSG MSG(&MSG2) TOMSGQ(MOPERQ))
ABNOR:
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
