/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Reset replication sub-system.')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC1070 - Reset Replication Sub-System.                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. NCI103             Date 18Jul19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CPL004  *CREATE    Date 03Dec00              */
/*                      ______             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       NCI103 - Replication Enhancements                           */
/*                (Upgrade NCI003 to FM 2.1 SP20)                    */
/*                Addition of hook NCI103_016                        */
/*                Addition of hook NCI103_017                        */
/*                Addition of hook NCI103_018                        */
/*                Addition of hook NCI103_019                        */
/*                Addition of hook NCI103_020                        */
/*                Addition of hook NCI103_021                        */
/*                Addition of hook NCI103_022                        */
/*                Addition of hook NCI103_023                        */
/*       MD046248 - Finastra Rebranding                              */
/*       CPL004 - Midas-Plato Interface.                             */
/*                Enhancements for Plato v4.80.                      */
/*                                                                   */
/*********************************************************************/

             PGM

             DCL        VAR(&WAITCOUNT) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*173248*/
             DCL        VAR(&RSBS) TYPE(*CHAR) LEN(10)                                    /*173248*/
             DCL        VAR(&UNIT) TYPE(*CHAR) LEN(3)                                     /*173248*/
             DCL        VAR(&MQQN) TYPE(*CHAR) LEN(80)                                    /*173248*/

             DCLF       FILE(X4PF)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,NCI103_016                                       */ /*NCI103*/

/* Global Monitor Message                                        **/

             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))

/*/COPY WNCPYSRC,NCI103_017                                       */ /*NCI103*/
             SNDPGMMSG  MSG('RPC1070 Replication - End Replication +
                          Sub-System') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             CHGJOB     SWS(XXXXXX00)

/*  Get Midas system prefix and construct the name of the         **/         /*173248*/
/*    Replication sub-system.                                     **/         /*173248*/
                                                                              /*173248*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                    /*173248*/
             CHGVAR     VAR(&RSBS) VALUE('REPMIDAS' *TCAT &PRFX)              /*173248*/
                                                                              /*173248*/
/* Attempt to end the Replication Sub-System                     **/

TAG001:
             ENDSBS     SBS(&RSBS) OPTION(*IMMED)                                         /*173248*/
             MONMSG     MSGID(CPF0943)
             MONMSG     MSGID(CPF1056) EXEC(DLYJOB DLY(10))
             MONMSG     MSGID(CPF1054) EXEC(GOTO CMDLBL(TAG002))

/* Only wait for a maximum of 50 loops.                          **/

             CHGVAR     VAR(&WAITCOUNT) VALUE(&WAITCOUNT + 1)
             IF         COND(&WAITCOUNT > 50) THEN(GOTO CMDLBL(TAG998))

             GOTO       CMDLBL(TAG001)
                                                                              /*173248*/
TAG002:

/*  Get Midas system prefix and construct the name of the         **/         /*173248*/
/*    Replication Unit.                                           **/         /*173248*/
                                                                              /*173248*/
             CHGVAR     VAR(&UNIT) VALUE(&PRFX *TCAT '1')                     /*173248*/

/* Process each valid Replication Sub-System                     **/
TAG003:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(TAG004))
/*/COPY WNCPYSRC,NCI103_018                                 */ /*NCI103*/
             IF         COND((&X4PRDN *NE 'PLATO') *OR (&X4UNIT *NE +
                          &UNIT)) THEN(GOTO CMDLBL(TAG003))
/*/COPY WNCPYSRC,NCI103_019                                 */ /*NCI103*/

/* Construct the name of the internal MQ Queue and clear it.      **/
/*/COPY WNCPYSRC,NCI103_020                                 */ /*NCI103*/
             CHGVAR     VAR(&MQQN) VALUE('PLATOINTERNAL.' *CAT &X4DSMN)
             CLRMQMQ    QNAME(&MQQN)
             MONMSG     MSGID(CPF0000)

             GOTO       CMDLBL(TAG003)
/*/COPY WNCPYSRC,NCI103_021                                 */ /*NCI103*/

TAG004:
/* Retrieve the name of the Initiation Queue and clear it.         */
/*/COPY WNCPYSRC,NCI103_022                                 */ /*NCI103*/
             RTVDTAARA  DTAARA(RPTRGMPI (1 48)) RTNVAR(&MQQN)
             CLRMQMQ    QNAME(&MQQN)
/*/COPY WNCPYSRC,NCI103_023                                       */ /*NCI103*/

             GOTO       CMDLBL(TAG999)

/* Error Processing:                                               */
/* Dump the program if error occurred in this program              */

TAG998:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)

             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)

             SNDMSG     MSG('Job terminated - RPC1070 Replication - +
                          End Replication Sub-System - Ended in +
                          Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)

/* End of Program:                                                 */
TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
