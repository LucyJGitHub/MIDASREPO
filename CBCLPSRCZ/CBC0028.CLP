/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Reopen I/C from COB monitor')                */
/*********************************************************************/
/*                                                                   */
/*        Midas - Close of Business Processing                       */
/*                                                                   */
/*       CBC0028 - REOPEN INPUT CYCLE FROM CLOSE OF BUSINESS MONITOR */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1074036          Date 30Dec12              */
/*                      CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      237463 (Reopen)    Date 21Jun06              */
/*                      240226             Date 05Jun06              */
/*                       CGP002            Date 04Jul03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date  18Sep01             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      111332             Date  05Feb98             */
/*                      092729             Date  12Sep95             */
/*                      S01420            DATE  10MAR95              */
/*                      S01343            DATE  15AUG91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1074036 - COB reopen does not restore DBIC                */
/*                   completely / correctly                          */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       237463 - Applied fix 240226, annotated as 240226.           */
/*       240226 - Execute SCC07 again when reopen IC fails.          */
/*       CGP002 - Add call to GOC000100 to update the global         */
/*                dashboard.                                         */
/*       CSC011 - 24x7 Midas Availability                            */
/*       111332 - Call new program SC1714 to ensure I/C              */
/*                termination save is done before restore for        */
/*                re-open.                                           */
/*       092729 - Give Access to Reopen when phase is 'B'            */
/*       S01420 - CoB Enhancement (Batch Monitor)                    */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                    */
/*                - SCMINIT RENAMED FROM MINIT                       */
/*                - SCC07 RENAMED FROM SDC07                         */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)             */              /*S01420 CCB020*/
/**********  DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)             */              /*S01420 CCB020*/
/**********  DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7)             */              /*S01420 CCB020*/
/**********  DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6)             */              /*S01420 CCB020*/
             DCL        VAR(&DBSAVE) TYPE(*CHAR) LEN(1)               /*111332*/
/**********  DCL        VAR(&SSCSARD) TYPE(*CHAR)  LEN(200)        */              /*S01420 CCB020*/
             DCL        VAR(&CBPROMPT) TYPE(*CHAR)  LEN(256)          /*S01420*/
             DCL        VAR(&REOPEN) TYPE(*CHAR)  LEN(1)              /*S01420*/
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(20)                /*S01420*/
             DCL        VAR(&TXT) TYPE(*CHAR) LEN(180)                /*S01420*/
/**********  DCL        VAR(&S01420) TYPE(*CHAR) LEN(1) VALUE('N') */              /*092729 CCB020*/
/**********  DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1)            */              /*CSC011 CCB020*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                                     /*CSC011*/
/**********  DCL        VAR(&CSTAT) TYPE(*CHAR) LEN(4)               */         /*CCB020 AR1074036*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                                                                                          /*CSC011*/
/***Check*if*CSC011*is*installed**/                                                /*CSC011 CCB020*/
                                                                                          /*CSC011*/
/**********  CHGVAR     VAR(&SRTCD) VALUE('       ')               */              /*CSC011 CCB020*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */              /*CSC011 CCB020*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CSC011')                */              /*CSC011 CCB020*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +  */                     /*CCB020*/
/**********               &SSCSARD)                                */              /*CSC011 CCB020*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(DO)        */              /*CSC011 CCB020*/
/**********    CHGVAR     VAR(&CSC011) VALUE('Y')                  */              /*CSC011 CCB020*/
/**********  ENDDO                                                 */              /*CSC011 CCB020*/
/**********  IF         COND(&SRTCD *NE '       ' *AND &SRTCD +    */                     /*CCB020*/
/**********               *NE '*NRF   ') THEN(DO)                  */              /*CSC011 CCB020*/
/**********    CHGJOB     SWS(XXXXXX11)                            */              /*CSC011 CCB020*/
/**********    GOTO       CMDLBL(ABNOR)                            */              /*CSC011 CCB020*/
/**********  ENDDO                                                 */              /*CSC011 CCB020*/
                                                                                          /*CSC011*/
/***If*CSC011*is*installed**/                                                      /*CSC011 CCB020*/
                                                                                          /*CSC011*/
