/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Outgoing Payments by Destination')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTC0240  - CL Component to control FT0240                   */
/*                - Outgoing Payment Summary By Destination          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 074791             Date 19Jul94              */
/*                      S01494             Date 25May94              */
/*                      051416             DATE  26FEB93             */
/*                      E25340             DATE  31MAY91             */
/*                      S01194             DATE  20SEP90             */
/*                      S01117             DATE  11SEP90             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       074791 - Override spool file name if in regular payments    */
/*                mode. Fixed during development of S01494.          */
/*       S01494 - BLI Funds Transfer Enhancements                    */
/*       051416 - ADD PARAMETER &TYPE ON CALL TO FT0239              */
/*       E25340 - EXTRACT FILE OTPAYEX NOW GENERATED WITH  FULL      */
/*                ADDRESS OF DESTINATION TO PROVIDE CORRECT          */
/*                SEQUENCING                                         */
/*       S01194 - STANDING DATA CHANGES                              */
/*       S01117 - RELEASE 10 MULTIBRANCHING CHANGES                  */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**          PGM        PARM(&TYPE)                                  /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)               /*S01117*/
 
/**     DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)                    /*S01194*/
        DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                    /*S01194*/
        DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
        DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                     /*S01117*/
        DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                     /*S01117*/
        DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                     /*S01117*/
        DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)                  /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
        DCL        VAR(&RNTP) TYPE(*CHAR) LEN(7)                     /*S01494*/
/**/
        CHGJOB     SWS(XXXXXX00)
        CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 3 1))                /*S01117*/
                                                                     /*S01117*/
        IF (&TYPE = '3') THEN(DO)                                    /*S01117*/
        CHGVAR     VAR(&TYPE) VALUE(' ')                             /*S01117*/
        ENDDO                                                        /*S01117*/
/**/                                                                 /*S01194*/
/** CHECK IF LDA DATA AREA EXISTS AND CREATE IT IF NOT **/           /*S01194*/
/**/                                                                 /*S01194*/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)                         /*S01194*/
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))                 /*S01194*/
/**/                                                                 /*S01194*/
 
/*E25340*/
/* CLEAR EXTRACT FILE OTPAYEX */
             CLRPFM     FILE(OTPAYEX)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('REPORT IS ALREADY IN USE PLEASE WAIT +
                          AND TRY AGAIN') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(WAIT)
             ENDDO
 
/**/                                                                 /*S01494*/
/** If run type is Regular Payment (FTM2507) then override the */    /*S01494*/
/** database file OTPAYDD to RPPAYBB */                              /*S01494*/
/**/                                                                 /*S01494*/
             CHGVAR     VAR(&RNTP) VALUE(%SST(&RPARM 4 7))           /*S01494*/
             IF         COND(&RNTP *EQ 'FTM2507') THEN(DO)           /*S01494*/
                OVRDBF     FILE(OTPAYDD) TOFILE(RPPAYBB)             /*S01494*/
             ENDDO                                                   /*S01494*/
 
/*GENERATE OTPAYEX EXTRACT RECORDS*/
 
/*051416*/
/*           CALL PGM(FT0239)                    */
/************CALL PGM(FT0239) PARM(&TYPE)                         */ /*S01494*/
             CALL PGM(FT0239) PARM(&TYPE &RNTP)                      /*S01494*/
/*051416*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('CALL TO EXTRACT PROGRAM FT0239 FROM +
                          FTC0240 ENDED IN ERROR') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END))
/*E25340*/
                                                                     /*S01117*/
/***Override*if*required***/                                         /*S01117*/
/**     IF (&TYPE = '1') THEN(DO)                                    /*S01117*/
/**     OVRDBF OTPALL OTPAUT                                         /*S01117*/
/**     ENDDO                                                        /*S01117*/
 
/**     IF (&TYPE = '2') THEN(DO)                                    /*S01117*/
/**     OVRDBF OTPALL OTPUNT                                         /*S01117*/
/**     ENDDO                                                        /*S01117*/
 
/**/                                                                 /*S01117*/
/** SET UP OVER RIDES **/                                            /*S01117*/
/**/                                                                 /*S01117*/
             IF         COND(&TYPE *EQ ' ') THEN(DO)                 /*S01117*/
             IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(OTPALLBB) POSITION(*KEY 1 *N &RENT)     /*S01117*/
             OPNDBF     FILE(OTPALLBB) OPTION(*INP)                  /*S01117*/
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(OTPALLBB) +
                          POSITION(*END))                            /*S01117*/
             ENDDO                                                   /*S01117*/
             ENDDO                                                   /*S01117*/
                                                                     /*S01117*/
             IF         COND(&TYPE *EQ '1') THEN(DO)                 /*S01117*/
             IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(OTPALLBB) TOFILE(OTPAUTBB) +
                          POSITION(*KEY 1 *N &RENT)                  /*S01117*/
             OPNDBF     FILE(OTPALLBB) OPTION(*INP)                  /*S01117*/
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(OTPALLBB) +
                          POSITION(*END))                            /*S01117*/
             ENDDO                                                   /*S01117*/
             ELSE       CMD(OVRDBF FILE(OTPALLBB) TOFILE(OTPAUTBB))  /*S01117*/
             ENDDO                                                   /*S01117*/
                                                                     /*S01117*/
             IF         COND(&TYPE *EQ '2') THEN(DO)                 /*S01117*/
             IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(OTPALLBB) TOFILE(OTPUNTBB) +
                          POSITION(*KEY 1 *N &RENT)                  /*S01117*/
             OPNDBF     FILE(OTPALLBB) OPTION(*INP)                  /*S01117*/
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(OTPALLBB) +
                          POSITION(*END))                            /*S01117*/
             ENDDO                                                   /*S01117*/
             ELSE       CMD(OVRDBF FILE(OTPALLBB) TOFILE(OTPUNTBB))  /*S01117*/
             ENDDO                                                   /*S01117*/
 
