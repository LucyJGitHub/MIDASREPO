/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Clear Italian Reporting Daily Files')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting - Italy                          */
/*                                                                   */
/*       SDCLRIR - Clear Italian Reporting Daily Files               */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 08Jan21              */
/*       Prev Amend No. UIT024             Date 01Jun98              */
/*                      UIT021  *CREATE    Date 03FEB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - UCI Italian returns upgrade to FM2.1               */
/*       UIT024 - National Bank of Italy Anti-Laundering Reporting   */
/*       UIT021 - Bank Of Italy Monthly Reporting                    */
/*                                                                   */
/*********************************************************************/
                                                                      /*UIT021*/
             PGM                                                      /*UIT021*/
                                                                      /*UIT021*/
/***  Declare varaible used.  ***/                                    /*UIT021*/
                                                                      /*UIT021*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                   Copyright Midas-Kapiti International Ltd. 1997')   /*UIT021*/
                                                                      /*UIT021*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('UIT021')  /*UIT021*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*UIT021*/
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*UIT021*/
             DCL        VAR(&UIT021) TYPE(*CHAR) LEN(1) VALUE('N')    /*UIT021*/
             DCL        VAR(&UIT024) TYPE(*CHAR) LEN(1) VALUE('N')    /*UIT024*/
                                                                      /*UIT021*/
/***  Global monitor message  ***/                                    /*UIT021*/
                                                                      /*UIT021*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000 CPA0000) +
                          EXEC(GOTO CMDLBL(ABNOR))                    /*UIT021*/
                                                                      /*UIT021*/
/***  Check if feature UIT021 is installed.  ***/                     /*UIT021*/
                                                                      /*UIT021*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*UIT021*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPT &SAR)           /*UIT021*/
                                                                      /*UIT021*/
/***  If feature is installed  ***/                                   /*UIT021*/
                                                                      /*UIT021*/
             IF         COND(&RTCD *EQ '       ')  +
                   THEN(CHGVAR VAR(&UIT021) VALUE('Y'))               /*UIT021*/
                                                                      /*UIT021*/
/***  If feature UIT021 is installed, clear file IRAPOSPD  ***/       /*UIT021*/
/***  - Italian Reporting Postings File - PUMA2  ***/                 /*UIT021*/
                                                                      /*UIT021*/
             IF         COND(&UIT021 *EQ 'Y') THEN(CLRPFM +
                          FILE(IRAPOSPD))                             /*UIT021*/
                                                                      /*UIT024*/
/***  Check if feature UIT024 is installed.  ***/                     /*UIT024*/
                                                                      /*UIT024*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*UIT024*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPT 'UIT024')       /*UIT024*/
                                                                      /*UIT024*/
/***  If feature is installed  ***/                                   /*UIT024*/
                                                                      /*UIT024*/
             IF         COND(&RTCD *EQ '       ')  +
                   THEN(CHGVAR VAR(&UIT024) VALUE('Y'))               /*UIT024*/
                                                                      /*UIT024*/
/***  If feature UIT024 is installed, clear file IRMAPOPD  ***/       /*UIT024*/
/***  - Anti-Laundering Reporting Postings File  ***/                 /*UIT024*/
                                                                      /*UIT024*/
             IF         COND(&UIT024 *EQ 'Y') THEN(CLRPFM +
                          FILE(IRMAPOPD))                             /*UIT024*/
                                                                      /*UIT021*/
             GOTO       CMDLBL(END)                                   /*UIT021*/
                                                                      /*UIT021*/
 ABNOR:      DMPCLPGM                                                 /*UIT021*/
             MONMSG     MSGID(CPF0000)                                /*UIT021*/
             CHGJOB     SWS(XXXXXX1X)                                 /*UIT021*/
             MONMSG     MSGID(CPF0000)                                /*UIT021*/
             SNDPGMMSG  MSG('SDCLRIR - Job abnormally terminated - +
                          Execution error') TOMSGQ(MRUNQ MOPERQ)      /*UIT021*/
             MONMSG     MSGID(CPF0000)                                /*UIT021*/
                                                                      /*UIT021*/
 END:        CHGVAR     VAR(&CPYFLD) +
                  VALUE('Copyright Midas-Kapiti International Ltd.')  /*UIT021*/
             MONMSG     MSGID(CPF0000)                                /*UIT021*/
                                                                      /*UIT021*/
             ENDPGM                                                   /*UIT021*/
                                                                      /*UIT021*/
