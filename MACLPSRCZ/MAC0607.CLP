/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MA Clear archived output queues')               */
/*XBIA : OVRDBF FILE(TMPSPLF) TOFILE(FCTMPPD)                       :*/
/*********************************************************************/
/*                                                                   */
/*  Midas - Microfiche/Optical Disk Archiving Module         */
/*                                                                   */
/*  MAC0607  - Clear Archived Output Queues                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD056839           Date 16Oct20              */
/*       Prev Amend No. MD039095           Date 16Apr19              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      190517             Date 28Feb01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      089639             Date 08Jan97              */
/*                 089636               DATE 19OCT95                 */
/*                 S01382               DATE 21JUL92                 */
/*                 LN1079               DATE 13DEC90                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD056839 - MA No spool files should be cleared if ODACLR    */
/*                  equal to 'N'.                                    */
/*                - Revert changes of MD039095 for this program only.*/
/*       MD039095 - CLROUTQ automatically if auto clear in optical   */
/*                  ICD is Y else prompt operator.                   */
/*       MD046248 - Finastra Rebranding                              */
/*  190517 - CLROUTQ job is looping. MAC0607 is looking for a value  */
/*           of either 'Z' or 'C' in dtaara MACHK. Amendment 090061  */
/*           passes the value 'N' to MACHK instead of 'Z'. Thus the  */
/*           the endless loop of job CLROUTQ.                        */
/*  089639 - Delete individual spool entry rather than clear the     */
/*           whole output queue.  Deletion will be based on date     */
/*           and time this program tries to clear the output queue.  */
/*  089636 - Make 'Allow Auto-Clear of Outqs' field functional by    */
/*           doing nothing if value is 'N' and asking for            */
/*           confirmation if value is 'Y'.                           */
/*  S01382 - OPTICAL DISK DEVELOPMENT                                */
/*  LN1079 - ASK USER TO CONFIRM THE CLEAR OF OUTPUT QUEUE           */
/*           RATHER THAN CLEARING AUTOMATICALLY                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* This program reads Archive Header file and clears all output      */
/*  queues processed in MAC0606                                      */
/*                                                                   */
/*********************************************************************/
/***PGM    parm(&eflg)                                                /*S01382*/
/*********** PGM                                               /*S01382*089639*/
             PGM        PARM(&SDATE &STIME)                           /*089639*/

/***DCL        &eflg    *char   1                                     /*S01382*/
 DCL        &machk   *char   1
             DCL        VAR(&ANS) TYPE(*CHAR) LEN(1)                  /*LN1079*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(107) VALUE('Can +
                          output queue            be cleared? Enter +
                          Y to clear or N to continue processing.')   /*LN1079*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*089636*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*089636*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')                                          /*089636*/
             DCL        VAR(&CLEAR) TYPE(*CHAR) LEN(1)                /*089636*/

             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*089639*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*089639*/
 DCLF       file(MAARCHL3)

 monmsg     (RPG0000 CPF0000 MCH0000) exec(goto abnor)

 chgjob     sws(xxxxxx00)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* RETRIEVE OPTICAL ICD                                               /*089636*/
                                                                      /*089636*/
             CALL       PGM(AOOPTCR0) PARM(&RTCD &OPTN &FMT)          /*089636*/
                                                                      /*089636*/
