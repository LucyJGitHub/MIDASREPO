/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Plato interface - end feeder and trigger')   */
/*********************************************************************/
/*                                                                   */
/*       Midas / Replication                                         */
/*                                                                   */
/*       RPC1045 - Midas-Plato Interface - End Feeder and Trigger-COB*/
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. 191408             Date 23Mar01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. CPL004             Date 03Dec00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CPL003  *CREATE    Date 12Oct99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       191408 - Midas-Plato Interface.                             */
/*                Separate reset of replication subsystem to a new   */
/*                component (RPC1046).                               */
/*       CPL004 - Midas-Plato Interface.                             */
/*                Enhancements for Plato v4.80.                      */
/*       CPL003 - Midas-Plato Interface.                             */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CSTS) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/**  Global Monitor Message                                        **/
/**/
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC1045 Midas-Plato Interface - End +
                          Feeder and Trigger - COB') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
/**/
/** Set status of component for start of processing.               **/
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&CSTS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &CSTS)
/**/
/**  Call the program to end the Feeder and Trigger jobs.          **/
/**/
             CALL       PGM(RPC1040)
/**/
/**  If any errors are reported, perform error processing.         **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               GOTO       CMDLBL(TAG998)
             ENDDO
/****************************************                                      /*CPL004*/ /*191408*/
/****Call*the*program*to*reset*the*Replication Sub-System.         **/         /*CPL004*/ /*191408*/
/****************************************                                      /*CPL004*/ /*191408*/
/************DLYJOB*****DLY(10)**********                                      /*CPL004*/ /*191408*/
/************CALL*******PGM(RPC1070)*****                                      /*CPL004*/ /*191408*/
/****************************************                                      /*CPL004*/ /*191408*/
/****If*any*errors*are*reported,*perform*error processing.         **/         /*CPL004*/ /*191408*/
/****************************************                                      /*CPL004*/ /*191408*/
/************IF*********COND(%SWITCH(XXXXXX11)) THEN(DO)                       /*CPL004*/ /*191408*/
/**************GOTO*******CMDLBL(TAG998)*                                      /*CPL004*/ /*191408*/
/************ENDDO***********************                                      /*CPL004*/ /*191408*/
/**/
/** Set status of component for successful completion.             **/
/**/
             CHGVAR     VAR(&CSTS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &CSTS)
 
             GOTO       CMDLBL(TAG999)
 
/**/
/**  Error Processing:                                               */
/**   Dump the program if error occurred in this program             */
/**/
TAG998:      DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('Job terminated - RPC1045 Midas-Plato +
                          Interface - End Feeder and Trigger - COB +
                          - Ended in Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
/**/
/**  End of Program:                                                 */
TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