/**********  IF         COND(&CSC011 *EQ 'Y') THEN(DO)             */              /*CSC011 CCB020*/
/**********    CHGDTAARA  DTAARA(SCREOP (1 1)) VALUE(Y)            */              /*CSC011 CCB020*/
/**********    CALL       PGM(SC004330)                            */              /*CSC011 CCB020*/
/**********                                                        */              /*CSC011 CCB020*/
/***Database*error*processing**/                                                   /*CSC011 CCB020*/
/**********                                                        */              /*CSC011 CCB020*/
/**********    IF         COND(%SWITCH(XXXXXX11)) THEN(DO)         */              /*CSC011 CCB020*/
/**********      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)      */              /*CSC011 CCB020*/
/**********      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +              /*CSC011 CCB020*/
/**********                  TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */              /*CSC011 CCB020*/
/**********      GOTO       CMDLBL(ABNOR)                          */              /*CSC011 CCB020*/
/**********    ENDDO                                               */              /*CSC011 CCB020*/
/**********  ENDDO                                                 */              /*CSC011 CCB020*/
                                                                                          /*CSC011*/
/**/
/* SET REOPEN FAILED INDICATOR ON CBSTAT - POS 32 TO 'Y'.            */
/**/
             ALCOBJ     OBJ((CBSTAT *DTAARA *EXCL))
             CHGDTAARA  DTAARA(CBSTAT (32 1)) VALUE('Y')
             DLCOBJ     OBJ((CBSTAT *DTAARA *EXCL))
                                                                                          /*CGP002*/
/* Update global dashboard */                                                             /*CGP002*/
                                                                                          /*CGP002*/
             CALL       PGM(GOC000100) PARM('*PHASE')                                     /*CGP002*/
/**/
/* REMOVE 'EOD' FROM MSGQ/MSPECIAL                                   */
/**/
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(*CLS)
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             RCVMSG     MSGQ(MSPECIAL) RMV(*YES)
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
/**/
/**CALL*MINIT*TO*REOPEN*INPUT*CYCLE                                  /*S01343*/
/* CALL SCMINIT TO REOPEN INPUT CYCLE                                /*S01343*/
/**/
/**/                                                                  /*S01420*/
/*  S01420 - CoB Enhancement installed */                             /*S01420*/
/**/                                                                  /*S01420*/
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)         */              /*S01420 CCB020*/
                                                                                          /*CCB020*/
/**********  CALL       PGM(AOCOMSR0) PARM('SCC1711' '00001' &CSTAT) */         /*CCB020 AR1074036*/
                                                                                          /*CCB020*/
/**/                                                            /*Begin 111332*/
             CALL       PGM(SC1714) PARM(&DBSAVE)
/**/                                                            /*End   111332*/
             RTVDTAARA  DTAARA(CBPROMPT) RTNVAR(&CBPROMPT)            /*S01420*/
             CHGVAR     VAR(&REOPEN) VALUE(%SST(&CBPROMPT 256 1))     /*S01420*/
 
/**********  CHGVAR     VAR(&SRTCD) VALUE('       ')               */              /*S01420 CCB020*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */              /*S01420 CCB020*/
/**********  CHGVAR     VAR(&SSARD) VALUE('S01420')                */              /*S01420 CCB020*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +  */                     /*CCB020*/
/**********               &SSCSARD)                                */              /*S01420 CCB020*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(DO)        */                     /*CCB020*/
/**********     CHGVAR     VAR(&S01420) VALUE('Y')                 */              /*092729 CCB020*/
                                                                                          /*CCB020*/
                CHGVAR     VAR(&QUAL) VALUE('USRTRACE  ' *CAT +
                             '*LIBL     ')                            /*S01420*/
                CHGVAR     VAR(&TXT) VALUE('Re-open I/c ')            /*S01420*/
                CALL       PGM(QUSCHGUS) PARM(&QUAL X'00000001' +
                             X'00000180' &TXT '0')                    /*S01420*/
                CALL       PGM(CB0534)                                /*S01420*/
                                                                                          /*CCB020*/
/**********  ENDDO                                                 */              /*S01420 CCB020*/
/**/
/**********  IF         COND((&SRTCD *EQ '       ') *AND (&MPHAS *EQ +
/**********          'B') *AND (&REOPEN *EQ ' ')) THEN(DO) /*S01420***  092729*/
                                                                /*Begin 111332*/
