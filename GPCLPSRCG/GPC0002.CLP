/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GP Universal transactions update Mgr')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GPC0002 - Universal Transactions Update Manager             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. 259792             Date 19Aug14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG3963            Date 06Aug04              */
/*                      CSC020             Date 31Mar04              */
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       259792 - When receiver is changed, use the updated last     */
/*                sequence number in order to retrieve the next set  */
/*                of journal entries to be processed.                */
/*       BUG3963 - When receiver changed or invalid sequence         */
/*                 number, use *CURCHAIN and retrieve current        */
/*                 receiver name.                                    */
/*       CSC020 - Journaling changes for MidasPlus                   */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&TEMPENTYP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JSEQN) TYPE(*DEC) LEN(10)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURRCV) TYPE(*CHAR) LEN(10)                                  /*CSC020*/
             DCL        VAR(&CURRCVNO) TYPE(*DEC) LEN(8)                                  /*CSC020*/
             DCL        VAR(&CURRCVNOA) TYPE(*CHAR) LEN(8)                                /*CSC020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             DCLF       FILE(GPUTJSPD)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             ALCOBJ     OBJ((GPUTJSPD *FILE *EXCLRD)) WAIT(30)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
             SNDPGMMSG  MSG('Attempt to start Universal Transactions +
                          Manager has failed. Probable cause: +
                          process is active already.') +
                          TOMSGQ(GPOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             CHGJOB SWS(00000000)
 
             CALL       PGM(GPCMTCTL) PARM('S' &CMTRTN)
 
             RCVF
 
             CHGVAR     VAR(&JSEQN) VALUE(&I#LASTSEQ)
 
/* Check if journal sequence exists. */
/* If journal sequence does not exist, set to restart at first entry */
 
 RERUN:
/*                                                                                         *CSC020*/
/*  Use *CURCHAIN to retrieve journal entry in case receiver has changed since the         *CSC020*/
/*  last time the job was active.                                                          *CSC020*/
/*                                                                                         *CSC020*/
/*********** RTVJRNE    JRN(GPJRN) FROMENT(&JSEQN) TOENT(&JSEQN) +
                          RTNENTTYP(&TEMPENTYP) ***************************************** /*CSC020*/
             RTVJRNE    JRN(GPJRN) RCVRNG(*CURCHAIN) FROMENT(&JSEQN) +
                          TOENT(&JSEQN) RTNENTTYP(&TEMPENTYP) +
                          RTNRCV(&CURRCV)                                                 /*CSC020*/
                MONMSG     MSGID(CPF0000) EXEC(DO)
/*                                                                                         *CSC020*/
/*  Start search from sequence number 1 because 0 is invalid.                              *CSC020*/
/*                                                                                         *CSC020*/
/*************     CHGVAR     VAR(&JSEQN) VALUE(0)                                         *CSC020*/
                   CHGVAR     VAR(&JSEQN) VALUE(1)                                        /*CSC020*/
/*************     RTVJRNE    JRN(GPJRN) FROMENT(*FIRST) +
                                TOENT(*FIRST) RTNSEQNBR(&JSEQN)  **************************BUG3963*/
                   RTVJRNE    JRN(GPJRN) RCVRNG(*CURCHAIN) FROMENT(*FIRST) +
                          TOENT(*FIRST) RTNSEQNBR(&JSEQN) +
                          RTNRCV(&CURRCV)                                                /*BUG3963*/
                   MONMSG     MSGID(CPF0000)
                ENDDO
 
             CHGVAR     VAR(&JSEQN) VALUE(&JSEQN + 1)
 
/* Overrides */
             OVRDBF     FILE(GPULOGPD) SHARE(*NO) SEQONLY(*YES 1)
             OVRDBF     FILE(GPUTJSPD) SHARE(*NO)
             OVRDBF     FILE(GPUTJSPDN) TOFILE(GPUTJSPD) SHARE(*NO)
 
             RCVJRNE    JRN(GPJRN) EXITPGM(GPUTUPDMG) +
                          FILE((GPTRAPPD)) RCVRNG(*CURCHAIN) +
                          FROMENT(&JSEQN) JRNCDE((R) (C *IGNFILSLT) +
                          (U *IGNFILSLT) (J *IGNFILSLT)) +
                          ENTFMT(*TYPE1) DELAY(*NEXTENT)
 
             DLTOVR *ALL
 
/*                                                                                          CSC020*/
/*  If switch 6 is on, then journal receiver has been changed.                              CSC020*/
/*                                                                                          CSC020*/
             IF         COND(%SWITCH(XXXXX100)) THEN(DO)
                                                                                          /*259792*/
/* Get the latest journal sequence number */                                              /*259792*/
             OPNDBF     FILE(GPUTJSPD) OPTION(*INP) OPNSCOPE(*JOB)                        /*259792*/
             POSDBF     OPNID(GPUTJSPD) POSITION(*START)                                  /*259792*/
             RCVF                                                                         /*259792*/
             CHGVAR     VAR(&JSEQN) VALUE(&I#LASTSEQ)                                     /*259792*/
             CLOF       OPNID(GPUTJSPD)                                                   /*259792*/
                                                                                          /*259792*/
/**********************************************************************            /*CSC020 259792*/
/***Calculate*name*of*next*receiver*in*chain.**************************            /*CSC020 259792*/
/**********************************************************************            /*CSC020 259792*/
/**********     CHGVAR     VAR(&CURRCVNOA) VALUE(%SST(&CURRCV 3 8))                /*CSC020 259792*/
/**********     CHGVAR     VAR(&CURRCVNO) VALUE(&CURRCVNOA)                        /*CSC020 259792*/
/**********     CHGVAR     VAR(&CURRCVNO) VALUE(&CURRCVNO + 1)                     /*CSC020 259792*/
/**********     CHGVAR     VAR(&CURRCVNOA) VALUE(&CURRCVNO)                        /*CSC020 259792*/
/**********     CHGVAR     VAR(&CURRCV) VALUE('GR' *CAT &CURRCVNOA)                /*CSC020 259792*/
/*********      CHGVAR     VAR(&JSEQN) VALUE(0)                                             CSC020*/
/**********************************************************************            /*CSC020 259792*/
/***Retrieve*first*sequence*number*of*new*receiver.********************            /*CSC020 259792*/
/**********************************************************************            /*CSC020 259792*/
/**********     RTVJRNE    JRN(GPJRN) RCVRNG(&CURRCV) TOENT(*FIRST) +
                          RTNSEQNBR(&JSEQN)                                        /*CSC020 259792*/
                CHGJOB     SWS(00000000)
                GOTO       CMDLBL(RERUN)
             ENDDO
 
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             GPC0002 ended abnormally - see job log') +
                             TOMSGQ(GPOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GPC0002 ended abnormally - see job log') +
                          TOMSGQ(GPOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             DLCOBJ     OBJ((GPUTJSPD *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
