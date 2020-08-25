/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Save journal receivers to save files')       */
/*********************************************************************/
/*                                                                   */
/*       MIDAS SYSTEM CONTROL MODULE                                 */
/*                                                                   */
/*       SCC2470SAV - Save Journal Receivers To Save Files           */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD055681           Date 31Jul20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD036915           Date 06Jan16              */
/*                      AR855839           Date 25Nov12              */
/*                      CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      260790  *CREATE    Date 19Jun09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD055681 - Deliverable Data Split for SAR                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD036915 - COB: COBJRNMON is not ready for IASP.            */
/*       AR855839 - Reopen of Input cycle gives MSGW in COBJRNMON.   */
/*                  Fix is to CALL CB0602X and AOSARDR0 only when    */
/*                  CBACOBL1 and SCSARDL1 are not allocated.         */
/*                  (Child:AR855840)                                 */
/*                - Applied for AR1006062 (Child:AR1006063)          */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       260790 - COB performance fix                                */
/*                Save journal receivers to disk as they are chg'd   */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* System ID */
/**/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
/**/
/* Libraries */
/**/
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
/**/
/* Parms for CB0602X */
/**/
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
             DCL        VAR(&ASP) TYPE(*CHAR) LEN(2)
/**/
/* Midas Phase */
/**/
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)
/**/
/* Save Journal Receiver Destination */
/**/
             DCL        VAR(&SJRD) TYPE(*CHAR) LEN(5)
/**/
/* Attached Receiver */
/**/
             DCL        VAR(&ATTACHED) TYPE(*CHAR) LEN(10)
/**/
/* Current Receiver */
/**/
             DCL        VAR(&CURR_RCVN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CURR_RDEC) TYPE(*DEC) LEN(8 0)
/**/
/* Next Receiver to save */
/**/
             DCL        VAR(&NEXT_RCVN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NEXT_RDEC) TYPE(*DEC) LEN(8 0)
/**/
/**CCB009*switchable*feature**/                                                           /*CCB020*/
/**/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)                                */ /*CCB020*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                               */ /*CCB020*/
/**/
/* Receiver being saved */
/**/
             DCL        VAR(&SAVF_NAME) TYPE(*CHAR) LEN(10)
/**/
/* Copyright statement definition */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
/**/
/* Global MONMSG */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/* Copyright statement definition at runtime */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE(&CPYFLD)
/**/
/* Obtain the system library id from SDSTAT */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
             CHGVAR     VAR(&DILIB) VALUE(&SYSID *CAT 'DILIB')
                                                                                        /*AR855839*/
/** Call CB0602X only when CBACOBL1 is not allocated */                                 /*AR855839*/
                                                                                        /*AR855839*/
             ALCOBJ     OBJ((CBACOBL1 *FILE *EXCL *FIRST)) WAIT(1)                      /*AR855839*/
             MONMSG     MSGID(CPF0000) EXEC(RETURN)                                     /*AR855839*/
             DLCOBJ     OBJ((CBACOBL1 *FILE *EXCL *FIRST))                              /*AR855839*/
/**/
/* Obtain the ASP for save files via CB0602X */
/* Obtain the destination for RCVR saves also via CB0602X*/
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
             CHGVAR     VAR(&ASP) VALUE(%SST(&CB_AUTO 51 2))
             CHGVAR     VAR(&SJRD) VALUE(%SST(&CB_AUTO 31 5))
/**/
/* Obtain MPHAS */
/**/
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&PHASE)
/**/
/**If*this*is*I/C*(&PHASE*=*'A')*and*save*destination*for*receivers**/
/** If &PHASE = 'A' or 'G' and save destination for receivers */                          /*CCB020*/
/* is not DISK then exit program as journal receivers will be saved */
/* to TAPE in SCC0401 */
/**/
/**********  IF         COND((&PHASE *EQ 'A') *AND (&SJRD *NE +
                          '*DISK')) THEN(RETURN)                                       */ /*CCB020*/
             IF         COND((&PHASE *EQ 'A' *OR &PHASE *EQ 'G') +
                          *AND (&SJRD *NE '*DISK')) THEN(RETURN)                          /*CCB020*/
                                                                                        /*AR855839*/
/** Call AOSARDR0 only when SCSARDL1 is not allocated */                                /*AR855839*/
                                                                                        /*AR855839*/
/**********  ALCOBJ     OBJ((SCSARDL1 *FILE *EXCL *FIRST)) WAIT(1) */         /*AR855839**MD055681*/
             ALCOBJ     OBJ((SCSRDJW0 *FILE *EXCL *FIRST)) WAIT(1)                      /*MD055681*/
             MONMSG     MSGID(CPF0000) EXEC(RETURN)                                     /*AR855839*/
