/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE End projections background job')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0040 - End Projections Background Job                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDE005             Date 27Sep02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002             Date 22Mar01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      180491             Date 19Jun00              */
/*                      CDE001  *CREATE    Date 15Nov99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDE005 - Data Export - Reservation ID                       */
/*       CPB002 - Add the REPMIDASxx library back into the library   */
/*                list after the replication processing has removed  */
/*                it.                                                */
/*       180491 - Ensure that commitment control is ended otherwise  */
/*                the COB will fall over and sign the user off.      */
/*       CDE001 - Data Export - CCRM Limits                          */
/*                                                                   */
/*********************************************************************/
/**********  PGM */                                                                       /*180491*/
             PGM        PARM(&MODE)                                                       /*180491*/
 
/*/COPY WNCPYSRC,DEC0040INT                                          */
 
             DCL        VAR(&TREF) TYPE(*CHAR) LEN(20) +
                        VALUE('SHUTDOWN')
             DCL        VAR(&TCAT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RSRV) TYPE(*CHAR) LEN(10)                                    /*CDE005*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                                     /*180491*/
             DCL        VAR(&REPMIDAS) TYPE(*CHAR) LEN(10)                                /*CPB002*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                   /*CPB002*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,DEC0040MPS                                          */
 
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                           /*CPB002*/
                CHGVAR     VAR(&REPMIDAS) VALUE('REPMIDAS' *CAT &PREFIX)                  /*CPB002*/
                                                                                          /*CPB002*/
                ADDLIBLE   LIB(&REPMIDAS) POSITION(*LAST)                                 /*CPB002*/
                MONMSG     MSGID(CPF0000)                                                 /*CPB002*/
                                                                                          /*CPB002*/
/* Try and allocate DEOLEJPD - if it fails, the CCRM - Limits Drip  */
/* Feed Transfer job is active, so shut it down.                    */
 
              ALCOBJ     OBJ((DEOLEJPD *FILE *EXCL)) WAIT(0)
              MONMSG     MSGID(CPF0000) EXEC(DO)
 
                STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                           CMTSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
 
/***********    CALL PGM(DEWTTRIG) PARM(&TREF &TCAT)               */                     /*CDE005*/
                CALL PGM(DEWTTRIG) PARM(&TREF &TCAT &RSRV)                                /*CDE005*/
                COMMIT
 
/* Call program to end Meridian Replication Feeder Job */
                CALL       PGM(KMDJFC)
 
                ADDLIBLE   LIB(&REPMIDAS) POSITION(*LAST)                                 /*CPB002*/
                MONMSG     MSGID(CPF0000)                                                 /*CPB002*/
                                                                                          /*CPB002*/
              ENDDO
 
              DLCOBJ     OBJ((DEOLEJPD *FILE *EXCL))
              MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,DEC0040MPE                                          */
 
            GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0040ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
               ROLLBACK
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0040 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DEC0040END                                          */
 
             IF         COND(&MODE *EQ 'C') THEN(DO)                                      /*180491*/
                ENDCMTCTL                                                                 /*180491*/
                MONMSG     MSGID(CPF0000)                                                 /*180491*/
             ENDDO                                                                        /*180491*/
                                                                                          /*180491*/
ENDPGM
