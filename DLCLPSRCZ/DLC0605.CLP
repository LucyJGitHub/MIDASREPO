/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL BASE RATES UPDATE')                          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0605 - BASE RATE CHANGES UPDATE                         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAS009             Date 04May04              */
/* Midas Release 4.01.03 --------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      P01101             Date 29Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E22196             Date 20Jun90              */
/*                      E250               Date 01Mar90              */
/*                      S01117                  DATE  13/07/89      */
/*                      S01194                  DATE  18/04/89      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       P01101 - SDBANKL1 cannot be opened from DL0250 because this */
/*                was previously opened by AOBANKR0.  Need to        */
/*                override SDBANKL1 to SHARE(*NO) for this to run.   */
/*    E22196 - INCREASE RECORD WAIT TIME ON TABDLEE TO 1800 SECS    */
/*             AS RECORDS ON TABLETK MAY BE LOCKED FOR UPDATE BY    */
/*             CONCURRENT COB STREAMS FOR MORE THAN 60 SECONDS.     */
/*             NOW IRRELEVANT.                                      */
/*   E250   - REMOVE UNNECESSARY PARAMETERS                         */
/*   S01117 - MULTIBRANCHING (INCLUDING RCF) CHANGES                */
/*       S01194 - STANDING DATA CHANGES                             */
/*                                                                  */
/*********************************************************************/
/*/COPY WNCPYSRC,DLC0605002                                          */
             PGM
/*/COPY WNCPYSRC,DLC0605003                                          */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/**DCL*VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number * *S01117 /*E250*/
/*/COPY WNCPYSRC,DLC0605001                                          */
 
/**********  CHGVAR     VAR(&RSEQ) VALUE('     ')             /*S01117/*E250*/
 
                                                                                          /*CAS009*/
/* Declare the variables CAS009 */                                                        /*CAS009*/
                                                                                          /*CAS009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CAS009*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CAS009*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CAS009*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CAS009*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1)                                   /*CAS009*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                    /*CAS009*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')                   /*CAS009*/
                                                                                          /*CAS009*/
/* Setup system prefix variable from SDSTAT data area. */                                 /*CAS009*/
                                                                                          /*CAS009*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*CAS009*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)                         /*CAS009*/
                                                                                          /*CAS009*/
/* Check if CAS009 is enabled */                                                          /*CAS009*/
                                                                                          /*CAS009*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CAS009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CAS009*/
             CHGVAR     VAR(&SARD) VALUE('CAS009')                                        /*CAS009*/
                                                                                          /*CAS009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                     /*CAS009*/
                                                                                          /*CAS009*/
             CHGVAR     VAR(&CAS009) VALUE('N')                                           /*CAS009*/
             IF         COND(&RTCD *EQ '       ') +
                          THEN(CHGVAR VAR(&CAS009) VALUE('Y'))                            /*CAS009*/
 
/*   BASE RATE CHANGES                                        */
             SNDPGMMSG  MSG('BASE RATE CHANGES') TOMSGQ(MRUNQ) +
                        MSGTYPE(*INFO)
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('00000000')
             CHGJOB     SWS(&SWS)
             CLRPFM     FILE(DAMBRDH)
             CLRPFM     FILE(DAMBRDI)
             CLRPFM     FILE(DAMBRDJ)
                                                                                          /*CAS009*/
             IF         COND(&CAS009 *EQ 'Y') THEN(DO)                                    /*CAS009*/
                DLTF       FILE(XMMEIRDPD)                                                /*CAS009*/
                MONMSG     MSGID(CPF2105)                                                 /*CAS009*/
                CPYF       FROMFILE(MMEIRDPD) TOFILE(&DPLIB/XMMEIRDPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)                               /*CAS009*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*CAS009*/
             ENDDO                                                                        /*CAS009*/
                                                                                          /*CAS009*/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01194*/
/*********** OVRDBF     FILE(TABLE2) TOFILE(TABDLEI)                  /*S01194*/
             OVRDBF     FILE(SDBANKL1) SHARE(*NO)                     /*P01101*/
/*********** CALL       PGM(DL0250)                                   /*S01117*/
/************CALL       PGM(DL0250) PARM(&RSEQ)             /*S01117* /*E250*/
             CALL       PGM(DL0250)                                   /*S01117*/
             DLTOVR     FILE(SDBANKL1)                                /*P01101*/
/*/COPY WNCPYSRC,DLC0605005                                          */
/*********** DLTOVR     FILE(*ALL)                                    /*S01194*/
/*   UPDATE BASE RATES TABLE                                 */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                SNDPGMMSG  MSG('UPDATE BASE RATES TABLE') +
                           TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/************** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                /*S01194*/
                CALL       PGM(DL0255)
/************** DLTOVR     FILE(*ALL)                                 /*S01194*/
             ENDDO
/*/COPY WNCPYSRC,DLC0605006                                          */
             IF         COND(&CAS009 *EQ 'Y') THEN(DO)                                    /*CAS009*/
               IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                 DLTF       FILE(XMMEIRDPD)                                               /*CAS009*/
                 MONMSG     MSGID(CPF2105)                                                /*CAS009*/
               ENDDO                                                                      /*CAS009*/
               IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXX1X)) +
                 THEN(DO)                                                                 /*CAS009*/
                 CPYF       FROMFILE(XMMEIRDPD) TOFILE(MMEIRDPD) +
                             MBROPT(*REPLACE)                                             /*CAS009*/
                 MONMSG     (CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(MMEIRDPD))                                              /*CAS009*/
               ENDDO                                                                      /*CAS009*/
             ENDDO                                                                        /*CAS009*/
/*   ERROR MESSAGES                                          */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
/*/COPY WNCPYSRC,DLC0605004                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
