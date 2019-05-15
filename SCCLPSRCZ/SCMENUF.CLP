/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Recovery menu')                              */
/********************************************************************/
/*                                                                  */
/*        Midas     - Standing Data Module                          */
/*                                                                  */
/*       SCMENUF - RECOVERY MENU                                    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/*                      CBF002             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886        Date 23May08                 */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015         Date 14Feb02                 */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CTI001         Date 31Jul97                 */
/*                      S01408         DATE 30AUG96                 */
/*                      S01343         DATE 15AUG91                 */
/*                      E20405         DATE 19DEC89                 */
/*                      S01199         DATE 26APR90                 */
/*                      S01117         DATE 17/08/89                */
/*                      E14914         DATE 27/02/89                */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       CBF002 - BF Infrastructure: Backup and Recovery            */
/*              - This program will be replaced by the              */
/*                Configuration Maintenance (artf815172)            */
/*       BG18886 - Amend non-standard codes.                        */
/*       CPK015 - Code is redundant.                                */
/*       CTI001 - Midas/TI Interface (Phase 1)                      */
/*                                                                  */
/*       S01408 - Addition of core hook SCMENUF004                  */
/*              - Addition of core hook SCMENUF003                  */
/*              - Addition of core hook SCMENUF002                  */
/*              - Addition of core hook SCMENUF001                  */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                   */
/*                - SCMENUF RENAMED FROM L1MNUF                     */
/*                - SCBACKUP RENAMED FROM MBACKUP                   */
/*                - RRRECOVER RENAMED FROM MRECOVR                  */
/*                - SCUSRMNU RENAMED FROM MUSRMNU                   */
/*                - SCC1711 RENAMED FROM SDC1711                    */
/*       E20405 - SEVERAL OPTIONS NOW SUPPRESSED WHEN SCMENUF       */
/*                CALLED DURING PHASE 'D'.                          */
/*       S01199 - HELP CHANGES                                      */
/*       S01117 - RELEASE 10 MULTIBRANCHING                         */
/*       E14914 - TO INSERT 'RESTART FAILED TRANSACTION' OPTION     */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*           DCL        &N  TYPE(*CHAR)  LEN(8)                     */
/************DCL    VAR(&HBPGM) TYPE(*CHAR) LEN(8) VALUE('RR1701') */ /*S01199*/
/************DCL        VAR(&HERCD) TYPE(*CHAR) LEN(80) */            /*S01199*/
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                          */ /*E20405 CCB020*/
             DCL        VAR(&IN72) TYPE(*LGL) LEN(1)                  /*E20405*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*CTI001*/
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(7)               /*CTI001*/
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(200)             /*CTI001*/
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(132)               /*CTI001*/
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(132)               /*CTI001*/
/*           DCLF       SCMENUFDF RCDFMT(SCMENUF)     */              /*CTI001*/
             DCLF       SCMENUFDF                                     /*CTI001*/
/*                                                                            */
             RTVJOBA    JOB(&DEVNM)
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                            */ /*E20405 CCB020*/
/**/                                                                  /*E20405*/
/**********  IF         COND(&MPHAS *EQ 'D') THEN(DO)                           */ /*E20405 CCB020*/
             CHGVAR     VAR(&IN72) VALUE('1')                         /*E20405*/