/**********  IF         COND(((&S01420 *EQ 'Y') *AND (&MPHAS *EQ +
/**********               'B') *AND (&REOPEN *EQ ' ')) *OR +
/**********               ((&S01420 *NE 'Y') *AND (&MPHAS *EQ 'B') +
/**********               *AND (&REOPEN *EQ ' '))) THEN(DO)          /*092729*/
             IF        COND(&DBSAVE *NE 'F') THEN(DO)
/**********  IF       COND((((&S01420 *EQ 'Y') *AND (&MPHAS *EQ +                         /*240226*/
/**********             'B') *AND (&REOPEN *EQ ' ') *OR (&DBSAVE +                        /*240226*/
/**********             *EQ 'N'))) *OR (((&S01420 *NE 'Y') *AND +                         /*240226*/
/**********            ((&MPHAS**EQ''B')**AND((&REOPEN**EQ''''))++                        /*240226*/
/**********             *OR (&DBSAVE *EQ 'N'))) THEN(DO)                                  /*240226*/
/**********  IF       COND((((&S01420 *EQ 'Y') *AND (&MPHAS *EQ +                         /*CCB020*/
/**********        'B') *AND (&REOPEN *EQ ' ') *AND (&DBSAVE *NE 'Y') *OR (&DBSAVE +      /*CCB020*/
/**********             *EQ 'N'))) *OR (((&S01420 *NE 'Y') *AND +                         /*CCB020*/
/**********             (&MPHAS *EQ 'B') *AND (&REOPEN *EQ ' ')) +                        /*CCB020*/
/**********             *OR (&DBSAVE *EQ 'N'))) THEN(DO)                                  /*CCB020*/
/**********  IF         COND((((&CSTAT *NE 'C   ') *AND (&REOPEN *EQ +                 /*AR1074036*/
/**********               ' ') *AND (&DBSAVE *NE 'Y') *OR (&DBSAVE +                   /*AR1074036*/
/**********               *EQ 'N'))) *OR (((&CSTAT *EQ 'C   ') *AND +                  /*AR1074036*/
/**********               (&REOPEN *EQ ' ')) *OR (&DBSAVE *EQ +                        /*AR1074036*/
/**********               'N'))) THEN(DO)                            */         /*CCB020 AR1074036*/
                                                                                       /*AR1074036*/
             IF         COND(((&REOPEN *EQ ' ') *AND (&DBSAVE *NE 'Y') +
                          *OR (&DBSAVE *EQ 'N'))) THEN(DO)                             /*AR1074036*/
/**/                                                            /*End   111332*/
             CALL       PGM(SCMINIT) PARM('SCC0700')                 /*S01343*/
             ENDDO                                                    /*S01420*/
/************CALL       PGM(MINIT) PARM('SDC07')                     /*S01343*/
             ELSE       CMD(DO)                                       /*S01420*/
/**/                                                            /*Begin 111332*/
             IF         COND(&DBSAVE *EQ 'Y') THEN(DO)
/**/                                                            /*End   111332*/
             CALL       PGM(SCMINIT) PARM('SCC07')                   /*S01343*/
/**/                                                            /*Begin 111332*/
             ENDDO
/**/                                                            /*End   111332*/
             ENDDO                                                   /*S01420*/
/**/                                                            /*Begin 111332*/
             ENDDO
/**/                                                            /*End   111332*/
/**/
/**IF*MINIT*HAS*FAILED*SEND*'EOD'*TO*MSGQ/MSPECIAL.                  /*S01343*/
/* IF SCMINIT HAS FAILED SEND 'EOD' TO MSGQ/MSPECIAL.                /*S01343*/
/**/
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(*CLS)
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             SNDPGMMSG  MSG('EOD') TOMSGQ(MSPECIAL)
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
/**/
/**/
/**RETURN*TO*CB0015*IF*MINIT*HAS*FAILED .                            /*S01343*/
/* RETURN TO CB0015 IF SCMINIT HAS FAILED .                          /*S01343*/
/*/COPY WNCPYSRC,CBC0028001                                          */
/**/
             RETURN
/**/
/* ABNORMAL TERMINATION PROCESSING                                   */
/**/
 ABNOR:      SNDPGMMSG  MSG('REOPEN INPUT CYCLE FROM CLOSE OF +
                          BUSINESS MONITOR TERMINATED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     (CPF0000 MCH0000)
/**/
             ENDPGM
