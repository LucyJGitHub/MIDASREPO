/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RP Plato interface - reset replication sbs')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication Module                                  */
/*                                                                   */
/*       RPC1046 - Midas-Plato Interface                             */
/*                 Reset Replication Subsystem - COB                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      191408  *CREATE    Date 23Mar01              */
/*                      Xxxxxx             Date 00Xxx00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       191408 - Separate End Feeder component from reset subsystem.*/
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,RPC1046INT                                          */
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
/**********  DCL        VAR(&CSTS) TYPE(*CHAR) LEN(1)                                     /*CCB023*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('RPC1046 Midas-Plato Interface - Reset +
                          Replication Subsystem - COB') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* Set status of component for start of processing */
 
             CHGJOB     SWS(XXXXXX00)
 
/**********  CHGVAR     VAR(&CSTS) VALUE('Y')                      */                     /*CCB023*/
 
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &CSTS)        */                     /*CCB023*/
 
/*/COPY WNCPYSRC,RPC1046MPS                                          */
 
/* Call the program to reset the replication subsystem */
 
             DLYJOB     DLY(10)
 
             CALL       PGM(RPC1070)
 
/* If any errors are reported, perform error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Set status of component for successful completion */
 
/**********  CHGVAR     VAR(&CSTS) VALUE('N')                      */                     /*CCB023*/
 
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &CSTS)        */                     /*CCB023*/
 
/*/COPY WNCPYSRC,RPC1046MPE                                          */
 
             GOTO       CMDLBL(ENDPGM)
 
/* Error Processing:                                  */
/* Dump the program if error occurred in this program */
 
ABNOR:
/*/COPY WNCPYSRC,RPC1046ERR                                          */
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDMSG     MSG('Job terminated - RPC1046 Midas-Plato +
                          Interface - Reset Replication Subsystem - +
                          COB - Ended in Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
/* End of Program: */
 
ENDPGM:
/*/COPY WNCPYSRC,RPC1046END                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
