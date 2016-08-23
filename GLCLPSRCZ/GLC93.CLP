/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL STRAN file size increase')                   */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*       GLC93 - FILE SIZE INCREASE                                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408            DATE  30OCT95             */
/*       PREV AMEND NO. DT0072            DATE  02MAY91             */
/*                      S01154            DATE  24/08/88            */
/*                      E11273            DATE  24/08/87            */
/*                      S01129            DATE  28/05/87            */
/*                      E81123            DATE  23/03/87            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       S01408 - ADDITION OF CORE HOOK GLC93INT                    */
/*                ADDITION OF CORE HOOK GLC93001                    */
/*       DT0072  -  ADDITION OF STRANF                              */
/*       S01154  -  CHANGES FOR NEW GENERAL LEDGER  : NEW FILE      */
/*       E11273  SWITCHES NOT BEING INITIALIZED BEFORE CALLING      */
/*               'GL0935'                                           */
/*       S01129  SWITCH 8 NOT BEING INITIALISED BEFORE CALLING      */
/*               GL0935 - RESULTING IN DATABASE ERROR.              */
/*       E81123  MISLEADING MESSAGES DISPLAYED AT INITIAL SET-UP    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM    PARM(&FILE)
/**/
/*/COPY WNCPYSRC,GLC93INT                                          */ /*S01408*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(6)                 /*DT0072*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&INCR) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&MIN) TYPE(*DEC) LEN(5)                 *  *S01154*/
             DCL        VAR(&MNT) TYPE(*DEC) LEN(5)
/**/                                                                  /*E11273*/
             /* INITIALIZE SWITCHES */                                /*E11273*/
             CHGJOB     SWS(XXXXXX00)                                 /*E11273*/
/**/                                                                  /*E81123*/
             SNDPGMMSG  MSG('GLC93 - FILE SIZE INCREASE') TOMSGQ(MRUNQ)
             IF         COND(%SUBSTRING(&FILE 5 1) = '1') THEN(DO)    /*E81123*/
             CHGVAR     VAR(%SUBSTRING(&FILE 4 2)) VALUE(AN)          /*E81123*/
             ENDDO                                                    /*E81123*/
             ELSE       CMD(DO)                                       /*E81123*/
/**/
             CHGVAR     VAR(&MSG) VALUE('WHEN ALL DEALING INPUT FROM ALL +
                        WORKSTATIONS HAS BEEN STOPPED ENTER YES')
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ)
/**/
             RCVMSG     MSGQ(*PGMQ) MSGTYPE(*RPY) WAIT(*MAX) RMV(*YES) +
                        MSG(&MSG)
             ENDDO                                                    /*E81123*/
/**/
/*           IF         COND(&FILE *EQ 'BTRAN') THEN(DO)            *  *S01154*/
/**/
/* NEXT STMT. ADDED FOR SE 2 SET UP STAGE */                          /*S01129*/
/***************CHGJOB     SWS(XXXXXXX0)                  *  *S01129*  *S01154*/
/***************OVRDBF     FILE(TABLE) TOFILE(TABGL)                *  *S01154*/
/***************CALL       PGM(GL0935) PARM(&INCR &MIN)             *  *S01154*/
/***************DLTOVR     FILE(TABLE)                              *  *S01154*/
/***************ENDDO                                               *  *S01154*/
/**/
/***********ELSE    *  * (&FILE *EQ 'STRAN') *  *CMD(DO)            *  *S01154*/
/**/
/**/      /* (&FILE *EQ 'STRAN') */                                   /*S01154*/
                CALL      PGM(GL0936) PARM(&INCR &MNT)
/**/
/************ENDDO                                                  *  *S01154*/
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 8 1) *NE '1') THEN(DO)
/**/
                IF     COND(&INCR *EQ 'Y') THEN(DO)
/**/
/******************IF     COND(&FILE *EQ 'BTRAN') +                 *  *S01154*/
/*************************THEN(INZPFM   FILE(&FILE) TOTRCDS(&MIN))  *  *S01154*/
/**/
/******************ELSE      CMD(INZPFM  FILE(&FILE)  TOTRCDS(&MNT))*  *S01154*/
/**/                                                                  /*S01154*/
                   INZPFM  FILE(&FILE)  TOTRCDS(&MNT)                 /*S01154*/
                   IF         COND(&FILE *EQ 'STRAN') THEN(DO)        /*DT0072*/
                   CHGVAR     VAR(&FIL1) VALUE(&FILE *CAT F)          /*DT0072*/
                   INZPFM  FILE(&FIL1)  TOTRCDS(&MNT)                 /*DT0072*/
 
/*/COPY WNCPYSRC,GLC93001                                          */ /*S01408*/
 
                   ENDDO                                              /*DT0072*/
/**/
                   CHGVAR     VAR(&MSG) VALUE(&FILE *CAT 'FILE SIZE +
                              INCREASE EXECUTED - DEALING INPUT CAN +
                              NOW BE RESTARTED')
                   SNDMSG     TOMSGQ(MOPERQ) MSG(&MSG)
                   IF         COND(&FILE *EQ 'STRAN') THEN(DO)        /*DT0072*/
                   CHGVAR     VAR(&MSG) VALUE(&FIL1 *CAT 'FILE SIZE +
                              INCREASE EXECUTED - DEALING INPUT CAN +
                              NOW BE RESTARTED')
                   SNDMSG     TOMSGQ(MOPERQ) MSG(&MSG)                /*DT0072*/
                   ENDDO                                              /*DT0072*/
/**/
                ENDDO
/**/
                ENDDO
/**/
             ELSE      CMD(SNDMSG   MSG('Job terminated - database in error') +
                                       TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