/**/                                                                 /*074791*/
/** If run type is Regular Payment (FTM2507) then override the */    /*074791*/
/** printer files */                                                 /*074791*/
/**/                                                                 /*074791*/
             IF         COND(&RNTP *EQ 'FTM2507') THEN(DO)           /*074791*/
                OVRPRTF    FILE(FT0240P1) SPLFNAME(FT0242P1)         /*074791*/
                OVRPRTF    FILE(FT0240AU) SPLFNAME(FT0242AU)         /*074791*/
             ENDDO                                                   /*074791*/
/**/
/**/
/** CALL PROGRAM **/
/**/
/**     CALL       PGM(FT0240) PARM(&TYPE)                           /*S01117*/
/*******CALL       PGM(FT0240) PARM(&TYPE &RSEQ &RLEV &RENT)*/ /*S01117S01494*/
        CALL       PGM(FT0240) PARM(&TYPE &RSEQ &RLEV &RENT &RNTP)   /*S01494*/
 
/** Delete*Overrides*if*present  */                                  /*S01117*/
/**          IF         COND(&TYPE = '1' *OR &TYPE = '2') THEN(DO)   /*S01117*/
/**     DLTOVR OTPALL                                                /*S01117*/
/**     ENDDO                                                        /*S01117*/
             CLOF       OPNID(OTPALLBB)                              /*S01117*/
             MONMSG     MSGID(CPF4520)                               /*S01117*/
/**/                                                                 /*S01117*/
/** Delete overrides */                                              /*S01117*/
/**/                                                                 /*S01117*/
             DLTOVR     FILE(OTPALLBB)                               /*S01117*/
             MONMSG     MSGID(CPF9841)                               /*S01117*/
             DLTOVR     FILE(FT0240P1)                               /*074791*/
             MONMSG     MSGID(CPF9841)                               /*074791*/
             DLTOVR     FILE(FT0240AU)                               /*074791*/
             MONMSG     MSGID(CPF9841)                               /*074791*/
 
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
                                                             /*E25340*/
END:
                                                             /*E25340*/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/**          RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&MEM)         /*S01194*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)         /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                    TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
/**/
/** CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM    **/
/**/
        IF   COND(%SWITCH(XXXXXX01))   THEN(DO)
                     SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*E25340*/
/* CLEAR EXTRACT FILE OTPAYEX */
             CLRPFM     FILE(OTPAYEX)
/*E25340*/
 
                                                             /*E25340*/
WAIT:
                                                             /*E25340*/
             ENDPGM
