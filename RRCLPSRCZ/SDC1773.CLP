/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Rep Last Sucs. Trans on Primary Mach')          */
/********************************************************************/
/*                                                                  */
/*        Midas - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1773 - Send Rebuild file entries to data queue REBUILD  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. AR1037730          Date 15Oct12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK016             Date 29Aug03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE  10MAY95            */
/*                      E13205             DATE  14/02/89           */
/*                                                                  */
/********************************************************************/
/*       New program overview                                       */
/*                                                                  */
/*       AR1037730 - SDC1774 failed in reopen (Child:AR1037731)      */
/*       CPK016 - Release 5 packaging.  Make data queue REBUILD      */
/*                permanent.                                         */
/*       S01408 - Addition of core hook SDC1773MPS                  */
/*       E13205 - For each Logical file in list send entry to       */
/*                data queue REBUILD                                */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(30)
/**********  DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)                                 */ /*CPK016*/
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(30)
/**********  DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)                              */ /*CPK016*/
/**/
             DCLF       FILE(*LIBL/SD1724L0)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
                                                                                       /*AR1037730*/
             CHGJOB     SWS(XXXXXX0X)                                                  /*AR1037730*/
/**/
/**********  RTVDTAARA  DTAARA(*LIBL/SDSTAT (6 2)) RTNVAR(&DBPREFIX)                   */ /*CPK016*/
/**********  CHGVAR     VAR(&JLIB) VALUE(&DBPREFIX *CAT 'JLIB')                        */ /*CPK016*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1773MPS                                          */
                                                                      /*S01408*/
/**/
/*           Read until end of file                                  */
/**/
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
/**/
/*           Format entry and send to queue                          */
/**/
             CHGVAR     VAR(&DATA) VALUE(&FILE *CAT &LIB *CAT &NAME)
/**********  CALL       PGM(*LIBL/QSNDDTAQ) PARM('REBUILD' &JLIB +                     */ /*CPK016*/
/**********               &FLDLEN &DATA)                                               */ /*CPK016*/
             CALL       PGM(*LIBL/QSNDDTAQ) PARM('REBUILD' '*LIBL' +
                          &FLDLEN &DATA)                                                  /*CPK016*/
/**/
/*           If member name is OTC call SDC1779 to place extra       */
/*           entries for Futures and Options multimembered files     */
/**/
             IF         COND(&NAME *EQ 'OTC') THEN(DO)
             CALL       PGM(SDC1779) PARM(&FILE &LIB)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))
             ENDDO
/**/
             GOTO       CMDLBL(READ)
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1773 - Send Rebuild file +
                          entries to data queue REBUILD  - ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
END:         ENDPGM
/**/