/*  Database error handling  */                                       /*089636*/
                                                                      /*089636*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*089636*/
               SNDPGMMSG  MSG('Error on access to ICD file +
                            SDOPTCPD') TOMSGQ(MOPERQ)                 /*089636*/
               GOTO       CMDLBL(ABNOR)                               /*089636*/
             ENDDO                                                    /*089636*/

/* Retrieve Archiving Status                                       */

/****rtvdtaara  machk   rtnvar(&machk)                            */ /*S01382*/
 LOOP:       RTVDTAARA  DTAARA(MACHK) RTNVAR(&MACHK)                 /*S01382*/

/**If*Archiving*Status*(&MACHK)*is*not*set to 'C'or 'Z',           + /*190517*/
/**wait*for*5*minutes*before*receiving*data area again    /*S01382*/ /*190517*/
/* If Archiving Status (&MACHK) is not set to 'C'or 'N',           + /*190517*/
/* wait for 5 minutes before receiving data area again            */ /*190517*/
                                                                     /*S01382*/
/**********  IF         COND((&MACHK *NE 'C') *AND (&MACHK *NE 'Z')) +
/**********               THEN(DO)                        /*S01382*/ /*190517*/
             IF         COND((&MACHK *NE 'C') *AND (&MACHK *NE 'N')) +
                          THEN(DO)                                   /*190517*/
                DLYJOB     DLY(300)                                  /*S01382*/
                GOTO       CMDLBL(LOOP)                              /*S01382*/
             ENDDO                                                   /*S01382*/

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**If*Archiving*Status*(&machk)*is*set to to 'C' or 'Z'            + /*190517*/
/**clear*all*output*queues*defined*in MAARCHL3                     + /*190517*/
/* If Archiving Status (&machk) is set to to 'C' or 'N'            + /*190517*/
/* clear all output queues defined in MAARCHL3                     + /*190517*/
/**and*re-set*Archiving*Status*dta*area*to*'F'                    */ /*S01382*/

/*IF****(&machk *eq 'C') then+                                        /*S01382*/
/******(DO) **/                                                       /*S01382*/

/**********  IF         COND((&MACHK *EQ 'C') *OR (&MACHK *EQ 'Z')) + /*190517*/
/**********               THEN(DO)                         /*S01382*/ /*190517*/
             IF         COND((&MACHK *EQ 'C') *OR (&MACHK *EQ 'N')) +
                          THEN(DO)                                    /*190517*/
                                                                      /*S01382*/
/* clear all output queues                                         */

READ:  rcvf    rcdfmt(MAARCHD0)
       monmsg  (CPF0864) exec(goto NEXT)

       CHGVAR     VAR(&CLEAR) VALUE('N')                              /*089636*/
       IF         COND(%SST(&FMT 12 1) *EQ 'Y') THEN(DO)              /*089636*/
/******CHGVAR     VAR(&CLEAR) VALUE('Y') */                                    /*MD039095 MD056839*/
/******ENDDO                             */                                    /*MD039095 MD056839*/
/******ELSE  (DO)                        */                                    /*MD039095 MD056839*/
/*/COPY WNCPYSRC,MAC0607001                                          */
             CHGVAR     VAR(%SUBSTRING(&MSG 18 10)) VALUE(&EAAOTQ)    /*LN1079*/
             SNDUSRMSG  MSG(&MSG) VALUES('Y' 'N') +
                          TOMSGQ(MOPERQ) MSGRPY(&ANS)                 /*LN1079*/
             IF         COND(&ANS = 'Y') THEN(DO)                     /*LN1079*/
             CHGVAR     VAR(&CLEAR) VALUE('Y')                        /*089636*/
             ENDDO                                                    /*089636*/
/*/COPY WNCPYSRC,MAC0607003                                          */
       ENDDO                                                          /*089636*/
/*/COPY WNCPYSRC,MAC0607002                                          */
       IF   COND(&CLEAR = 'Y') THEN(DO)                               /*089636*/
/******clroutq &EAAOTQ                                                 *089639*/
             CALL       PGM(MAC0608) PARM(&EAAOTQ &SDATE &STIME)      /*089639*/
       monmsg  (CPF0000 MCH0000)
       ENDDO                                                          /*LN1079*/
       goto READ

/**change*Archiving*Status*data*area*MACHK*to*'F'******************/ /*S01382*/

/******NEXT:  chgdtaara  MACHK  ('F')                             */ /*S01382*/
NEXT:                                                                /*S01382*/

       ENDDO

 goto   END

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ABNOR:  CHGJOB    sws(xxxxxx11)
        monmsg    (RPG0000 CPF0000 MCH0000)
/**********CHGVAR    &eflg   ('Y')                                   /*S01382*/
           monmsg    (RPG0000 CPF0000 MCH0000)
              SNDMSG    MSG('Clear Archive Output Queues program +
                        ended abnormally')  TOMSGQ(MOPERQ)
              monmsg    (RPG0000 CPF0000 MCH0000)

END:    ENDPGM
