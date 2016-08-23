/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Rep last sucs. trans on primy m/c')          */
/********************************************************************/
/*                                                                  */
/*        Midas - System Control Module                     */
/*                                                                  */
/*       SDC1779 - Send message to rebuild FF Multimembered files   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK016             Date 29Aug03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 10May95              */
/*                      E29436             DATE  11OCT91            */
/*                      E13205             DATE  21/03/89           */
/*                                                                  */
/********************************************************************/
/*       New program overview                                       */
/*                                                                  */
/*       CPK016 - Release 5 packaging.  Make data queue REBUILD      */
/*                permanent.                                         */
/*       S01408 - Addition of core hook SDC1779MPS                  */
/*       E29436 - Move to SCCLSRC from RR.                          */
/*       E13205 - For each record read add a new entry to the data  */
/*                queue REBUILD.                                    */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&FILE &LIB)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(30)
/**********  DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)                                 */ /*CPK016*/
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(30)
/**********  DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)                              */ /*CPK016*/
/**/
             DCLF       FILE(MKCTL)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/**********  RTVDTAARA  DTAARA(*LIBL/SDSTAT (6 2)) RTNVAR(&DBPREFIX)                   */ /*CPK016*/
/**********  CHGVAR     VAR(&JLIB) VALUE(&DBPREFIX *CAT 'JLIB')                        */ /*CPK016*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1779MPS                                          */
                                                                      /*S01408*/
/**/
/*           Read until end of file                                  */
/**/
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
/**/
/*           Format entry and send to queue                          */
/**/
             CHGVAR     VAR(&DATA) VALUE(&FILE *CAT &LIB *CAT &MRKT)
/**********  CALL       PGM(*LIBL/QSNDDTAQ) PARM('REBUILD' &JLIB +                     */ /*CPK016*/
/**********               &FLDLEN &DATA)                                               */ /*CPK016*/
             CALL       PGM(*LIBL/QSNDDTAQ) PARM('REBUILD' '*LIBL' +
                          &FLDLEN &DATA)                                                  /*CPK016*/
/**/
             GOTO       CMDLBL(READ)
/* */
ABNOR:
/* */
/* Send abnormal termination message */
/* */
             SNDPGMMSG  MSG('PROGRAM SDC1779 - Send message to data +
                          queue REBUILD - ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
 END:        ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
