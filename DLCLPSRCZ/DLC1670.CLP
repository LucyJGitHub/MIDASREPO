/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL OIS Settlement Control - Rerun')             */
/*********************************************************************/
/*                                                                   */
/*      Midas - Dealing Module                                       */
/*                                                                   */
/*      DLC1670 - OIS Deal Settlement Rerun Prompt                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 236830             Date 18Nov05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CIR007 *C *CREATE  Date 11May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*      236830 - Don't set Data Area flag to 'Y' until job is        */
/*               actually running.  Applied fix 211836.              */
/*      CIR007 - Overnight Index Swaps                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM &RACT &RCMD)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OISRUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Global monitor message                                         */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/** Retrieve OIS Control Data Area to see if option                */
/** is already being run                                           */
             ALCOBJ     OBJ((DLOISDTA *DTAARA *EXCL)) WAIT(1)
 
/** Data area already allocated                                    */
             MONMSG     MSGID(CPF1002) EXEC(DO)
              SNDPGMMSG  MSG('OIS Deals Settlement process is +
                         currently in use. Please retry later') +
                         TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
              CHGVAR     VAR(&RCMD) VALUE('E')
              RETURN
             ENDDO
 
/** Check if process already being run                             */
             RTVDTAARA  DTAARA(DLOISDTA (1 1)) RTNVAR(&OISRUN)
             IF         COND(&OISRUN *EQ 'Y') THEN(DO)
              SNDPGMMSG  MSG('OIS Deals Settlement process is +
                         currently in use. Please retry later') +
                         TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
              CHGVAR     VAR(&RCMD) VALUE('E')
              DLCOBJ     OBJ((DLOISDTA *DTAARA *EXCL))
              RETURN
             ENDDO
 
/** Call prompt program                                            */
             CALL       PGM(DL1670) PARM(&RSEQ &RLEV &RENT &PARM +
                          &RACT &RCMD)
 
/***Flag*OIS*data*area*to*indicate*process*to*run*********************/                   /*236830*/
/*           IF         COND(&RCMD *EQ ' ') THEN(DO)                 */                   /*236830*/
/*            CHGDTAARA  DTAARA(DLOISDTA (1 1)) VALUE('Y')           */                   /*236830*/
/*           ENDDO                                                   */                   /*236830*/
 
/** Release data area                                              */
             DLCOBJ     OBJ((DLOISDTA *DTAARA *EXCL))
 
/** Return to calling program                                      */
             RETURN
 
/** Error Processing                                               */
ERROR:
             SNDPGMMSG  MSG('Problem has occurred in the OIS Deal +
                          Settlement.') TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((DLOISDTA *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