/**********  ENDDO                                                              */ /*E20405 CCB020*/
                                                                      /*CTI001*/
             CHGVAR     VAR(&##PGM) VALUE('SCMENUF')                  /*CTI001*/
RDSPLY:      SNDRCVF    RCDFMT(SCMENUF)
             RMVMSG     PGMQ(*SAME (&##PGM)) MSGQ(*PGMQ) CLEAR(*ALL)  /*CTI001*/
             SNDF       RCDFMT(MSGCTL)                                /*CTI001*/
/*  ALLOW HELP                                                     */ /*S01199*/
/*           IF         COND(&IN01 *EQ '1') THEN(DO)               */ /*S01199*/
/*              CALL       PGM(MHELP) PARM(&HBPGM &HERCD)          */ /*S01199*/
/*              GOTO       RDSPLY                                  */ /*S01199*/
/*           ENDDO                                                 */ /*S01199*/
/**/                                                                  /*E20405*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                            */ /*E20405 CCB020*/
/**********  IF         COND(&MPHAS *EQ 'D') THEN(DO)                           */ /*E20405 CCB020*/
             CHGVAR     VAR(&IN72) VALUE('1')                         /*E20405*/
/**********  ENDDO                                                              */ /*E20405 CCB020*/
/**/
/**********  IF         COND(&MOPTN *EQ 01) THEN(CALL PGM(SDC1740))  */                   /*CBF002*/
             IF         COND(&MOPTN *EQ 01) THEN(DO)                                      /*CBF002*/
             CHGVAR     VAR(&MSG1) VALUE('This menu has been +
                          replaced by Configuration Maintenance.')                        /*CBF002*/
             SNDPGMMSG  MSG(&MSG1) TOPGMQ(*SAME)                                          /*CBF002*/
             SNDPGMMSG  MSG(&MSG1) TOMSGQ(MOPERQ)                                         /*CBF002*/
             SNDF       RCDFMT(MSGCTL)                                                    /*CBF002*/
             CHGVAR     VAR(&MSG1) VALUE(' ')                                             /*CBF002*/
             GOTO       CMDLBL(RDSPLY)                                                    /*CBF002*/
             ENDDO                                                                        /*CBF002*/
             IF         COND(&IN72 *EQ '0') THEN(DO)                  /*E20405*/
/************IF         COND(&MOPTN *EQ 02) THEN(CALL PGM(SCBACKUP) +
/************             PARM(SDC1711 ' '))                          /*S01343*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCMENUF001                                        */ /*S01408*/
                                                                      /*S01408*/
/*******     IF         COND(&MOPTN *EQ 02) THEN(CALL PGM(SCBACKUP) + /*CTI001*/
/*******                  PARM(SCC1711 ' '))             /*S01343*/   /*CTI001*/
                                                                      /*CTI001*/
             IF         COND(&MOPTN *EQ 02) THEN(DO)                  /*CTI001*/
/* Check if Midas/TI Interface Module is switched on  */              /*CTI001*/
             CHGVAR     VAR(&RTNCDE) VALUE('*DBERR ')                 /*CTI001*/
             CHGVAR     VAR(&OPTION) VALUE('*FIRST ')                 /*CTI001*/
             CALL       PGM(AOMMODR0) PARM(&RTNCDE &OPTION &FORMAT)   /*CTI001*/
/*  Database error handling.                                          /*CTI001*/
             IF         COND(&RTNCDE *NE '       ') THEN(DO)          /*CTI001*/
             CHGVAR     VAR(&MSG1) VALUE('Error on access to ICD +
                          file SDMMODPD')                             /*CTI001*/
             SNDPGMMSG  MSG(&MSG1) TOMSGQ(MRUNQ MOPERQ)               /*CTI001*/
             GOTO       CMDLBL(ENDPGM)                                /*CTI001*/
             ENDDO                                                    /*CTI001*/
                                                                      /*CTI001*/
/* Midas/TI Interface Module is ON  */                                /*CTI001*/
             IF         COND(%SST(&FORMAT 103 1) *EQ 'Y') THEN(DO)    /*CTI001*/
             CALL       PGM(TIC0030) PARM('STOP' 'SCMENUF')           /*CTI001*/
/**********  IF         COND(**%SWITCH(XXXXXX00)) THEN(GOTO +      */ /*BG18886*/
/**********               CMDLBL(TIERR))                           */ /*BG18886*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(TIERR))                              /*BG18886*/
             CALL       PGM(TIC0050) PARM('STOP')                     /*CTI001*/
/**********  IF         COND(*%SWITCH(XXXXXX00)) THEN(GOTO +       */ /*CTI001*/ /*BG18886*/
/**********               CMDLBL(TIERR))                           */ /*CTI001*/ /*BG18886*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(TIERR))                              /*CTI001*/ /*BG18886*/
             CALL       PGM(TIC0040)                                  /*CTI001*/
/**********  IF         COND(*%SWITCH(XXXXXX00)) THEN(GOTO +       */ /*CTI001*/ /*BG18886*/
/**********               CMDLBL(TIERR))                           */ /*CTI001*/ /*BG18886*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(TIERR))                              /*CTI001*/ /*BG18886*/
                                                                      /*CTI001*/
             CALL       PGM(SCBACKUP) PARM(SCC1711 ' ')               /*CTI001*/
                                                                      /*CTI001*/
             CALL       PGM(TIC0030) PARM('START' 'SCMENUF')          /*CTI001*/
/**********  IF         COND(*%SWITCH(XXXXXX00)) THEN(GOTO +       */ /*CTI001*/ /*BG18886*/
/**********               CMDLBL(TIERR))                           */ /*CTI001*/ /*BG18886*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(TIERR))                              /*CTI001*/ /*BG18886*/
             CALL       PGM(TIC0050) PARM('START')                    /*CTI001*/
/**********  IF         COND(*%SWITCH(XXXXXX00)) THEN(GOTO +       */ /*CTI001*/ /*BG18886*/
/**********               CMDLBL(TIERR))                           */ /*CTI001*/ /*BG18886*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(TIERR))                              /*CTI001*/ /*BG18886*/
             CALL       PGM(TIC0041)                                  /*CTI001*/
/**********  IF         COND(*%SWITCH(XXXXXX00)) THEN(GOTO +       */ /*CTI001*/ /*BG18886*/
/**********               CMDLBL(TIERR))                           */ /*CTI001*/ /*BG18886*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(TIERR))                              /*CTI001*/ /*BG18886*/
 
             GOTO       CMDLBL(RDSPLY)                                /*CTI001*/
 TIERR:      RCVMSG     MSGQ(MOPERQ) MSGTYPE(*LAST) MSG(&MSG1)        /*CTI001*/
             RCVMSG     MSGQ(MOPERQ) MSGTYPE(*LAST) RMV(*NO) +
                          MSG(&MSG2)                                  /*CTI001*/
             SNDPGMMSG  MSG(&MSG2) TOPGMQ(*SAME)                      /*CTI001*/
             SNDPGMMSG  MSG(&MSG1) TOPGMQ(*SAME)                      /*CTI001*/
             SNDPGMMSG  MSG(&MSG1) TOMSGQ(MOPERQ)                     /*CTI001*/
             SNDF       RCDFMT(MSGCTL)                                /*CTI001*/
             CHGVAR     VAR(&MSG1) VALUE(' ')                         /*CTI001*/
             CHGVAR     VAR(&MSG2) VALUE(' ')                         /*CTI001*/
             GOTO       CMDLBL(RDSPLY)                                /*CTI001*/
             ENDDO                                                    /*CTI001*/
                                                                      /*CTI001*/
/* Midas/TI Interface Module is OFF */                                /*CTI001*/
             ELSE       CMD(CALL PGM(SCBACKUP) PARM(SCC1711 ' '))     /*CTI001*/
             ENDDO                                                    /*CTI001*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCMENUF002                                        */ /*S01408*/
                                                                      /*S01408*/
             IF         COND(&MOPTN *EQ 03) THEN(CALL PGM(SDC1715)            +
                          PARM('0'))
             IF         COND(&MOPTN *EQ 04) THEN(CALL PGM(RRRECOVER) +
                          PARM(SDC1725 ' '))
             IF         COND(&MOPTN *EQ 05) THEN(CALL PGM(RRRECOVER) +
                          PARM(SDC1720 ' '))
             IF         COND(&MOPTN *EQ 06) THEN(CALL PGM(SDC1790))
             IF         COND(&MOPTN *EQ 07) THEN(CALL PGM(RRRECOVER) +
                          PARM(SDC1750 ' '))
             IF         COND(&MOPTN *EQ 08) THEN(CALL PGM(RRRECOVER) +
                          PARM(SDC1753 ' '))
             IF         COND(&MOPTN *EQ 09) THEN(CALL PGM(RRRECOVER) +
                          PARM(SDC1755 ' '))
                                                             /*E14914*/
             IF         COND(&MOPTN *EQ 11) THEN(CALL PGM(DLC0210F))
                                                             /*E14914*/
             ENDDO                                                    /*E20405*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCMENUF004                                 */        /*S01408*/
                                                                      /*S01408*/
/************IF         COND(&MOPTN *EQ 12) THEN(CALL PGM(FCC1701))            /*S01117*/ /*CPK015*/
/************IF         COND(&MOPTN *EQ 13) THEN(CALL PGM(FCC1702))            /*S01117*/ /*CPK015*/
/**/
             IF         COND(&MOPTN *EQ 22) THEN(CALL SCUSRMNU)
             IF         (&MOPTN *EQ 23)  THEN(GOTO ENDPGM)
             IF         (&MOPTN *EQ 24)  THEN(SIGNOFF *LIST)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCMENUF003                                 */        /*S01408*/
                                                                      /*S01408*/
             CHGJOB     SWS(00000000)
             GOTO       RDSPLY
/*                                                                            */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDPGM:     ENDPGM     /* END CL PGM SCMENUF */
