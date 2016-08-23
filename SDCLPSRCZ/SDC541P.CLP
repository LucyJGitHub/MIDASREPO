/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Pgm to control list production')             */
/********************************************************************/
/*                                                                  */
/*       Midas     STANDING DATA MODULE                         */
/*                                                                  */
/*       SDC541P - ON REQUEST REPORTS                               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG7198            Date 30May05              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 195963             Date 13May02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAS002             Date 14Jan02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E26585             Date 10Sep91              */
/*                      BHF372             Date 08Aug90              */
/*                     LN0549          DATE  23JUL90                */
/*                     LN0220          DATE  21MAY90                */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       BUG7198 - SDC541P 10007 failed component                    */
/*       195963 - Deleted broker codes not shown in SD0070P audit.   */
/*       CAS002 - Hedge Strategy/Linkage                             */
/*       E26585 - NO DETAILS ARE PRINTED IN THE I/C CLIENT          */
/*                LIMITS REPORT BECAUSE THE LEVEL VARIABLE IS       */
/*                NOT ONE OF THE VARIABLES PASSED TO THE REPORT     */
/*                PROGRAM.                                          */
/*                - REPLACE DUMMY VARIABLE WITH &LEVEL.             */
/*       BHF372 - CORRECTION OF LN0549                              */
/*       LN0549 - CHANGE PARAMETERS TO CORRECT ORDER                */
/*       LN0220 - CHANGE CALL TO INCLUDE DUMMY PARAMETER            */
/*                AND ADD (C)                                       */
/********************************************************************/
 
PGM  PARM(&PGM &SEQ &LEVEL &ENTITY)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**DCL**VAR(&PGM)    TYPE(*CHAR)  LEN(8)  ***/                        /*CAS002*/
   DCL  VAR(&PGM)    TYPE(*CHAR)  LEN(10)
   DCL  VAR(&SEQ)    TYPE(*CHAR)  LEN(5)
   DCL  VAR(&LEVEL)  TYPE(*CHAR)  LEN(1)
   DCL  VAR(&ENTITY) TYPE(*CHAR)  LEN(3)
   DCL  VAR(&RTNCD)  TYPE(*CHAR)  LEN(7)
   DCL  VAR(&MODE)   TYPE(*CHAR)  LEN(1)  VALUE('R')
   DCL  VAR(&MSG)    TYPE(*CHAR)  LEN(75)
   DCL  VAR(&SWS)    TYPE(*CHAR)  LEN(8)
/**DCL**VAR(&DMY)    TYPE(*CHAR)  LEN(1)                 /* LN0220 */ /*E26585*/
 
/*/COPY WNCPYSRC,SDC541P001                                          */
/* CALL  PGM(&PGM)  PARM(&RTNCD  &MODE  &SEQ  &ENTITY)                 LN0220 */
/* CALL  PGM(&PGM)  PARM(&RTNCD  &MODE  &DMY  &SEQ  &ENTITY)  LN0220   LN0549 */
/* CALL  PGM(&PGM)  PARM(&RTNCD  &MODE  &DMY  &SEQ  &ENTITY)  LN0549   BHF372*/
/**CALL**PGM(&PGM)  PARM(&RTNCD  &MODE  &SEQ  &DMY  &ENTITY)   /*BHF372*E26585*/
                                                                                         /*BUG7198*/
   IF         COND(&PGM *EQ 'SD0070P') THEN(DO)                                          /*BUG7198*/
   CLRPFM FILE(SDBRKDPD)                                              /*195963*/
   ENDDO                                                                                 /*BUG7198*/
 
   CALL  PGM(&PGM)  PARM(&RTNCD  &MODE  &SEQ  &LEVEL  &ENTITY)        /*E26585*/
   MONMSG  MSGID(CPF0001)  EXEC(DO)
      CHGVAR  VAR(&MSG)  VALUE('Error on call to program' *BCAT &PGM)
      SNDPGMMSG  TOMSGQ(MRUNQ MOPERQ)  MSG(&MSG)
   ENDDO
 
   RTVJOBA  SWS(&SWS)
 
   IF  (%SST(&SWS 7 2) *EQ '11') THEN(DO)
      CHGVAR     &MSG VALUE(' JOB TERMINATED - DATABASE IN ERROR')
      SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)
   ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