/**********  DLCOBJ     OBJ((SCSARDL1 *FILE *EXCL *FIRST)) */                 /*AR855839**MD055681*/
             DLCOBJ     OBJ((SCSRDJW0 *FILE *EXCL *FIRST))                              /*MD055681*/
/**/
/**Decide*if*CCB009*-*journalling*during*COB*is*on**/                                     /*CCB020*/
/**/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                                             */ /*CCB020*/
/**/
/**If*the*phase*is*NOT*'A'*and*CCB009*is*NOT*'ON'*then*exit*the**/                        /*CCB020*/
/**program*as*SCC0405*will*delete*all*the*JRNRCVRs*rather*than*save**/                    /*CCB020*/
/**them.**/                                                                               /*CCB020*/
/**/
/**********  IF         COND((&PHASE *NE 'A') *AND (&CCB009 *NE +
                          '          ')) THEN(RETURN)                                  */ /*CCB020*/
/**/
/* Update JNSTAT to correctly reflect the currently attached  */
/* receiver.  Receivers may be changed automatically by the   */
/* operating system during the close of business.             */
/**/
/**********  IF         COND(&PHASE *NE 'A') THEN(DO)                                  */ /*CCB020*/
             IF         COND(&PHASE *NE 'A' *AND &PHASE *NE 'G') +
                          THEN(DO)                                                        /*CCB020*/
                 RTVJRNE    JRN(ICJRN) RTNRCV(&ATTACHED)
                 CHGDTAARA  DTAARA(JNSTAT (1 10)) VALUE(&ATTACHED)
             ENDDO
/**/
/* Obtain next receiver to be saved - JNSTAT 13 - 20 */
/**/
             RTVDTAARA  DTAARA(JNSTAT (13 8)) RTNVAR(&NEXT_RCVN)
/**/
/* Obtain current attached receiver saved - JNSTAT 3 - 10 */
/**/
             RTVDTAARA  DTAARA(JNSTAT (3 8)) RTNVAR(&CURR_RCVN)
/**/
/* Set up numeric values of next and current receivers */
/**/
             CHGVAR     VAR(&CURR_RDEC) VALUE(&CURR_RCVN)
             CHGVAR     VAR(&NEXT_RDEC) VALUE(&NEXT_RCVN)
/**/
/* Last Receiver to save should be the Current - 1 i.e. don't back */
/* up attached receiver */
/**/
             CHGVAR     VAR(&CURR_RDEC) VALUE(&CURR_RDEC - 1)

 SAVE:
/**/
/* Are there any receivers to save - Yes if the &CURR_RCV -1 is */
/* greater than or equal to the &NEXT_RCV */
/**/
             IF         COND(&CURR_RDEC *GE &NEXT_RDEC) THEN(DO)
                 CHGVAR     VAR(&NEXT_RCVN) VALUE(&NEXT_RDEC)
                 CHGVAR     VAR(&SAVF_NAME) VALUE('IR' *CAT &NEXT_RCVN)
/**/
/* Delete any pre-existing SAVF for this receiver */
/**/
                 DLTF       FILE(&DILIB/&SAVF_NAME)
                 MONMSG     MSGID(CPF0000 MCH0000)
/**/
/* Create the SAVF for this receiver to be saved */
/**/
             IF (&ASP < '33') DO                                                        /*MD036915*/
                 CRTSAVF    FILE(&DILIB/&SAVF_NAME) TEXT('Save file for +
                          Auto COB') ASP(&ASP)
                 MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO                                                                      /*MD036915*/
             ELSE DO                                                                    /*MD036915*/
                 CRTSAVF    FILE(&DILIB/&SAVF_NAME) TEXT('Save file for +
                          Auto COB') ASP(*LIBASP)                                       /*MD036915*/
                 MONMSG MSGID(CPF0000 MCH0000)                                          /*MD036915*/
             ENDDO                                                                      /*MD036915*/
/**/
/* Now save the receiver */
/**/
                 SAVOBJ     OBJ(&SAVF_NAME) LIB(&JLIB) DEV(*SAVF) +
                          OBJTYPE(*JRNRCV) SAVF(&DILIB/&SAVF_NAME) +
                          USEOPTBLK(*NO) CLEAR(*ALL) OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* Save was successful so update JNSTAT with the next receiver to save */
/* receivers to save */
/**/
                 CHGVAR     VAR(&NEXT_RDEC) VALUE(&NEXT_RDEC + 1)
                 CHGVAR     VAR(&NEXT_RCVN) VALUE(&NEXT_RDEC)
                 CHGDTAARA  DTAARA(JNSTAT (13 8)) VALUE(&NEXT_RCVN)
/**/
/* Loop around in case there are more */
/**/
                 GOTO       CMDLBL(SAVE)
             ENDDO

             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal Termination */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             SNDPGMMSG  MSG('Program SCC2470SAV ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

 ENDCLPGM:
             ENDPGM
